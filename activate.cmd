@echo off
setlocal EnableDelayedExpansion

call "%~dp0keys.cmd"

echo ===============================
echo Windows / Office Activation
echo ===============================

:: ===== Detect Windows =====
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B

echo Detected: %PRODUCT% (%EDITION%)

:: ===== Select key =====
set KEY=

if "%EDITION%"=="Professional" set KEY=%WIN10_PRO_KMS%
if "%EDITION%"=="ServerDatacenter" (
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_DC_KMS%
    echo %PRODUCT% | find "2022" >nul && set KEY=%WS2022_DC_KMS%
)

if "%KEY%"=="" (
    echo ❌ Unsupported Windows edition
    goto END
)

:: ===== Configure KMS =====
echo Configuring KMS server...
cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT% >nul

:: ===== Install key =====
echo Installing key...
cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY% >nul

:: ===== Activate =====
echo Activating...
cscript //nologo %windir%\system32\slmgr.vbs /ato >nul

:: ===== Check result =====
for /f "delims=" %%S in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr') do set STATUS=%%S

echo.
echo Activation result:
echo %STATUS%

echo %STATUS% | find "permanently activated" >nul
if %errorlevel%==0 (
    echo ✅ ACTIVATION SUCCESS
) else (
    echo ❌ ACTIVATION FAILED
    echo 👉 Check:
    echo - KMS server reachable
    echo - Correct edition
    echo - Volume License validity
)

:END
echo.
pause
