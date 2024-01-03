@echo off
setlocal enabledelayedexpansion

echo Checking Dependancies...

:: Winget Check
:wingetcheck
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
set "repo_owner=Berkkenz"
set "repo_name=Berkkenz-Modpack"
set "file_path=BerkkenzModpack/1.0.txt"
set "github_token=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"

set "api_url=https://api.github.com/repos/%repo_owner%/%repo_name%/contents/%file_path%"

curl -H "Authorization: token %github_token%" -s %api_url% > response.json

set "content="
for /f "tokens=* delims=" %%a in ('type response.json ^| jq -r ".content"') do set "content=%%a"

if "%content%" neq "null" (
   echo File exists in the repository.
   pause
) else (
   echo File does not exist in the repository.
   pause
   goto :versiondownload
)

del response.json
goto :exit

:versiondownload
if not exist "%userprofile%\Desktop\BerkkenzModpack" (
    echo Cloning repository...
    git clone "https://github.com/Berkkenz/Berkkenz-Modpack.git" "%userprofile%\Desktop\BerkkenzModpack"
) else (
    echo Updating repository...
    cd "%userprofile%\Desktop\BerkkenzModpack"
    git pull origin master  REM or replace 'master' with the branch you want to pull
)

:exit
endlocal