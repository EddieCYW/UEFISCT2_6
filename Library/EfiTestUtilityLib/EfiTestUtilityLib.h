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

  EfiTestUtilityLib.h

Abstract:

EFI Test Utility library functions

--*/

#ifndef _EFI_TEST_UTILITY_LIB_H_
#define _EFI_TEST_UTILITY_LIB_H_

//
// Disabling bitfield type checking warnings.
//
#ifndef __GNUC__
#pragma warning ( disable : 4214 )
#endif

#include "LinkedList.h"
#include "EfiPerf.h"
#include EFI_PROTOCOL_DEFINITION (SimpleFileSystem)
#include EFI_PROTOCOL_DEFINITION (FileInfo)
#include EFI_PROTOCOL_DEFINITION (FileSystemInfo)
#include EFI_PROTOCOL_DEFINITION (FileSystemVolumeLabelInfo)
#include EFI_PROTOCOL_DEFINITION (BlockIo)
#include EFI_PROTOCOL_DEFINITION (DeviceIo)
#if (EFI_SPECIFICATION_VERSION >= 0x0002000A)
#include "TianoHii.h"
#else
#include EFI_PROTOCOL_DEFINITION (Hii)
#endif
//
// Public read-only data in the EFI library
//

extern EFI_GUID gtEfiDevicePathProtocolGuid;
extern EFI_GUID gtEfiLoadedImageProtocolGuid;
extern EFI_GUID gtEfiSimpleTextInProtocolGuid;
extern EFI_GUID gtEfiSimpleTextOutProtocolGuid;
extern EFI_GUID gtEfiBlockIoProtocolGuid;
extern EFI_GUID gtEfiDiskIoProtocolGuid;
extern EFI_GUID gtEfiSimpleFileSystemProtocolGuid;
extern EFI_GUID gtEfiLoadFileProtocolGuid;
extern EFI_GUID gtEfiDeviceIoProtocolGuid;
extern EFI_GUID gtEfiVariableStoreProtocolGuid;
extern EFI_GUID gtEfiLegacyBootProtocolGuid;
extern EFI_GUID gtEfiUnicodeCollationProtocolGuid;
extern EFI_GUID gtEfiSerialIoProtocolGuid;
extern EFI_GUID gtEfiVgaClassProtocolGuid;
extern EFI_GUID tTextOutSpliterProtocol;
extern EFI_GUID tErrorOutSpliterProtocol;
extern EFI_GUID tTextInSpliterProtocol;
extern EFI_GUID gtEfiSimpleNetworkProtocolGuid;
extern EFI_GUID gtEfiPxeBaseCodeProtocolGuid;
extern EFI_GUID gtEfiPxeCallbackProtocolGuid;
extern EFI_GUID gtEfiNetworkInterfaceIdentifierProtocolGuid;

extern EFI_GUID tEfiGlobalVariable;
extern EFI_GUID tGenericFileInfo;
extern EFI_GUID gtEfiFileSystemInfoGuid;
extern EFI_GUID gtEfiFileSystemVolumeLabelInfoGuid;
extern EFI_GUID tPcAnsiProtocol;
extern EFI_GUID tVt100Protocol;
extern EFI_GUID gtEfiUnknownDeviceGuid;

extern EFI_GUID gtEfiPartTypeSystemPartitionGuid;
extern EFI_GUID gtEfiPartTypeLegacyMbrGuid;

extern EFI_GUID gtEfiMpsTableGuid;
extern EFI_GUID gtEfiAcpiTableGuid;
extern EFI_GUID gtEfiAcpi20TableGuid;
extern EFI_GUID gtEfiSMBIOSTableGuid;
extern EFI_GUID gtEfiSalSystemTableGuid;

//
// EFI Variable strings
//
#define LOAD_OPTION_ACTIVE          0x00000001

#define VarLanguageCodes            L"LangCodes"
#define VarLanguage                 L"Lang"
#define VarTimeout                  L"Timeout"
#define VarConsoleInp               L"ConIn"
#define VarConsoleOut               L"ConOut"
#define VarErrorOut                 L"ErrOut"
#define VarBootOption               L"Boot%04x"
#define VarBootOrder                L"BootOrder"
#define VarBootNext                 L"BootNext"
#define VarBootCurrent              L"BootCurrent"
#define VarDriverOption             L"Driver%04x"
#define VarDriverOrder              L"DriverOrder"
#define VarConsoleInpDev            L"ConInDev"
#define VarConsoleOutDev            L"ConOutDev"
#define VarErrorOutDev              L"ErrOutDev"

#define LanguageCodeEnglish         "eng"

extern EFI_DEVICE_PATH_PROTOCOL     *RootDevicePath ;
extern EFI_DEVICE_PATH_PROTOCOL     EndDevicePath[];
extern EFI_DEVICE_PATH_PROTOCOL     EndInstanceDevicePath[];

//
// Other public data in the EFI library
//

extern EFI_MEMORY_TYPE              PoolAllocationType;

//
// Prototypes
//

VOID
InitializeUnicodeSupport (
  CHAR8                             *LangCode
  );

BOOLEAN
MetaMatch (
  IN CHAR16                         *String,
  IN CHAR16                         *Pattern
  );

BOOLEAN
MetaiMatch (
  IN CHAR16                         *String,
  IN CHAR16                         *Pattern
  );

VOID
InitializeLock (
  IN OUT FLOCK                      *Lock,
  IN EFI_TPL                        Priority
  );

VOID
AcquireLock (
  IN FLOCK                          *Lock
  );

