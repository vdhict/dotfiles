# PowerShell Profile for Windows
# Works alongside WSL dotfiles

# Oh My Posh - Modern prompt theme
# Installation: winget install JanDeDobbeleer.OhMyPosh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\powerlevel10k_lean.omp.json" | Invoke-Expression
}

# PSReadLine - Enhanced readline
# Installation: Install-Module PSReadLine -Force
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -EditMode Windows

# WSL Interop - Import Linux commands
# Installation: Install-Module WslInterop -Force
if (Get-Module -ListAvailable -Name WslInterop) {
  Import-WslCommand "cat", "grep", "head", "ls", "sed", "tail", "tree", "which"
}

# Chocolatey profile
if (Get-Command choco -ErrorAction SilentlyContinue) {
  if (Test-Path "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1") {
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  }
}

# WinGet argument completer
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# PowerToys CommandNotFound module
if (Test-Path "C:\Program Files\PowerToys\WinGetCommandNotFound.psd1") {
  Import-Module "C:\Program Files\PowerToys\WinGetCommandNotFound.psd1"
}

# Helper functions
function Refresh-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

# Full system upgrade function
# Requires: gsudo (winget install gerardog.gsudo)
# Requires: PSWindowsUpdate (Install-Module PSWindowsUpdate -Force)
function Full-Upgrade {
  gsudo {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
      Write-Host '-> Upgrading Chocolatey packages' -ForegroundColor Cyan
      choco upgrade all --yes
    }

    Write-Host '-> Upgrading WinGet packages' -ForegroundColor Cyan
    winget upgrade --all --accept-source-agreements --accept-package-agreements

    Write-Host '-> Triggering Microsoft Store updates' -ForegroundColor Cyan
    Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod > $null

    if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
      Write-Host '-> Installing Windows updates' -ForegroundColor Cyan
      Get-WindowsUpdate -Install -AcceptAll
    }

    Write-Host '-> Updating PowerShell modules' -ForegroundColor Cyan
    Update-Module -Confirm:$false
  }
}

# Aliases
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name which -Value Get-Command
Set-Alias -Name touch -Value New-Item

# Navigation shortcuts
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function ~ { Set-Location $HOME }
