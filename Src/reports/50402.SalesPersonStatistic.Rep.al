report 50402 "SalesPerson Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/SalesPersonStatistic.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'SalesPerson Statistic';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;


    dataset
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("No.") WHERE(Type = CONST(Item));
            RequestFilterFields = "Posting Date";

            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(SortingPostingDateFilter; StrSubstNo(Text001, ItemDateFilter))
                {
                }
                column(SalesPersonFilter; SalesPersonName)
                {
                }
                column(ItemFilter; ItemFilter)
                {
                }
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(No_Item; SalesInvoiceLine."No.")
                {
                    IncludeCaption = true;
                }
                column(Description_Name; SalesInvoiceLine.Description)
                {
                    IncludeCaption = true;
                }
                column(InvoiceNo; SalesInvoiceLine."Document No.")
                {
                }
                column(Quantity_Item; SalesInvoiceLine.Quantity)
                {
                    IncludeCaption = true;
                }
                column(Amount_Item; SalesInvoiceLine."Line Amount")
                {
                    IncludeCaption = true;
                }

                column(CustomerNo; SalesInvoiceLine."Sell-to Customer No.")
                {
                }
                column(CustomerName; Customer.Name)
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
                column(SalesPersonCode; SalesPersonCode)
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

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not PostedSalesInvoice.Find('-') then
                            CurrReport.Break();
                    end else
                        if PostedSalesInvoice.Next = 0 then
                            CurrReport.Break();

                    if Customer.Get(SalesInvoiceLine."Sell-to Customer No.") then;
                    If Item.Get(PostedSalesInvoice."No.") then begin
                        if Item.PaySaldo = true then
                            PaySaldoYes := PaySaldoYes + SalesInvoiceLine."Line Amount"
                        else
                            PaySaldoNo := PaySaldoNo + SalesInvoiceLine."Line Amount";
                        AmountBelow := Item.MinPris * SalesInvoiceLine.Quantity;

                    end;
                    /*  if AmountBelow < SalesInvoiceLine."Line Amount" then
                         CurrReport.Skip(); */

                end;

                trigger OnPreDataItem()
                begin

                end;

                trigger OnPostDataItem()
                begin
                    PostedSalesInvoice.DELETEALL;
                end;
            }
            trigger OnAfterGetRecord()
            var
                SalesInvHdr: Record "Sales Invoice Header";
            begin

                CLEAR(SalesInvHdr);
                SalesInvHdr.SETRANGE("No.", "Document No.");
                SalesInvHdr.SETFILTER("Salesperson Code", SalesPersonFilter);
                IF SalesInvHdr.FINDFIRST THEN BEGIN
                    PostedSalesInvoice.INIT;
                    PostedSalesInvoice.TRANSFERFIELDS(SalesInvoiceLine);
                    PostedSalesInvoice."Sell-to Customer No." := GetSalesPersonCode("Document No.");
                    PostedSalesInvoice."Price description" := GetSalesPersonName("Document No.");
                    PostedSalesInvoice.INSERT;
                    SalesPersonCode := PostedSalesInvoice."Sell-to Customer No.";
                    SalesPersonName := PostedSalesInvoice."Price description";

                END;


            end;

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
                    Caption = 'Options';
                    field(SalesPFilter; SalesPersonFilter)
                    {
                        ApplicationArea = ALl;
                        CaptionML = DEU = 'Sales Person', DAN = 'Salesperson ', ENU = 'Salesperson code';
                        TableRelation = "Salesperson/Purchaser".Code;
                        Lookup = true;
                        LookupPageId = "Salespersons/Purchasers";
                    }
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
        ItemFilter := FormatDocument.GetRecordFiltersWithCaptions(SalesInvoiceLine);
        ItemDateFilter := FormatDocument.GetRecordFiltersWithCaptions(SalesInvoiceLine);
    end;

    var
        Text001: Label 'Period: %1';
        PostedSalesInvoice: Record "Sales Invoice Line" temporary;
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

}

