# Configure FTP Client

### Use WinSCP to connect to Shoutbomb's FTP server

{% hint style="info" %}
WinSCP offers comprehensive documentation for the [command-line interface](https://winscp.net/eng/docs/commandline) and for [scripting and automation](https://winscp.net/eng/docs/scripting).
{% endhint %}

1. Download and install the latest version of WinSCP from [https://winscp.net/eng/download.php](https://winscp.net/eng/download.php)
2. Open WinSCP and create a New Site. If you are not prompted to create a site, click on **New Tab.** Then click **New Site** in the "Login" window.
3. Enter the FTP information provided by Shoutbomb. If Shoutbomb has provided you with an SSL certificate, click **Advanced** and select **TLS/SSL.** Click the browse icon (**...**) to select the "Client certificate file" from your hard drive.
4. Click **Save.** Change the "Site name" to **Shoutbomb** and click **OK**. Click **Login** to test the connection.
5. Leave the tab open to stay connected to the server, and continue to Generate session URL.

### Generate session URL

{% hint style="info" %}
If the Shoutbomb tab is still open in WinSCP, right-click on the tab and select **Generate Session URL/Code**. Then skip to step 5.
{% endhint %}

1. Click **New Tab.**
2. Select the Shoutbomb site.
3. Click **Manage.**
4. Select **Generate Session URL/Code**.\\
5. Copy the connection URL, between "open " and " -rawsettings." If you have an SSL certificate provided by Shoutbomb, be sure to copy the entire certificate hash. It will likely extend past the viewable area, so keep dragging to the right to highlight the entire URL.

{% hint style="info" %}
If you would like to use an environment variable to store the session URL, you can skip to (Optional) Use environment variables to store the session URL.
{% endhint %}

6. Right-click on C:\shoutbomb\scripts\shoutbomb.bat and select **Edit.** Replace "%shoutbomb%" with the session URL.

<pre class="language-batch" data-title="scripts\shoutbomb.bat" data-overflow="wrap" data-full-width="false"><code class="lang-batch">:: Connect and upload the query results to Shoutbomb's FTP server using the WinSCP command line program.
"C:\Program Files (x86)\WinSCP\WinSCP.com" ^
  /log="C:\shoutbomb\logs\%info%.log" /ini=nul ^
  /command ^
    "open <a data-footnote-ref href="#user-content-fn-1">%shoutbomb%</a> -rawsettings ProxyPort=0" ^
    "lcd C:\shoutbomb\ftp\%info%" ^
    "cd /%info%" ^
    "put *" ^
    "exit"
</code></pre>

7. Repeat step 6 for shoutbomb\_conflicts.bat. Optionally, if your library is like DCPL and does not count Sundays against the loan period, you can edit shoutbomb\_renew\_thursday.bat. This script can be used for any day of the week, as long as you schedule it to run 3 days in advance.

### (Optional) Use Environment Variables to store FTP credentials

Once you have completed Generate session URL steps 1-5, you can opt to store the session URL in an environment variable. This will prevent you from having to edit each batch file in the scripts folder.

1. Click the Windows Start button and start typing "environment." Before you finish, the Start menu item "Edit the system environment variables" should appear. Click it.
2. Click **Environment Variables**.
3. Under "System variables," click **New**.
4. Enter "shoutbomb" for the Variable name and paste the session URL into the Variable value field.
5. Click OK twice to save the shoutbomb environment variable.

[^1]: Replace
