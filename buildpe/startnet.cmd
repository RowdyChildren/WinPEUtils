@echo off
wpeinit
wpeutil.exe WaitForRemovableStorage
wpeutil.exe UpdateBootInfo

:loop
cls
ipconfig
ping 127.0.0.1 -n 3 >NUL
cls
ipconfig
net use z: \\fileserver.drunkresearch.com\tank
if not exist z:\*.* goto loop

z:
cd \deployment\Windows\Autodeploy
cls
echo Have fun!