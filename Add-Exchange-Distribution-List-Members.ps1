workflow Add-Exchange-Distribution-List-Members 
{ 
    <# 
    Project Name: Build Exchange Distribution List 
    Runbook Name: Add-Exchange-Distribution-List-Members 
    Runbook Type: Subroutine 
    Runbook Tags: Type:Sub, Proj:Build Exchange Distribution List 
    Runbook Description: Subroutine Runbook for adding users to an Exchange DL 
    Runbook Author: Charles Joy & Jim Britt 
    Runbook Creation Date: 06/20/2013 
    #> 

    param( 
    [string]$ExchangeServer, 
    [string]$DomainFQDN, 
    [string]$DistributionListName, 
    [string[]]$Members, 
    [string]$PSCredName 
    ) 
    $PSUserCred = Get-AutomationPSCredential -Name $PSCredName 
    
    $DLExists = Get-Exchange-Distribution-List -DistributionListName $DistributionListName -DomainFQDN $DomainFQDN -ExchangeServer $ExchangeServer -PSCredName $PSCredName 
    If($DLExists) 
    { 
        $DLMembersAdded = InlineScript{ 
            $ConnectionURI = “http://$Using:ExchangeServer.$Using:DomainFQDN/PowerShell/” 
            $AddMemberDLConn = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $ConnectionURI -Authentication Kerberos -Credential $Using:PSUserCred  
            $AddMemberDL = “” 
            foreach($Member in $Using:Members)  
            {  
                $AddMemberDL += Invoke-Command{  
                    param( 
                    [string]$DistributionListName, 
                    [string]$Member 
                    ) 
                    Add-DistributionGroupMember -Identity $DistributionListName -Member $Member  
                } -Session $AddMemberDLConn -ArgumentList $Using:DistributionListName, $Using:Member  
            } 
            $AddMemberDL 
            Remove-PSSession $AddMemberDLConn 
        } -psComputerName $ExchangeServer -psCredential $PSUserCred 
        $DLMembersAdded 
    } 
} 