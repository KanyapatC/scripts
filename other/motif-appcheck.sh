echo "===================== Operating System ID =======================" 
         systeminfo | findstr /C:"OS" /C:"OS Version" > sysinfo.txt 2>&1