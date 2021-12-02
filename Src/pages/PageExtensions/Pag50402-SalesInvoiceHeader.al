page 50402 "Sales Invoice Header SIH"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Invoice Header";
    Caption = 'Sales Invoice Header SIH';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(SIH_No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(SIH_SelltoCustNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(SIH_PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(SIH_SalesPersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(SIH_DocDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(SIH_LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field(SIH_LocationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(SIH_CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}