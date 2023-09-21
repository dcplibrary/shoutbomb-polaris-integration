::====================================================================================================================
::  PURPOSE
::
::  This script provides patron account notification information to the Shoutbomb Voice and Text notification service.
::  1.  The script retrieves hold, overdue, and renew notification information from the Polaris ILS database using 
::      sqlcmd and external sql scripts. It writes the query results to a pipe (|) delimited text files.
::  2.  The script uploads the files to Shoutbomb's FTP server using the WinSCP program for Microsoft Windows.
::      The WinSCP activity is written to a log file.
::  3.  The script moves the query results file to a backup folder and appends the date and time to the filename.
::
::  PARAMETERS
::
::  The script accepts 1 parameter based on the information requested.  The options are holds, overdue, renew,
::  voice_patrons, and text_patrons.  These terms are used for any folder, file, or script names related to the specific
::  information requested.  Hold, renew, and overdue are patron notification information, and voice_patrons and 
::  text_patrons are lists of patrons who have selected phone or texting as their primary notification method.
::
::  USAGE
::
::  This batch file can be called from the command prompt using one of the accepted parameters listed about.
::  For example, to submit hold notifications to Shoutbomb, run the command "shoutbomb.bat holds".
::  
::  SUPPORT
::
::  This script was created by Brian Lashbrook (blashbrook@dcplibrary.org) for the Daviess County Public Library.  
::  The script contains components of scripts created by other unknown but talented developers.
::  It is free to use and modify.  
::
::====================================================================================================================
@echo off
::  Set info variable to the input parameter value.
set info=%1
::  Set backup variable to the info variable plus the date and time.  This will be used to rename the backup file.
set backup=%info%_submitted_%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
::  Replace the space created by the system TIME variable with a 0.  The space occurs when hours have single digits.
set backup=%backup: =0%
::  Execute sql script related to the requested information.  The script filename and the output folder and filename must 
::  all match the input parameter, which is now stored in the %info% variable.  Acceptable input is listed in the PARAMETERS
::  section above.
sqlcmd -S DCPLPRO -d Polaris -i C:\shoutbomb\sql\%info%.sql -o C:\shoutbomb\ftp\%info%\%info%.txt -h-1 -W -s "|"
::  Connect and upload the query results to Shoutbomb's FTP server using the WinSCP command line program.
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\shoutbomb\logs\%info%.log" /ini=nul ^
  /command ^
    "open %shoutbomb% -rawsettings ProxyPort=0" ^
    "lcd C:\shoutbomb\ftp\%info%" ^
    "cd /%info%" ^
    "put *" ^
    "exit"
::  Write WinSCP FTP activity to log file.
set WINSCP_RESULT=%ERRORLEVEL%
if %WINSCP_RESULT% equ 0 (
  echo Success
::  Backup query results file.
  move C:\shoutbomb\ftp\%info%\%info%.txt C:\shoutbomb\logs\%backup%.txt
) else (
  echo Error
)

exit /b %WINSCP_RESULT%