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
CaseGuid          C6AFBE18-2170-49cd-8F5E-74706847C334
CaseName          RstHandling.Func2.Case3
CaseCategory      TCP
CaseDescription   {This item is to test the <EUT> correctly handles the        \
                   reception of a RST segment in SYN_SENT state                \
                   - return to CLOSED state}
################################################################################

Include TCP4/include/Tcp4.inc.tcl

proc CleanUpEutEnvironmentBegin {} {
global RST

  UpdateTcpSendBuffer TCB -c $RST
  SendTcpPacket TCB

  DestroyTcb
  DestroyPacket
  DelEntryInArpCache

  Tcp4ServiceBinding->DestroyChild "@R_Tcp4Handle, &@R_Status"
  GetAck
 
}

proc CleanUpEutEnvironmentEnd {} {
  EndLogPacket
  EndScope _TCP4_RSTHANDLING_FUNC2_CASE4_
  EndLog
}

#
# Begin log ...
#
BeginLog

#
# BeginScope on OS.
#
BeginScope _TCP4_RSTHANDLING_FUNC2_CASE4_

BeginLogPacket RstHandling.Func2.Case4 "host $DEF_EUT_IP_ADDR and host         \
                                             $DEF_ENTS_IP_ADDR"

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
UINTN                            R_Status
UINTN                            R_Tcp4Handle
UINTN                            R_Context

EFI_TCP4_ACCESS_POINT            R_Configure_AccessPoint
EFI_TCP4_CONFIG_DATA             R_Configure_Tcp4ConfigData

EFI_TCP4_COMPLETION_TOKEN        R_Connect_CompletionToken
EFI_TCP4_CONNECTION_TOKEN        R_Connect_ConnectionToken

EFI_TCP4_COMPLETION_TOKEN        R_Close_CompletionToken
EFI_TCP4_CLOSE_TOKEN             R_Close_CloseToken

INTN                             R_Connection_State

LocalEther  $DEF_ENTS_MAC_ADDR
RemoteEther $DEF_EUT_MAC_ADDR
LocalIp     $DEF_ENTS_IP_ADDR
RemoteIp    $DEF_EUT_IP_ADDR

#
# Initialization of TCB related on OS side.
#
set L_Port $DEF_ENTS_PRT
set R_Port $DEF_EUT_PRT

CreateTcb TCB $DEF_ENTS_IP_ADDR $L_Port $DEF_EUT_IP_ADDR $R_Port
CreatePayload HelloWorld STRING 11 HelloWorld

#
# Add an entry in ARP cache.
#
AddEntryInArpCache

#
# Create Tcp4 Child.
#
Tcp4ServiceBinding->CreateChild "&@R_Tcp4Handle, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Tcp4Handle
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4SBP.CreateChild - Create Child 1."                        \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Configure TCP instance.
#
SetVar R_Configure_AccessPoint.UseDefaultAddress      FALSE
SetIpv4Address R_Configure_AccessPoint.StationAddress $DEF_EUT_IP_ADDR
SetIpv4Address R_Configure_AccessPoint.SubnetMask     $DEF_EUT_MASK
SetVar R_Configure_AccessPoint.StationPort            $R_Port
SetIpv4Address R_Configure_AccessPoint.RemoteAddress  $DEF_ENTS_IP_ADDR
SetVar R_Configure_AccessPoint.RemotePort             $L_Port
SetVar R_Configure_AccessPoint.ActiveFlag             TRUE

SetVar R_Configure_Tcp4ConfigData.TypeOfService       0
SetVar R_Configure_Tcp4ConfigData.TimeToLive          128
SetVar R_Configure_Tcp4ConfigData.AccessPoint         @R_Configure_AccessPoint
SetVar R_Configure_Tcp4ConfigData.ControlOption       0

Tcp4->Configure {&@R_Configure_Tcp4ConfigData, &@R_Status}
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Tcp4.Configure - Configure Child 1."                          \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

#
# Enter SYN_RCVD From SYN_SENT
#           sent SYN
#  CLOSED -----------> SYN_SENT
#

#
# Call Tcp4->Connect to initialize connection
#
BS->CreateEvent "$EVT_NOTIFY_SIGNAL, $EFI_TPL_CALLBACK, 1, &@R_Context,        \
                 &@R_Connect_CompletionToken.Event, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "BS.CreateEvent."                                              \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_Connect_ConnectionToken.CompletionToken @R_Connect_CompletionToken
