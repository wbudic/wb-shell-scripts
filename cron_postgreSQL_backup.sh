#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
export PGPASSWORD="postgres"

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Started"

/usr/lib/postgresql/12/bin/pg_dump --file "/home/will/dev/lifelog.sql" --host "localhost" --port "5432" --username "postgres" --verbose --format=c --blobs --create --column-inserts "lifelog"

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Ended\n"

exit;
