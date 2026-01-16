@echo off
setlocal EnableDelayedExpansion
title Windows Activation (KMS)

:: ==================================================
:: =============== KMS CONFIG =======================
:: ==================================================
:: SỬA 2 DÒNG DƯỚI CHO ĐÚNG KMS CỦA BẠN
set KMS_HOST=kms.digiboy.ir
set KMS_PORT=1688
:: ==================================================

:: ==================================================
:: ========== KMS CLIENT KEYS (GVLK) ================
:: ==================================================
:: Windows Client
set WIN10_PRO_KMS=W269N-WFGWX-YVC9B-4J6C9-T83GX
set WIN11_PRO_KMS=W269N-WFGWX-YVC9B-4J6C9-T83GX

:: Windows Server
set WS2019_DC_KMS=WX4NM-KYWYW-QJJR4-XV3QB-6VM33
set WS2022_DC_KMS=WX4NM-KYWYW-QJJR4-XV3QB-6VM33

:: ==================================================
:: ============== MENU ===============================
:: ==================================================
:MENU
cls
echo =====================================
echo     Windows Activation (KMS)
echo =====================================
echo KMS Server : %KMS_HOST%:%KMS_PORT%
echo -------------------------------------
echo 1. Check activation status
echo 2. Activate Windows
echo 3. Exit
echo.
set /p CHOICE=Choose: 

if "%CHOICE%"=="1" goto CHECK
if "%CHOICE%"=="2" goto ACTIVATE
if "%CHOICE%"=="3" exit /b
goto MENU

:: ==================================================
:: ============== CHECK STATUS ======================
:: ==================================================
:CHECK
cls
echo Checking activation status...
echo.
cscript //nologo %windir%\system32\slmgr.vbs /xpr
echo.
pause
goto MENU

:: ==================================================
:: ============== ACTIVATE ==========================
:: ==================================================
:ACTIVATE
cls
echo Detecting Windows version...
echo.

:: Detect EditionID
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B

echo Detected OS:
echo   %PRODUCT%
echo   EditionID: %EDITION%
echo.

:: Select correct GVLK
set KEY=

if "%EDITION%"=="Professional" set KEY=%WIN10_PRO_KMS%
if "%EDITION%"=="ProfessionalWorkstation" set KEY=%WIN10_PRO_KMS%

if "%EDITION%"=="ServerDatacenter" (
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_DC_KMS%
    echo %PRODUCT% | find "2022" >nul && set KEY=%WS2022_DC_KMS%
)

if "%KEY%"=="" (
    echo ❌ Unsupported Windows edition
    echo.
    pause
    goto MENU
)

:: Configure KMS
echo Setting KMS server...
echo   %KMS_HOST%:%KMS_PORT%
cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT% >nul

:: Install key
echo Installing KMS client key...
cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY% >nul

:: Activate
echo Activating Windows...
cscript //nologo %windir%\system32\slmgr.vbs /ato >nul

:: Check result
echo.
echo Activation result:
for /f "delims=" %%S in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr') do set STATUS=%%S
echo %STATUS%
echo.

echo %STATUS% | find "activated" >nul
if %errorlevel%==0 (
    echo ✅ ACTIVATION SUCCESS
) else (
    echo ❌ ACTIVATION FAILED
    echo.
    echo Possible reasons:
    echo - KMS server unreachable
    echo - Wrong edition key
    echo - No valid Volume License
)

echo.
pause
goto MENU
