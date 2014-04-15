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
// List API
//

#define INITIALIZE_SCT_LIST_HEAD_VARIABLE(ListHead)  {&ListHead, &ListHead}

typedef struct _SCT_LIST_ENTRY {
  struct _SCT_LIST_ENTRY  *ForwardLink;
  struct _SCT_LIST_ENTRY  *BackLink;
} SCT_LIST_ENTRY;

VOID
SctInitializeListHead (
  SCT_LIST_ENTRY       *List
  );

SCT_LIST_ENTRY *
SctGetFirstNode (
  CONST SCT_LIST_ENTRY  *List
  );

SCT_LIST_ENTRY *
SctGetNextNode (
  CONST SCT_LIST_ENTRY  *List,
  CONST SCT_LIST_ENTRY  *Node
  );

BOOLEAN
SctIsListEmpty (
  CONST SCT_LIST_ENTRY  *List
  );

BOOLEAN
SctIsNull (
  CONST SCT_LIST_ENTRY  *List,
  CONST SCT_LIST_ENTRY  *Node
  );

VOID
SctRemoveEntryList (
  SCT_LIST_ENTRY  *Entry
  );

VOID
SctInsertTailList (
  SCT_LIST_ENTRY  *ListHead,
  SCT_LIST_ENTRY  *Entry
  );

VOID
SctInsertHeadList (
  SCT_LIST_ENTRY  *ListHead,
  SCT_LIST_ENTRY  *Entry
  );

BOOLEAN
SctIsNodeAtEnd (
  CONST SCT_LIST_ENTRY  *List,
  CONST SCT_LIST_ENTRY  *Node
  );

//
// Math API
//

UINT64
SctLShiftU64 (
  IN UINT64                         Operand,
  IN UINTN                          Count
  );

UINT64
SctRShiftU64 (
  IN UINT64                         Operand,
  IN UINTN                          Count
  );

UINT64
SctMultU64x32 (
  IN UINT64                         Multiplicand,
  IN UINTN                          Multiplier
  );

