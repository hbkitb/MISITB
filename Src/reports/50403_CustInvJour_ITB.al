report 50403 "CustInvJour_ITB"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/CustInvJour_ITB.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'DebitorJournal';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;


    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("salesperson code", "Posting Date") WHERE("Document Type" = filter(invoice | "Credit Memo"));
            RequestFilterFields = "Salesperson Code", "Posting Date";


            column(BillToCust; "Cust. Ledger Entry"."Customer No.")
            {
                IncludeCaption = true;
            }
            column(salespersonCode; "Cust. Ledger Entry"."Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(InvoiceNo; "Cust. Ledger Entry"."Document No.")
            {
            }

            column(CustomerName; Customer.Name)
            {
            }
            column(SellToCust; "Cust. Ledger Entry"."Sell-to Customer No.")
            {
            }
            column(MinPris; Item.MinPris)
            {
            }
            column(paysaldo; Item.PaySaldo)
            {
            }
            column(NoInnoItem; Item.NoInnoItem)
            {
            }
            column(SalesStatisticsCaption; SalesStatsCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }

            column(SalesPersonName; SalesPersonName)
            {
            }
            column(AmountBelow; AmountBelow)
            {
            }
            column(PaySaldoYes; PaySaldoYes)
            {
            }
            column(PaySaldoNo; PaySaldoNo)
            {
            }
            column(ItemNoCaptionLbl; ItemNoCaptionLbl)
            {
            }
            column(CustomerNoCaptionLbl; CustomerNoCaptionLbl)
            {
            }
            column(CustomerNameCaptionLbl; CustomerNameCaptionLbl)
            {
            }
            column(InoviceCaptionLbl; InoviceCaptionLbl)
            {
            }
            column(AmountBelowCaptionLbl; AmountBelowCaptionLbl)
            {
            }
            column(TotalCaptionLbl; TotalCaptionLbl)
            {
            }
            column(FooterCaptionLbl; FooterCaptionLbl)
            {
            }
            column(MarkedItemCaptionLbl; MarkedItemCaptionLbl)
            {
            }
            column(OtherItemsCaptionLbl; OtherItemsCaptionLbl)
            {
            }
            column(NetAmountCaptionLbl; NetAmountCaptionLbl)
            {
            }
            column(SalesPersonCaptionLbl; SalesPersonCaptionLbl)
            {
            }
            column(Posting_Date; "Cust. Ledger Entry"."Posting Date")
            {
                IncludeCaption = true;
            }
            column(MrkSales; MrkSales)
            {
                //IncludeCaption = true;
            }
            column(MrkSalesNI; MrkSalesNI)
            {
                //IncludeCaption = true;
            }
            column(RestSales; RestSales)
            {
                //IncludeCaption = true;
            }
            column(RestSalesNI; RestSalesNI)
            {
                //IncludeCaption = true;
            }
            column(NetAmountTotal; NetAmountTotal)
            {
                //IncludeCaption = true;
            }
            column(LineNetAmount; LineNetAmount)
            {
                //IncludeCaption = true;
            }
            column(TotalLowSale; TotalLowSale)
            {
                //IncludeCaption = true;
            }




            trigger OnAfterGetRecord()
            var
                SalesInvHdr: Record "Sales Invoice Header";
                SalesInvLine: Record "Sales Invoice Line";
                SalesCreLine: Record "Sales Cr.Memo Line";
            begin

                AmountBelow := 0;
                LineNetAmount := 0;
                if Customer.get("Cust. Ledger Entry"."Customer No.") then
                    CustName := Customer.Name
                else
                    CustName := '';


                //if PostedSalesInvoice.get("Cust. Ledger Entry"."Document No.") then begin
                //if Customer.Get(PostedSalesInvoice."Sell-to Customer No.") then begin
                //If Item.Get(PostedSalesInvoice."No.") then begin

                Clear(SalesInvLine);
                SalesInvLine.Reset;
                SalesInvLine.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                if SalesInvLine.FindSet then
                    if Item.Get(SalesInvLine."No.") then
                        if Item.Type = item.Type::Inventory then begin
                            repeat

                                if Item.PaySaldo = true then
                                    if (Item.NoInnoItem) then
                                        MrkSalesNI := MrkSalesNI + SalesInvLine."Line Amount"
                                    //PaySaldoYes := PaySaldoYes //+ salesinvoiceline."Line Amount"
                                    else
                                        MrkSales := MrkSales + SalesInvLine."Line Amount"

                                else
                                    if (Item.NoInnoItem) then
                                        RestSalesNI := RestSalesNI + SalesInvLine."Line Amount"
                                    //PaySaldoNo := PaySaldoNo //+ salesinvoiceline."Line Amount"
                                    else
                                        RestSales := RestSales + SalesInvLine."Line Amount";

                                if SalesInvLine."Line Amount" - Item.MinPris * SalesInvLine.Quantity < 0 then
                                    AmountBelow := Amountbelow + (Item.MinPris * SalesInvLine.Quantity - SalesInvLine."Line Amount"); //* SalesInvoiceLine.Quantity;
                                LineNetAmount := LineNetAmount + SalesInvLine."Line Amount";
                            //NetAmountTotal := NetAmountTotal + LineNetAmount;
                            //TotalLowSale := TotalLowSale + AmountBelow;
                            until SalesInvLine.Next = 0;
                            NetAmountTotal := NetAmountTotal + LineNetAmount;
                            TotalLowSale := TotalLowSale + AmountBelow;

                        end
                        //end
                        else begin
                            //if PostedSalesCreditNote.get("Cust. Ledger Entry"."Document No.") then begin
                            //    if Customer.Get(PostedSalesCreditNote."Sell-to Customer No.") then begin
                            //If Item.Get(PostedSalesInvoice."No.") then begin
                            Clear(SalesCreLine);
                            SalesCreLine.Reset;
                            SalesCreLine.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
                            if SalesCreLine.FindSet then
                                if Item.Get(SalesCreLine."No.") then
                                    if Item.Type = item.Type::Inventory then begin
                                        repeat

                                            if Item.PaySaldo = true then
                                                if (Item.NoInnoItem) then
                                                    MrkSalesNI := MrkSalesNI + SalesCreLine."Line Amount"
                                                //PaySaldoYes := PaySaldoYes //+ salesinvoiceline."Line Amount"
                                                else
                                                    MrkSales := MrkSales + SalesCreLine."Line Amount"

                                            else
                                                if (Item.NoInnoItem) then
                                                    RestSalesNI := RestSalesNI + SalesCreLine."Line Amount"
                                                //PaySaldoNo := PaySaldoNo //+ salesinvoiceline."Line Amount"
                                                else
                                                    RestSales := RestSales + SalesCreLine."Line Amount";

                                            if SalesCreLine."Line Amount" - Item.MinPris * SalesCreLine.Quantity < 0 then
                                                AmountBelow := AmountBelow + (Item.MinPris * SalesCreLine.Quantity - SalesCreLine."Line Amount"); //* SalesInvoiceLine.Quantity;
                                            LineNetAmount := LineNetAmount + SalesCreLine."Line Amount";
                                        //NetAmountTotal := NetAmountTotal + LineNetAmount;
                                        //TotalLowSale := TotalLowSale + AmountBelow;
                                        until SalesCreLine.Next = 0;
                                        NetAmountTotal := NetAmountTotal + LineNetAmount;
                                        TotalLowSale := TotalLowSale + AmountBelow;

                                    end;
                            // end;
                        end;




                /*  if AmountBelow < SalesInvoiceLine."Line Amount" then
                     CurrReport.Skip(); */


            END;




            trigger OnPreDataItem()
            begin
                i := 0;
                PostedSalesInvoice.DeleteAll();
            end;
        }

    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    /*
                    Caption = 'Options';//
                    field(SalesPFilter; SalesPersonFilter)
                    {
                        ApplicationArea = ALl;
                        CaptionML = DEU = 'Sales Person', DAN = 'Salesperson ', ENU = 'Salesperson code';
                        TableRelation = "Salesperson/Purchaser".Code;
                        Lookup = true;
                        LookupPageId = "Salespersons/Purchasers";
                    }
                    */
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
        end;

        trigger OnOpenPage()
        begin
            if NoOfRecordsToPrint = 0 then
                NoOfRecordsToPrint := 10;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        //ItemFilter := FormatDocument.GetRecordFiltersWithCaptions(SalesInvoiceLine);
        //ItemDateFilter := FormatDocument.GetRecordFiltersWithCaptions(SalesInvoiceLine);
    end;

    var
        Text001: Label 'Period: %1';
        PostedSalesInvoice: Record "Sales Invoice header" temporary;
        PostedSalesCreditNote: Record "Sales Cr.Memo Header" temporary;
        SalesPersonFilter: Text;
        salespersonCode: Code[20];
        salespersonname: Text[70];
        ItemFilter: Text;
        ItemDateFilter: Text;
        NoOfRecordsToPrint: Integer;
        i: Integer;
        PaySaldoYes: Decimal;
        PaySaldoNo: Decimal;
        SalesStatsCaptionLbl: Label 'Sælgsjournalfor';
        SalesPersonCaptionLbl: Label 'Sælger';
        CurrReportPageNoCaptionLbl: Label 'Page';
        NoOfRecordsToPrintErrMsg: Label 'The value must be a positive number.';
        ItemNoCaptionLbl: Label 'Varenr.';
        CustomerNoCaptionLbl: Label 'Kundenr';
        CustomerNameCaptionLbl: Label 'Navn';
        InoviceCaptionLbl: Label 'Faktura';
        AmountBelowCaptionLbl: Label 'Kr. Under';
        TotalCaptionLbl: Label 'I ALT....:';
        FooterCaptionLbl: Label 'INNOTEC VARER + + IKKE INNOTEC VARER';
        MarkedItemCaptionLbl: Label 'Markerede varenumre';
        OtherItemsCaptionLbl: Label 'Øvrige varenumre';
        NetAmountCaptionLbl: Label 'Netto salg';
        Item: Record Item;
        Customer: Record Customer;
        AmountBelow: Decimal;
        MrkSales: Decimal;
        MrkSalesNI: Decimal;
        RestSales: Decimal;
        RestSalesNI: Decimal;
        NetAmountTotal: Decimal;
        LineNetAmount: Decimal;
        TotalLowSale: Decimal;
        CustName: Text[100];

    /*
        procedure GetSalesPersonCode(DocumentNo: code[20]) SalesPeerson: Code[20]
        var
            PSalesInvoice: Record "Sales Invoice Header";
        begin
            IF PSalesInvoice.GET(DocumentNo) THEN
                EXIT(PSalesInvoice."Salesperson Code")
            ELSE
                EXIT('');
        end;

        procedure GetSalesPersonName(DocumentNo: code[20]) SalesPerson: Text[70]
        var
            PSalesInvoice: Record "Sales Invoice Header";
            mSalesperson: Record "Salesperson/Purchaser";
        begin
            IF PSalesInvoice.GET(DocumentNo) THEN BEGIN
                IF msalesPerson.GET(PSalesInvoice."Salesperson Code") THEN
                    EXIT(msalesPerson.Name);
            END;
        end;
    */
}

