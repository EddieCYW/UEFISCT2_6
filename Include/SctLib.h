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

  Copyright 2006 - 2012 Unified EFI, Inc. All
  Rights Reserved, subject to all existing rights in all
  matters included within this Test Suite, to which United
  EFI, Inc. makes no claim of right.

  Copyright (c) 2013-2014, ARM Ltd. All rights reserved.

--*/

#ifndef __SCTLIB_H__
#define __SCTLIB_H__

#include "Efi.h"

//
// Allocation API
//

VOID *
SctAllocatePool (
  IN UINTN                          Size
  );

VOID *
SctAllocateCopyPool (
  IN  UINTN                         AllocationSize,
  IN  VOID                          *Buffer
  );

VOID *
SctAllocateZeroPool (
  IN UINTN                          Size
  );

VOID *
SctReallocatePool (
  IN VOID                           *OldPool,
  IN UINTN                          OldSize,
  IN UINTN                          NewSize
  );

VOID
SctFreePool (
  IN VOID                           *p
  );

//
// Public read-only data in the EFI library
//

extern EFI_SYSTEM_TABLE         *tST;
extern EFI_BOOT_SERVICES        *tBS;
extern EFI_RUNTIME_SERVICES     *tRT;

//
// Init API
//
EFI_STATUS
SctInitializeLib (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  );

EFI_STATUS
SctInitializeDriver (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  );

//
// Memory API
//

VOID
SctZeroMem (
  IN VOID                           *Buffer,
  IN UINTN                          Size
  );

VOID*
SctSetMem (
  IN VOID                           *Buffer,
  IN UINTN                          Size,
  IN UINT8                          Value
  );

VOID
SctCopyMem (
  IN VOID                           *Dest,
  IN CONST VOID                     *Src,
  IN UINTN                          len
  );

INTN
SctCompareMem (
  IN VOID                           *Dest,
  IN VOID                           *Src,
  IN UINTN                          len
  );

//
// Protocol & Handle API
//

#define SCT_HANDLE_TYPE_UNKNOWN                      0x000
#define SCT_HANDLE_TYPE_IMAGE_HANDLE                 0x001
#define SCT_HANDLE_TYPE_DRIVER_BINDING_HANDLE        0x002
#define SCT_HANDLE_TYPE_DEVICE_DRIVER                0x004
#define SCT_HANDLE_TYPE_BUS_DRIVER                   0x008
#define SCT_HANDLE_TYPE_DRIVER_CONFIGURATION_HANDLE  0x010
#define SCT_HANDLE_TYPE_DRIVER_DIAGNOSTICS_HANDLE    0x020
#define SCT_HANDLE_TYPE_COMPONENT_NAME_HANDLE        0x040
#define SCT_HANDLE_TYPE_DEVICE_HANDLE                0x080
#define SCT_HANDLE_TYPE_PARENT_HANDLE                0x100
#define SCT_HANDLE_TYPE_CONTROLLER_HANDLE            0x200
#define SCT_HANDLE_TYPE_CHILD_HANDLE                 0x400

EFI_STATUS
SctGetSystemConfigurationTable (
  IN EFI_GUID                       *TableGuid,
  IN OUT VOID                       **Table
  );

EFI_STATUS
SctLocateProtocol (
  IN  EFI_GUID    *ProtocolGuid,
  OUT VOID        **Interface
  );

EFI_STATUS
SctGetPeiProtocol (
  IN EFI_GUID      *ProtocolGuid,
  IN OUT VOID      **Interface
  );

EFI_STATUS
SctLocateHandle (
  IN EFI_LOCATE_SEARCH_TYPE       SearchType,
  IN EFI_GUID                     *Protocol OPTIONAL,
  IN VOID                         *SearchKey OPTIONAL,
  IN OUT UINTN                    *NoHandles,
  OUT EFI_HANDLE                  **Buffer
  );

EFI_STATUS
SctScanHandleDatabase (
  EFI_HANDLE  DriverBindingHandle,       OPTIONAL
  UINT32      *DriverBindingHandleIndex, OPTIONAL
  EFI_HANDLE  ControllerHandle,          OPTIONAL
  UINT32      *ControllerHandleIndex,    OPTIONAL
  UINTN       *HandleCount,
  EFI_HANDLE  **HandleBuffer,
  UINT32      **HandleType
  );

#endif
