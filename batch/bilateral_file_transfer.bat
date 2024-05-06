@echo off

:: Can use this script to any windows to invoke pscp.ext to fulfill file transfer feature.
::
:: PSCP (PuTTY Secure Copy Protocol) 
:: is a command-line tool for transferring files and folders from a Windows computer to a Linux computer.

:: set DATESTAMP=%date:~10,4%%date:~4,2%%date:~7,2%
:: set LOGFILE=log_%DATESTAMP%.txt

echo File transferred started! >> file_transfer_log.txt
echo %DATE% %TIME%  >> file_transfer_log.txt

:: Replace with your username and hostname
set USERNAME=<your-user-name>
set HOSTNAME=<your-host-name>
set PASSWORD=<your-password>

:: set WINDOWS_SRC_DIR and WINDOWS_DEST_DIR
set WINDOWS_SRC_DIR="<windows-source-directory>"
set WINDOWS_DEST_DIR="<windows-destination-directory>"

:: set LINUX_SRC_DIR and LINUX_DEST_DIR
set LINUX_SRC_DIR=<linux-source-directory>
set LINUX_DEST_DIR=<linux-destination-directory>

echo login in with: %USERNAME% >> file_transfer_log.txt

:: Clear the destination directory (replace with your preferred method)
:: plink.exe -ssh -pw %PASSWORD% %USERNAME%@%HOSTNAME% "rm -rf %LINUX_DIR%/*"
:: Transfer the file using pscp
echo SRC: %WINDOWS_SRC_DIR% to %LINUX_DEST_DIR% >> file_transfer_log.txt
pscp.exe -pw %PASSWORD% -r %WINDOWS_SRC_DIR% %USERNAME%@%HOSTNAME%:%LINUX_DEST_DIR%
echo Windows to Linux File transferred successfully! >> file_transfer_log.txt

echo SRC: %LINUX_SRC_DIR% to %WINDOWS_DEST_DIR% >> file_transfer_log.txt
pscp.exe -pw %PASSWORD% -r %USERNAME%@%HOSTNAME%:%LINUX_SRC_DIR% %WINDOWS_DEST_DIR% 
echo Linux to Windows File transferred successfully! >> file_transfer_log.txt