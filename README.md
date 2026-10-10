# PowerShell Scripting Labs

## About This Repo

This repo has the **commands and scripts** from my PowerShell Scripting course labs. They are sorted *week by week*, so each folder holds one lab.

Every file has comments that explain what each command does, so you can read along even if you are new to PowerShell.

> **Lab setup:** a Windows Server 2022 VM on Hyper-V at `192.168.1.20`.
>
> I control it from my Windows host using **PowerShell Remoting**. The domain is `saksham.powershell.com`.

---

## Weekly Files

| Week | Topic | Files |
|:-----|:-----:|------:|
| 01 | Basics, help system, PS Remoting | [week01-commands.ps1](week-01-intro-help-remoting/week01-commands.ps1) |
| 02 | Variables & arrays | [week02-commands.ps1](week-02-variables-arrays/week02-commands.ps1) |
| 03 | Active Directory: OUs, users, bulk CSV import | [week03-commands.ps1](week-03-adds-users/week03-commands.ps1), [AddNewUser.ps1](week-03-adds-users/AddNewUser.ps1), [Users.csv](week-03-adds-users/Users.csv) |
| 04 | Excel automation with ImportExcel | [week04-commands.ps1](week-04-importexcel/week04-commands.ps1) |

---

## Week 01: Basics, Help & Remoting

This week was about the **first steps**: running a script, finding commands, and getting help.

### What I did

1. Wrote my first script, which prints `Hello World!`
2. Checked the execution policy with `Get-ExecutionPolicy -List`
3. Played with dates and wrote a small function
    1. `Get-Date -Format hh:mm:ss` shows only the time
    2. `get-time` is my own function that wraps `Get-Date`
4. Found commands with `Get-Module` and `Get-Command`
5. Used `Start-Process` with `.WaitForExit()` so the script *waits* for Notepad to close

### The help system

- `Get-Help Format-Table` shows basic help
    - `-Detailed` and `-Full` show more
    - `-Examples` shows only examples
    - `-Online` opens the web page
- `Get-Help about_*` lists the topic articles
- `Save-Help` saves help files to a folder

### Remoting

- `Test-WsMan` checks that the server can be reached
- `Invoke-Command` runs one command on the server
- `Enter-PSSession` opens a live session on the server

---

## Week 02: Variables & Arrays

A **variable** stores a value. An **array** stores a list of values.

### Variables

- Saved process data in a variable, then filtered it with `Where-Object` and sorted it with `Sort-Object`
- Learned the difference between *loose* and *strong* typing
    - `2 + 2` gives `4`, but `'2' + '2'` gives `22` (text is joined)
    - `[int]$num1 = '2.6'` turns the value into a whole number
- Single quotes `'...'` print text as it is, while double quotes `"..."` fill in variables
- `Get-Variable` lists all variables and `$env:COMPUTERNAME` reads an environment variable

### Arrays

- Made arrays with `@('Apples','Oranges','Bananas')`
- Picked items by index: `$data[0]`, `$data[1..3]` and `$data[-1]`
- Used array operators:
    - `-join` joins items into one string
    - `-contains` checks if an item is in the list
    - `-eq` and `-ne` filter items
- Tried typed arrays, `ArrayList`, and nested arrays

### Use cases

1. A script that finds files bigger than **100 MB**
2. A script that removes duplicates from a list of failed backup servers

---

## Week 03: Active Directory with PowerShell

This week I created an **OU** and **users** in Active Directory, first by hand and then from a CSV file.

### Steps

1. Connected to the domain controller with `New-PSSession` and `Enter-PSSession`
2. Created the `Department-IT` OU with `New-ADOrganizationalUnit`
3. Created users by hand with `New-ADUser`
    1. `User15` with basic settings
    2. `User6` with city, country and department
4. Copied `Users.csv` and `AddNewUser.ps1` to the server with `Copy-Item -ToSession`
5. Ran `AddNewUser.ps1` to create **10 users** from the CSV

### Users in the CSV

| First Name | Last Name | User Name |
|:-----------|:---------:|----------:|
| John | Doe | jdoe |
| Jane | Smith | jsmith |
| Michael | Brown | mbrown |
| Emily | Davis | edavis |
| David | Wilson | dwilson |
| Sarah | Taylor | staylor |
| Chris | Anderson | canderson |
| Laura | Thomas | lthomas |
| Daniel | White | dwhite |
| Olivia | Martin | omartin |

### About `AddNewUser.ps1`

- Reads every row in `Users.csv`
- Creates each user in the `Department-IT` OU
- *Skips* users that already exist, so it is safe to run again
- Makes users change their password at first logon

> **Lesson learned:** save the file in Notepad *before* copying it.
>
> My first copy was a 0-byte file, and it failed without showing any error!

---

## Week 04: Excel with ImportExcel

The server has **no internet** and **no Excel**, but the `ImportExcel` module still lets PowerShell read and write `.xlsx` files.

### Steps

1. Copied `Fruits.xlsx` from the host to the server
2. Installed the module *offline*
    1. Ran `Save-Module -Name ImportExcel` on the host
    2. Copied the folder to `C:\Program Files\WindowsPowerShell\Modules` on the server
3. Read data with `Import-Excel` and saved data with `Export-Excel`
4. Imported only some columns and rows with `-ImportColumns`, `-StartRow` and `-EndRow`
5. Added new sheets with `-Append`
6. Added formatting with `-TableStyle` and `-Title`
7. Made a chart with `New-ExcelChartDefinition`
8. Copied the files back to the host with `Copy-Item -FromSession`

---

## Progress Checklist

- [x] Week 01: Basics, help system, PS Remoting
- [x] Week 02: Variables & arrays
- [x] Week 03: Active Directory users
- [x] Week 04: Excel automation
- [ ] Week 05: coming soon

---

## Useful Links

- [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [New-ADUser Documentation](https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-aduser)
- [ImportExcel Module on GitHub](https://github.com/dfinke/ImportExcel)
- [Markdown Guide: Basic Syntax](https://www.markdownguide.org/basic-syntax/)

> ⚠️ The password in these scripts (`P@ssw0rd`) is only for the lab. Never use it on a real system.

*Made by* **Saksham Sain**
