@echo off
set "logFile=C:\Users\%Username%\Desktop\BerkkenzModpack\update_log.txt"
echo Starting Updater... >> "%logFile%"
echo Starting Updater...
if not exist "C:\Users\Berkken\Documents\GitHub\Berkkenz-Modpack\BerkkenzModpack\bin\ID(1.0).txt" (
	echo Starting Update... >> "%logFile%"
	echo Starting Update...
	cd "C:\Users\Berkken\Desktop\BerkkenzModpack"
	git pull origin master
) else (
	echo Up to date! >> "%logFile%"
	echo Up to date!
	exit