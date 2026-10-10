# PowerShell Commands

## About This Repository

This repository is a beginner-friendly reference for **Windows PowerShell** commands. It covers the cmdlets used most often for navigating the file system, managing files, working with processes and services, and doing basic network troubleshooting.

PowerShell is a *cross-platform task automation solution* made up of a command-line shell, a scripting language, and a configuration management framework. It runs on **Windows**, **Linux**, and **macOS**.

> PowerShell is built on .NET, so it works with *objects* rather than plain text.
>
> Each command passes rich, structured data down the pipeline!

---

## Table of Contents

1. [What is PowerShell?](#what-is-powershell)
2. [Getting Started](#getting-started)
3. [Command Reference](#command-reference)
    1. [Navigation](#navigation)
    2. [File and Folder Management](#file-and-folder-management)
    3. [Processes and Services](#processes-and-services)
    4. [Networking](#networking)
4. [Cmdlet vs. Alias Cheat Sheet](#cmdlet-vs-alias-cheat-sheet)
5. [Learning Checklist](#learning-checklist)
6. [Resources](#resources)

---

## What is PowerShell?

PowerShell commands are called **cmdlets** (pronounced *"command-lets"*). Every cmdlet follows a **Verb-Noun** naming pattern, which makes commands easy to guess and remember.

Common verbs include:

- `Get` – retrieves information
- `Set` – changes a value or setting
- `New` – creates something new
- `Remove` – deletes something
- `Start` / `Stop` – controls processes and services
    - `Start-Process` – launches an application
    - `Stop-Process` – ends a running application

> **Tip:** Not sure what a command does? Use `Get-Help <cmdlet-name>` to read its documentation.

---

## Getting Started

Follow these steps to open PowerShell and run your first command:

1. Press `Win + X` on your keyboard.
2. Select **Windows PowerShell** or **Terminal**.
3. Check your PowerShell version:
    1. Type `$PSVersionTable`
    2. Press **Enter**
4. Allow local scripts to run (optional, requires *Administrator*):
    1. Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
    2. Type `Y` to confirm

---

## Command Reference

### Navigation

| Command | Description | Example |
|:--------|:-----------:|--------:|
| `Get-Location` | Shows the current directory | `Get-Location` |
| `Set-Location` | Changes the current directory | `Set-Location C:\Users` |
| `Get-ChildItem` | Lists files and folders | `Get-ChildItem -Force` |
| `Push-Location` | Saves the current location and moves | `Push-Location C:\Temp` |
| `Pop-Location` | Returns to the saved location | `Pop-Location` |

### File and Folder Management

| Command | Description | Example |
|:--------|:-----------:|--------:|
| `New-Item` | Creates a file or folder | `New-Item -Path .\Notes -ItemType Directory` |
| `Copy-Item` | Copies a file or folder | `Copy-Item .\a.txt .\backup\a.txt` |
| `Move-Item` | Moves or renames an item | `Move-Item .\a.txt .\b.txt` |
| `Remove-Item` | Deletes a file or folder | `Remove-Item .\old.txt` |
| `Get-Content` | Reads the contents of a file | `Get-Content .\log.txt -Tail 10` |
| `Set-Content` | Writes (overwrites) file contents | `Set-Content .\a.txt "Hello World!"` |
| `Add-Content` | Appends text to a file | `Add-Content .\a.txt "New line"` |

### Processes and Services

| Command | Description | Example |
|:--------|:-----------:|--------:|
| `Get-Process` | Lists running processes | `Get-Process -Name notepad` |
| `Start-Process` | Starts a program | `Start-Process notepad` |
| `Stop-Process` | Stops a running process | `Stop-Process -Name notepad` |
| `Get-Service` | Lists Windows services | `Get-Service -Name Spooler` |
| `Restart-Service` | Restarts a service | `Restart-Service -Name Spooler` |

### Networking

| Command | Description | Example |
|:--------|:-----------:|--------:|
| `Test-Connection` | Pings a remote host | `Test-Connection google.com -Count 4` |
| `Get-NetIPAddress` | Shows IP address configuration | `Get-NetIPAddress -AddressFamily IPv4` |
| `Test-NetConnection` | Tests a port on a remote host | `Test-NetConnection google.com -Port 443` |
| `Resolve-DnsName` | Looks up DNS records | `Resolve-DnsName github.com` |

#### Example: Sample Subnet Plan

The table below shows how networking information might be documented when testing connectivity with `Test-Connection`:

|Subnet | Network Address | Broadcast Address | Default Gateway|
|:--------|:--------------------:|:----------------------:|--------------------:|
|SN1 | 192.168.1.0 | 192.168.1.127 | 192.168.1.1 |
|SN2 | 192.168.1.128 | 192.168.1.255 | 192.168.1.129 |

---

## Cmdlet vs. Alias Cheat Sheet

Many cmdlets have short **aliases** that match familiar *CMD* or *Linux* commands:

| Cmdlet | PowerShell Alias | CMD Equivalent | Linux Equivalent |
|:-------|:----------------:|:--------------:|-----------------:|
| `Get-ChildItem` | `gci`, `ls`, `dir` | `dir` | `ls` |
| `Set-Location` | `cd`, `sl` | `cd` | `cd` |
| `Copy-Item` | `cp`, `copy` | `copy` | `cp` |
| `Move-Item` | `mv`, `move` | `move` | `mv` |
| `Remove-Item` | `rm`, `del` | `del` | `rm` |
| `Get-Content` | `cat`, `gc` | `type` | `cat` |
| `Clear-Host` | `cls`, `clear` | `cls` | `clear` |

> **Note:** Use `Get-Alias` to see every alias available in your session.

---

## Working with the Pipeline

The pipeline (`|`) sends the output of one command into the next. A few useful examples:

- Show the 5 processes using the most memory:
    - `Get-Process | Sort-Object WS -Descending | Select-Object -First 5`
- List only the services that are running:
    - `Get-Service | Where-Object Status -eq 'Running'`
- Export a process list to a CSV file:
    - `Get-Process | Export-Csv .\processes.csv -NoTypeInformation`

---

## Learning Checklist

- [x] Open PowerShell and check the version
- [x] Navigate folders with `Set-Location` and `Get-ChildItem`
- [x] Create, copy, move, and delete files
- [ ] Manage processes and services
- [ ] Use the pipeline to filter and sort output
- [ ] Write and run a first `.ps1` script

---

## Resources

- [Microsoft PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [PowerShell GitHub Repository](https://github.com/PowerShell/PowerShell)
- [Markdown Guide – Basic Syntax](https://www.markdownguide.org/basic-syntax/)

---

*Created by* **Saksham Sain**
