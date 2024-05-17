// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Finance.RoleCenters;

using Microsoft.Finance.VAT.Reporting;

pageextension 14601 "IS Bookkeeper Role Center" extends "Bookkeeper Role Center"
{
    actions
    {
        addafter("G/L - VAT Reconciliation")
        {
            action("IS VAT Balancing A")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Balancing A';
                Image = "Report";
                RunObject = Report "IS VAT Reconciliation A";
                ToolTip = 'View a VAT reconciliation report for sales and purchases for a specified period. The report lists entries by general ledger account and posting group.';
            }
            action("IS VAT Balancing Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'VAT Balancing Report';
                Image = "Report";
                RunObject = Report "IS VAT Balancing Report";
                ToolTip = 'Get an overview of VAT for sales and purchases and payments due for a specified period.';
            }
        }
    }
}

