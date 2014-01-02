/*++
  The material contained herein is not a license, either        
  expressly or impliedly, to any intellectual property owned    
  or controlled by any of the authors or developers of this     
  material or to any contribution thereto. The material         
  contained herein is provided on an "AS IS" basis and, to the  
  maximum extent permitted by applicable law, this information  
  is provided AS IS AND WITH ALL FAULTS, and the authors and    
  developers of this material hereby disclaim all other         
  warranties and conditions, either express, implied or         
  statutory, including, but not limited to, any (if any)        
  implied warranties, duties or conditions of merchantability,  
  of fitness for a particular purpose, of accuracy or           
  completeness of responses, of results, of workmanlike         
  effort, of lack of viruses and of lack of negligence, all     
  with regard to this material and any contribution thereto.    
  Designers must not rely on the absence or characteristics of  
  any features or instructions marked "reserved" or             
  "undefined." The Unified EFI Forum, Inc. reserves any         
  features or instructions so marked for future definition and  
  shall have no responsibility whatsoever for conflicts or      
  incompatibilities arising from future changes to them. ALSO,  
  THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT,  
  QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR            
  NON-INFRINGEMENT WITH REGARD TO THE TEST SUITE AND ANY        
  CONTRIBUTION THERETO.                                         
                                                                
  IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THIS MATERIAL OR  
  ANY CONTRIBUTION THERETO BE LIABLE TO ANY OTHER PARTY FOR     
  THE COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST      
  PROFITS, LOSS OF USE, LOSS OF DATA, OR ANY INCIDENTAL,        
  CONSEQUENTIAL, DIRECT, INDIRECT, OR SPECIAL DAMAGES WHETHER   
  UNDER CONTRACT, TORT, WARRANTY, OR OTHERWISE, ARISING IN ANY  
  WAY OUT OF THIS OR ANY OTHER AGREEMENT RELATING TO THIS       
  DOCUMENT, WHETHER OR NOT SUCH PARTY HAD ADVANCE NOTICE OF     
  THE POSSIBILITY OF SUCH DAMAGES.                              
                                                                
  Copyright 2006 - 2013 Unified EFI, Inc. All  
  Rights Reserved, subject to all existing rights in all        
  matters included within this Test Suite, to which United      
  EFI, Inc. makes no claim of right.                            
                                                                
  Copyright (c) 2010 - 2013, Intel Corporation. All rights reserved.<BR>   
   
--*/
/*++

Module Name:

  misc.c

Abstract:

  Misc functions

--*/

#include "lib.h"

EFI_MEMORY_DESCRIPTOR *
LibMemoryMap (
  OUT UINTN               *NoEntries,
  OUT UINTN               *MapKey,
  OUT UINTN               *DescriptorSize,
  OUT UINT32              *DescriptorVersion
  )
/*++

Routine Description:
  This function retrieves the system's current memory map.

Arguments:
  NoEntries                - A pointer to the number of memory descriptors in the system

  MapKey                   - A pointer to the current memory map key.

  DescriptorSize           - A pointer to the size in bytes of a memory descriptor

  DescriptorVersion        - A pointer to the version of the memory descriptor.

Returns:

  None

--*/
{
  EFI_STATUS              Status;
  EFI_MEMORY_DESCRIPTOR   *Buffer;
  UINTN                   BufferSize;

  //
  // Initialize for SctGrowBuffer loop
  //

  Buffer = NULL;
  BufferSize = sizeof(EFI_MEMORY_DESCRIPTOR);

  //
  // Call the real function
  //

  while (SctGrowBuffer (&Status, (VOID **) &Buffer, BufferSize)) {
    Status = tBS->GetMemoryMap (
                   &BufferSize,
                   Buffer,
                   MapKey,
                   DescriptorSize,
                   DescriptorVersion
                   );
  }

  //
  // Convert buffer size to NoEntries
  //

  if (!EFI_ERROR(Status)) {
    *NoEntries = BufferSize / *DescriptorSize;
  }

  return Buffer;
}


VOID *
LibGetVariableAndSize (
    IN CHAR16               *Name,
    IN EFI_GUID             *VendorGuid,
    OUT UINTN               *VarSize
    )
/*++

Routine Description:
  Function returns the value of the specified variable and its size in bytes.

Arguments:
  Name                - A Null-terminated Unicode string that is
                        the name of the vendor's variable.

  VendorGuid          - A unique identifier for the vendor.

  VarSize             - The size of the returned environment variable in bytes.

Returns:

  None

--*/
{
  EFI_STATUS              Status;
  VOID                    *Buffer;
  UINTN                   BufferSize;

  //
  // Initialize for SctGrowBuffer loop
  //

  Buffer = NULL;
  BufferSize = 100;

  //
  // Call the real function
  //

  while (SctGrowBuffer (&Status, &Buffer, BufferSize)) {
    Status = tRT->GetVariable (
                   Name,
                   VendorGuid,
                   NULL,
                   &BufferSize,
                   Buffer
                   );
  }
  if (Buffer) {
    *VarSize = BufferSize;
  } else {
    *VarSize = 0;
  }
  return Buffer;
}


