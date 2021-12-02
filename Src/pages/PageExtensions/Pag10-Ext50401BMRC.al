pageextension 50401 BusinessManagerRC extends "Business Manager Role Center"
{


    actions
    {
        addafter("Chart of Accounts")
        {
            action("NavigateDenmarkCompany")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DAN = 'Danmark', ENU = 'Denmark';
                Image = Import;
                //Visible = InnotechDK;
                RunObject = codeunit NavigateDKC;
                ToolTip = 'View or organize Danmark.';
            }

            action("NavigateSwedenCompany")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DAN = 'Sverige', ENU = 'Sweden';
                Image = Import;
                //Visible = InnotechDK;
                RunObject = codeunit NavigateSWC;
                ToolTip = 'View or organize Danmark.';
            }
            action("NavigateNorwayCompany")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = DAN = 'Norge', ENU = 'Norway';
                Image = Import;
                //Visible = InnotechDK;
                RunObject = codeunit NavigateNOC;
                ToolTip = 'View or organize Danmark.';
            }
        }

    }




}