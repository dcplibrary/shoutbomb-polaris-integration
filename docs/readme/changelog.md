# Changelog

## 2025-06-03

### Streamlined Scheduled Tasks

Removed all scheduled tasks that resolve text / phone notification conflicts based on mobile provider.  Since it is no longer necessary to keep the correct provider for each phone number, we only need to change the notification method.  This can be done with one scheduled task.
