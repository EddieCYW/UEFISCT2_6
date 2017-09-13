#
# The material contained herein is not a license, either
# expressly or impliedly, to any intellectual property owned
# or controlled by any of the authors or developers of this
# material or to any contribution thereto. The material
# contained herein is provided on an "AS IS" basis and, to the
# maximum extent permitted by applicable law, this information
# is provided AS IS AND WITH ALL FAULTS, and the authors and
# developers of this material hereby disclaim all other
# warranties and conditions, either express, implied or
# statutory, including, but not limited to, any (if any)
# implied warranties, duties or conditions of merchantability,
# of fitness for a particular purpose, of accuracy or
# completeness of responses, of results, of workmanlike
# effort, of lack of viruses and of lack of negligence, all
# with regard to this material and any contribution thereto.
# Designers must not rely on the absence or characteristics of
# any features or instructions marked "reserved" or
# "undefined." The Unified EFI Forum, Inc. reserves any
# features or instructions so marked for future definition and
# shall have no responsibility whatsoever for conflicts or
# incompatibilities arising from future changes to them. ALSO,
# THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT,
# QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR
# NON-INFRINGEMENT WITH REGARD TO THE TEST SUITE AND ANY
# CONTRIBUTION THERETO.
#
# IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THIS MATERIAL OR
# ANY CONTRIBUTION THERETO BE LIABLE TO ANY OTHER PARTY FOR
# THE COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST
# PROFITS, LOSS OF USE, LOSS OF DATA, OR ANY INCIDENTAL,
# CONSEQUENTIAL, DIRECT, INDIRECT, OR SPECIAL DAMAGES WHETHER
# UNDER CONTRACT, TORT, WARRANTY, OR OTHERWISE, ARISING IN ANY
# WAY OUT OF THIS OR ANY OTHER AGREEMENT RELATING TO THIS
# DOCUMENT, WHETHER OR NOT SUCH PARTY HAD ADVANCE NOTICE OF
# THE POSSIBILITY OF SUCH DAMAGES.
#
# Copyright 2006 - 2016 Unified EFI, Inc. All
# Rights Reserved, subject to all existing rights in all
# matters included within this Test Suite, to which United
# EFI, Inc. makes no claim of right.
#
# Copyright (c) 2010 - 2016, Intel Corporation. All rights reserved.<BR>
#
# Copyright (c) 2016, ARM Ltd. All rights reserved.<BR>
#
#
#/*++
#
# Module Name:
#
#    SBBR_SCT.dsc
#
# Abstract:
#
#   This is a build description file used to build the test modules of SBBR SCT.
#
# Notes:
#
#   The info in this file is broken down into sections. The start of a section
#   is designated by a "[" in the first column. So the [=====] separater ends
#   a section.
#
#--*/

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = SbbrSct
  PLATFORM_GUID                  = d513138b-9d4a-479c-8058-4a5160018663
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/SbbrSct
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT

  DEFINE GCC_VER_MACRO           = -D EFI_SPECIFICATION_VERSION=0x00020028 -D TIANO_RELEASE_VERSION=0x00080006
  DEFINE MSFT_VER_MACRO          = /D EFI_SPECIFICATION_VERSION=0x00020028 /D TIANO_RELEASE_VERSION=0x00080006


################################################################################
#
# SKU Identification section - list of all SKU IDs supported by this
#                              Platform.
#
################################################################################
[SkuIds]
  0|DEFAULT              # The entry: 0|DEFAULT is reserved and always required.

[BuildOptions]
  *_*_AARCH64_CC_FLAGS         = -D EFIAARCH64 -I$(WORKSPACE)/MdePkg/Include/AArch64 $(GCC_VER_MACRO)
  GCC:*_*_AARCH64_CC_FLAGS     = -D EFIAARCH64 $(GCC_VER_MACRO) -ffreestanding -nostdinc -nostdlib -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error
  *_*_AARCH64_VFRPP_FLAGS      = -D EFIAARCH64 $(GCC_VER_MACRO)
  *_*_AARCH64_APP_FLAGS        = -D EFIAARCH64 $(GCC_VER_MACRO)
  *_*_AARCH64_PP_FLAGS         = -D EFIAARCH64 $(GCC_VER_MACRO)
  RVCT:*_*_AARCH64_DLINK_FLAGS = --muldefweak

  DEBUG_*_*_CC_FLAGS  = -DEFI_DEBUG
  RELEASE_*_*_CC_FLAGS  = -DMDEPKG_NDEBUG

