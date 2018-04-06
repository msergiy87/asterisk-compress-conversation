# asterisk-compress-conversation

This script:
 - runs every mounth 
 - create dir
 - compress (bzip2) conversation files and move files to dir
 - delete calls from $SOURCE that older than 365 days

07 2  1 * *     /root/scripts/compress_old_conversation.sh > /dev/null 2>&1
