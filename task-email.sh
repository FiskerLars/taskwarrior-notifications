#!/bin/bash

#email myself info about upcoming tasks in a pretty HTML format
# Requires ssmtp
# cron: 30 5 * * 1-6 /home/user/bin/taskwarrior-notifications/task-email.sh

# Directory to find support files
inc="/home/jritchie/scripts/taskwarrior-notifications"
tmp_email="/tmp/task_email.txt"
templates="$inc/templates"
scripts="$inc/scripts"
# Whom to email this too
sendto="josiah@fim.org"

# Format time string
date=`date '+%b %d'` #Sept 07

cat > $tmp_email <<EOF
From: The Task List <$sendto> 
To: $sendto
Subject: Daily Task Email
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
EOF

# Get the template loaded up
cat $templates/html_email_head.template >> $tmp_email
echo "<h1>Task Info: $date</h1>" >> $tmp_email
echo `task _query status:completed | $scripts/export-html.py` >> $tmp_email
cat $templates/html_email_foot.template >> $tmp_email

# Send the email
ssmtp $sendto < $tmp_email
rm $tmp_email