[Libraries]
  SctPkg/Library/SctLib/SctLib.inf
  SctPkg/Library/SctGuidLib/SctGuidLib.inf
  SctPkg/Library/EfiTestLib/EfiTestLib.inf

  SctPkg/TestInfrastructure/SCT/Framework/ENTS/EasLib/EntsLib.inf

  MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf

[Libraries.ARM]
  ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf

[Libraries.AARCH64]
  ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf

[LibraryClasses.common]
  UefiApplicationEntryPoint|MdePkg/Library/UefiApplicationEntryPoint/UefiApplicationEntryPoint.inf
  UefiDriverEntryPoint|MdePkg/Library/UefiDriverEntryPoint/UefiDriverEntryPoint.inf
  UefiBootServicesTableLib|MdePkg/Library/UefiBootServicesTableLib/UefiBootServicesTableLib.inf
  BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
  BaseMemoryLib|MdePkg/Library/BaseMemoryLib/BaseMemoryLib.inf
  DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
  MemoryAllocationLib|MdePkg/Library/UefiMemoryAllocationLib/UefiMemoryAllocationLib.inf
  UefiRuntimeServicesTableLib|MdePkg/Library/UefiRuntimeServicesTableLib/UefiRuntimeServicesTableLib.inf
  UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
  HiiLib|MdeModulePkg/Library/UefiHiiLib/UefiHiiLib.inf
  PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
  UefiLib|MdePkg/Library/UefiLib/UefiLib.inf
  DevicePathLib|MdePkg/Library/UefiDevicePathLib/UefiDevicePathLib.inf

  SctLib|SctPkg/Library/SctLib/SctLib.inf
  NetLib|SctPkg/Library/NetLib/NetLib.inf
  EntsLib|SctPkg/TestInfrastructure/SCT/Framework/ENTS/EasLib/EntsLib.inf
  EasLib|SctPkg/TestInfrastructure/SCT/Framework/ENTS/EasDispatcher/Eas.inf
  EfiTestLib|SctPkg/Library/EfiTestLib/EfiTestLib.inf

[LibraryClasses.ARM]
  NULL|ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf

[LibraryClasses.AARCH64]
  NULL|ArmPkg/Library/CompilerIntrinsicsLib/CompilerIntrinsicsLib.inf
  ArmLib|ArmPkg/Library/ArmLib/ArmBaseLib.inf

###############################################################################
#
# These are the components that will be built by the master makefile
#
###############################################################################

[Components]

#
# The default package
#
DEFINE PACKAGE=Default

#
# Components
#

#
# Following are the SCT suite & related drivers
#

SctPkg/TestInfrastructure/SCT/Framework/Sct.inf
SctPkg/TestInfrastructure/SCT/Drivers/StandardTest/StandardTest.inf
SctPkg/TestInfrastructure/SCT/Drivers/TestProfile/TestProfile.inf
SctPkg/TestInfrastructure/SCT/Drivers/TestRecovery/TestRecovery.inf
SctPkg/TestInfrastructure/SCT/Drivers/TestLogging/TestLogging.inf

#
# Related SCT applications
#

SctPkg/Application/InstallSct/InstallSct.inf
SctPkg/Application/StallForKey/StallForKey.inf

SctPkg/SCRT/SCRTApp/SCRTApp.inf
SctPkg/SCRT/SCRTDriver/SCRTDriver.inf

#
# Test cases for SBBR SCT
#

