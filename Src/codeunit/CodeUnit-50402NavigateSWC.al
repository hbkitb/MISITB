
codeunit 50402 "NavigateSWC"
{

    var


        ClientTypeManagement: Codeunit "Client Type Management";

        LocaleID: Integer;

        VarCompany: Text;

        ProfileID: Code[30];
        RunningOnSaaS: Boolean;
        MyNotificationsLbl: Label 'Change when I receive notifications.';
        IsNotOnMobile: Boolean;
        CompanyDisplayName: Text[250];
        ProfileAppID: Guid;
        ProfileScope: Option System,Tenant;
        IsCompanyChanged: Boolean;

    trigger OnRun()
    begin
        NavigateCompany();
    end;


    procedure NavigateCompany()
    var
        company: Record Company;
        CurrentCompany: Text[100];

    begin
        if NOT (company.CurrentCompany = 'Innotec Sverige') then begin
            VarCompany := 'Innotec Sverige';
            SetCompanyDisplayName;

        end;


    end;

    local procedure SetCompanyDisplayName()
    var
        SelectedCompany: Record Company;
        CompanyInformationManagement: Codeunit "Company Information Mgt.";
    begin
        if SelectedCompany.Get(VarCompany) then
            CompanyDisplayName := CompanyInformationManagement.GetCompanyDisplayNameDefaulted(SelectedCompany);
        OnQueryCompanyPage();
    end;

    local procedure OnQueryCompanyPage()
    var
        AllProfile: Record "All Profile";
        TenantLicenseState: Codeunit "Tenant License State";
        UserPersonalization: Record "User Personalization";
        sessionSetting: SessionSettings;
        AnythingUpdated: Boolean;
        WasEvaluation: Boolean;
    begin

        with UserPersonalization do begin
            Get(UserSecurityId);

            if (Company <> VarCompany) or
                IsCompanyChanged or
               (Scope <> ProfileScope)
            then begin
                AnythingUpdated := true;
                sessionSetting.Init();

                if Company <> VarCompany then begin
                    WasEvaluation := TenantLicenseState.IsEvaluationMode();
                    sessionSetting.Company := VarCompany;
                end;

                if ("Profile ID" <> ProfileID) or
                    ("App ID" <> ProfileAppID) or
                    (Scope <> ProfileScope)
                then begin
                    sessionSetting.ProfileId := ProfileID;
                    sessionSetting.ProfileAppId := ProfileAppID;
                    sessionSetting.ProfileSystemScope := ProfileScope = ProfileScope::System;
                end;


                if "Locale ID" <> LocaleID then
                    sessionSetting.LocaleId := LocaleID;


            end;
        end;


        if AnythingUpdated then
            sessionSetting.RequestSessionUpdate(true);


    end;

}