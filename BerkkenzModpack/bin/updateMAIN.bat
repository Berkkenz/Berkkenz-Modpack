@echo off
setlocal enabledelayedexpansion

echo Checking Dependancies...

:: Winget Check
:wingetcheck
cls
echo WingetCheck
if not exist "%LocalAppData%\Microsoft\WindowsApps\winget.exe" (
	start /wait "%~dp0\bin\wingetinstaller.ps1"
	echo Winget Installed Successfully!
	goto :wingetcheck
) else (
	goto :gitcheck
)

:: Git Dependancies Check
:gitcheck
echo Git Check
if not exist "%ProgramFiles%\Git\bin\git.exe" (
	goto :gitinstall
) else (
	goto :jqcheck
)

:: JQ Plugin Check
:jqcheck
echo JQ Check
if not exist "%LocalAppData%\Microsoft\WinGet\Links\jq.exe" (
	goto :jqinstall
) else (
	goto :versioncheck
)

:gitinstall
echo Downloading Git Installer...
curl -L -o %userprofile%\Downloads\Git-2.43.0-64-bit.exe https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe
echo Installing Git...
start /wait %userprofile%\Downloads\Git-2.43.0-64-bit.exe /VERYSILENT /NORESTART /NOCANCEL /SP-
echo Cleaning up...
del %userprofile%\Downloads\Git-2.43.0-64-bit.exe /s
if errorlevel 1 (
    echo Failed to install Git.
    pause
    goto :exit
) else (
    echo Git installed successfully.
    goto :wingetcheck
)

:jqinstall
echo Downloading JQ Plugin...
winget install jqlang.jq
if errorlevel 1 (
    echo Failed to install JQ Plugin.
    pause
    goto :exit
) else (
    echo JQ Plugin Installed Successfully.
    goto :wingetcheck
)

:versioncheck
echo Version Check
curl -s -o response.json https://raw.githubusercontent.com/Berkkenz/Berkkenz-Modpack/main/BerkkenzModpack/1.0.txt
if exist response.json (
    set "file_exists=true"
) else (
    set "file_exists=false"
)

if %file_exists%==true (
    echo You Are Up-To-Date!
	timeout 4 /nobreak
	goto :exit
) else (
    echo Starting Update for Berkkenz Modpack...
	timeout 4 /nobreak
	goto :versiondownload
	pause
)

:versiondownload
del response.json
if not exist "C:\Users\%username%\Desktop\BerkkenzModpack" (
    echo Cloning repository...
    git clone "https://github.com/Berkkenz/Berkkenz-Modpack.git" "C:\Users\%username%\Desktop\BerkkenzModpack"
) else (
    echo Updating repository...
    cd "C:\Users\%username%\Desktop\BerkkenzModpack"
    git pull origin main  REM or replace 'master' with the branch you want to pull
)

msg * "Files Are Updated, Restarting Installer...
timeout /nobreak 5

:exit
endlocal