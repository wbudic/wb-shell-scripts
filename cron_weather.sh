#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"

echo -e $(date +"%D %T") $(basename $0) "Started" 

grab=$(curl -X GET 'https://api.openweathermap.org/data/2.5/weather?q=Sydney,NSW,AU&units=metric&appid=xxxx')
json=$(echo $grab | jq '{City: .name, Weather:.weather[].description, Temp: .main.temp}')
echo $json
formated=$(echo $json | jq -c -j '(.City+" - "+.Weather+ " ", .Temp, " C°\n")') 
~/uvar.sh WEATHER "$formated"

echo -e $(date +"%D %T") $(basename $0) "Ended\n"



