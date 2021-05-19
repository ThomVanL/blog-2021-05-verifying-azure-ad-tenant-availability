# Verifying Azure AD tenant availability

When [Yannick Dils](https://www.tunecom.be/) and [Thomas Van Laere](https://thomasvanlaere.com/) had a conversation about how to handle a certain aspect of an Azure migration project a question arose: "How do we check whether or not an Azure AD tenant is in use, without access to Microsoft Partner Center"

This can be easily achieved by looking at the tenant-specific Azure Active Directory single sign-on and single sign-out endpoints. When you receive an HTTP 200 status code, the endpoint data exists and you could assume that the Azure Active Directory tenant's name is in use. When the HTTP 404 status code is returned you could assume the opposite, that the Azure Active Directory tenant's name is not in use!

Feel free to read the [full blog post](https://thomasvanlaere.com/posts/2021/05/verifying-azure-ad-tenant-availability/)!

## Prerequisites

To run the PowerShell sample you will need:

- PowerShell 7.0+

> ⚠️ "```Invoke-WebRequest```" does not have the "```-SkipHttpErrorCheck```" parameter in PowerShell 5.1 and thus this script will not function as is. You could rewrite the script for PowerShell 5.1 so it takes advantage of a "```try/catch```" block, in order to capture the status code, more info on how to do that [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-5.1#example-4--catch-non-success-messages-from-invoke-webrequest). You could also rewrite the script so you check the "```$PsVersionTable```" and then branch the logic off from there, the choice is entirely yours.

This sample also includes a Visual Studio Code [DevContainer](https://code.visualstudio.com/docs/remote/containers) configuration, allowing you to run this sample in a Docker container with the necessary dependencies preinstalled.
