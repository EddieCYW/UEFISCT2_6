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
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid        44326E1C-883E-49bf-A871-F7EF44B81554
CaseName        Groups.Func2.Case1
CaseCategory    IP4
CaseDescription {Test the Groups Function of IP4 - After leaving a group address, \
                 Packet to that group can't be received}
################################################################################

Include IP4/include/Ip4.inc.tcl

#
# Begin log ...
#
BeginLog

#
# Begin scope
#
BeginScope _IP4_GROUPS_FUNCTION2_CASE1_

set hostmac    [GetHostMac]
set targetmac  [GetTargetMac]

VifUp 0 172.16.210.162 255.255.255.0

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
UINTN                            R_Status
UINTN                            R_Handle
EFI_IP4_CONFIG_DATA              R_IpConfigData
UINTN                            R_Context1
UINTN                            R_Context2
EFI_IP4_COMPLETION_TOKEN         R_Token1
EFI_IP4_COMPLETION_TOKEN         R_Token2
EFI_IPv4_ADDRESS                 R_GroupAddress

Ip4ServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4SBP.Groups - Func - Create Child"                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_IpConfigData.DefaultProtocol             0
SetVar R_IpConfigData.AcceptAnyProtocol           TRUE
SetVar R_IpConfigData.AcceptIcmpErrors            TRUE
SetVar R_IpConfigData.AcceptBroadcast             FALSE
SetVar R_IpConfigData.AcceptPromiscuous           FALSE
SetVar R_IpConfigData.UseDefaultAddress           FALSE
SetIpv4Address R_IpConfigData.StationAddress      "172.16.210.102"
SetIpv4Address R_IpConfigData.SubnetMask          "255.255.255.0"
SetVar R_IpConfigData.TypeOfService               0
SetVar R_IpConfigData.TimeToLive                  16
SetVar R_IpConfigData.DoNotFragment               TRUE
SetVar R_IpConfigData.RawData                     FALSE
SetVar R_IpConfigData.ReceiveTimeout              0
SetVar R_IpConfigData.TransmitTimeout             0

#
# check point
#
Ip4->Configure {&@R_IpConfigData, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - Config Child"                             \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetIpv4Address R_GroupAddress "225.0.0.1"

#
# Join group 225.0.0.1
#
Ip4->Groups {TRUE, &@R_GroupAddress, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - Join a group"                             \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# build packet to 225.0.0.1
#
LocalEther  0:2:3:4:5:6
RemoteEther 01:00:5e:00:00:01
LocalIp     172.16.210.161
RemoteIp    225.0.0.1

CreatePayload aaa const 18 0x0
CreatePacket 2 -t ip -ipv4_prot 250 -ipv4_payload aaa

#
# Set RxToken
#
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context1,        \
                 &@R_Token1.Event, &@R_Status"
GetAck

Ip4->Receive {&@R_Token1, &@R_Status}

#
# Send packet to group 225.0.0.1
#
SendPacket   2
Stall        1

#
# Check packet 
#
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - Receive a packet afeter adding group"     \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

GetVar R_Context1
if {$R_Context1 == 1} {
  set assert pass
} else {
  set assert fail
}
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - check Event"                              \
                "Return R_Context - $R_Context1, Expected R_Context - 1"

#
# Leave Group 225.0.0.1
#
Ip4->Groups {FALSE, &@R_GroupAddress, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - Leave a group"                            \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Set RxToken2
#
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context2,        \
                 &@R_Token2.Event, &@R_Status"
GetAck

Ip4->Receive {&@R_Token2, &@R_Status}

#
# Send packet to group 225.0.0.1
#
SendPacket   2
Stall        1

#
# Check packet 
#
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - Receive a packet afeter leaving group"     \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"


GetVar R_Context2
if {$R_Context2 == 0} {
  set assert pass
} else {
  set assert fail
}
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4.Groups - Func - check Event"                              \
                "Return R_Context - $R_Context2, Expected R_Context - 0"

#
# Destroy Chile
#
Ip4ServiceBinding->DestroyChild {@R_Handle, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Ip4SB.Groups - Func - Destroy Child"                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"
#
# Close Event
#
BS->CloseEvent "@R_Token1.Event, &@R_Status"
GetAck
BS->CloseEvent "@R_Token2.Event, &@R_Status"
GetAck


VifDown 0

DestroyPacket

#
# End scope
#
EndScope _IP4_GROUPS_FUNCTION2_CASE1_

#
# End Log
#
EndLog
