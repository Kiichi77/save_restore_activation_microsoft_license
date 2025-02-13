@echo off
rem Offline script to save and restore activation for Microsoft Windows and Office licenses by Thelogh
rem Backup and Restore Microsoft Windows and Microsoft Office License Activation Offline
rem https://www.alldiscoveries.com/backup-and-restore-microsoft-windows-and-microsoft-office-license-activation-offline/
rem For all requests write on the blog
rem REPOSITORY
rem https://github.com/thelogh/save_restore_activation_microsoft_license
rem V.1.0.0

rem Get hostname
for /f "tokens=* USEBACKQ" %%F in (`hostname`) do (set HOST=%%F)

rem Create directories for placing the license and token file.
if not exist "backups\%HOST%\license" mkdir "backups\%HOST%\license"
if not exist "backups\%HOST%\GenuineTicket" mkdir "backups\%HOST%\GenuineTicket"

rem Stop the services to get the license and token file
net stop clipsvc
net stop sppsvc
xcopy C:\Windows\System32\spp\store .\license /O /X /E /H /K /Y
xcopy C:\ProgramData\Microsoft\Windows\ClipSVC\tokens.dat .\GenuineTicket /O /X /H /K /Y

rem Dump the licnese in registry 
psexec -i -s -accepteula reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\{7746D80F-97E0-4E26-9543-26B41FC22F79} .\winactivationkey.reg
copy C:\Windows\System32\winactivationkey.reg .\backups\%HOST%\
del C:\Windows\System32\winactivationkey.reg

rem Bring back the services
net start clipsvc
net start sppsvc

echo Your licnese file is located at .\backups\%HOST%\, please keep it safe.
pause