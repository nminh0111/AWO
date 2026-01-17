@echo off
setlocal EnableDelayedExpansion
title Windows Activation (KMS)

:: ===============================
:: KMS CONFIG
:: ===============================
set KMS_HOST=KMS.your-server.com
set KMS_PORT=1688

:: ===============================
:: KMS CLIENT KEYS (GVLK)
:: ===============================

:: Windows Server 2022
set WS2022_DC=WX4NM-KYWYW-QJJR4-XV3QB-6VM33
set WS2022_STD=VDYBN-27WPP-V4HQT-9VMD4-VMK7H

:: Windows Server 2019
set WS2019_DC=WMDGN-G9PQG-XVVXX-R3X43-63DFG
set WS2019_STD=N69G4-B89J2-4G8F4-WWYCC-J464C
set WS2019_ESS=WVDHN-86M7X-466P6-VHXV7-YY726

:: Windows Server 2016
set WS2016_DC=CB7KF-BWN84-R7R2Y-793K2-8XDDG
set WS2016_STD=WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
set WS2016_ESS=JCKRF-N37P4-C2D82-9YXRT-4M63B

:: Windows Server 2012 R2
set WS2012R2_STD=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set WS2012R2_DC=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set WS2012R2_ESS=KNC87-3J2TX-XB4WP-VCPJV-M4FWM

:: Windows 10
set W10_PRO=W269N-WFGWX-YVC9B-4J6C9-T83GX
set W10_PRON=MH37W-N47XK-V7XM9-C7227-GCQG9
set W10_PROWS=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
set W10_PROWSN=9FNHH-K3HBT-3W4TD-6383H-6XYWF
set W10_PROEDU=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
set W10_PROEDUN=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
set W10_EDU=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
set W10_EDUN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
set W10_ENT=NPPR9-FWDCX-D2C8J-H872K-2YT43
set W10_ENTN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
set W10_ENTG=YYVX9-NTFWV-6MDM3-9PT4T-4M68B
set W10_ENTGN=44RPN-FTY23-9VTTB-MP9BX-T84FV

:: ===============================
:: PRINT FUNCTION (FIXED COLUMN)
:: ===============================
:print
set "PAD=................................................"
set "OUT=%~1%PAD%"
set "OUT=%OUT:~0,26%"
echo   %OUT%: %~2
exit /b

:: ===============================
:: TEMP STATUS (SHOW / CLEAR)
:: ===============================
:status_tmp
<nul set /p ="   %~1"
exit /b

:status_clear
<nul set /p ="                                   " & echo.
exit /b

:: ===============================
:: MENU
:: ===============================
:MENU
cls
color 0A
echo ============================================================
echo               WINDOWS ACTIVATION (KMS)
echo ============================================================
echo.
echo   1. Check OS and activation status
echo   2. Activate Windows (KMS)
echo   3. Exit
echo.
set /p CHOICE=   Choose an option: 

if "%CHOICE%"=="1" goto CHECK
if "%CHOICE%"=="2" goto ACTIVATE
exit /b

:: ===============================
:: CHECK STATUS
:: ===============================
:CHECK
cls
color 0B
echo ============================================================
echo                 SYSTEM INFORMATION
echo ============================================================
echo.

for /f "tokens=2,*" %%A in ('reg query HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion /v ProductName ^| find "ProductName"') do set PRODUCT=%%B
for /f "tokens=2,*" %%A in ('reg query HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion /v EditionID ^| find "EditionID"') do set EDITION=%%B

call :print "Operating System" "%PRODUCT%"
call :print "Edition" "%EDITION%"
echo.

:: ---- TEMP CHECKING (WILL DISAPPEAR)
call :status_tmp "Checking activation status..."
set EXPIRE=
for /f "tokens=*" %%A in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr ^| find "expire"') do set EXPIRE=%%A
timeout /t 1 >nul
call :status_clear

:: ---- FINAL OUTPUT
if defined EXPIRE (
    color 0A
    call :print "Activation Status" "Licensed"
    call :print "Expiration Date" "%EXPIRE:~32%"
) else (
    color 0C
    call :print "Activation Status" "Not Activated"
)

echo.
pause
goto MENU

:: ===============================
:: ACTIVATE
:: ===============================
:ACTIVATE
cls
color 0F
echo ============================================================
echo            WINDOWS KMS ACTIVATION PROCESS
echo ============================================================
echo.

:: Detect OS
for /f "tokens=2,*" %%A in ('reg query HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion /v ProductName ^| find "ProductName"') do set PRODUCT=%%B
for /f "tokens=2,*" %%A in ('reg query HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion /v EditionID ^| find "EditionID"') do set EDITION=%%B

call :print "Detected OS" "%PRODUCT%"
call :print "Edition" "%EDITION%"
echo.

:: Select KEY (ví dụ cơ bản – bạn có thể mở rộng)
set KEY=
if "%EDITION%"=="ServerDatacenter" set KEY=%WS2019_DC%
if "%EDITION%"=="ServerStandard" set KEY=%WS2019_STD%
if "%EDITION%"=="Professional" set KEY=%W10_PRO%
if "%EDITION%"=="Enterprise" set KEY=%W10_ENT%

if "%KEY%"=="" (
    color 0C
    echo   Unsupported Windows edition.
    pause
    goto MENU
)

:: ---- TEMP PROCESSING (WILL DISAPPEAR)
call :status_tmp "Processing Windows activation..."
timeout /t 2 >nul
call :status_clear

:: ---- ACTIVATE
cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT% >nul
cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY% >nul
cscript //nologo %windir%\system32\slmgr.vbs /ato >nul

:: ---- RESULT
set STATUS=
for /f "tokens=*" %%A in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr ^| find "expire"') do set STATUS=%%A

echo.
if defined STATUS (
    color 0A
    call :print "Activation Status" "[Successful]"
    call :print "Expiration Date" "%STATUS:~32%"
) else (
    color 0C
    call :print "Activation Status" "[Failed]"
)

echo.
pause
goto MENU
