:: Robot FTP Backup Script
:: Downloads all .ls program files from FANUC controller
:: Robot IP: 192.168.1.99
:: Credentials: fanuc/fanuc
:: Output folder: C:\robot_backup

echo bin> %TEMP%\ftpcmds.txt
echo prompt>> %TEMP%\ftpcmds.txt
echo lcd C:\robot_backup>> %TEMP%\ftpcmds.txt
echo cd /FR/tp>> %TEMP%\ftpcmds.txt
echo mget *.ls>> %TEMP%\ftpcmds.txt
echo quit>> %TEMP%\ftpcmds.txt

ftp -s:%TEMP%\ftpcmds.txt 192.168.1.99

del %TEMP%\ftpcmds.txt