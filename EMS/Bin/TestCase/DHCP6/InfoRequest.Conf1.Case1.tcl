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
CaseGuid        64DAE4A1-81D6-4929-9DD6-3BAE97F09C44
CaseName        InfoRequest.Conf1.Case1
CaseCategory    DHCP6
CaseDescription {Test the InfoRequest Conformance of DHCP6 - Invoke InfoRequest() \
                 with OptionRequest NULL. \
                 EFI_INVALID_PARAMETER should be returned.
                }
################################################################################

Include DHCP6/include/Dhcp6.inc.tcl

#
# Begin log ...
#
BeginLog
#
# BeginScope
#
BeginScope  _DHCP6_INFOREQUEST_CONF1_

#
# Parameter Definition
# R_ represents "Remote EFI Side Parameter"
# L_ represents "Local OS Side Parameter"
#
UINTN                                   R_Status
UINTN                                   R_Handle

#
# Create child.
#
Dhcp6ServiceBinding->CreateChild "&@R_Handle, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                       \
                "Dhcp6SB.CreateChild - Create Child 1"                       \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle

BOOLEAN                                 R_SendClientId
POINTER                                 R_PtrOptionRequest
UINT32                                  R_OptionCount
POINTER                                 R_OptionList
UINT32                                  R_Retransmission(4)
SetVar R_SendClientId                   FALSE
SetVar R_PtrOptionRequest               0
SetVar R_OptionCount                    0
SetVar R_OptionList                     0

#
# Retransmission parameters
# Irt 1
# Mrc 2
# Mrt 3
# Mrd 2
#
SetVar R_Retransmission                 {1 2 3 2}                          

UINTN                                   R_ReplyCallback
UINTN                                   R_CallbackContext
#0: NULL 1: Abort 2: DoNothing
SetVar R_ReplyCallback                  2

#
# Check point: Call InfoRequest() with OptionRequest being NULL.
#              EFI_INVALID_PARAMETER should be returned.
#
Dhcp6->InfoRequest "@R_SendClientId, @R_PtrOptionRequest, @R_OptionCount, @R_OptionList, \
                                                     &@R_Retransmission, 0, @R_ReplyCallback, &@R_CallbackContext, &@R_Status"
GetAck
set assert [VerifyReturnStatus R_Status $EFI_INVALID_PARAMETER]
RecordAssertion $assert $Dhcp6InfoRequestConf1AssertionGuid001   \
                        "Dhcp6.InfoRequest - OptitionRequest is NULL"      \
                        "ReturnStatus - $R_Status, ExpectedStatus - $EFI_INVALID_PARAMETER"

#
# Destroy child.
#
Dhcp6ServiceBinding->DestroyChild "@R_Handle, &@R_Status"
GetAck

#
# EndScope
#
EndScope _DHCP6_INFOREQUEST_CONF1_
#
# End Log 
#
EndLog

