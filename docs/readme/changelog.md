# Changelog

## 2025-06-03

### Streamlined Scheduled Tasks

Removed all scheduled tasks that resolve text / phone notification conflicts based on mobile provider.  Since it is no longer necessary to keep the correct provider for each phone number, we only need to change the notification method.  This can be done with one scheduled task.

### Create a note on account changes (Daviess County Public Library only)

The DCPL uses Polaris' Patron Custom Data fields for staff to denote changes made to a patron's account.  I've added commands to the resolve\_text.sql and the resolve\_voice.sql file to make notes in these fields.  The script is commented out by default.
