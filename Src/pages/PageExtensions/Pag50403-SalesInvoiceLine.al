page 50403 "Sales Invoice Line SIL"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Invoice Line";
    Caption = 'Sales Invoice Line SIL';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(SIL_DocNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(SIL_No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(SIL_Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(SIL_Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(SIL_UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(SIL_UnitCostLCY; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field(SIL_UOM; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field(SIL_UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field(SIL_Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(SIL_PostingDate; Rec."Posting Date")
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