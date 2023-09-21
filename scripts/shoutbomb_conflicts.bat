:: 
set today=%date:~-4,4%-%date:~-10,2%-%date:~-7,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%
sqlcmd -S DCPLPRO -d Polaris -i C:\shoutbomb\sql\conflicts\%1.sql -o C:\shoutbomb\conflicts\%1_%today.txt -h-1 -W -s "|"