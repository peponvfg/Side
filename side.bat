@echo off
title @Side - Panel Real
echo Abriendo @Side con datos reales...
echo NO cierres esta ventana
powershell -ExecutionPolicy Bypass -NoProfile -Command "iwr https://raw.githubusercontent.com/peponvfg/Side/main/side-server.ps1 -OutFile %TEMP%\side-server.ps1; powershell -ExecutionPolicy Bypass -File %TEMP%\side-server.ps1"
pause
