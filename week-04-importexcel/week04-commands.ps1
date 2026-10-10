<#
.SYNOPSIS
    Week 4 - Working with Excel in PowerShell (ImportExcel module)
.NOTES
    Server : 192.168.1.20 (no internet, no Excel installed)
    Domain : saksham.powershell.com
    Commands extracted from the Week 4 lab report screenshots.
#>

# =====================================================================
# Step 1: Copy Fruits.xlsx from the host to the server
# =====================================================================
Test-Path "$HOME\Downloads\Fruits.xlsx"
$session = New-PSSession 192.168.1.20 -Credential saksham.powershell.com\administrator
$copyParams = @{
    Path        = "$HOME\Downloads\Fruits.xlsx"
    Destination = "C:\Users\Administrator\Documents\Fruits.xlsx"
    ToSession   = $session
}
Copy-Item @copyParams

Enter-PSSession 192.168.1.20 -Credential saksham.powershell.com\administrator
Test-Path "C:\Users\Administrator\Documents\Fruits.xlsx"     # True

# =====================================================================
# Step 2: Install ImportExcel (offline server workaround)
# =====================================================================
# Install-Module ImportExcel fails on the server -> "No match was found"
# (no internet to reach the PowerShell Gallery).
# Fix (from the lab write-up): on the HOST, download the module, then copy
# the folder to the server's module path.
#   Save-Module -Name ImportExcel -Path <local folder>
#   copy the ImportExcel folder to: C:\Program Files\WindowsPowerShell\Modules  (on the server)

Import-Module ImportExcel
Get-Module -ListAvailable ImportExcel                         # version 7.8.10

# =====================================================================
# Step 3: Import the Fruits data
# =====================================================================
Import-Excel "C:\Users\Administrator\Documents\Fruits.xlsx" -OutVariable fruit
$fruit | Get-Member                                           # NoteProperties: Fruits, Quantity

# =====================================================================
# Step 4: Export process info to Excel
# =====================================================================
Get-Process | Export-Excel "C:\Users\Administrator\Documents\ProcessInfo.xlsx" -WorksheetName Processes
Get-ChildItem C:\Users\Administrator\Documents

# =====================================================================
# Step 5: Import only some columns and rows
# =====================================================================
# Print every column name with its number first (numbers differ per machine!)
$h = (Import-Excel "C:\Users\Administrator\Documents\ProcessInfo.xlsx" -WorksheetName Processes | Select-Object -First 1).psobject.Properties.Name
for ($i=0; $i -lt $h.Count; $i++) { "{0}  {1}" -f ($i+1), $h[$i] }

# On this server: Name=1, ProcessName=48, CPU=10, WS=5
$cols = 1,48,10,5
$cols
Import-Excel "C:\Users\Administrator\Documents\ProcessInfo.xlsx" -WorksheetName Processes -ImportColumns $cols -StartRow 1 -EndRow 7

# =====================================================================
# Step 6: Add a new sheet to an existing file
# =====================================================================
$people = @(
    [PSCustomObject]@{ Name = "Jeremy"; City = "Loxahatchee" }
    [PSCustomObject]@{ Name = "Mike";   City = "Apex" }
    [PSCustomObject]@{ Name = "Kevin";  City = "Cary" }
    [PSCustomObject]@{ Name = "Phil";   City = "Holly Springs" }
)
$people | Format-Table -AutoSize

$people | Export-Excel "C:\Users\Administrator\Documents\ProcessInfo.xlsx" -Append -WorksheetName "People"
Import-Excel "C:\Users\Administrator\Documents\ProcessInfo.xlsx" -WorksheetName People
Get-ExcelSheetInfo "C:\Users\Administrator\Documents\ProcessInfo.xlsx"   # Processes, People

# =====================================================================
# Step 7: Export with formatting
# =====================================================================
New-Item -ItemType Directory -Path C:\temp -Force
$people | Export-Excel C:\temp\ExcelDemo.xlsx -Append -WorksheetName "PeopleFormatted" -TableStyle Medium16 -Title "Demo of Table Formatting" -TitleBold
Get-ExcelSheetInfo C:\temp\ExcelDemo.xlsx

# =====================================================================
# Step 8: Create a chart
# =====================================================================
# Handout used Item / TotalSold - this file's columns are Fruits / Quantity
$fruit = Import-Excel "C:\Users\Administrator\Documents\Fruits.xlsx"
$ChartData = New-ExcelChartDefinition -XRange Fruits -YRange Quantity -ChartType ColumnClustered -Title "Total Fruit Sales"
$fruit | Export-Excel C:\temp\ExcelDemo.xlsx -Append -WorksheetName FruitSalesChart -ExcelChartDefinition $ChartData -AutoNameRange -Title "Fruit Sales"
Get-ExcelSheetInfo C:\temp\ExcelDemo.xlsx                     # PeopleFormatted, FruitSalesChart

# =====================================================================
# Step 9: Copy both files back to the host to open in Excel
# =====================================================================
Exit-PSSession
$session = New-PSSession 192.168.1.20 -Credential saksham.powershell.com\administrator
Copy-Item C:\temp\ExcelDemo.xlsx -Destination $HOME\Desktop -FromSession $session
Copy-Item C:\Users\Administrator\Documents\ProcessInfo.xlsx -Destination $HOME\Desktop -FromSession $session
Get-ChildItem $HOME\Desktop\*.xlsx
