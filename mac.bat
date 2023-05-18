@echo off
:: BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

color 17
mode con cols=95 lines=10
echo 取得目前網路介面.../Catching net interface...
powershell.exe -nologo -noprofile -noninteractive -command "get-netadapter | select Name"
set /p netname=請輸入你欲設定的網路介面名稱：
:Start
cls
echo 設定%netname%中
SET choice=
echo 1. 取得MAC/Geting MAC
echo 2. 設定學校網路/Setting fixed IP
echo 3. 重新設定(刪除之前設定檔)/Reset(delete config file in PC)
echo 4. DHCP
echo 9. 離開程式(EXIT)
choice /C:12349 /N /M ">Enter Your Choice in the Keyboard [1,2,3,4,9] : "

if errorlevel  9 goto:Exit
if errorlevel  4 goto:C4
if errorlevel  3 goto:C3
if errorlevel  2 goto:C2
if errorlevel  1 goto:C1

echo 輸入錯誤選項/Wrong choose 
Goto Start 
:Exit
exit
:C1
echo 抓取MAC中.../Catching MAC...
powershell.exe -nologo -noprofile -noninteractive -command "get-netadapter | select Name, MacAddress |sls %netname%"; powershell.exe -nologo -noprofile -command "Read-Host "按確定後繼續""
Goto Start 
exit
:C2
IF EXIST "C:\!KnetlogK!.txt" (
attrib C:\!KnetlogK!.txt -a -s -h -r 
powershell.exe -nologo -noprofile -noninteractive -command "ren C:\!KnetlogK!.txt C:\!KnetlogK!.bat"
call C:\!KnetlogK!.bat
powershell.exe -nologo -noprofile -noninteractive -command "ren C:\!KnetlogK!.bat C:\!KnetlogK!.txt"
attrib C:\!KnetlogK!.txt +a +s +h +r 
echo 設定完成/Setting done
) ELSE (
goto :SET
)
exit

:C3
echo 將刪除設定檔.../Delete config...
del C:\!KnetlogK!.txt
goto start


:SET
set /p ipstatic=請輸入學校指定IP：/fixed IP
set /p Netmask=請輸入學校指定子網路遮罩：/Submask
set /p Gateway=請輸入學校指定通訊閘：/Gateway
set /p dns=請輸入學校指定DNS：
set /p dns2=若知道請輸入DNS2：
if '%dns2%' == '' (
netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1
netsh interface ip set dns "%netname%" static %dns%
) else (
goto :DNS2
)
echo 設定完成/Setting finish
echo Y
echo N
set /p choie=是否儲存設定?/Save?
if '%choie%' =='Y' goto :Y
exit
:DNS2
echo seting dns2
netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1
netsh interface ip set dns "%netname%" static %dns%
netsh interface ip add dns "%netname%" %dns2%
echo 設定完成
echo Y
echo N
set /p choie=是否儲存設定?/Save?
if '%choie%' =='Y' (
echo saving data...
echo netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1 > C:\!KnetlogK!.txt
echo netsh interface ip set dns "%netname%" static %dns% >> C:\!KnetlogK!.txt
echo netsh interface ip add dns "%netname%" %dns2% >> C:\!KnetlogK!.txt
attrib C:\!KnetlogK!.txt +a +s +h +r 
echo 完成/Finished!
pause
) else (
echo goodbye
)
exit

:Y
echo Saving Data1...
echo netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1 > C:\!KnetlogK!.txt
echo netsh interface ip set dns "%netname%" static %dns% >> C:\!KnetlogK!.txt
attrib C:\!KnetlogK!.txt +a +s +h +r 
echo 完成/Finished!
pause
exit

:C4
echo
netsh interface ip set address "%netname%" source=dhcp
netsh interface ip set dnsservers name="%netname%" source=dhcp
pause
exit


