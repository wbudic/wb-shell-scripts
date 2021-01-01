#!/bin/bash
SELPID=`ps -u $USER -o pid,%mem,%cpu,command | sort -b -k2 -r | sed -n '1!p' | dmenu -i -b -l 25 | awk '{print $1,$4}'`;
echo $SELPID;
if [ ! -z "$SELPID" ]; then
 sudo kill -9 `echo $SELPID| awk '{FIELDWIDTHS = " 1"} {print $1}'`
fi
