#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
export BACKUP_VERBOSE=0
export HOME=/home/will
export USER=will

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Started"

rsync -chavzP --stats will@nuc:thttpd_dev/dbLifeLog/  /home/will/backups/NUC_dbLifeLog

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Ended\n"

exit;
