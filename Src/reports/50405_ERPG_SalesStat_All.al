report 50405 "ERPGSalesSattAll"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/SalesStat_All.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'INNO Item Statistic';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(SalesInvoiceLine; "Sales Invoice Line")
        {
            DataItemTableView = SORTING("No.") WHERE(Type = CONST(Item));
            //DataItemTableView = SORTING(Quantity) WHERE(Type = CONST(Item));
            RequestFilterFields = "No.", "Posting Date";

            dataitem("Integer"; "Integer")
            {
                ////DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(SortingPostingDateFilter; StrSubstNo(Text001, ItemDateFilter))
                {
                }
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(ItemFilter; ItemFilter)
                {
                }
                column(ItemDateFilter; ItemDateFilter)
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
                column(Quantity_Item; SalesInvoiceLine.Quantity)
                {
                    IncludeCaption = true;
                }
                column(Amount_Item; SalesInvoiceLine.Amount)
                {
                    IncludeCaption = true;
                }
                column(UnitPrice_Item; SalesInvoiceLine."Unit Price")
                {
                }
                column(UnitCost_Item; SalesInvoiceLine."Unit Cost")
                {
                }
                column(UnitCostLCY_Item; SalesInvoiceLine."Unit Cost (LCY)")
                {
                }
                column(Salespersoncode_Item; SalesInvoiceLine."Sell-to Customer No.")
                {
                }
                column(Salespersonname_Item; SalesInvoiceLine."Price description")
                {
                }
                column(SalesStatisticsCaption; SalesStatsCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(TotalSalesCaption; TotalSalesCaptionLbl)
                {
                }
                column(PercentofTotalSalesCaption; PercentofTotalSalesCaptionLbl)
                {
                }
                column(AverageFilter; bAverage)
                {
                }
                column(CostFilter; bCost)
                {
                }
                column(TurnoverFilter; bTurnover)
                {
                }
                column(ItemNoCaptionLbl; ItemNoCaptionLbl)
                {
                }
                column(SalesPersonCaptionLbl; SalesPersonCaptionLbl)
                {
                }
                column(DescriptionCaptionLbl; DescriptionCaptionLbl)
                {
                }
                column(VisOMSAETNINGCaptionLbl; VisOMSAETNINGCaptionLbl)
                {
                }
                column(ViaGennemsnitCaptionLbl; ViaGennemsnitCaptionLbl)
                {
                }
                column(VisVareforbrugCaptionLbl; VisVareforbrugCaptionLbl)
                {
                }
                column(SalesPersonCode; SalesPersonCode)
                {
                }
                column(SalesPersonName; SalesPersonName)
                {
                }
                column(QuantityCaptionLbl; QuantityCaptionLbl)
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

                /*  if (NoOfRecordsToPrint = 0) or (i < NoOfRecordsToPrint) then
                     i := i + 1
                 else begin
                     PostedSalesInvoice.Find('+');
                     PostedSalesInvoice.Delete();
                 end; */

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
                        Lookup = true;  //
                        LookupPageId = "Salespersons/Purchasers";
                        //ToolTip = 'Specifies how the report will sort the customers: Sales, to sort by purchase volume; or Balance, to sort by balance. In either case, the customers with the largest amounts will be shown first.';
                    }
                    field(bTurnover; bTurnover)
                    {
                        ApplicationArea = ALl;
                        CaptionML = DEU = 'Turnover', DAN = 'Vis OMSÆTNING ', ENU = 'Turnover';
                    }
                    field(bAverage; bAverage)
                    {
                        ApplicationArea = ALl;
                        CaptionML = DEU = 'Average', DAN = 'Via Gennemsnit', ENU = 'Average';
                    }
                    field(bCost; bCost)
                    {
                        ApplicationArea = ALl;
                        CaptionML = DEU = 'Cost', DAN = 'Vis vareforbrug', ENU = 'Cost';
                    }
                    field(NoOfRecordsToPrint; NoOfRecordsToPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Items';
                        ToolTip = 'Specifies the number of Items that will be included in the report.';

                        trigger OnValidate()
                        begin
                            if NoOfRecordsToPrint <= 0 then
                                Error(NoOfRecordsToPrintErrMsg);
                        end;
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
        //ItemDateFilter := FormatDocument.GetRecordFiltersWithCaptions(SalesInvoiceLine);
    end;

    var
        Text001: Label 'Period: %1';
        PostedSalesInvoice: Record "Sales Invoice Line" temporary;
        SalesPersonFilter: Text;
        bTurnover: Boolean;
        bAverage: Boolean;
        bCost: Boolean;
        salespersonCode: Code[20];
        salespersonname: Text[70];
        ItemFilter: Text;
        ItemDateFilter: Text;
        ShowType: Option "Sales (LCY)","Balance (LCY)";
        NoOfRecordsToPrint: Integer;
        MaxAmount: Decimal;
        i: Integer;
        TotalSales: Decimal;
        Text004: Label 'Sales (LCY),Balance (LCY)';
        TotalBalance: Decimal;
        SalesStatsCaptionLbl: Label 'SælgerStatistiks';
        CurrReportPageNoCaptionLbl: Label 'Page';
        TotalCaptionLbl: Label 'Total';
        TotalSalesCaptionLbl: Label 'Total Sales';
        PercentofTotalSalesCaptionLbl: Label '% of Total Sales';
        NoOfRecordsToPrintErrMsg: Label 'The value must be a positive number.';
        ItemNoCaptionLbl: Label 'Item No.';
        DescriptionCaptionLbl: Label 'Description';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        VisOMSAETNINGCaptionLbl: Label 'Vis OMSÆTNING';
        ViaGennemsnitCaptionLbl: Label 'Via Gennemsnit';
        VisVareforbrugCaptionLbl: Label 'Vis vareforbrug';
        QuantityCaptionLbl: Label 'Quantity';



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

