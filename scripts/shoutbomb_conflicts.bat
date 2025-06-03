:: shoutbomb_conflicts.bat is part of a collection of script to integrate Polaris with the Shoutbomb notification service.
::
:: Runs SQL scripts that look for accounts with text or voice notifications that have been updated in the past week,
:: Searches for other accounts that use the same phone number, and updates those account to use the same notification method.
:: Only affect accounts that use text or voice notifications.  Does not change accounts that use email or mail.
::
:: Expect 1 parameter, and 1 optional parameter for text notifications
:: @Parameter 1
::  Expects text or voice
::  text changes all conflicts to text notifications.  voice changes all conflicts to voice notifications.
:: @Parameter 2
::  If Parameter 1 is text, Parameter two should be the keyword for the Mobile Phone Carrier, e.g. att,
::
:: Example usage:  shoutbomb_conflicts.bat text att
::  Searches for recently updated accounts using AT&T text notifications.
::
::  Created by Brian Lashbrook for the Daviess County Public Library on 2020-08-22.
@echo off
:: Sets variable type to Parameter 1 (voice|text).
set type=%1
:: Sets variable provider to blank in case variable type is voice.
set provider=''
::  Sets variable provider to Patameter 2, the Mobile Phone Carrier keyword.
set provider=%2
:: Sets local variable "today" to the current date and time.
set today=%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
set today=%today: =0%
:: Runs SQL script to find recently update accounts using either text or voice notifications.
:: Finds accounts using the same phone number but a conflicting notification method and logs them.
sqlcmd -S DCPLPRO -d Polaris -i C:\shoutbomb\sql\conflicts\log_%type%_conflicts.sql -o C:\shoutbomb\logs\%type%%provider%_conflicts_%today%.txt -h-1 -W -s "|"
:: Updates the other accounts using the same phone number.
sqlcmd -S DCPLPRO -d Polaris -i C:\shoutbomb\sql\conflicts\resolve_%type%.sql -v Provider='%provider%'