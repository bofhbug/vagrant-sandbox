call c:\vagrant\shell\solid-desktop.bat
call c:\vagrant\shell\06-set-timezone-berlin.bat
call c:\vagrant\shell\07-set-keyboard-german.bat

echo Turn off windows updates
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\dis-updates.ps1"

echo Ensuring .NET 4.0 is installed
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallNet4.ps1"

echo Ensuring Chocolatey is Installed
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallChocolatey.ps1"

where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%ALLUSERSPROFILE%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst

echo Installing Developer Base
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallDeveloperBase.ps1"
copy /Y "c:\vagrant\shell\winmerge.bat" %ALLUSERSPROFILE%\Chocolatey\bin\winmerge.bat

echo Installing VS2012
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\InstallVS2012.ps1"

set QTVERSION=5.1.1
rem set QTVERSION=5.2.0
if not exist "c:\vagrant\resources\QtCommercial\Qt%QTVERSION%\DistLicenseFile.txt" goto QTDONE
@powershell -NoProfile -ExecutionPolicy Bypass -File "c:\vagrant\shell\Qt5\Set-ShortCut.ps1"

call c:\vagrant\shell\Qt5\install-qt5.bat -schedule %QTVERSION% msvc2012
rem schtasks /Delete /F /TN InstQt5
rem schtasks /Create /SC ONLOGON /TN InstQt5 /TR "c:\vagrant\shell\Qt5\install-qt5.bat %QTVERSION% msvc2012"
rem schtasks /Run /TN InstQt5

:QTDONE
