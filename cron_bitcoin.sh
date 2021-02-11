#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
tvup=39000
tvdw=30000
stor=$($HOME/uvar.sh -r BITCOIN_PRICE);
grab=$(curl -s rate.sx./1btc | cut -d. -f1) 
notify=1
if [ -z $stor ] || [ $stor -ne $grab ]; then
   $HOME/uvar.sh -n BITCOIN_PRICE -v $grab;
   stor=1;
fi

if [ $grab -le $tvup ] && [ $grab -gt $tvdw ]; then
  (( $stor == $grab )) && notify=0
fi

grab=$(printf "US $%'.2f", $grab)

if [ $notify == 1 ]; then
/usr/bin/notify-send "BITCON PRICE" "$grab"
echo "$stor" | ~/log -db_src "DBI:Pg:host=localhost;" -database lifelog -sys_table=BITCOIN:VALUE:INTEGER -system
fi
