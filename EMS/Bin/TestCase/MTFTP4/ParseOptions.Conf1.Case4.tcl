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
# Copyright 2006, 2007, 2008, 2009, 2010 Unified EFI, Inc. All
# Rights Reserved, subject to all existing rights in all      
# matters included within this Test Suite, to which United    
# EFI, Inc. makes no claim of right.                          
#                                                             
# Copyright (c) 2010, Intel Corporation. All rights reserved.<BR> 
#
#
################################################################################
CaseLevel         CONFORMANCE
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid        3D61D23A-D7FF-41de-ABB1-CDA2BECA6D93
CaseName        ParseOptions.Conf1.Case4
CaseCategory    MTFTP4
CaseDescription {This case is to test the EFI_INVALID_PARAMETER conformance of \
                Mtftp4.ParseOptions with the packet being not an OACK packet.}
################################################################################
#
# Begin log ...
#
BeginLog

Include MTFTP4/include/Mtftp4.inc.tcl

BeginScope _MTFTP4_PARSEOPTIONS_CONFORMANCE1_CASE4_

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
UINTN                            R_Status
UINTN                            R_Handle
EFI_MTFTP4_CONFIG_DATA           R_MtftpConfigData
UINT32                           R_PacketLen
EFI_MTFTP4_PACKET                R_Packet
UINT32                           R_OptionCount
POINTER                          R_OptionList
CHAR8                            R_Filename(9)
CHAR8                            R_FilenameValue(9)
POINTER                          R_Temp

#
# Mtftp4
#
Mtftp4ServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mtftp4SBP.CreateChild - Create Child 1"                       \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_MtftpConfigData.UseDefaultSetting   FALSE
SetIpv4Address R_MtftpConfigData.StationIp   "192.168.88.88"
SetIpv4Address R_MtftpConfigData.SubnetMask  "255.255.255.0"
SetVar R_MtftpConfigData.LocalPort           2048
SetIpv4Address R_MtftpConfigData.GatewayIp   "0.0.0.0"
SetIpv4Address R_MtftpConfigData.ServerIp    "192.168.88.1"
SetVar R_MtftpConfigData.InitialServerPort   69
SetVar R_MtftpConfigData.TryCount            10
SetVar R_MtftpConfigData.TimeoutValue        2

Mtftp4->Configure {&@R_MtftpConfigData, &@R_Status}
GetAck

set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mtftp4.Configure - Normal operation."                         \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"
#
# check point
#
SetVar R_PacketLen          20
SetVar R_Packet.OpCode      0x100
SetVar R_Packet.Rrq.OpCode  0x100
SetVar R_Filename           "Filename"
SetVar R_FilenameValue      "test.txt"
BS->CopyMem {&@R_Packet.Rrq.Filename, &@R_Filename, 9, &@R_Status}
GetAck

SetVar R_Temp &@R_Packet.Rrq.Filename
GetVar R_Temp
set tmp $R_Temp
set tmp [expr $tmp + 9]
SetVar R_Temp $tmp
BS->CopyMem {@R_Temp, &@R_FilenameValue, 9, &@R_Status}
GetAck

Mtftp4->ParseOptions {@R_PacketLen, &@R_Packet, &@R_OptionCount, &@R_OptionList,\
                    &@R_Status}
GetAck

set assert [VerifyReturnStatus R_Status $EFI_INVALID_PARAMETER]
RecordAssertion $assert $Mtftp4ParseOptionsConfAssertionGuid007                \
                "Mtftp4.ParseOptions - returns EFI_INVALID_PARAMETER with the  \
                 packet being not an OACK packet."                             \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_INVALID_PARAMETER"

BS->FreePool {@R_OptionList, &@R_Status}
GetAck

Mtftp4ServiceBinding->DestroyChild {@R_Handle, &@R_Status}
GetAck

set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mtftp4SBP.DestroyChild - Destroy Child 1"                     \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

EndScope _MTFTP4_PARSEOPTIONS_CONFORMANCE1_CASE4_

#
# End Log
#
EndLog
