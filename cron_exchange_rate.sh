#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"

grab=$(curl -X GET https://openexchangerates.org/api/latest.json?app_id=xxx) 
echo $grab
~/uvar.sh EXCHANGE_JSON '$grab'
~/uvar.sh EXCHANGE_AUD $(echo $grab | jq '.rates.AUD')
~/uvar.sh EXCHANGE_EUR $(echo $grab | jq '.rates.EUR')
