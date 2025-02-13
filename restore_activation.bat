rem Offline script to save and restore activation for Microsoft Windows and Office licenses by Thelogh
rem Backup and Restore Microsoft Windows and Microsoft Office License Activation Offline
rem https://www.alldiscoveries.com/backup-and-restore-microsoft-windows-and-microsoft-office-license-activation-offline/
rem For all requests write on the blog
rem REPOSITORY
rem https://github.com/thelogh/save_restore_activation_microsoft_license
rem V.1.0.0

echo Do not connect your PC or SERVER to the internet until the license has been restored!!!
echo Please make sure the internet is disconnected before you continue.
pause

rem Check the backup directory exist or not
if not exist "backups\%HOST%" echo The directory that holds backed up licenses for this PC is not exist (Maybe wrong hostname). && goto end
if not exist "backups\%HOST%\license" echo The 'license' directory is missing. && goto end
if not exist "backups\%HOST%\GenuineTicket" echo The 'GenuineTicket' directory is missing. && goto end
if not exist "backups\%HOST%\winactivationkey.reg" echo File 'winactivationkey.reg' is missing && goto end

rem The files are ready, go on to restore license(s)

rem Stop the services
net stop clipsvc
net stop sppsvc

xcopy .\backups\%HOST%\license\2.0\ C:\Windows\System32\spp\store\2.0 /O /X /E /H /K /Y
xcopy .\backups\%HOST%\GenuineTicket\tokens.dat C:\ProgramData\Microsoft\Windows\ClipSVC /O /X /H /K /Y
copy /Y .\backups\%HOST%\winactivationkey.reg C:\Windows\System32\winactivationkey.reg
psexec -i -s -accepteula reg import C:\Windows\System32\winactivationkey.reg
del C:\Windows\System32\winactivationkey.reg

echo Restoring license is finished. You may need to check whether there is some errors in the output above.
echo You computer will reboot after you press any key.
pause >nul
shutdown /r /t 0

:end 
echo Please check make sure the backup directory is existed and retry by running this programme again.