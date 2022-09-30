@ECHO OFF
REM  Repair Windows Update Advanced Script
REM  Reset Windows Update components:
REM  https://support.microsoft.com/en-us/kb/971058

REM STEP 1:
REM Stop the BITS service, the Windows Update service, and the Cryptographic service
ECHO "Stop the BITS service, the Windows Update service, and the Cryptographic service ..."
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc

REM STEP 2:
REM Delete the qmgr*.dat files.
ECHO "Delete the qmgr*.dat files ..."
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"


REM If this is your first attempt at resolving your Windows Update issues by following the steps in this article, you should skip step 4 and go to step 5. You should follow step 4 at this point in 

the troubleshooting only if you cannot resolve your Windows Update issues after you follow all steps except step 4. 
REM (Step 4 is performed by the "Aggressive" mode of the Fix it Solution that was mentioned earlier.)

REM STEP 4
REM Rename the softare distribution folders backup copies. 
ECHO "Rename the softare distribution folders backup copies.  ..."
Ren %systemroot%\SoftwareDistribution SoftwareDistribution.bak
Ren %systemroot%\system32\catroot2 catroot2.bak

REM Reset the BITS service and the Windows Update service to the default security descriptor. 
ECHO "Reset the BITS service and the Windows Update service to the default security descriptor ..."
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)

REM STEP 5
REM Re-register the BITS files and the Windows Update files.
ECHO "Re-register the BITS files and the Windows Update files ..."
cd /d %windir%\system32

regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll

REM STEP 6:
REM Reset Winsock.
ECHO "Reset Winsock ..."
netsh winsock reset

REM Reset proxy
ECHO "Reset proxy ..."
netsh winhttp reset proxy

REM STEP 7:
REM Restart the BITS service, the Windows Update service, and the Cryptographic service. 
ECHO "Restart the BITS service, the Windows Update service, and the Cryptographic service ..."
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

REM STEP 8:
REM Install the latest Windows Update Agent
ECHO "Download and Install the latest Windows Update Agent ..."
cd /d %USERPROFILE%\Downloads

REM Check if wget.exe exists
IF EXIST c:\windows\wget.exe GOTO EXISTS
IF NOT EXIST c:\windows\wget.exe ECHO PLEASE DOWNLOAD THE LATEST WINDOWS UPDATE AGENT FROM HERE: https://support.microsoft.com/en-us/kb/3138612 && GOTO ALLDONE

:EXISTS
@echo off
Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry% > checkOS.txt

echo %RegQry%

Find /i "x86" < CheckOS.txt > StringCheck.txt
If %%ERRORLEVEL%% == 0 (
    Echo "This is 32 Bit Operating system"
	wget -nc http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/WindowsUpdateAgent-7.6-x86.exe
	WindowsUpdateAgent-7.6-x86.exe /quiet /norestart /wuforce
	del /y %USERPROFILE%\Downloads\StringCheck.txt
	del /y %USERPROFILE%\Downloads\checkOS.txt
) ELSE (
    Echo "This is 64 Bit Operating System"
	wget -nc http://download.windowsupdate.com/windowsupdate/redist/standalone/7.6.7600.320/WindowsUpdateAgent-7.6-x64.exe
	WindowsUpdateAgent-7.6-x64.exe /quiet /norestart /wuforce
	del /y %USERPROFILE%\Downloads\StringCheck.txt
	del /y %USERPROFILE%\Downloads\checkOS.txt
)
 
:ALLDONE
ECHO "ALL DONE!!!"
ECHO "Please Reboot your system now or install the Update Agent if not downloaded above"
PAUSE

