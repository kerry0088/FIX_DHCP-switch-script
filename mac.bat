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
echo ���o�ثe��������.../Catching net interface...
powershell.exe -nologo -noprofile -noninteractive -command "get-netadapter | select Name"
set /p netname=�п�J�A���]�w�����������W�١G
:Start
cls
echo �]�w%netname%��
SET choice=
echo 1. ���oMAC/Geting MAC
echo 2. �]�w�Ǯպ���/Setting fixed IP
echo 3. ���s�]�w(�R�����e�]�w��)/Reset(delete config file in PC)
echo 4. DHCP
echo 9. ���}�{��(EXIT)
choice /C:12349 /N /M ">Enter Your Choice in the Keyboard [1,2,3,4,9] : "

if errorlevel  9 goto:Exit
if errorlevel  4 goto:C4
if errorlevel  3 goto:C3
if errorlevel  2 goto:C2
if errorlevel  1 goto:C1

echo ��J���~�ﶵ/Wrong choose 
Goto Start 
:Exit
exit
:C1
echo ���MAC��.../Catching MAC...
powershell.exe -nologo -noprofile -noninteractive -command "get-netadapter | select Name, MacAddress |sls %netname%"; powershell.exe -nologo -noprofile -command "Read-Host "���T�w���~��""
Goto Start 
exit
:C2
IF EXIST "C:\!KnetlogK!.txt" (
attrib C:\!KnetlogK!.txt -a -s -h -r 
powershell.exe -nologo -noprofile -noninteractive -command "ren C:\!KnetlogK!.txt C:\!KnetlogK!.bat"
call C:\!KnetlogK!.bat
powershell.exe -nologo -noprofile -noninteractive -command "ren C:\!KnetlogK!.bat C:\!KnetlogK!.txt"
attrib C:\!KnetlogK!.txt +a +s +h +r 
echo �]�w����/Setting done
) ELSE (
goto :SET
)
exit

:C3
echo �N�R���]�w��.../Delete config...
del C:\!KnetlogK!.txt
goto start


:SET
set /p ipstatic=�п�J�Ǯի��wIP�G/fixed IP
set /p Netmask=�п�J�Ǯի��w�l�����B�n�G/Submask
set /p Gateway=�п�J�Ǯի��w�q�T�h�G/Gateway
set /p dns=�п�J�Ǯի��wDNS�G
set /p dns2=�Y���D�п�JDNS2�G
if '%dns2%' == '' (
netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1
netsh interface ip set dns "%netname%" static %dns%
) else (
goto :DNS2
)
echo �]�w����/Setting finish
echo Y
echo N
set /p choie=�O�_�x�s�]�w?/Save?
if '%choie%' =='Y' goto :Y
exit
:DNS2
echo seting dns2
netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1
netsh interface ip set dns "%netname%" static %dns%
netsh interface ip add dns "%netname%" %dns2%
echo �]�w����
echo Y
echo N
set /p choie=�O�_�x�s�]�w?/Save?
if '%choie%' =='Y' (
echo saving data...
echo netsh interface ip set address "%netname%" static %ipstatic% %Netmask% %Gateway% 1 > C:\!KnetlogK!.txt
echo netsh interface ip set dns "%netname%" static %dns% >> C:\!KnetlogK!.txt
echo netsh interface ip add dns "%netname%" %dns2% >> C:\!KnetlogK!.txt
attrib C:\!KnetlogK!.txt +a +s +h +r 
echo ����/Finished!
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
echo ����/Finished!
pause
exit

:C4
echo
netsh interface ip set address "%netname%" source=dhcp
netsh interface ip set dnsservers name="%netname%" source=dhcp
pause
exit


