@echo off
:recheck

if "%updated%==true" (
	goto :start
) else (
	call "%~dp0\bin\updateMAIN.bat"
	goto :recheck
)

:start
cls
echo Starting Berkkenz Modpack Installation.
timeout 4
cls
REM Minecraft Check
if exist "%appdata%\.minecraft" (
	echo Minecraft Exists!
    goto :JavaCheck
) else (
    goto :NoMC
)

:JavaCheck
cls
if exist "%ProgramFiles%\Java\jre-1.8\bin\java.exe" (
	echo Java 1.8 Present!
    goto :JavaCheckTwo
) else (
    goto :JavaInstallOne
)

:JavaCheckTwo
if exist "%ProgramFiles%\Java\jdk-17\bin\java.exe" (
	echo Java 17.0.9 Present!
    goto :VersionCheck
) else (
    goto :JavaInstallTwo
)

:VersionCheck
if exist "%Appdata%\.minecraft\versions\1.19.2" (
	echo Version 1.19.2 Present!
	goto :ForgeCheck
) else (
	goto :VersionDL
)

:ForgeCheck
if exist "%Appdata%\.minecraft\versions\1.19.2-forge-43.3.5" (
	echo Forge 1.19.2 Present!
	goto :Installation
) else (
	goto :ForgeInstall
)

:JavaInstallOne
cls
call %~dp0\bin\JavaInstallTwo.bat
if %errorlevel% neq 0 (
	echo Failed to Install Java 1.8.
	pause
	exit /b %errorlevel%
) else (
	echo Java 1.8 Installed Successfully!
	timeout 2
	goto :JavaCheck
)

:JavaInstallTwo
cls
call %~dp0\bin\JavaInstallOne.bat
if %errorlevel% neq 0 (
	echo Failed to Install Java 17.0.9.
	pause
	exit /b %errorlevel%
) else (
	echo Java 17.0.9 Installed Successfully!
	timeout 2
	goto :JavaCheck
)

:VersionDL
cls
xcopy /i /s "%~dp0\versions" "%AppData%\.minecraft\versions"
if errorlevel 1 (
	echo Failed to Install Version.
	pause
	goto :exit
) else (
	echo Version Installed Successfully!
	timeout 2
	goto :JavaCheck

:ForgeInstall
cls
echo Installing Forge...
call %~dp0\bin\ForgeInstall.bat
if %errorlevel% neq 0 (
	echo Failed to Install Forge.
	pause
	exit /b %errorlevel%
) else (
	echo Forge Installed Successfully!
	timeout 2
	goto :JavaCheck

:Installation
cls
echo Installing Mods and Configs...
echo Deleting Old "mods" Folder in ".minecraft"
DEL "%AppData%\.minecraft\mods" /Q
echo Deleted "mods" Folder in ".minecraft"
echo Deleting Old "config" Folder in ".minecraft"
DEL "%AppData%\.minecraft\config" /Q
echo Deleted "config" Folder in ".minecraft"
echo Deleting Old "resourcepacks" Folder in ".minecraft"
DEL "%AppData%\.minecraft\resourcepacks" /Q
echo Deleted "resourcepacks" Folder in ".minecraft"
echo Deleting Old "shaderpacks" Folder in ".minecraft"
DEL "%AppData%\.minecraft\shaderpacks" /Q
echo Deleted "shaderpacks" Folder in ".minecraft"
echo Copying Mods to ".minecraft"
COPY "%~dp0\mods" "%AppData%\.minecraft\mods"
echo Copied Mods to ".minecraft"
echo Copying Configs to ".minecraft"
COPY "%~dp0\config" "%AppData%\.minecraft\config"
echo Copied Configs to ".minecraft"
echo Copying Resourcepacks to ".minecraft"
COPY "%~dp0\resourcepacks" "%AppData%\.minecraft\resourcepacks"
echo Copied Resourcepacks to ".minecraft"
echo Copying Shaderpacks to ".minecraft"
COPY "%~dp0\shaderpacks" "%AppData%\.minecraft\shaderpacks"
echo Copied Shaderpacks to ".minecraft"
echo %DATE% %TIME% Mods, Configs and Resourcepacks Installed.
echo Mods and Configs Installed!
echo Now Exiting...
timeout 3 /nobreak
goto :exit

:NoMC
echo Minecraft Not Installed On C: Drive, Contact The Berkken Mans. (unless you know where the files should be)
pause
exit /b 1

:NoFolder
echo The "Berkken's Modpack" folder is not on your desktop.
echo 	Please extract the folder in
echo 	
echo 	BerkkenzModpack.zip
echo	
echo 	To your desktop, then run the setup again.
pause
goto :exit

:exit
exit