#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
export CRON_DISABLED_STDIN=1

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Started"

stor=$($HOME/uvar.sh -r BITCOIN_PRICE);
grab=$(curl -s rate.sx./1btc | cut -d. -f1) 
record=0
if [ -z $stor ] || [ $stor -ne $grab ]; then
   $HOME/uvar.sh -n BITCOIN_PRICE -v $grab;
   stor=$grab; record=1;
fi 
grab=$(printf "US $%'.2f", $grab)
/usr/bin/notify-send "BITCON PRICE" "$grab"
if [ $record == 1 ]; then
cd ~/dev/LifeLog
./log.pl -db_src "DBI:Pg:host=localhost;" -alias lifelog -database lifelog -sys_table=BITCOIN:VALUE:INTEGER -system -insert "$stor"
cd
fi

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Ended\n"
exit;
