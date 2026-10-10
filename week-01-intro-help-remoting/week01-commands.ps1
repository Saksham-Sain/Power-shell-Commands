<#
.SYNOPSIS
    Week 1 - PowerShell basics, the help system, and PS Remoting
.NOTES
    Environment : Windows Server VM (Hyper-V) + VS Code + PowerShell ISE
    Server IP   : 192.168.1.20
    Commands extracted from the Week 1 lab report screenshots.
#>

# =====================================================================
# EXERCISE 1 - First script & basic cmdlets  (VS Code)
# =====================================================================

# --- Step 1: MyFirstScript.ps1 ---
Write-Host "Hello World!"

# --- Step 2: Run the script by its full path ---
C:\Users\Administrator\Documents\Lab-1\MyFirstScript.ps1

# --- Step 3: Check execution policy (LocalMachine = RemoteSigned) ---
Get-ExecutionPolicy -List

# --- Step 4: Date and time formatting ---
Get-Date
Get-Date -Format hh:mm:ss

# --- Step 5: A simple function ---
Function get-time
{
    get-date -Format hh:mm
}
get-time

# --- Step 6: List installed modules ---
Get-Module -ListAvailable

# --- Step 7: Discover commands ---
Get-Command
Get-Command -Name *IP*                       # searches everywhere -> long list
Get-Command -Module NetTCPIP -Name *IP*      # only inside NetTCPIP -> shorter list

# --- Step 8: Start a process, wait for it to exit, then start another ---
Start-Process notepad.exe
$NotepadProc = Get-Process -Name notepad
$NotepadProc.WaitForExit()                   # script pauses until Notepad is closed
Start-Process calc.exe

# --- Step 9: Inspect object members ---
Get-Process | Get-Member


# =====================================================================
# EXERCISE 2 - The help system  (PowerShell ISE)
# =====================================================================

# --- Step 1: Basic help for a cmdlet ---
Get-Help Format-Table
Get-Help -Name Format-Table
Format-Table -?

# --- Step 2: One page at a time ---
help Format-Table
man Format-Table
Get-Help Format-Table | Out-Host -Paging

# --- Step 3: More information ---
Get-Help Format-Table -Detailed
Get-Help Format-Table -Full

# --- Step 4: Selected parts using parameters ---
Get-Help Format-Table -Examples
Get-Help Format-Table -Online
Get-Help Format-Table -Parameter *
Get-Help Get-ChildItem -Parameter *
Get-Help Format-Table -Parameter GroupBy

# --- Step 5: List conceptual (about_) articles ---
Get-Help about_*

# --- Step 6: Articles that include a word ---
Get-Help -Name remoting

# --- Step 7: Save help for a module to a folder ---
$modulename = "Microsoft.PowerShell.Management"
$module = Get-Module -Name $modulename -ListAvailable
New-Item -Path "C:\SavedHelp" -ItemType Directory -Force
Save-Help -Module $module -DestinationPath "C:\SavedHelp"


# =====================================================================
# EXERCISE 3 - PS Remoting  (run from the HOST, as Administrator)
# =====================================================================

# --- Output 1: Test that WinRM is reachable on the server ---
Test-WsMan 192.168.1.20

# --- Output 2: Run a command remotely ---
Invoke-Command -ComputerName 192.168.1.20 -ScriptBlock { Get-ChildItem C:\ } -Credential Administrator

# --- Output 3: Interactive remote session ---
Enter-PSSession -ComputerName 192.168.1.20 -Credential Administrator
# prompt becomes: [192.168.1.20]: PS C:\Users\Administrator\Documents>
