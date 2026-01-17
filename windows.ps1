# ===============================
# STRICT + ERROR
# ===============================
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ===============================
# CHECK ADMIN
# ===============================
$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Start-Process PowerShell `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}

# ===============================
# TLS
# ===============================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ===============================
# SINGLE STATUS LINE
# ===============================
Write-Host ">>> AWO is running... Please wait <<<"

# ===============================
# PATH CONFIG
# ===============================
$CmdUrl  = "https://raw.githubusercontent.com/nminh0111/AWO/refs/heads/main/awo_activate.cmd"
$WorkDir = "$env:ProgramData\AWO"
$CmdFile = "$WorkDir\awo_activate.cmd"

# ===============================
# PREPARE FOLDER
# ===============================
if (-not (Test-Path $WorkDir)) {
    New-Item -ItemType Directory -Path $WorkDir | Out-Null
}

# ===============================
# DOWNLOAD CMD
# ===============================
Invoke-WebRequest $CmdUrl -OutFile $CmdFile -UseBasicParsing

# ===============================
# RUN CMD (WAIT UNTIL CLOSED)
# ===============================
Start-Process cmd `
    -ArgumentList "/c `"$CmdFile`"" `
    -Wait

# ===============================
# CLEANUP AFTER CMD CLOSED
# ===============================
Start-Sleep -Seconds 1

if (Test-Path $CmdFile) {
    Remove-Item $CmdFile -Force
}

if (Test-Path $WorkDir -and @(Get-ChildItem $WorkDir).Count -eq 0) {
    Remove-Item $WorkDir -Force
}

# ===============================
# CLOSE POWERSHELL
# ===============================
exit
