title %~n0 %1
if "%1x"=="x" goto NO_QT5_VERSION
if "%2x"=="x" goto NO_COMPILER_VERSION
where cinst
if ERRORLEVEL 1 goto set_chocolatey
goto inst
:set_chocolatey
set ChocolateyInstall=%SystemDrive%\Chocolatey
set PATH=%PATH%;%ChocolateyInstall%\bin
:inst
cd /D %ChocolateyInstall%

if exist C:\strawberry goto PERL_INSTALLED
call cinst StrawberryPerl
:PERL_INSTALLED

if exist %USERPROFILE%\.qt-license goto QTLIC_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\DistLicenseFile.txt" goto QTLIC_INSTALLED
echo Licensing Qt5
copy "%~dp0\..\..\resources\QtCommercial\Qt%1\DistLicenseFile.txt" %USERPROFILE%\.qt-license
:QTLIC_INSTALLED

if exist "%ProgramFiles(x86)%\Digia\Qt5VSAddin" goto QT5ADDIN_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-vs-addin-1.2.2.exe" goto QT5ADDIN_INSTALLED
echo Installing Qt5 VS AddIn interactively
"%~dp0\..\..\resources\QtCommercial\Qt%1\qt-vs-addin-1.2.2.exe"
:QT5ADDIN_INSTALLED

if exist c:\Qt\Qt%1 goto QT5_INSTALLED
if not exist "%~dp0\..\..\resources\QtCommercial\Qt%1\qt-enterprise-%1-windows-%2-x86_64-offline.exe" goto QT5_INSTALLED
echo Installing Qt5 MSVC2012 offline
"%~dp0\..\..\resources\QtCommercial\Qt%1\qt-enterprise-%1-windows-%2-x86_64-offline.exe"
:QT5_INSTALLED

if exist %ChocolateyInstall%\bin\7za.bat goto ZIP_INSTALLED
call cinst 7zip.commandline
:ZIP_INSTALLED
if exist %ChocolateyInstall%\bin\jom.bat goto JOM_INSTALLED
call cinst jom
:JOM_INSTALLED

if not exist C:\Qt\Qt%1\%1\Src goto SRC_ZIPPED
if exist C:\Qt\Qt%1\%1\Src.zip goto SRC_ZIPPED
echo Zipping Src for faster rebuild
cd /D C:\Qt\Qt%1\%1
call 7za a Src.zip Src >nul
:SRC_ZIPPED

if exist %ChocolateyInstall%\bin\cmake.bat goto CMAKE_INSTALLED
call cinst cmake
:CMAKE_INSTALLED

echo Starting Qt5 64bit compile in second window
start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 amd64 %2_64_static

echo Starting Qt5 32bit compile in second window
start /WAIT %ComSpec% /C "%~dp0\install-qt5-compile-static.bat" %1 %2 x86 %2_32_static

goto nowait

:NO_QT5_VERSION
echo No Qt5 version given, eg. 5.1.0
goto wait

:NO_COMPILER_VERSION
echo No MSVC compiler version given, eg. msvc2012
goto wait


:wait
time /t
pause
:nowait
