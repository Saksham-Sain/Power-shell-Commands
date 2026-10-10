<#
.SYNOPSIS
    Week 2 - Variables and Arrays
.NOTES
    Environment : Windows Server 2022, PowerShell 7.6.6
    Connection  : Remoting session (Enter-PSSession) to 192.168.1.20
    Commands extracted from the Week 2 lab report screenshots.
#>

# =====================================================================
# PART A - VARIABLES
# =====================================================================

# --- Step 1: PowerShell 7 remoting endpoints ---
# (After installing PowerShell 7, run this inside pwsh on the server)
Enable-PSRemoting
Get-PSSessionConfiguration | Select-Object Name, PSVersion
# -> PowerShell.7 / PowerShell.7.6.6 endpoints, version 7.6

# Connect from the host
Enter-PSSession -ComputerName 192.168.1.20 -Credential Administrator

# --- Step 2: Store running processes in a variable ---
Get-Process
$processes = Get-Process
$processes                      # snapshot - does not update by itself

# --- Step 3: Processes with high CPU time ---
Get-Process | Where-Object {$_.CPU -gt 2000}
$processes  | Where-Object {$_.CPU -gt 2000}

# --- Step 4: Sort by memory (highest first) ---
Get-Process | Sort-Object WorkingSet64 -Descending
$processes  | Sort-Object WorkingSet64 -Descending

# --- Step 5: Loosely typed variable (number) ---
$total = 2+2
$total                          # 4
$total | Get-Member             # System.Int32

# --- Step 6: Loosely typed variable (string) ---
$total = '2+2'
$total                          # 2+2
$total | Get-Member             # System.String

# --- Step 7: Adding numbers vs adding strings ---
$num1 = 2
$num2 = 2
$total = $num1 + $num2
$total                          # 4

$num1 = '2'
$num2 = '2'
$total = $num1 + $num2
$total                          # 22  (strings are joined)

# --- Step 8: Strongly typed variables ---
# As written in the handout (error - space in "$num 2"):
# $total = $num1 + $num 2
# Fixed:
[int]$num1 = '2.6'
[int]$num2 = '1.7'
$total = $num1 + $num2
$total                          # 5  (2.6 -> 3, 1.7 -> 2)

# --- Step 9: Convert integer to string ---
$stringReturn = $total.ToString()
$stringReturn | Get-Member      # System.String
$total        | Get-Member      # System.Int32

# --- Step 10: Single quotes vs double quotes ---
$literal = ' Two plus one equals: $(1+2)'
$literal                        # prints $(1+2) as text
$escaped = "Two plus one equals: $(1+2)"
Write-Host '$escaped'           # prints the word $escaped
Write-Host "$escaped"           # Two plus one equals: 3

# --- Step 11: View all variables ---
Get-Variable

# --- Step 12: Environment variables ---
Get-ChildItem env:
$env:COMPUTERNAME
$env:USERNAME

# --- Step 13: Use-case - find large files ---
New-Item -ItemType Directory C:\TestShare -Force
# (a 150 MB test file was placed in C:\TestShare)
$path = Read-Host -Prompt 'Please enter the file path you wish to scan for large files...'
$rawFileData = Get-ChildItem -Path $path -Recurse
$largeFiles = $rawFileData | Where-Object {$_.Length -gt 100MB}
$largeFilesCount = $largeFiles | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "You have $largeFilesCount large file(s) in $path"


# =====================================================================
# PART B - ARRAYS
# =====================================================================

# --- Step 14: Basic array ---
$fruit = @('Apples','Oranges','Bananas')
$fruit

# --- Step 15: Empty array, count and indexing ---
$data = @()
$data.Count                     # 0
$data = @('zero','one','two','three')
$data
$data[0]
$data[0,1,2,3]
$data[1..3]
$data[-1]
$data[2] = 'second'
$data

# --- Step 16: ForEach-Object on an array ---
$data | ForEach-Object {"Item: $PSItem"}

# --- Step 17: Array of objects ---
$data = @(
    [pscustomobject]@{FirstName='Kevin'; LastName='Marquette'}
    [pscustomobject]@{FirstName='John';  LastName='Doe'}
)
$data
$data[0]
$data[0].FirstName
$data[0].FirstName = 'Jay'
$data
$data | ForEach-Object {$_.LastName}
$data.LastName

# --- Step 18: Array operators ---
$data = @(1,2,3,4)
$data -join '-'                 # 1-2-3-4
$data = @('red','green','blue')
$data -contains 'green'         # True
$data -eq 'green'               # green
$data -ne 'green'               # red, blue

# --- Step 19: Adding arrays together ---
$first  = @('zero','one')
$second = @('two','three')
$first + $second
$first += 'Two, Three'          # added as ONE item
$first
$first.Count                    # 3

# --- Step 20: Strongly typed array ---
[int[]]$numbers = 1,2,3
$numbers
$numbers += 'abc'               # error: cannot convert "abc" to System.Int32

# --- Step 21: ArrayList ---
$myArray = [System.Collections.ArrayList]::new()
[void]$myArray.Add('Value')
$myArray
$myArray.Count

# --- Step 22: Multiplying an array ---
$data = @('red','green','blue')
$data * 3

# --- Step 23: Nested arrays ---
$data = @(@(1,2,3),@(4,5,6),@(7,8,9))
$outsideIndex = 0
$insideIndex  = 2               # handout had typo "$insudeIndex"
$data[$outsideIndex][$insideIndex]   # 3

# --- Step 24: Use-case - investigating failed server backups ---
$failedServers = @(
    "SRV-FILE01",
    "SRV-DB01",
    "SRV-WEB01",
    "SRV-FILE01",
    "SRV-APP01",
    "SRV-DB01",
    "SRV-BACKUP01"
)
Write-Host "`nTotal Failure Records: $($failedServers.Count)"
$uniqueServers = $failedServers | Select-Object -Unique
$uniqueServers
if ($uniqueServers -contains "SRV-DB01") {
    Write-Host "SRV-DB01 is in the failure list."
}
$serverList = $uniqueServers -join "; "
Write-Host "Server list: $serverList"
