<#
.SYNOPSIS
    Week 3 - Working with Active Directory Domain Services (ADDS) using PowerShell
.NOTES
    Domain     : saksham.powershell.com
    DC / Server: 192.168.1.20
    Run from   : Host machine -> PSSession to the DC
    Commands extracted from the Week 3 lab report screenshots.
    The script itself is in AddNewUser.ps1 (same folder).
#>

# =====================================================================
# 1. Connect to the domain controller and create an OU
# =====================================================================
$session = New-PSSession 192.168.1.20 -Credential saksham.powershell.com\administrator
Enter-PSSession $session

whoami                                            # saksham\administrator
Get-ADDomain | Select-Object DNSRoot, DistinguishedName

New-ADOrganizationalUnit -Name "Department-IT" -Path "DC=saksham,DC=powershell,DC=com"
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -AutoSize

# =====================================================================
# 2. Check existing users (only defaults: Administrator, Guest, krbtgt)
# =====================================================================
Get-ADUser -Filter * | Select-Object Name

# =====================================================================
# 3. Create users manually
# =====================================================================
# NOTE: P@ssw0rd is a lab-only password. Never reuse it outside a lab.

# User15 - basic settings
# (top of this command was cut off in the screenshot; reconstructed from
#  the visible lines and the result table)
New-ADUser -Name "User15" -Path "OU=Department-IT,DC=saksham,DC=powershell,DC=com" `
    -UserPrincipalName "User15@saksham.powershell.com" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
    -Enabled $true `
    -ChangePasswordAtLogon $true

# User6 - with city, country and department
New-ADUser -Name "User6" -Path "OU=Department-IT,DC=saksham,DC=powershell,DC=com" `
    -UserPrincipalName "User6@saksham.powershell.com" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) `
    -City "Toronto" `
    -Country "CA" `
    -Department "IT" `
    -Enabled $true `
    -ChangePasswordAtLogon $true

# Verify
Get-ADUser -Filter * -SearchBase "OU=Department-IT,DC=saksham,DC=powershell,DC=com" -Properties City, Country, Department |
    Format-Table Name, UserPrincipalName, City, Country, Department, Enabled -AutoSize

# =====================================================================
# 4. Explore New-ADUser options
# =====================================================================
Get-Help New-ADUser

# =====================================================================
# 5. Prepare Users.csv on the HOST
# =====================================================================
Exit-PSSession
mkdir "$env:USERPROFILE\PowerShell_Scripts"
$csv = "$env:USERPROFILE\PowerShell_Scripts\Users.csv"
(Get-Content $csv) -replace 'manpreet', 'saksham' | Set-Content $csv   # fix UPN domain
Get-Content $csv

# =====================================================================
# 6. Copy Users.csv to the server
# =====================================================================
$copyParams = @{
    Path        = "$env:USERPROFILE\PowerShell_Scripts\Users.csv"
    Destination = "C:\Users\Administrator\Documents\Users.csv"
    ToSession   = $session
}
Copy-Item @copyParams

# =====================================================================
# 7. Create / edit the script, then copy it to the server
# =====================================================================
notepad "$env:USERPROFILE\PowerShell_Scripts\AddNewUser.ps1"
# !! SAVE in Notepad before copying - first attempt copied a 0-byte file !!

$copyParams = @{
    Path        = "$env:USERPROFILE\PowerShell_Scripts\AddNewUser.ps1"
    Destination = "C:\Users\Administrator\Documents\AddNewUser.ps1"
    ToSession   = $session
}
Copy-Item @copyParams

# =====================================================================
# 8. Run the script on the server
# =====================================================================
Enter-PSSession $session
cd C:\Users\Administrator\Documents
dir                                   # check AddNewUser.ps1 is NOT 0 bytes (should be ~1271)
.\AddNewUser.ps1                      # Created jdoe ... Created omartin

# =====================================================================
# 9. Final check - 12 users in Department-IT
# =====================================================================
Get-ADUser -Filter * -SearchBase "OU=Department-IT,DC=saksham,DC=powershell,DC=com" -Properties DisplayName, Department |
    Format-Table Name, DisplayName, UserPrincipalName, Department, Enabled -AutoSize
