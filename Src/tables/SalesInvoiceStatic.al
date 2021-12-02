table 50401 "ItemSalesStatics"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; entryno; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Sell-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Salesperson Code"; code[10])
        {
            CaptionML = DEU = 'Salesperson code', DAN = 'Salesperson code', ENU = 'Salesperson code';
        }
        field(6; "Salesperson name"; Text[70])
        {
            CaptionML = DEU = 'Salesperson Name', DAN = 'Salesperson Name', ENU = 'Salesperson Name';
        }
        field(7; "Item No"; code[20])
        {
            CaptionML = DEU = 'Item No', DAN = 'Item No', ENU = 'Item No';
        }

        field(8; Description; text[150])
        {
        }

        field(9; Quantity; Decimal)
        {
        }


        field(10; "Unit Cost"; Decimal)
        {
        }

        field(11; "Unit Cost (LCY)"; Decimal)
        {
        }

        field(12; "Unit Price"; Decimal)
        {
        }

        field(13; Amount; Decimal)
        {
        }
        field(14; "Unit of Measure"; Text[50])
        {
        }




    }
    keys
    {
        key(PK; entryno, "Item No")
        {
            Clustered = true;
        }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin
    end;
}
