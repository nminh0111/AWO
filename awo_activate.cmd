@echo off
setlocal EnableDelayedExpansion
title Windows Activation (KMS)

:: ===============================
:: KMS CONFIG
:: ===============================
set KMS_HOST=kms.digiboy.ir
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
echo ============================================================
echo               WINDOWS ACTIVATION (KMS)
echo ============================================================
echo.
echo   1. Check OS and activation status
echo   2. Activate Windows (KMS)
echo   3. Exit
echo.
echo ------------------------------------------------------------
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
color 0B
echo ============================================================
echo                 SYSTEM INFORMATION
echo ============================================================
echo.

for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber ^| find "CurrentBuildNumber"') do set BUILD=%%B

echo   Operating System : %PRODUCT%
echo   Edition          : %EDITION%
echo   Build            : %BUILD%
echo   Architecture     : %PROCESSOR_ARCHITECTURE%
echo.
echo   Activation Status:
cscript //nologo %windir%\system32\slmgr.vbs /xpr

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

for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B

echo   Detected OS : %PRODUCT%
echo   Edition     : %EDITION%
echo.

set KEY=

:: Windows 10
if "%EDITION%"=="Professional" set KEY=%W10_PRO%
if "%EDITION%"=="ProfessionalN" set KEY=%W10_PRON%
if "%EDITION%"=="Enterprise" set KEY=%W10_ENT%
if "%EDITION%"=="EnterpriseN" set KEY=%W10_ENTN%

:: Windows Server
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

if "%KEY%"=="" (
    echo   Unsupported Windows edition.
    pause
    goto MENU
)

echo   Processing Windows...
timeout /t 2 >nul

cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT%
cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY%
cscript //nologo %windir%\system32\slmgr.vbs /ato

echo.
echo   Activation Result:
cscript //nologo %windir%\system32\slmgr.vbs /xpr

echo.
pause
goto MENU
