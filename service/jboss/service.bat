@echo off
REM JBoss, the OpenSource webOS
REM
REM Distributable under LGPL license.
REM See terms of license at gnu.org.
REM
REM -------------------------------------------------------------------------
REM JBoss Service Script for Windows ( Customiosed by Gerry Matte from the version supplied within jboss-native-2.0.9-windows-x64-ssl.zip 
REM -------------------------------------------------------------------------
REM Contains this service.bat file as well as files README-service.txt, jbosssvc.exe, jbossweb.x64.exe, and jbossweb.x64.exe
REM The above files are copied to [JBOSS_HOME]\bin and executed from there.


@if not "%ECHO%" == "" echo %ECHO%
@if "%OS%" == "Windows_NT" setlocal
set DIRNAME=%CD%

REM
REM VERSION, VERSION_MAJOR and VERSION_MINOR are populated
REM during the build with ant filter.
REM(Three lines below were customised bty Gerry Matte)
set SVCNAME=JBOSSEAP72
set SVCDISP=JBoss Enterprise Application Platform 7.2
set SVCDESC=JBoss Enterprise Application 7.2.0Final/Platform: Windows x64
set NOPAUSE=Y

 REM Suppress killing service on logoff event
REM set JAVA_OPTS=-Xrs


REM Figure out the running mode


if /I "%1" == "install"   goto cmdInstall
if /I "%1" == "uninstall" goto cmdUninstall
if /I "%1" == "start"     goto cmdStart
if /I "%1" == "stop"      goto cmdStop
if /I "%1" == "restart"   goto cmdRestart
if /I "%1" == "signal"    goto cmdSignal
echo Usage: service install^|uninstall^|start^|stop^|restart^|signal
goto cmdEnd


REM jbosssvc retun values
REM ERR_RET_USAGE           1
REM ERR_RET_VERSION         2
REM ERR_RET_INSTALL         3
REM ERR_RET_REMOVE          4
REM ERR_RET_PARAMS          5
REM ERR_RET_MODE            6


:errExplain
if errorlevel 1 echo Invalid command line parameters
if errorlevel 2 echo Failed installing %SVCDISP%
if errorlevel 4 echo Failed removing %SVCDISP%
if errorlevel 6 echo Unknown service mode for %SVCDISP%
goto cmdEnd


:cmdInstall
jbosssvc.exe -imwdc %SVCNAME% "%DIRNAME%" "%SVCDISP%" "%SVCDESC%" service.bat
if not errorlevel 0 goto errExplain
echo Service %SVCDISP% installed
goto cmdEnd


:cmdUninstall
jbosssvc.exe -u %SVCNAME%
if not errorlevel 0 goto errExplain
echo Service %SVCDISP% removed
goto cmdEnd


:cmdStart
REM Executed on service start
del .r.lock 2>&1 | findstr /C:"being used" > nul
if not errorlevel 1 (
  echo Could not continue. Locking file already in use.
  goto cmdEnd
)
echo Y > .r.lock
jbosssvc.exe -p 1 "Starting %SVCDISP%" > standalone.log (if your log file is located a particular folder, spell it out. ex.  C:\opt\jboss7\standalone\log\standalone.log)
call standalone.bat --server-config=standalone.xml < .r.lock >> standalone.log 2>&1
jbosssvc.exe -p 1 "Shutdown %SVCDISP% service" >> standalone.log
del .r.lock
goto cmdEnd


:cmdStop
REM Executed on service stop
echo Y > .s.lock
jbosssvc.exe -p 1 "Shutting down %SVCDISP%" > shutdown.log
call jboss-cli.bat --connect command=:shutdown >> shutdown.log 2>&1
jbosssvc.exe -p 1 "Shutdown %SVCDISP% service" >> shutdown.log
del .s.lock
goto cmdEnd


:cmdRestart
REM Executed manually from command line
REM Note: We can only stop and start
echo Y > .s.lock
jbosssvc.exe -p 1 "Shutting down %SVCDISP%" >> shutdown.log
call jboss-cli.bat --connect command=:shutdown >> shutdown.log 2>&1
del .s.lock
:waitRun
REM Delete lock file
del .r.lock > nul 2>&1
REM Wait one second if lock file exist
jbosssvc.exe -s 1
if exist ".r.lock" goto waitRun
echo Y > .r.lock
jbosssvc.exe -p 1 "Restarting %SVCDISP%" >> standalone.log
call standalone.bat --server-config=standalone.xml < .r.lock >> standalone.log 2>&1
jbosssvc.exe -p 1 "Shutdown %SVCDISP% service" >> standalone.log
del .r.lock
goto cmdEnd


:cmdSignal
REM Send signal to the service.
REM Requires jbosssch.dll to be loaded in JVM
@if not ""%2"" == """" goto execSignal
echo Missing signal parameter.
echo Usage: service signal [0...9]
goto cmdEnd
:execSignal
jbosssvc.exe -k%2 %SVCNAME%
goto cmdEnd


:cmdEnd