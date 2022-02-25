report 50404 "ITB_Afgift"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/ITB_Afgift.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'InnoAfgift';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;


    dataset
    {
        dataitem(Item_; Item)
        {
            DataItemTableView = SORTING("no."); //WHERE(Type = filter(item.type:: | "Credit Memo"));
            RequestFilterFields = "No.";


            column(Item; Item."No.")
            {
                IncludeCaption = true;
            }
            column(ItemNo; ItemNo)
            {
                //IncludeCaption = true;
            }

            column(CustomerName; Customer.Name)
            {
            }

            column(ItemQuantity; ItemQuantity)
            {
            }
            column(ItemEmpQty; ItemEmpQty)
            {
            }
            column(ItemEnergiQty; ItemEnergiQty)
            {
            }
            column(ItemOlieQty; ItemOlieQty)
            {
            }
            column(TotItemEmpQty; TotItemEmpQty)
            {
            }
            column(TotItemEnergiQty; TotItemEnergiQty)
            {
            }
            column(TotItemOlieQty; TotItemOlieQty)
            {
            }


            column(AfgiftRepNoCaptionLbl; AfgiftRepNoCaptionLbl)
            {
            }
            column(AfguftRepSVCaptionLbl; AfguftRepSVCaptionLbl)
            {
            }
            column(AfgiftRepCaption; AfgiftRepCaption)
            {
                //IncludeCaption = true;
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
            column(FromDate; FromDate)
            {

            }
            column(CustAfgift; CustAfgift)
            {

            }
            column(ToDate; ToDate)
            {
                //IncludeCaption = true;//
            }
            column(MrkSalesNI; MrkSalesNI)
            {
                //IncludeCaption = true;
            }
            column(RestSales; RestSales)
            {
                //IncludeCaption = true;//
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
            //SalesInvHdr: Record "Sales Invoice Header";
            //SalesInvLine: Record "Sales Invoice Line";
            //SalesCreLine: Record "Sales Cr.Memo Line";

            begin
                ItemQuantity := 0;
                ItemEmpQty := 0;
                ItemEnergiQty := 0;
                ItemOlieQty := 0;
                ItemNo := "No.";

                if CustCountry = CustCountry::"Norge(SALG)" then begin
                    CustAfgift := '50';
                    AfgiftRepCaption := 'Afgiftbelastet salg til Norge(kundenr: ' + CustAfgift + ')';
                end;
                if CustCountry = CustCountry::"Sverige(SALG)" then begin
                    CustAfgift := '4600';
                    AfgiftRepCaption := 'Afgiftbelastet salg til Sverige(kundenr: ' + CustAfgift + ')';
                end;
                if CustCountry = CustCountry::"Belgien(KØB)" then begin
                    CustAfgift := '3214346637';
                    AfgiftRepCaption := 'Afgiftbelastet køb fra Belgien(Kred: ' + CustAfgift + ')';
                end;

                if CustAfgift <> '3214346637' then begin
                    Clear(ItemLedger);
                    ItemLedger.Reset;
                    ItemLedger.SetRange("Item No.", "No.");
                    ItemLedger.SetRange("Posting Date", FromDate, ToDate);
                    ItemLedger.SetRange("Item Ledger Entry Type", ItemLedger."Item Ledger Entry Type"::Sale);
                    ItemLedger.SetRange("Source Code", 'SALG');
                    ItemLedger.SetRange("Source No.", CustAfgift); //Debitor

                    if ItemLedger.FindSet then begin
                        repeat
                            if (Item_.Afgift <> 0) or (Item_.Afgift2 <> 0) or (Item_.Afgift3 <> 0) then begin
                                ItemQuantity := ItemQuantity + ItemLedger."Invoiced Quantity";

                                ItemEmpQty := ItemEmpQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift);
                                ItemOlieQty := ItemOlieQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift2);
                                ItemEnergiQty := ItemEnergiQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift3);

                                TotItemEmpQty := TotItemEmpQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift);
                                TotItemOlieQty := TotItemOlieQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift2);
                                TotItemEnergiQty := TotItemEnergiQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift3);
                            end;


                        until ItemLedger.Next = 0;
                    end;
                end
                else begin  //Så kommer indkøb CustAfgift := '3214346637'
                    Clear(ItemLedger);
                    ItemLedger.Reset;
                    ItemLedger.SetRange("Item No.", "No.");
                    ItemLedger.SetRange("Posting Date", FromDate, ToDate);
                    ItemLedger.SetRange("Item Ledger Entry Type", ItemLedger."Item Ledger Entry Type"::Purchase);
                    ItemLedger.SetRange("Source Code", 'KØB');
                    ItemLedger.SetRange("Source No.", CustAfgift); //Debitor

                    if ItemLedger.FindSet then begin
                        repeat
                            if (Item_.Afgift <> 0) or (Item_.Afgift2 <> 0) or (Item_.Afgift3 <> 0) then begin
                                ItemQuantity := ItemQuantity + ItemLedger."Invoiced Quantity";

                                ItemEmpQty := ItemEmpQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift);
                                ItemOlieQty := ItemOlieQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift2);
                                ItemEnergiQty := ItemEnergiQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift3);

                                TotItemEmpQty := TotItemEmpQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift);
                                TotItemOlieQty := TotItemOlieQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift2);
                                TotItemEnergiQty := TotItemEnergiQty + (ItemLedger."Invoiced Quantity" * Item_.Afgift3);
                            end;


                        until ItemLedger.Next = 0;
                    end;
                end;
            end;




            trigger OnPreDataItem()
            begin
                //210218 i := 0;
                //210218 PostedSalesInvoice.DeleteAll();
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

                    field(CustCountry; CustCountry)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Land';
                        //CaptionML = DEU = 'Turnover', DAN = 'Vis OMSÆTNING ', ENU = 'Turnover';

                        trigger OnValidate()
                        begin
                            if CustCountry = CustCountry::"Norge(SALG)" then
                                CustAfgift := '50';
                            if CustCountry = CustCountry::"Sverige(SALG)" then
                                CustAfgift := '4600';
                            if CustCountry = CustCountry::"Belgien(KØB)" then
                                CustAfgift := '3214346637';
                        end;
                    }
                    /*
                    field(CustAfgift; CustAfgift)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Debitor';
                        TableRelation = Customer."No.";
                        Lookup = true;
                        LookupPageId = "Customer List";
                        //CaptionML = DEU = 'Turnover', DAN = 'Vis OMSÆTNING ', ENU = 'Turnover';
                    }
                    */
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Fra dato';
                        //CaptionML = DEU = 'Turnover', DAN = 'Vis OMSÆTNING ', ENU = 'Turnover';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Til dato';
                        //CaptionML = DEU = 'Turnover', DAN = 'Vis OMSÆTNING ', ENU = 'Turnover';
                    }
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
            //210222 if NoOfRecordsToPrint = 0 then
            //210222 NoOfRecordsToPrint := 50;
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
        AfguftRepSVCaptionLbl: Label 'Afgiftbelastet salg til Sverige(kundenr: 4600';
        AfgiftRepNoCaptionLbl: Label 'Afgiftbelastet salg til Norge(kundenr: 50';
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
        ItemQuantity: Decimal;
        ItemEmpQty: Decimal;
        ItemOlieQty: Decimal;
        TotItemEnergiQty: Decimal;
        TotItemEmpQty: Decimal;
        TotItemOlieQty: Decimal;
        ItemEnergiQty: Decimal;
        MrkSales: Decimal;
        MrkSalesNI: Decimal;
        RestSales: Decimal;
        RestSalesNI: Decimal;
        NetAmountTotal: Decimal;
        LineNetAmount: Decimal;
        TotalLowSale: Decimal;
        CustName: Text[100];
        FromDate: Date;
        ToDate: Date;
        CustAfgift: Code[20];
        ItemLedger: Record "Value Entry";  //i stedet for item ledger entry
        CustCountry: Option "Sverige(SALG)","Norge(SALG)","Belgien(KØB)";
        AfgiftRepCaption: Text[100];
        ItemNo: Code[20];


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