# Boot Services Tests - SBBR v1.0 Appendix A
#
##  1. EFI_RAISE_TPL
##  2. EFI_RESTORE_TPL
##  3. EFI_CREATE_EVENT
##  4. EFI_SET_TIMER
##  5. EFI_WAIT_FOR_EVENT
##  6. EFI_SIGNAL_EVENT
##  7. EFI_CLOSE_EVENT
##  8. EFI_CREATE_EVENT_EX
SctPkg/TestCase/UEFI/EFI/BootServices/EventTimerTaskPriorityServices/BlackBoxTest/EventTimerTaskPriorityServicesBBTest_uefi.inf
#
##  9. EFI_IMAGE_LOAD
## 10. EFI_IMAGE_START
## 11. EFI_EXIT
## 12. EFI_IMAGE_UNLOAD
## 13. EFI_EXIT_BOOT_SERVICES
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/ImageBBTest.inf
##
## Dependency files for Image Services Test
##
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/LoadFile/LoadFile.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/Application1/Application1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/Application2/Application2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/Application3/Application3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/Application4/Application4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver1/BootServicesDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver2/BootServicesDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver3/BootServicesDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver4/BootServicesDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver5/BootServicesDriver5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/BootServicesDriver6/BootServicesDriver6.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver1/RuntimeServicesDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver2/RuntimeServicesDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver3/RuntimeServicesDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver4/RuntimeServicesDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver5/RuntimeServicesDriver5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/RuntimeServicesDriver6/RuntimeServicesDriver6.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage1/CombinationImage1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage2/CombinationImage2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage3/CombinationImage3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage4/CombinationImage4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage5/CombinationImage5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage6/CombinationImage6.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage7/CombinationImage7.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage8/CombinationImage8.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage9/CombinationImage9.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/CombinationImage10/CombinationImage10.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage1/InvalidImage1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage2/InvalidImage2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage3/InvalidImage3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage4/InvalidImage4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage5/InvalidImage5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage6/InvalidImage6.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/InvalidImage7/InvalidImage7.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ImageServices/BlackBoxTest/Dependency/ValidHiiImage1/ValidHiiImage1.inf
#
## 14. EFI_ALLOCATE_PAGES
## 15. EFI_FREE_PAGES
## 16. EFI_GET_MEMORY_MAP
## 17. EFI_ALLOCATE_POOL
## 18. EFI_FREE_POOL
SctPkg/TestCase/UEFI/EFI/BootServices/MemoryAllocationServices/BlackBoxTest/MemoryAllocationServicesBBTest.inf
#
## 19. EFI_INSTALL_CONFIGURATION_TABLE
## 20. EFI_GET_NEXT_MONOTONIC_COUNT
## 21. EFI_STALL
## 22. EFI_SET_WATCHDOG_TIMER
## 23. EFI_CALCULATE_CRC32
## 24. EFI_COPY_MEM
## 25. EFI_SET_MEM
SctPkg/TestCase/UEFI/EFI/BootServices/MiscBootServices/BlackBoxTest/MiscBootServicesBBTest.inf
#
## 26. EFI_INSTALL_PROTOCOL_INTERFACE
## 27. EFI_REINSTALL_PROTOCOL_INTERFACE
## 28. EFI_UNINSTALL_PROTOCOL_INTERFACE
## 29. EFI_HANDLE_PROTOCOL
## 30. EFI_REGISTER_PROTOCOL_NOTIFY
## 31. EFI_LOCATE_HANDLE
## 32. EFI_LOCATE_PROTOCOL
## 33. EFI_LOCATE_DEVICE_PATH
## 34. EFI_CONNECT_CONTROLLER
## 35. EFI_DISCONNECT_CONTROLLER
## 36. EFI_OPEN_PROTOCOL
## 37. EFI_CLOSE_PROTOCOL
## 38. EFI_OPEN_PROTOCOL_INFORMATION
## 39. EFI_PROTOCOLS_PER_HANDLE
## 40. EFI_LOCATE_HANDLE_BUFFER
## 41. EFI_INSTALL_MULTIPLE_PROTOCOL_INTERFACES
## 42. EFI_UNINSTALL_MULTIPLE_PROTOCOL_INTERFACES
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/ProtocolHandlerBBTest.inf
##
## Dependency files for Protocol Handler Services Test
##
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/BusDriver1/BusDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/BusDriver2/BusDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/BusDriver3/BusDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/BusDriver4/BusDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DBindingDriver1/DBindingDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DBindingDriver2/DBindingDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DBindingDriver3/DBindingDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DBindingDriver4/DBindingDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DBindingDriver5/DBindingDriver5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver1/DeviceDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver2/DeviceDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver3/DeviceDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver4/DeviceDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver5/DeviceDriver5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver6/DeviceDriver6.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver7/DeviceDriver7.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver11/DeviceDriver11.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver12/DeviceDriver12.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver13/DeviceDriver13.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver14/DeviceDriver14.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver15/DeviceDriver15.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver18/DeviceDriver18.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver19/DeviceDriver19.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver110/DeviceDriver110.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/DeviceDriver111/DeviceDriver111.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/TestDriver1/TestDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/TestDriver2/TestDriver2.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/TestDriver3/TestDriver3.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/TestDriver4/TestDriver4.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/TestDriver5/TestDriver5.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/PlatformOverrideDriver1/PlatformOverrideDriver1.inf
SctPkg/TestCase/UEFI/EFI/BootServices/ProtocolHandlerServices/BlackBoxTest/Dependency/BusOverrideDriver1/BusOverrideDriver1.inf
# End of Boot Services Tests - SBBR v1.0 Appendix A

