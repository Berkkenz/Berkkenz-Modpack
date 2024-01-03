@echo off
set logFile=%~dp0\log.txt
echo %DATE% %TIME% Script started. >> "%logFile%"

call "%~dp0\bin\updateMAIN.bat"

echo Starting Berkkenz Modpack Installation.
timeout 4
cls
REM Minecraft Check
if exist "C:\Users\%Username%\AppData\Roaming\.minecraft" (
    goto :JavaCheck
) else (
    goto :NoMC
)

:JavaCheck
cls
if exist "%ProgramFiles%\Java\jre-1.8\bin\java.exe" (
    goto :JavaCheckTwo
) else (
    goto :JavaInstallOne
)

:JavaCheckTwo
if exist "%ProgramFiles%\Java\jdk-17\bin\java.exe" (
    goto :VersionCheck
) else (
    goto :JavaInstallTwo
)

:VersionCheck
if exist "%Appdata%\.minecraft\versions\1.19.2" (
	goto :ForgeCheck
) else (
	goto :VersionDL
)

:ForgeCheck
if exist "%Appdata%\.minecraft\versions\1.19.2-forge-43.3.5" (
	goto :Installation
) else (
	goto :ForgeInstall
)

:JavaInstallOne
cls
echo Starting Java Runtime 1.8 Download...
start /WAIT %~dp0\bin\jre-8u391-windows-x64.exe /s
if errorlevel 1 (
	echo Failed to Install Java 1.8.
	pause
	goto :exit
) else (
	echo Java 1.8 Installed Successfully!
	timeout 2
	goto :JavaCheck

:JavaInstallTwo
cls
echo Starting Java 17.0.9 Download...
set "url=https://download.oracle.com/java/17/archive/jdk-17.0.9_windows-x64_bin.exe"
set "installer=%userprofile%\Downloads\jdk-17.0.9_windows-x64_bin.exe"
echo Downloading Java 17.0.9...
bitsadmin /transfer "Downloading Java Runtime 17.0.9" %url% %installer%
echo Installing Java 17.0.9
start /WAIT %userprofile%\Downloads\jdk-17.0.9_windows-x64_bin.exe /s >> %logFile%
del %installer% /s
if errorlevel 1 (
	echo Failed to Install Java 17.0.9.
	pause
	goto :exit
) else (
	echo Java 17.0.9 Installed Successfully!
	timeout 2
	goto :JavaCheck

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
java -jar %~dp0\bin\forge-1.19.2-43.3.5-installer.jar /s
cls
if errorlevel 1 (
	echo Failed to Install Forge.
	pause
	goto :exit
) else (
	echo Forge Installed Successfully!
	timeout 2
	goto :JavaCheck

:Installation
cls
echo Installing Mods and Configs...
echo Deleting Old "mods" Folder in ".minecraft"
DEL "%AppData%\.minecraft\mods" /Q >> "%logFile%"
echo Deleted "mods" Folder in ".minecraft"
echo Deleting Old "config" Folder in ".minecraft"
DEL "%AppData%\.minecraft\config" /Q >> "%logFile%"
echo Deleted "config" Folder in ".minecraft"
echo Deleting Old "resourcepacks" Folder in ".minecraft"
DEL "%AppData%\.minecraft\resourcepacks" /Q >> "%logFile%"
echo Deleted "resourcepacks" Folder in ".minecraft"
echo Deleting Old "shaderpacks" Folder in ".minecraft"
DEL "%AppData%\.minecraft\shaderpacks" /Q >> "%logFile%"
echo Deleted "shaderpacks" Folder in ".minecraft"
echo Copying Mods to ".minecraft"
COPY "%~dp0\mods" "%AppData%\.minecraft\mods" >> "%logFile%"
echo Copied Mods to ".minecraft"
echo Copying Configs to ".minecraft"
COPY "%~dp0\config" "%AppData%\.minecraft\config" >> "%logFile%"
echo Copied Configs to ".minecraft"
echo Copying Resourcepacks to ".minecraft"
COPY "%~dp0\resourcepacks" "%AppData%\.minecraft\resourcepacks" >> "%logFile%"
echo Copied Resourcepacks to ".minecraft"
echo Copying Shaderpacks to ".minecraft"
COPY "%~dp0\shaderpacks" "%AppData%\.minecraft\shaderpacks"
echo Copied Shaderpacks to ".minecraft"
echo %DATE% %TIME% Mods, Configs and Resourcepacks Installed. >> "%logFile%"
echo Mods and Configs Installed!
echo Now Exiting...
timeout 3
goto :exit

:NoMC
echo Minecraft Not Installed On C: Drive, Contact The Berkken Mans. (unless you know where the files should be)
pause
goto :exit

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
echo %DATE% %TIME% Script completed successfully. >> "%logFile%"
exit