UINT64
SctDivU64x32 (
  IN UINT64                         Dividend,
  IN UINTN                          Divisor,
  OUT UINTN                         *Remainder OPTIONAL
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
// Misc API
//

INTN
SctCompareGuid (
  IN EFI_GUID                       *Guid1,
  IN EFI_GUID                       *Guid2
  );

EFI_STATUS
SctCalculateCrc32 (
  IN     UINT8                          *Data,
  IN     UINTN                          DataSize,
  IN OUT UINT32                         *CrcOut
  );

BOOLEAN
SctGrowBuffer (
  IN OUT EFI_STATUS   *Status,
  IN OUT VOID         **Buffer,
  IN UINTN            BufferSize
  );

UINT16
SctSwapBytes16 (
  IN      UINT16                    Value
  );

UINT32
SctSwapBytes32 (
  IN      UINT32                    Value
  );

UINT16
SctWriteUnaligned16 (
  OUT UINT16                    *Buffer,
  IN  UINT16                    Value
  );

UINT32
SctWriteUnaligned32 (
  OUT UINT32                    *Buffer,
  IN  UINT32                    Value
  );


//
// Print API
//

typedef struct {
  CHAR16                            *str;
  UINTN                             len;
  UINTN                             maxlen;
} SCT_POOL_PRINT;

UINTN
SctPrintAt (
  IN UINTN                          Column,
  IN UINTN                          Row,
  IN CONST CHAR16                   *fmt,
  ...
  );

UINTN
SctPrint (
  IN CONST CHAR16                   *fmt,
  ...
  );

UINTN
SctAPrint (
  IN CHAR8                          *fmt,
  ...
  );

UINTN
SctSPrint (
  OUT CHAR16  *Str,
  IN UINTN    StrSize,
  IN CHAR16   *fmt,
  ...
  );

UINTN
SctASPrint (
  OUT CHAR8   *Str,
  IN UINTN    StrSize,
  IN CHAR8    *fmt,
  ...
  );

UINTN
SctVSPrint (
  OUT CHAR16                        *Str,
  IN UINTN                          StrSize,
  IN CONST CHAR16                   *fmt,
  IN VA_LIST                        vargs
  );

CHAR16 *
SctPoolPrint (
  IN CONST CHAR16                   *fmt,
  ...
  );

CHAR16 *
SctCatPrint (
    IN OUT SCT_POOL_PRINT   *Str,
    IN CONST CHAR16     *fmt,
    ...
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

//
// String API
//

#define LEFT_JUSTIFY  0x01
#define PREFIX_SIGN   0x02
#define PREFIX_BLANK  0x04
#define COMMA_TYPE    0x08
#define LONG_TYPE     0x10
#define PREFIX_ZERO   0x20

INTN
SctStrCmp (
  IN CONST CHAR16                   *s1,
  IN CONST CHAR16                   *s2
  );

INTN
SctStrnCmp (
  IN CONST CHAR16                   *s1,
  IN CONST CHAR16                   *s2,
  IN UINTN                          len
  );

INTN
SctStriCmp (
  IN CONST CHAR16                   *s1,
  IN CONST CHAR16                   *s2
  );

VOID
SctStrLwr (
  IN CONST CHAR16                   *Str
  );

VOID
SctStrUpr (
  IN CONST CHAR16                   *Str
  );

VOID
SctStrCpy (
  IN CHAR16                         *Dest,
  IN CONST CHAR16                   *Src
  );

VOID
SctStrnCpy (
  OUT CHAR16                   *Dst,
  IN  CONST CHAR16             *Src,
  IN  UINTN                    Length
  );

VOID
StrTrim (
  IN OUT CHAR16                     *str,
  IN     CHAR16                     c
  );

VOID
SctStrCat (
  IN CHAR16                         *Dest,
  IN CONST CHAR16                   *Src
  );

CHAR16 *
SctStrChr (
  IN  CHAR16  *Str,
  IN  CHAR16  c
  );

UINTN
SctStrLen (
  IN CONST CHAR16                   *s1
  );

UINTN
SctStrSize (
  IN CONST CHAR16                   *s1
  );

CHAR16 *
SctStrDuplicate (
  IN CONST CHAR16                   *Src
  );

CHAR16*
SctStrStr (
  IN  CONST CHAR16  *Str,
  IN  CONST CHAR16  *Pat
  );

CHAR8 *
SctAsciiStrDuplicate (
  CHAR8 CONST  *str
  );

CHAR8 *
EFIAPI
SctAsciiStrCpy (
  OUT     CHAR8                     *Destination,
  IN      CONST CHAR8               *Source
  );

CHAR8 *
SctAsciiStrnCpy (
  CHAR8       *dst,
  CHAR8       *src,
  UINTN       n
  );

UINTN
EFIAPI
SctAsciiStrLen (
  IN      CONST CHAR8               *String
  );

UINTN
SctAsciiStrSize (
  IN CONST CHAR8   *String
  );

INTN
SctAsciiStriCmp (
  IN CONST CHAR8       *s1,
  IN CONST CHAR8       *s2
  );

CHAR8 *
EFIAPI
SctAsciiStrCat (
  IN OUT CHAR8    *Destination,
  IN CONST CHAR8  *Source
  );

UINTN
SctAsciiStrCmp (
  IN CHAR8                          *s1,
  IN CHAR8                          *s2
  );

UINTN
SctAsciiStrnCmp (
  IN CHAR8                          *s1,
  IN CHAR8                          *s2,
  IN UINTN                          len
  );

CHAR8*
EFIAPI
SctAsciiStrChr (
  IN  CHAR8  *String,
  IN  CHAR8  c
  );

CHAR8*
EFIAPI
SctAsciiStrStr (
  IN  CHAR8  *String,
  IN  CHAR8  *StrCharSet
  );

UINTN
SctXtoi (
  CHAR16                            *str
  );

UINTN
SctAtoi (
  CHAR16                            *str
  );

UINTN
SctStrToUInt (
  IN  CHAR16       *Str
  );

VOID
SctStrToUInt64 (
  IN  CHAR16       *Str,
  OUT UINT64       *Result
  );

VOID
SctValueToHexStr (
  IN CHAR16      *Buffer,
  IN UINT64      v,
  IN UINTN       Flags,
  IN UINTN       Width
  );

VOID
SctStrToAscii (
  IN CHAR16 *Str,
  IN CHAR8  *AsciiStr
  );

CHAR16 *
SctSplitStr (
  IN OUT CHAR16 **List,
  IN     CHAR16 Separator
  );

CHAR8 *
SctAsciiSplitStr (
  IN OUT CHAR8 **List,
  IN     CHAR8 Separator
  );

VOID
SctStrToIPv4Addr (
  IN OUT CHAR16           **Str,
  OUT    EFI_IPv4_ADDRESS *IPv4Addr
  );

VOID
SctStrToIPv6Addr (
  IN OUT CHAR16           **Str,
  OUT    EFI_IPv6_ADDRESS *IPv6Addr
  );

VOID
SctValueToHexStr (
  IN CHAR16      *Buffer,
  IN UINT64      v,
  IN UINTN       Flags,
  IN UINTN       Width
  );

BOOLEAN
SctIsHexDigit (
  OUT UINT8      *Digit,
  IN  CHAR16      Char
  );

CHAR16
SctNibbleToHexChar (
  IN UINT8      Nibble
  );

EFI_STATUS
SctHexStringToBuf (
  IN OUT UINT8                     *Buf,
  IN OUT UINTN                    *Len,
  IN     CHAR16                    *Str,
  OUT    UINTN                     *ConvertedStrLen  OPTIONAL
  );

EFI_STATUS
SctBufToHexString (
  IN OUT CHAR16                    *Str,
  IN OUT UINTN                     *HexStringBufferLength,
  IN     UINT8                     *Buf,
  IN     UINTN                      Len
  );

UINTN
SctUnicodeToAscii (
  CHAR8       *s,
  CHAR16      *pwcs,
  UINTN       n
  );

UINTN
SctAsciiToUnicode (
  CHAR16      *pwcs,
  CHAR8       *s,
  UINTN       n
  );

VOID
SctStrTrim (
  IN OUT CHAR16   *str,
  IN     CHAR16   c
  );

#endif
