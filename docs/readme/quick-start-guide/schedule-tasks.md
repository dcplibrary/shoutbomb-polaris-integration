---
description: Import or create tasks to run scripts on a schedule
---

# Schedule Tasks

1. On the ILS Server, Click the Windows Start button and start typing "task." Before you finish, the Start menu item "Task Scheduler" should appear. Click it.
2. In the Actions panel on the right, click **Import Task**.
3. Browse to C:\shoutbomb\scheduled\_tasks and double-click _Upload Holds.xml._
4. In the Security options under the General tab, select "Run whether user is logged in or not" and check "Run with highest privileges." You can adjust when the task runs by clicking on the Triggers tab and double-clicking the scheduled trigger.
5. Click **OK.** Enter your password when prompted and click **OK**.
6. Repeat steps 1-5 for _Upload Courtesy,_ _Upload Overdue_, _Upload Renew,_ _Upload Text Patrons_, _Upload Voice Patrons_, _Resolve Conflicts to Voice, and Resolve Conflicts to Text_.
