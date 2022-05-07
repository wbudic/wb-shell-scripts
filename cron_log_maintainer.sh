#!/bin/bash
# This is the users cron log maintenance script, trims the ~/cron.log every two days.
# Here the logs file crtime is not checked, last check time is used via uvar CRON_LOG_CHTIME
# Most unix file systems require inode to be checked for an files crtime which is su restricted.
# Using uvar we bypass this as requirment as cron is an background process, not interactive.
#

chtime=$(~/uvar.sh -r CRON_LOG_CHTIME)
nlines=1500
export CRON_DISABLED_STDIN=1

if [ -f ~/cron.log  ]; then
    now=$(date '+%s')
    let "two_days_back=$now - 3600*24*2";
    if [ -z "$chtime" ]; then
        ~/uvar.sh -n CRON_LOG_CHTIME -v "$now"
        exit
    fi   
    #echo -e "now\t\t:$now\nchtime\t\t:$chtime\ntwo_days_back\t:$two_days_back\n"
    if [ "$chtime" -lt "$two_days_back" ]; then
	tail -n "$nlines" ~/cron.log > ~/cron.tmp.log; mv ~/cron.tmp.log ~/cron.log; 
        echo -e $(date +"%d-%b-%Y %T") $(basename $0) "\nTAIL TRIMED LOG to 100 lines" >> ~/cron.log
        ~/uvar.sh -n CRON_LOG_CHTIME -v ""
    fi
fi
