<#
.SYNOPSIS
    Creates Active Directory users in bulk from a CSV file.

.DESCRIPTION
    This script reads Users.csv (firstName, lastName, userName, userPrincipalName)
    and creates an AD user for each row inside the Department-IT OU.
    Each user is enabled and must change the password at first logon.
    If a user already exists, the script skips it, so it is safe to run more than once.

.PARAMETER CsvPath
    Path to the CSV file with the user list.
    Default: C:\Users\Administrator\Documents\Users.csv

.PARAMETER OUPath
    Distinguished name of the OU where the users will be created.
    Default: OU=Department-IT,DC=saksham,DC=powershell,DC=com

.EXAMPLE
    Example usage:
    PS> .\AddNewUser.ps1

.EXAMPLE
    PS> .\AddNewUser.ps1 -CsvPath "C:\Temp\Users.csv" -OUPath "OU=Department-IT,DC=saksham,DC=powershell,DC=com"

.NOTES
    Author: Saksham
    Created: 2026-10-03
    Version: 1.1
    Last Modified: 2026-10-03
    Change Log:
        1.0 - Initial release (basic CSV import from the lab)
        1.1 - Added OU path, duplicate check, error handling, template format

.LINK
    https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-aduser
#>

#Parameters
param(
    [string]$CsvPath = "C:\Users\Administrator\Documents\Users.csv",
    [string]$OUPath  = "OU=Department-IT,DC=saksham,DC=powershell,DC=com"
)

# ---------------------------------------------------------------------
# NOTE: Everything below this line was not visible in the lab screenshots.
# It is a reconstruction based on the documented behaviour (help block +
# "Created <user>" output + final user table). Swap in your original
# body if it differs.
# ---------------------------------------------------------------------

#Functions
function New-LabUser {
    param($Row)

    if (Get-ADUser -Filter "SamAccountName -eq '$($Row.userName)'" -ErrorAction SilentlyContinue) {
        Write-Host "Skipped $($Row.userName) (already exists)" -ForegroundColor Yellow
        return
    }

    try {
        New-ADUser -Name $Row.userName `
            -GivenName $Row.firstName `
            -Surname $Row.lastName `
            -DisplayName "$($Row.firstName) $($Row.lastName)" `
            -SamAccountName $Row.userName `
            -UserPrincipalName $Row.userPrincipalName `
            -Department "IT" `
            -Path $OUPath `
            -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true
        Write-Host "Created $($Row.userName)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed $($Row.userName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

#Execution Code
Import-Module ActiveDirectory
$users = Import-Csv -Path $CsvPath
foreach ($user in $users) {
    New-LabUser -Row $user
}