VOID *
LibGetVariable (
  IN CHAR16               *Name,
  IN EFI_GUID             *VendorGuid
    )
/*++

Routine Description:
  Function returns the value of the specified variable.

Arguments:
  Name                - A Null-terminated Unicode string that is
                        the name of the vendor's variable.

  VendorGuid          - A unique identifier for the vendor.

Returns:

  None

--*/
{
  UINTN   VarSize;

  return LibGetVariableAndSize (Name, VendorGuid, &VarSize);
}

EFI_STATUS
LibGetHandleDatabaseSubset (
  EFI_HANDLE  DriverBindingHandle,
  EFI_HANDLE  ControllerHandle,
  UINT32      Mask,
  UINTN       *MatchingHandleCount,
  EFI_HANDLE  **MatchingHandleBuffer
  )

{
  EFI_STATUS  Status;
  UINTN       HandleCount;
  EFI_HANDLE  *HandleBuffer;
  UINT32      *HandleType;
  UINTN       HandleIndex;

  *MatchingHandleCount  = 0;
  if (MatchingHandleBuffer != NULL) {
    *MatchingHandleBuffer = NULL;
  }

  HandleBuffer = NULL;
  HandleType   = NULL;

  Status = SctScanHandleDatabase (
             DriverBindingHandle,
             NULL,
             ControllerHandle,
             NULL,
             &HandleCount,
             &HandleBuffer,
             &HandleType
             );
  if (EFI_ERROR (Status)) {
    goto Done;
  }

  //
  // Count the number of handles that match the attributes in Mask
  //
  for (HandleIndex = 0; HandleIndex < HandleCount; HandleIndex++) {
    if ((HandleType[HandleIndex] & Mask) == Mask) {
      (*MatchingHandleCount)++;
    }
  }

  //
  // If no handles match the attributes in Mask then return EFI_NOT_FOUND
  //
  if (*MatchingHandleCount == 0) {
    Status = EFI_NOT_FOUND;
    goto Done;
  }

  if (MatchingHandleBuffer == NULL) {
    Status = EFI_SUCCESS;
    goto Done;
  }

  //
  // Allocate a handle buffer for the number of handles that matched the attributes in Mask
  //
  Status = tBS->AllocatePool (
                 EfiBootServicesData,
                 *MatchingHandleCount * sizeof (EFI_HANDLE),
                 (VOID **)MatchingHandleBuffer
                 );
  if (EFI_ERROR (Status)) {
    goto Done;
  }

  //
  // Fill the allocated buffer with the handles that matched the attributes in Mask
  //
  *MatchingHandleCount = 0;
  for (HandleIndex = 0; HandleIndex < HandleCount; HandleIndex++) {
    if ((HandleType[HandleIndex] & Mask) == Mask) {
      (*MatchingHandleBuffer)[(*MatchingHandleCount)++] = HandleBuffer[HandleIndex];
    }
  }

  Status = EFI_SUCCESS;

Done:

  //
  // Free the buffers alocated by SctScanHandleDatabase()
  //
  if (HandleBuffer != NULL) {
    tBS->FreePool (HandleBuffer);
  }

  if (HandleType != NULL) {
    tBS->FreePool (HandleType);
  }

  return Status;
}

EFI_STATUS
LibGetManagedChildControllerHandles (
  EFI_HANDLE  DriverBindingHandle,
  EFI_HANDLE  ControllerHandle,
  UINTN       *ChildControllerHandleCount,
  EFI_HANDLE  **ChildControllerHandleBuffer
  )

{
  return LibGetHandleDatabaseSubset (
           DriverBindingHandle,
           ControllerHandle,
           SCT_HANDLE_TYPE_CHILD_HANDLE | SCT_HANDLE_TYPE_DEVICE_HANDLE,
           ChildControllerHandleCount,
           ChildControllerHandleBuffer
           );
}

EFI_STATUS
LibGetManagedControllerHandles (
  EFI_HANDLE  DriverBindingHandle,
  UINTN       *ControllerHandleCount,
  EFI_HANDLE  **ControllerHandleBuffer
  )

{
  return LibGetHandleDatabaseSubset (
           DriverBindingHandle,
           NULL,
           SCT_HANDLE_TYPE_CONTROLLER_HANDLE | SCT_HANDLE_TYPE_DEVICE_HANDLE,
           ControllerHandleCount,
           ControllerHandleBuffer
           );
}
