@echo off
setlocal EnableExtensions
title Office Activation (KMS)

:: ===============================
:: KMS CONFIG
:: ===============================
set KMS_HOST=KMS.DIGIBOY.IR
set KMS_PORT=1688

:: ===============================
:: OFFICE MENU
:: ===============================
:OFFICE_MENU
cls
color 0A
echo ============================================================
echo               OFFICE ACTIVATION (KMS)
echo ============================================================
echo.
echo   1. Check Office activation status
echo   2. Activate Office (KMS)
echo   3. Exit
echo.
echo ------------------------------------------------------------
set /p CHOICE=   Choose an option: 

if "%CHOICE%"=="1" goto OFFICE_CHECK
if "%CHOICE%"=="2" goto OFFICE_ACTIVATE
if "%CHOICE%"=="3" exit /b
goto OFFICE_MENU

:: ===============================
:: CHECK STATUS
:: ===============================
:OFFICE_CHECK
cls
color 0B
echo ============================================================
echo              OFFICE ACTIVATION STATUS
echo ============================================================
echo.

set "OSPP="

if exist "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
    set "OSPP=%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS"
)

if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (
    set "OSPP=%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS"
)

if exist "%ProgramFiles%\Microsoft Office\root\Office16\OSPP.VBS" (
    set "OSPP=%ProgramFiles%\Microsoft Office\root\Office16\OSPP.VBS"
)

if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\OSPP.VBS" (
    set "OSPP=%ProgramFiles(x86)%\Microsoft Office\root\Office16\OSPP.VBS"
)

if not defined OSPP (
    color 0C
    echo   Office Status          : Not Installed
    echo.
    echo   Microsoft Office is not installed.
    echo.
    pause
    goto OFFICE_MENU
)

cscript //nologo "%OSPP%" /dstatus
echo.
pause
goto OFFICE_MENU

:: ===============================
:: ACTIVATE
:: ===============================
:OFFICE_ACTIVATE
cls
color 0F
echo ============================================================
echo              OFFICE KMS ACTIVATION
echo ============================================================
echo.

set OSPP=

if exist "%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS" (
    set OSPP=%ProgramFiles%\Microsoft Office\Office16\OSPP.VBS
)

if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS" (
    set OSPP=%ProgramFiles(x86)%\Microsoft Office\Office16\OSPP.VBS
)

if not defined OSPP (
    color 0C
    echo   Office is not installed.
    echo.
    pause
    goto OFFICE_MENU
)

echo   Processing Office...
timeout /t 2 >nul

cscript //nologo "%OSPP%" /sethst:%KMS_HOST%
cscript //nologo "%OSPP%" /setprt:%KMS_PORT%
cscript //nologo "%OSPP%" /act

echo.
pause
goto OFFICE_MENU

