@echo off
setlocal enabledelayedexpansion
set "callerPath=%~1"
cd /d %callerPath%

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
cls
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
powershell -command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Berkkenz/Berkkenz-Modpack/main/BerkkenzModpack/1.0.txt', 'response.txt')"
if exist response.txt (
	set "updated=true"
	cls
    echo You Are Up-To-Date!
	timeout 3 /nobreak
	exit /b 0
) else (
	cls
    echo Starting Update for Berkkenz Modpack...
	timeout 3 /nobreak
	goto :versiondownload
	pause
)

:versiondownload
cd /d %~dp0..\..
echo %cd%
if not exist "%~dp0.git" (
    git init
    git remote add origin https://github.com/Berkkenz/Berkkenz-Modpack.git
)

cls
git fetch origin
if %errorlevel% neq 0 (
	echo Error: Git Fetch Failed.
	exit /b 1
)

cls
git reset --hard origin/main
if %errorlevel% neq 0 (
	echo Error: Git Reset Failed.
	exit /b 2
)

cls	
for /d /r %%d in (*) do (
    if exist "%%d\.git" (
        echo Updating "%%d"...
        pushd "%%d.."
        git fetch origin
        if %errorlevel% neq 0 (
            echo Error: Git fetch failed in subdirectory "%%d"
            pause
            exit /b %errorlevel%
        )
        git reset --hard origin/main
        if %errorlevel% neq 0 (
            echo Error: Git reset failed in subdirectory "%%d"
            pause
            exit /b %errorlevel%
        )
        popd
    )
)

set "updated=true"
echo Update Installed!
timeout /nobreak 3

:exit
endlocal