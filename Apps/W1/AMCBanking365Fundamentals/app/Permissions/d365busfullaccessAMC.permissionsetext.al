// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Bank.Payment;


using System.Security.AccessControl;

permissionsetextension 20102 "D365 BUS FULL ACCESS - AMC" extends "D365 BUS FULL ACCESS"
{
    Permissions = tabledata "AMC Bank Banks" = RIMD,
                  tabledata "AMC Bank Pmt. Type" = RIMD,
                  tabledata "AMC Banking Setup" = RIMD;
}
