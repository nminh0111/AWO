@echo off
setlocal EnableDelayedExpansion
title Windows Activation (KMS)

:: ===============================
:: KMS CONFIG
:: ===============================
set KMS_HOST=KMS_DIGIBOY.IR
set KMS_PORT=1688

:: ===============================
:: COLORS
:: ===============================
set COL_OK=0A
set COL_ERR=0C
set COL_INFO=0B
set COL_WARN=0E
set COL_DEF=07

:: ===============================
:: UI FUNCTIONS
:: ===============================
:line
echo ------------------------------------------------------------
exit /b

:title
color 0A
call :line
echo   %~1
call :line
color %COL_DEF%
exit /b

:row
:: %1 = label | %2 = value | %3 = state
set "LABEL=%~1"
set "VALUE=%~2"
set "STATE=%~3"
set "PAD=........................................"
set "OUT=%LABEL%%PAD%"
set "OUT=%OUT:~0,36%"

if "%STATE%"=="OK" color %COL_OK%
if "%STATE%"=="FAIL" color %COL_ERR%
if "%STATE%"=="INFO" color %COL_INFO%

echo %OUT%: %VALUE% [%STATE%]
color %COL_DEF%
exit /b

:loading
<nul set /p =%~1
for %%A in (1 2 3) do (
    <nul set /p =.
    timeout /t 1 >nul
)
echo.
exit /b

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
set WS2012R2_DC=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set WS2012R2_STD=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set WS2012R2_ESS=KNC87-3J2TX-XB4WP-VCPJV-M4FWM

:: Windows 10
set W10_PRO=W269N-WFGWX-YVC9B-4J6C9-T83GX
set W10_PRON=MH37W-N47XK-V7XM9-C7227-GCQG9
set W10_ENT=NPPR9-FWDCX-D2C8J-H872K-2YT43
set W10_ENTN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4

:: ===============================
:: MENU
:: ===============================
:MENU
cls
color 0A
call :title "WINDOWS ACTIVATION (KMS)"
echo.
echo   1. Check OS & activation status
echo   2. Activate Windows
echo   3. Exit
echo.
set /p CHOICE=   Choose an option: 

if "%CHOICE%"=="1" goto CHECK
if "%CHOICE%"=="2" goto ACTIVATE
if "%CHOICE%"=="3" exit /b
goto MENU

:: ===============================
:: CHECK STATUS
:: ===============================
:CHECK
cls
call :title "SYSTEM INFORMATION"

for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber ^| find "CurrentBuildNumber"') do set BUILD=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B

call :row "Operating System" "%PRODUCT%" INFO
call :row "Edition" "%EDITION%" INFO
call :row "Build" "%BUILD%" INFO
call :row "Architecture" "%PROCESSOR_ARCHITECTURE%" INFO

echo.
call :line
echo   Activation Status
call :line
cscript //nologo %windir%\system32\slmgr.vbs /xpr

echo.
echo   Press any key to go back...
pause >nul
goto MENU

:: ===============================
:: ACTIVATE
:: ===============================
:ACTIVATE
cls
call :title "WINDOWS KMS ACTIVATION"

for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B

call :row "Detected OS" "%PRODUCT%" INFO
call :row "Edition" "%EDITION%" INFO
echo.

set KEY=

if "%EDITION%"=="ServerDatacenter" (
    echo %PRODUCT% | find "2022" >nul && set KEY=%WS2022_DC%
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_DC%
    echo %PRODUCT% | find "2016" >nul && set KEY=%WS2016_DC%
    echo %PRODUCT% | find "2012 R2" >nul && set KEY=%WS2012R2_DC%
)

if "%EDITION%"=="ServerStandard" (
    echo %PRODUCT% | find "2022" >nul && set KEY=%WS2022_STD%
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_STD%
    echo %PRODUCT% | find "2016" >nul && set KEY=%WS2016_STD%
    echo %PRODUCT% | find "2012 R2" >nul && set KEY=%WS2012R2_STD%
)

if "%EDITION%"=="ServerEssentials" (
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_ESS%
    echo %PRODUCT% | find "2016" >nul && set KEY=%WS2016_ESS%
    echo %PRODUCT% | find "2012 R2" >nul && set KEY=%WS2012R2_ESS%
)

if "%EDITION%"=="Professional" set KEY=%W10_PRO%
if "%EDITION%"=="ProfessionalN" set KEY=%W10_PRON%
if "%EDITION%"=="Enterprise" set KEY=%W10_ENT%
if "%EDITION%"=="EnterpriseN" set KEY=%W10_ENTN%

if "%KEY%"=="" (
    call :row "Activation" "Unsupported Windows edition" FAIL
    pause
    goto MENU
)

call :loading "Processing Windows"

cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT% >nul
call :row "KMS Server" "%KMS_HOST%:%KMS_PORT%" OK

cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY% >nul
call :row "Installing GVLK" "%KEY%" OK

cscript //nologo %windir%\system32\slmgr.vbs /ato >nul

for /f "delims=" %%S in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr') do set STATUS=%%S

echo.
call :line
echo   ACTIVATION RESULT
call :line
echo   %STATUS%

echo %STATUS% | find "expire" >nul
if %errorlevel%==0 (
    color 0A
    echo   Windows is successfully activated.
) else (
    color 0C
    echo   Windows activation failed.
)

color %COL_DEF%
echo.
echo   Press any key to go back...
pause >nul
goto MENU
