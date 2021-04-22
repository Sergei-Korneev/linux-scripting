@echo off
setlocal enabledelayedexpansion
REM cygwin rsync daemon autoconfig for windows
REM Sergei Korneev 2021

set rsyncconfig=%systemdrive%\cygwin64\etc\rsyncd.conf
set cygpath=%systemdrive%\cygwin64

echo pid file = /var/run/rsyncd.pid >!rsyncconfig!
echo lock file = /var/run/rsync.lock>>!rsyncconfig!
echo log file = /var/log/rsync.log>>!rsyncconfig!
echo port = 12000>>!rsyncconfig!
echo.  >>!rsyncconfig!
set  comment=   
for /f "tokens=1 delims=:" %%a in ('wmic logicaldisk get name') do (

  if NOT "%%~a_" == " _"  IF EXIST "%%~a:\rsync.marker" (
  
  set /p comment= < "%%~a:\rsync.marker"
  
 
  echo Found config on %%~a  comment: !comment!
  echo [cygdrive_%%~a]>>!rsyncconfig!
  echo path =  /cygdrive/%%~a/>>!rsyncconfig!
  echo comment = Drive %%~a on %computername% comment: !comment!>>!rsyncconfig!
  echo read only = false>>!rsyncconfig!
  echo timeout = 300  >>!rsyncconfig!
  echo.  >>!rsyncconfig!
  set  comment=   

  
) ELSE (
  REM
)
  
  
)


taskkill /f /im rsync.exe 
%cygpath%\bin\bash.exe -l -c "rsync --daemon" 
::pause 
