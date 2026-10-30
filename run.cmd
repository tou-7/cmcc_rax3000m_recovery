@echo off


echo 1.有线网卡连接路由器lan口
echo 2..断电,按住路由器的reset,再通电,等待5,6秒放手(rax3000m 或 me 指示灯变蓝色)
echo 3. 右键管理员运行 run.cmd 脚本 (tftpd64运行是,防火墙会提示,请允许放行)
echo (手动请参考:https://www.right.com.cn/forum/thread-8487191-1-1.html)
echo 4.等待edge浏览器自动打开恢复系统
echo 5.登录系统(没密码)!
echo 6.在luci 管理, 系统->备份与更新->更新固件(点击刷写固件按钮)
echo 7.写入对应固件,恢复完成!

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