VOID
ReleaseLock (
  IN FLOCK                          *Lock
  );

VOID
Output (
  IN CHAR16                         *Str
  );

VOID
Input (
  IN CHAR16                         *Prompt OPTIONAL,
  OUT CHAR16                        *InStr,
  IN UINTN                          StrLen
  );

VOID
IInput (
  IN EFI_SIMPLE_TEXT_OUT_PROTOCOL   *ConOut,
  IN EFI_SIMPLE_TEXT_IN_PROTOCOL    *ConIn,
  IN CHAR16                         *Prompt OPTIONAL,
  OUT CHAR16                        *InStr,
  IN UINTN                          StrLen
  );

VOID
ValueToHex (
  IN CHAR16                         *Buffer,
  IN UINT64                         v
  );

VOID
DumpHex (
  IN UINTN                          Indent,
  IN UINTN                          Offset,
  IN UINTN                          DataSize,
  IN VOID                           *UserData
  );

EFI_MEMORY_DESCRIPTOR *
LibMemoryMap (
  OUT UINTN                         *NoEntries,
  OUT UINTN                         *MapKey,
  OUT UINTN                         *DescriptorSize,
  OUT UINT32                        *DescriptorVersion
  );

VOID *
LibGetVariable (
  IN CHAR16                         *Name,
  IN EFI_GUID                       *VendorGuid
  );

VOID *
LibGetVariableAndSize (
  IN CHAR16                         *Name,
  IN EFI_GUID                       *VendorGuid,
  OUT UINTN                         *VarSize
  );

EFI_STATUS
WaitForSingleEvent (
  IN EFI_EVENT                      Event,
  IN UINT64                         Timeout OPTIONAL
  );

EFI_FILE_HANDLE
LibOpenRoot (
  IN EFI_HANDLE                     DeviceHandle
  );

EFI_FILE_INFO *
LibFileInfo (
  IN EFI_FILE_HANDLE                FHand
  );

BOOLEAN
LibMatchDevicePaths (
  IN  EFI_DEVICE_PATH_PROTOCOL      *Multi,
  IN  EFI_DEVICE_PATH_PROTOCOL      *Single
  );

EFI_DEVICE_PATH_PROTOCOL *
DevicePathFromHandle (
  IN EFI_HANDLE                     Handle
  );

UINT16 *
DevicePathStrFromProtocol (
  IN VOID        *Protocol,
  IN EFI_GUID    *Guid
  );

EFI_DEVICE_PATH_PROTOCOL *
DevicePathInstance (
  IN OUT EFI_DEVICE_PATH_PROTOCOL   **DevicePath,
  OUT UINTN                         *Size
  );

UINTN
DevicePathInstanceCount (
  IN EFI_DEVICE_PATH_PROTOCOL       *DevicePath
  );

EFI_DEVICE_PATH_PROTOCOL *
AppendDevicePath (
  IN EFI_DEVICE_PATH_PROTOCOL       *Src1,
  IN EFI_DEVICE_PATH_PROTOCOL       *Src2
  );

EFI_DEVICE_PATH_PROTOCOL *
AppendDevicePathNode (
  IN EFI_DEVICE_PATH_PROTOCOL       *Src1,
  IN EFI_DEVICE_PATH_PROTOCOL       *Src2
  );

EFI_DEVICE_PATH_PROTOCOL*
AppendDevicePathInstance (
  IN EFI_DEVICE_PATH_PROTOCOL       *Src,
  IN EFI_DEVICE_PATH_PROTOCOL       *Instance
  );

EFI_DEVICE_PATH_PROTOCOL *
FileDevicePath (
  IN EFI_HANDLE                     Device  OPTIONAL,
  IN CHAR16                         *FileName
  );

UINTN
DevicePathSize (
  IN EFI_DEVICE_PATH_PROTOCOL       *DevPath
  );

EFI_DEVICE_PATH_PROTOCOL *
DuplicateDevicePath (
  IN EFI_DEVICE_PATH_PROTOCOL       *DevPath
  );

EFI_DEVICE_PATH_PROTOCOL *
UnpackDevicePath (
  IN EFI_DEVICE_PATH_PROTOCOL       *DevPath
  );

EFI_STATUS
LibDevicePathToInterface (
  IN EFI_GUID                       *Protocol,
  IN EFI_DEVICE_PATH_PROTOCOL       *FilePath,
  OUT VOID                          **Interface
  );

CHAR16 *
DevicePathToStr (
  EFI_DEVICE_PATH_PROTOCOL          *DevPath
  );

//
//added by kevin for test cases.
//
EFI_STATUS
GetFilePathByName (
  IN CHAR16                       *Name,
  OUT EFI_DEVICE_PATH_PROTOCOL    **DevicePath,
  OUT CHAR16                      **FilePath
  );

EFI_STATUS
LibGetManagedChildControllerHandles (
  EFI_HANDLE  DriverBindingHandle,
  EFI_HANDLE  ControllerHandle,
  UINTN       *ChildControllerHandleCount,
  EFI_HANDLE  **ChildControllerHandleBuffer
  );

EFI_STATUS
LibGetManagedControllerHandles (
  EFI_HANDLE  DriverBindingHandle,
  UINTN       *ControllerHandleCount,
  EFI_HANDLE  **ControllerHandleBuffer
  );

EFI_STATUS
LibGetFreePages (
  IN UINT64 *NoFreePages
  );

EFI_STATUS
StallForKey (
  IN UINTN             Seconds,
  OUT EFI_INPUT_KEY    *Key
  );

#endif