Tcp4->Connect {&@R_Connect_ConnectionToken, &@R_Status}
GetAck
if { $R_Status == $EFI_SUCCESS } {
  set assert pass
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "Tcp4.Connect - Open an active connection."                  \
                  "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"
} else {
  set assert fail
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "Tcp4.Connect - Open an active connection."                  \
                  "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

  CleanUpEutEnvironmentBegin
  BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
  GetAck
  CleanUpEutEnvironmentEnd
  return
}

# <EUT> --> <OS>: SYN
ReceiveTcpPacket TCB 5
if { ${TCB.received} == 1 } {
  if { ${TCB.r_f_syn} != 1} {
    set assert fail
    RecordAssertion $assert $GenericAssertionGuid                              \
                    "EUT doesn't send out SYN segment correctly."

    CleanUpEutEnvironmentBegin
    BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
    GetAck
    CleanUpEutEnvironmentEnd
    return
  }
} else {
  set assert fail
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "EUT doesn't send out any segment."

  CleanUpEutEnvironmentBegin
  BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
  GetAck
  CleanUpEutEnvironmentEnd
  return
}

#BUGBUG - Call GetModeData will result in crash
Tcp4->GetModeData {&@R_Connection_State, NULL, NULL, NULL, NULL, &@R_Status}
GetAck
GetVar R_Connection_State
if { $R_Connection_State!=$Tcp4StateSynSent || $R_Status!=$EFI_SUCCESS} {
  set assert fail
  RecordAssertion $assert $GenericAssertionGuid                                \
                  "Active Connection, Enter SYNC_SENT - 1."                    \
                  "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"    \
                  "CurState - $R_Connection_State, ExpectedState - $Tcp4StateSynSent"

  CleanUpEutEnvironmentBegin
  BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
  GetAck
  CleanUpEutEnvironmentEnd
  return
}
RecordAssertion pass $GenericAssertionGuid                                     \
                "Passive Connection: Enter SYNC_SENT state"

#
# Instruct <OS> send a valid RST segment
# It's sequence number is one-byte less than window boundary
#
set L_OrigSeq ${TCB.l_next_seq}
set L_TcpFlag [expr $RST|$ACK]
UpdateTcpSendBuffer TCB -c $L_TcpFlag -s [expr $L_OrigSeq+${TCB.r_win}-1]
SendTcpPacket TCB

# Recover the next sequence number
set TCB.l_next_seq $L_OrigSeq

#
# Expect: On receiving a valid RST, the connection returned to CLOSED state
#
#BUGBUG - Call GetModeData will result in crash
Tcp4->GetModeData {&@R_Connection_State, NULL, NULL, NULL, NULL, &@R_Status}
GetAck
GetVar R_Connection_State
if { $R_Connection_State != $Tcp4StateClosed || $R_Status != $EFI_SUCCESS} {
  set assert fail
  RecordAssertion $assert $Tcp4RstHandlingFunc2AssertionGuid003	               \
                  "Active Connection, In <SYNC_SENT> state:"                   \
                  "On recv RST, Expect: Return CLOSED."                        \
                  "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"    \
                  "CurState - $R_Connection_State, ExpectedState - CLOSED"
}
RecordAssertion pass $GenericAssertionGuid                                     \
                     "<SYNC_SENT>: On recv RST, Return to CLOSED"

# OS --> EUT: SYNC, expect recv RST, which indicate that EUT is CLOSED state
set L_TcpFlag $SYN
UpdateTcpSendBuffer TCB -c $L_TcpFlag
SendTcpPacket TCB

# Expect: EUT --> OS: RST
ReceiveTcpPacket TCB 5
if { ${TCB.received} == 1 } {
  if { ${TCB.r_f_rst} != 1} {
    set assert fail
    RecordAssertion $assert $GenericAssertionGuid                              \
                    "<CLOSED>: On In SYN, Should Out RST, "                    \
                    "Result: No RST out."

    CleanUpEutEnvironmentBegin
    BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
    GetAck
    CleanUpEutEnvironmentEnd
    return
  }
} else {
  set assert fail
    RecordAssertion $assert $GenericAssertionGuid                              \
                    "<CLOSED>: On In SYN, Should Out RST, "                    \
                    "Result: No packet out."

  CleanUpEutEnvironmentBegin
  BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
  GetAck
  CleanUpEutEnvironmentEnd
  return
}

RecordAssertion pass $GenericAssertionGuid                                     \
                "Active Connection, In <SYNC_SENT> state: "                    \
                "On recv RST (1-B less than window boundary), Return CLOSED state"


# Clean up the environment on EUT side.
#

CleanUpEutEnvironmentBegin
BS->CloseEvent "@R_Connect_CompletionToken.Event, &@R_Status"
GetAck
CleanUpEutEnvironmentEnd
