@echo off
set "logFile=C:\Users\%Username%\Desktop\BerkkenzModpack\script_log.txt"
echo %DATE% %TIME% Script started. >> "%logFile%"

echo Starting Berkkenz Modpack Installation.
timeout 4
cls
if exist "C:\Users\%Username%\AppData\Roaming\.minecraft" (
    goto :DesktopCheck
) else (
    goto :NoMC
)

:DesktopCheck
if exist "C:\Users\%Username%\Desktop\BerkkenzModpack" (
    goto :JavaCheck
) else (
    goto :NoFolder
)

:JavaCheck
cls
if exist "C:\Program Files\Java\jre-1.8\bin\java.exe" (
    goto :JavaCheckTwo
) else (
    goto :JavaInstallOne
)

:JavaCheckTwo
if exist "C:\Program Files\Java\jdk-17\bin\java.exe" (
    goto :VersionCheck
) else (
    goto :JavaInstallTwo
)

:VersionCheck
if exist "C:\Users\%Username%\AppData\Roaming\.minecraft\versions\1.19.2" (
	goto :ForgeCheck
) else (
	goto :VersionDL
)

:ForgeCheck
if exist "C:\Users\%Username%\AppData\Roaming\.minecraft\versions\1.19.2-forge-43.3.5" (
	goto :Installation
) else (
	goto :ForgeInstall
)

:JavaInstallOne
cls
echo Starting Java Runtime 1.8 Download...
start /WAIT C:\Users\Berkken\Desktop\BerkkenzModpack\bin\jre-8u391-windows-x64.exe /s
echo Java 1.8 Installed!
pause
timeout 2
goto :JavaCheck

:JavaInstallTwo
cls
echo Starting Java 17.0.9 Download...
set "url=https://download.oracle.com/java/17/archive/jdk-17.0.9_windows-x64_bin.exe"
set "installer=C:\Users\%username%\Downloads\jdk-17.0.9_windows-x64_bin.exe"
echo Downloading Java 17.0.9...
bitsadmin /transfer "Downloading Java Runtime 17.0.9" %url% %installer%
echo Installing Java 17.0.9
start /WAIT C:\Users\%username%\Downloads\jdk-17.0.9_windows-x64_bin.exe /s >> %logFile%
del %installer% /s
echo Java 17 Installed!
timeout 2
goto :JavaCheck

:VersionDL
cls
xcopy /i /s "C:\Users\%username%\Desktop\BerkkenzModpack\versions" "C:\Users\%username%\AppData\Roaming\.minecraft\versions"
echo Version Installed!
timeout 2
goto :JavaCheck

:ForgeInstall
cls
echo Installing Forge...
java -jar C:\Users\%username%\Desktop\BerkkenzModpack\bin\forge-1.19.2-43.3.5-installer.jar /s
cls
echo Forge Installed!
timeout 2
goto :JavaCheck

:Installation
cls
echo Installing Mods and Configs...
echo Deleting Old "mods" Folder in ".minecraft"
DEL "C:\Users\%username%\AppData\Roaming\.minecraft\mods" /Q >> "%logFile%"
echo Deleted "mods" Folder in ".minecraft"
echo Deleting Old "config" Folder in ".minecraft"
DEL "C:\Users\%username%\AppData\Roaming\.minecraft\config" /Q >> "%logFile%"
echo Deleted "config" Folder in ".minecraft"
echo Deleting Old "resourcepacks" Folder in ".minecraft"
DEL "C:\Users\%username%\AppData\Roaming\.minecraft\resourcepacks" /Q >> "%logFile%"
echo Deleted "resourcepacks" Folder in ".minecraft"
echo Deleting Old "shaderpacks" Folder in ".minecraft"
DEL "E:\CurseForge\Instances\Berkken's Modpack (1)\shaderpacks" /Q >> "%logFile%"
echo Deleted "shaderpacks" Folder in ".minecraft"
echo Copying Mods to ".minecraft"
COPY "C:\Users\%username%\Desktop\BerkkenzModpack\mods" "C:\Users\%username%\AppData\Roaming\.minecraft\mods" >> "%logFile%"
echo Copied Mods to ".minecraft"
echo Copying Configs to ".minecraft"
COPY "C:\Users\%username%\Desktop\BerkkenzModpack\config" "C:\Users\%username%\AppData\Roaming\.minecraft\config" >> "%logFile%"
echo Copied Configs to ".minecraft"
echo Copying Resourcepacks to ".minecraft"
COPY "C:\Users\%username%\Desktop\BerkkenzModpack\resourcepacks" "C:\Users\%username%\AppData\Roaming\.minecraft\resourcepacks" >> "%logFile%"
echo Copied Resourcepacks to ".minecraft"
echo Copying Shaderpacks to ".minecraft"
COPY "C:\Users\%username%\Desktop\BerkkenzModpack\shaderpacks" "C:\Users\%username%\AppData\Roaming\.minecraft\shaderpacks"
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