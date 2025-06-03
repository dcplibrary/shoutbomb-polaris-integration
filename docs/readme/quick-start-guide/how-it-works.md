# How it works

## Notification processing

1. Scheduled tasks launch batch files at specified times. &#x20;
2. The batch script runs a T-SQL script to query the Polaris database for notifications. &#x20;
3. The batch script writes the query results to a text file, in a Shoutbomb-friendly format.
4. The script then uses the WinSCP command-line client to connect to Shoutbomb's FTP server and upload the file.
5. Finally, the script logs the process and stores a copy of the text files uploaded to Shoutbomb.

## Patron registration

Staff handle notification method changes in the Polaris staff client.  However, this system should work if you allow patrons to update their own notification methods, as long as the changes are saved in Polaris.

{% hint style="info" %}
Shoutbomb assigns each phone number to either text or phone notifications.  If multiple patrons use the same number, they must both use the same notification method.  We first run a script to fix conflicts.
{% endhint %}

1. A scheduled batch file launches an SQL script that finds any patrons using the same phone number for conflicting notification methods. The script updates the Polaris database, changing the notification methods of all related accounts to the same method as the account that was updated last.
2. Another scheduled batch file runs an SQL script to query the Polaris database for patrons using text or phone notifications and writes them to a text file, in a Shoutbomb-friendly format.
3. The batch file then tells the FTP client to upload the registered patron list to Shoutbomb.
