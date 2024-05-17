namespace Microsoft.Integration.Shopify;

using Microsoft.Sales.Receivables;

/// <summary>
/// Page Shpfy Transactions (ID 30134).
/// </summary>
page 30134 "Shpfy Transactions"
{
    ApplicationArea = All;
    Caption = 'Shopify Transactions';
    PageType = List;
    SourceTable = "Shpfy Order Transaction";
    UsageCategory = History;
    ModifyAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Created At") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ShopifyTransactionId; Rec."Shopify Transaction Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique id of the Shopify transaction.';
                }
                field(CreatedAt; Rec."Created At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time at which the transaction is processed.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction type. Valid values are: authorization, capture, sale, void and refund.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the transaction. Valid values are: pending, failure, success and error.';
                }
                field(Gateway; Rec.Gateway)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the gateway the transaction was issued through.';
                }
                field(SourceName; Rec."Source Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the origin of the transaction. This is set by Shopify. Example values: web, pos, iphone, android.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount of money included in the transaction.';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the currency of the transaction.';
                }
                field(Test; Rec.Test)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the transaction was created for a test mode Order or payment.';
                }
                field("Message"; Rec.Message)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a string generated by the payment provider with additional information about why the transaction succeeded or failed.';
                }
                field(GiftCardId; Rec."Gift Card Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the id of the gift card used for a transaction.';
                }
                field(Authorization; Rec.Authorization)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the authorization code associated with the transaction.';
                }
                field(CreditCardCompany; Rec."Credit Card Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company that issued the customer''s credit card.';
                }
                field(CreditCardNumber; Rec."Credit Card Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer''s credit card number, with most of the leading digits redacted.';
                }
                field(CreditCardBin; Rec."Credit Card Bin")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the issuer identification number.';
                }
                field(AVSResultCode; Rec."AVS Result Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response code from the address verification system.';
                }
                field(CVVResultCode; Rec."CVV Result Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the response code from the credit card company indicating whether the customer entered the card security code, or card verificaion value, correctly.';
                }
                field(ErrorCode; Rec."Error Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the standardized error code, independent of the payment provider. Valid values are: incorrect_number, invalid_number, invalid_expiry_date, invalid_cvc, expired_card, incorrect_cvc, incorrect_zip, incorrect_address, card_declined, processing_error, call_issuer, pick_up_card.';
                }
                field(ShopifyOrderId; Rec."Shopify Order Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the id of the order in Shopify that the transaction is associated with.';
                }
                field(SalesDocumentNo; Rec."Sales Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sales document number to which the transaction relates.';
                }
                field(PostedInvoiceNo; Rec."Posted Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Posted Invoice number to which the transaction relates.';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(RetrievedShopifyData)
            {
                ApplicationArea = All;
                Caption = 'Retrieved Shopify Data';
                Image = Entry;
                ToolTip = 'View the data retrieved from Shopify.';

                trigger OnAction()
                var
                    DataCapture: Record "Shpfy Data Capture";
                begin
                    DataCapture.SetCurrentKey("Linked To Table", "Linked To Id");
                    DataCapture.SetRange("Linked To Table", Database::"Shpfy Order Transaction");
                    DataCapture.SetRange("Linked To Id", Rec.SystemId);
                    Page.Run(Page::"Shpfy Data Capture List", DataCapture);
                end;
            }
            action(CustLedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Customer Ledger Entries';
                Image = LedgerEntries;
                ToolTip = 'View the customer ledger entries for the transaction.';
                RunObject = Page "Customer Ledger Entries";
                RunPageLink = "Shpfy Transaction Id" = field("Shopify Transaction Id");
            }
            action(SuggestShopifyPayments)
            {
                ApplicationArea = All;
                Caption = 'Suggest Shopify Payments';
                Image = SuggestPayment;
                ToolTip = 'Create payment suggestions from selected transactions as lines in the cash receipt journal.';

                trigger OnAction()
                var
                    OrderTransaction: Record "Shpfy Order Transaction";
                    SuggestPayments: Report "Shpfy Suggest Payments";
                    IgnorePostedTransactions: Boolean;
                begin
                    CurrPage.SetSelectionFilter(OrderTransaction);
                    OrderTransaction.SetRange(Used, true);
                    if not OrderTransaction.IsEmpty() then
                        if Confirm(IgnorePostedTransactionsLbl) then
                            IgnorePostedTransactions := true;
                    OrderTransaction.SetRange(Used);
                    SuggestPayments.SetTableView(OrderTransaction);
                    SuggestPayments.SetIgnorePostedTransactions(IgnorePostedTransactions);
                    SuggestPayments.Run();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(SuggestShopifyPayments_Promoted; SuggestShopifyPayments) { }
            }
            group(Category_Inspect)
            {
                Caption = 'Inspect';
                actionref(RetrievedShopifyData_Promoted; RetrievedShopifyData) { }
            }
            group(Category_Related)
            {
                Caption = 'Related';
                actionref(CustLedgerEntries_Promoted; CustLedgerEntries) { }
            }
        }
    }

    var
        IgnorePostedTransactionsLbl: Label 'You have selected posted Shopify transactions. Do you want to use posted transactions?';
}