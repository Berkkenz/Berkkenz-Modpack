@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    goto :UACPrompt
) else (
    goto :gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
cls
echo Starting Java 17.0.9 Download...
set "url=https://download.oracle.com/java/17/archive/jdk-17.0.9_windows-x64_bin.exe"
set "installer=%userprofile%\Downloads\jdk-17.0.9_windows-x64_bin.exe"

echo Downloading Java 17.0.9...
bitsadmin /transfer "Downloading Java Runtime 17.0.9" %url% %installer%
if %errorlevel% neq 0 (
	echo Error: Java Download Failed.
	pause
	exit /b %errorlevel%
)
echo Installing Java 17.0.9
start /WAIT %userprofile%\Downloads\jdk-17.0.9_windows-x64_bin.exe /s
if %errorlevel% neq 0 (
	echo Error: Java Install Failed.
	pause
	exit /b %errorlevel%
)

echo Cleaning up...
del %installer% /s

echo Java 17.0.9 installation completed.
timeout /nobreak 3
exit /b 0