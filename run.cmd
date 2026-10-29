@echo off

pause

netsh interface ipv4 set address name="以太网" source=static address=192.168.1.254 mask=255.255.255.0 gateway=192.168.1.1

ipconfig /release
ipconfig /renew

cd /d  %~dp0
start tftpd64.exe

:loop
echo 等待刷入恢复系统...

curl http://192.168.1.1 | find "cgi-bin/luci/" >nul 2>&1

if %ERRORLEVEL% equ 0 (
    echo [完成] 成功刷入恢复系统，循环结束！
    goto end
)

timeout /t 3 >nul
goto loop

:end

taskkill /f /im "tftpd64.exe"

netsh interface ipv4 set address name="以太网" source=dhcp
netsh interface ipv4 set dnsservers name="以太网" source=dhcp

ipconfig /release
ipconfig /renew

start msedge http://192.168.1.1

