# asterisk-compress-conversation

This script:
 - runs every month
 - correct run when new year starts
 - create month dir and year dir
 - compress (bzip2) conversation files
 - move files to dirs
 - delete calls from $SOURCE that older than 365 days

```
07 2  1 * *     /root/scripts/compress_old_conversation.sh > /dev/null 2>&1
```
