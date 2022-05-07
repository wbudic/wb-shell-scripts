#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
export CRON_DISABLED_STDIN="1"

echo -e $(date +"%D %T") $(basename $0) "Started"

grab=$(curl -X GET https://openexchangerates.org/api/latest.json?app_id=00a1943886e24f9bb240e6aa3f7b9868) 
echo $grab
~/uvar.sh -n EXCHANGE_JSON -v $(echo $grab | tr -s '\n' '\\n') 
~/uvar.sh -n EXCHANGE_AUD  -v $(echo $grab | jq '.rates.AUD')
~/uvar.sh -n EXCHANGE_EUR  -v $(echo $grab | jq '.rates.EUR')

echo -e $(date +"%D %T") $(basename $0) "Ended\n"
