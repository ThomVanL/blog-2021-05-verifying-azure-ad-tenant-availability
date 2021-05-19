#Requires -Version 7.0

<#
.SYNOPSIS
    Checks whether an Azure AD tenant is available.
.DESCRIPTION
    Checks whether an Azure AD tenant is available.
.PARAMETER FQDN
    Provide the fully qualified domain name.
.INPUTS
    None. You cannot pipe objects to Get-AzureAdTenantAvailability.
.OUTPUTS
    System.Boolean. Get-AzureAdTenantAvailability returns a Boolean:
        - $true indicates the tenant's name is available.
        - $false indicates the tenant's name is unavailable.
.EXAMPLE
    PS C:\> .\Get-AzureAdTenantAvailability.ps1 -FQDN "thomasvanlaere.com"
.EXAMPLE
    PS C:\> .\Get-AzureAdTenantAvailability.ps1 -FQDN "www.tunecom.be"
.EXAMPLE
    PS C:\> .\Get-AzureAdTenantAvailability.ps1 -FQDN "even-this.works.co.uk"
.EXAMPLE
    PS C:\> .\Get-AzureAdTenantAvailability.ps1 -FQDN "contoso.onmicrosoft.com"
#>
[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        HelpMessage = "Provide the fully qualified domain name.")]
    [string]
    $FQDN
)

if ($FQDN -notmatch "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
    Write-Error -Message ("FQDN used incorrect format: '{0}'." -f $FQDN) -ErrorAction Stop
}

$uri = "https://login.microsoftonline.com/{0}/FederationMetadata/2007-06/FederationMetadata.xml" -f $FQDN
Write-Verbose ("Sending request to '{0}'." -f $uri)
$response = Invoke-WebRequest -Uri $uri -Method GET -SkipHttpErrorCheck
switch ($response.StatusCode) {
    200 {
        Write-Verbose "Received 200 status code, the tenant's name is unavailable."
        return $false
    }
    404 {
        Write-Verbose "Received 404 status code, the tenant's name is available."
        return $true
    }
    default {
        Write-Error -Message "Unable to determine result." -ErrorAction Stop
        break;
    }
}
