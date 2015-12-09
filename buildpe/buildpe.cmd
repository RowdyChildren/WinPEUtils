@echo off

REM ----- Important Paths ------

set DISM="C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\DISM\dism.exe"
set ORIGPE="C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\en-us\winpe.wim"
set MOUNTDIR="%TEMP%\wimmountdir"
set PACKAGES="C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs"
set STARTNET="T:\deployment\Windows\Tools\startnet.cmd"
set PXEDIR="T:\deployment\PXE\boot"

REM ----------------------------

REM Get a copy of the PE, mount it

echo Copying original PE WIM...
echo.
copy %ORIGPE% %TEMP%
echo.
echo Mounting copied WIM to temporary mountpoint...

if not exist %MOUNTDIR% mkdir %MOUNTDIR%
%DISM% /mount-wim /wimfile:%TEMP%\winpe.wim /mountdir:%MOUNTDIR% /index:1

REM Install WMI stuff

echo Installing WMI packages...

%DISM% /image:%MOUNTDIR% /add-package /packagepath:%PACKAGES%\winpe-scripting.cab
%DISM% /image:%MOUNTDIR% /add-package /packagepath:%PACKAGES%\en-us\winpe-scripting_en-us.cab
%DISM% /image:%MOUNTDIR% /add-package /packagepath:%PACKAGES%\winpe-wmi.cab
%DISM% /image:%MOUNTDIR% /add-package /packagepath:%PACKAGES%\en-us\winpe-wmi_en-us.cab

echo Copying startup script...
echo.
copy /y %STARTNET% %MOUNTDIR%\Windows\System32

REM ----- Cleanup -----

%DISM% /unmount-wim /mountdir:%MOUNTDIR% /commit
move /y %PXEDIR%\ghost.wim %PXEDIR%\ghost.wim.old
move /y %TEMP%\winpe.wim %PXEDIR%\ghost.wim
rmdir /s /q %MOUNTDIR%
echo.
echo All done.
echo.