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
CaseLevel         FUNCTION
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT

#
# test case Name, category, description, GUID...
#
CaseGuid        8E0A3387-6DC0-42cc-9B06-33557C9F1E01
CaseName        Request.Func5.Case1
CaseCategory    ARP
CaseDescription {This case is to test the function of ARP.Request}
################################################################################

proc CleanUpEutEnvironment {} {
  Arp->Delete {TRUE, NULL, &@R_Status}
  GetAck

  Arp->Delete {FALSE, NULL, &@R_Status}
  GetAck
 
  ArpServiceBinding->DestroyChild {@R_Handle, &@R_Status}
  GetAck

  BS->CloseEvent "@R_ResolvedEvent1, &@R_Status"
  GetAck
  BS->CloseEvent "@R_ResolvedEvent2, &@R_Status"
  GetAck

  EndCapture
  EndScope _ARP_FUNC_CONFORMANCE_
  VifDown 0
  EndLog
}

#
# Begin log ...
#
BeginLog

Include ARP/include/Arp.inc.tcl

set hostmac    [GetHostMac]
set targetmac  [GetTargetMac]

VifUp 0 172.16.210.162 255.255.255.0
BeginScope _ARP_FUNC_CONFORMANCE_

UINTN                            R_Status
UINTN                            R_Handle
EFI_IP_ADDRESS                   R_StationAddress
EFI_ARP_CONFIG_DATA              R_ArpConfigData
EFI_IP_ADDRESS                   R_TargetSwAddress
EFI_MAC_ADDRESS                  R_TargetHwAddress
EFI_IP_ADDRESS                   R_TargetSwAddress1
UINTN                            R_ResolvedEvent1
UINTN                            R_ResolvedEvent2
EFI_MAC_ADDRESS                  R_TargetHwAddress1
UINTN                            R_EventContext

ArpServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "ArpSBP.CreateChild - Create Child 1"                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetIpv4Address R_StationAddress.v4     "172.16.210.102"
SetVar R_ArpConfigData.SwAddressType   0x800
SetVar R_ArpConfigData.SwAddressLength 4
SetVar R_ArpConfigData.StationAddress  &@R_StationAddress
SetVar R_ArpConfigData.EntryTimeOut    500000000
SetVar R_ArpConfigData.RetryCount      30
SetVar R_ArpConfigData.RetryTimeOut    5000000

Arp->Configure {&@R_ArpConfigData, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Arp.Configure - Config Child 1"                               \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_EventContext 0
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_EventContext,   \
                 &@R_ResolvedEvent1, &@R_Status"
GetAck

BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_EventContext,   \
                 &@R_ResolvedEvent2, &@R_Status"
GetAck

set L_Filter "ether proto \\arp and src host 172.16.210.102"
StartCapture CCB $L_Filter

SetEthMacAddress R_TargetHwAddress 01:01:01:01:01:01
SetIpv4Address R_TargetSwAddress.v4 "172.16.210.161"

#
# Check point
#
Arp->Request {&@R_TargetSwAddress, @R_ResolvedEvent1, &@R_TargetHwAddress,      \
	            &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_NOT_READY]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Arp.Request - Send request"                                   \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_NOT_READY"

SetEthMacAddress R_TargetHwAddress1 01:01:01:01:01:01
SetIpv4Address R_TargetSwAddress1.v4 "172.16.210.161"

#
# Check point
#
Arp->Request {&@R_TargetSwAddress1, @R_ResolvedEvent2, &@R_TargetHwAddress1,   \
	            &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_NOT_READY]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Arp.Request - Send request"                                   \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_NOT_READY"

ReceiveCcbPacket CCB TmpPkt 10
if { ${CCB.received} == 0} {
  set assert fail
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "Arp.Request - Send Request"                                 \
                  "Packet not captured"

  CleanUpEutEnvironment
  return
}

ParsePacket TmpPkt -t arp -arp_sha ARP_SHA

LocalEther  00:02:03:04:05:06
RemoteEther $ARP_SHA
LocalIp     172.16.210.161
RemoteIp    172.16.210.102

CreatePacket Pkt1 -t arp -arp_op 2 
SendPacket Pkt1

GetVar R_EventContext
if {$R_EventContext == 2} {
  set assert pass
} else {
  set assert fail
}
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Arp.Request - Send request"                                   \
                "Context - $R_EventContext, ExpectedContext - 2"

set R_TargetHwAddress [GetEthMacAddress R_TargetHwAddress]
if {[string compare -nocase $R_TargetHwAddress 00:02:03:04:05:06] == 0} {
  set assert pass
} else {
  set assert fail
}
RecordAssertion $assert $ArpRequestFuncAssertionGuid009                        \
                "Arp.Request - R_TargetHwAddress is correct"                   \
                "Get - $R_TargetHwAddress, Expected - 00:02:03:04:05:06"

CleanUpEutEnvironment
