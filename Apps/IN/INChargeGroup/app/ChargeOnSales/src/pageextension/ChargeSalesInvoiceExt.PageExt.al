﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Sales.Document;

pageextension 18792 "Charge Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Charge Group Code"; Rec."Charge Group Code")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the charge group code is assigned to the document';
            }
        }
    }
}