#
# UEFI System Environment and Configuration Tests - SBBR v1.0 3.3
#
SctPkg/TestCase/UEFI/EFI/Generic/SbbrSysEnvConfig/BlackBoxTest/SysEnvConfigBBTest.inf
#End of UEFI System Environment and Configuration Tests - SBBR v1.0 3.3
#
# Check if EFI Specification Version is 2.5 or greater
SctPkg/TestCase/UEFI/EFI/Generic/SbbrEfiSpecVerLvl/BlackBoxTest/EfiSpecVerLvlBBTest.inf
#
# UEFI Boot Services - SBBR v1.0 3.4
#
## 3.4.4 Configuration Tables
SctPkg/TestCase/UEFI/EFI/BootServices/SbbrBootServices/BlackBoxTest/SbbrBootServicesBBTest.inf
# End of UEFI Boot Services - SBBR v1.0 3.4

#
# SMBIOS Requirements on UEFI - SBBR v1.0 5.1.1
#
SctPkg/TestCase/UEFI/EFI/Generic/SbbrSmbios/BlackBoxTest/SbbrSmbiosBBTest.inf

#
# Required UEFI Runtime Services Tests - SBBR v1.0 Appendix B
#
##  1. EFI_GET_TIME
##  2. EFI_SET_TIME
##  3. EFI_GET_WAKEUP_TIME
##  4. EFI_SET_WAKEUP_TIME
SctPkg/TestCase/UEFI/EFI/RuntimeServices/TimeServices/BlackBoxTest/TimeServicesBBTest.inf
#
##  5. EFI_GET_VARIABLE
##  6. EFI_GET_NEXT_VARIABLE_NAME
##  7. EFI_SET_VARIABLE
##  8. EFI_QUERY_VARIABLE_INFO
SctPkg/TestCase/UEFI/EFI/RuntimeServices/VariableServices/BlackBoxTest/VariableServicesBBTest.inf
#
##  9. EFI_QUERY_CAPSULE_CAPABILITIES
## 10. EFI_UPDATE_CAPSULE
## 11. EFI_RESET_SYSTEM
SctPkg/TestCase/UEFI/EFI/RuntimeServices/MiscRuntimeServices/BlackBoxTest/MiscRuntimeServicesBBTest.inf
#
## 12. EFI_SET_VIRTUAL_ADDRESS_MAP
## 13. EFI_CONVERT_POINTER
SctPkg/TestCase/UEFI/EFI/RuntimeServices/SBBRRuntimeServices/BlackBoxTest/SBBRRuntimeServicesBBTest.inf
# End of Runtime Services Tests - SBBR v1.0 Appendix B

#
# UEFI Required Protocols Tests - SBBR Appendix C
#
SctPkg/TestCase/UEFI/EFI/Generic/SbbrRequiredUefiProtocols/BlackBoxTest/RequiredUefiProtocolsBBTest.inf
SctPkg/TestCase/UEFI/EFI/Generic/EfiCompliant/BlackBoxTest/EfiCompliantBBTest_uefi.inf
##
## Dependency files for UEFI/EFI Compliant Test
##
SctPkg/TestCase/UEFI/EFI/Generic/EfiCompliant/BlackBoxTest/Dependency/Config/Config.inf
# End of UEFI Required Protocols Tests - SBBR Appendix C

#
# Support Files
#
SctPkg/TestInfrastructure/SCT/Framework/ENTS/Eftp/Eftp.inf
SctPkg/TestInfrastructure/SCT/Framework/ENTS/MonitorServices/SerialMonitor/SerialMonitor.inf
SctPkg/TestInfrastructure/SCT/Framework/ENTS/MonitorServices/ManagedNetworkMonitor/ManagedNetworkMonitor.inf
SctPkg/TestInfrastructure/SCT/Framework/ENTS/MonitorServices/IP4NetworkMonitor/IP4NetworkMonitor.inf

