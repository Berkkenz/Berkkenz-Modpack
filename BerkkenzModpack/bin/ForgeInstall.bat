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
echo Installing Forge...
java -jar forge-1.19.2-43.3.5-installer.jar /s
cls
if %errorlevel% neq 0 (
	echo Failed to Install Forge.
	pause
	exit /b %errorlevel%
)

echo Forge Installed Successfully!
timeout /nobreak 3
exit /b 0