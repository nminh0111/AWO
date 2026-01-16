@echo off
setlocal EnableDelayedExpansion

echo ===============================
echo Windows Activation (KMS)
echo ===============================

:: ===============================
:: KMS CONFIG (SỬA CHO ĐÚNG)
:: ===============================
set KMS_HOST=YOUR.KMS.SERVER.IP
set KMS_PORT=1688

:: ===============================
:: KMS CLIENT KEYS (GVLK - MICROSOFT PUBLIC)
:: ===============================
:: Windows Client
set WIN10_PRO_KMS=W269N-WFGWX-YVC9B-4J6C9-T83GX
set WIN11_PRO_KMS=W269N-WFGWX-YVC9B-4J6C9-T83GX

:: Windows Server Datacenter
set WS2019_DC_KMS=WX4NM-KYWYW-QJJR4-XV3QB-6VM33
set WS2022_DC_KMS=WX4NM-KYWYW-QJJR4-XV3QB-6VM33

:: ===============================
:: DETECT WINDOWS
:: ===============================
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v EditionID ^| find "EditionID"') do set EDITION=%%B
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName ^| find "ProductName"') do set PRODUCT=%%B

echo Detected OS: %PRODUCT% (%EDITION%)
echo.

:: ===============================
:: SELECT KEY
:: ===============================
set KEY=

if "%EDITION%"=="Professional" set KEY=%WIN10_PRO_KMS%
if "%EDITION%"=="ProfessionalWorkstation" set KEY=%WIN10_PRO_KMS%

if "%EDITION%"=="ServerDatacenter" (
    echo %PRODUCT% | find "2019" >nul && set KEY=%WS2019_DC_KMS%
    echo %PRODUCT% | find "2022" >nul && set KEY=%WS2022_DC_KMS%
)

if "%KEY%"=="" (
    echo ❌ Unsupported Windows edition
    goto END
)

:: ===============================
:: CONFIGURE KMS
:: ===============================
echo Setting KMS server: %KMS_HOST%:%KMS_PORT%
cscript //nologo %windir%\system32\slmgr.vbs /skms %KMS_HOST%:%KMS_PORT% >nul

:: ===============================
:: INSTALL KEY
:: ===============================
echo Installing KMS client key...
cscript //nologo %windir%\system32\slmgr.vbs /ipk %KEY% >nul

:: ===============================
:: ACTIVATE
:: ===============================
echo Activating...
cscript //nologo %windir%\system32\slmgr.vbs /ato >nul

:: ===============================
:: RESULT
:: ===============================
for /f "delims=" %%S in ('cscript //nologo %windir%\system32\slmgr.vbs /xpr') do set STATUS=%%S

echo.
echo Activation status:
echo %STATUS%
echo.

echo %STATUS% | find "activated" >nul
if %errorlevel%==0 (
    echo ✅ ACTIVATION SUCCESS
) else (
    echo ❌ ACTIVATION FAILED
    echo.
    echo Possible reasons:
    echo - KMS server unreachable (ping %KMS_HOST%)
    echo - Wrong edition key
    echo - No valid Volume License
)

:END
echo.
pause
