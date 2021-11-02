#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"

echo -e $(date +"%D %T") $(basename $0) "Started"

grab=$(curl -X GET https://openexchangerates.org/api/latest.json?app_id=xxx) 
echo $grab
~/uvar.sh EXCHANGE_JSON '$grab'
~/uvar.sh EXCHANGE_AUD $(echo $grab | jq '.rates.AUD')
~/uvar.sh EXCHANGE_EUR $(echo $grab | jq '.rates.EUR')

echo -e $(date +"%D %T") $(basename $0) "Ended\n"