@echo off

setlocal EnableDelayedExpansion

set ProxyKey="HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set ProxyValue=ProxyEnable
set ProxyData=0

@REM Find current settings for Manual Proxy Setup.
for /f "tokens=2*" %%a in ('reg query %ProxyKey% /v %ProxyValue% ^| findstr /i %ProxyValue%') do set proxy=%%b

if %proxy%==0x1 (
    echo Proxy is ON.
    set ProxyData=0
) else (
    echo Proxy is OFF.
    set ProxyData=1
)

echo Switching ...

@REM Replace current registry settings with the opposite value.
@REM Set ON if it's currently OFF and vice versa.
reg add %ProxyKey% /v %ProxyValue% /t REG_DWORD /d %ProxyData% /f

@REM Confirm successful switch.
for /f "tokens=2*" %%a in ('reg query %ProxyKey% /v %ProxyValue% ^| findstr /i %ProxyValue%') do set proxy=%%b

if %proxy%==0x1 (
    echo Proxy is now ON.
) else (
    echo Proxy is now OFF.
)

pause