#!/bin/bash
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export DISPLAY=":0"
export XAUTHORITY="$HOME/.Xauthority"
export CRON_DISABLED_STDIN="1"

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Started"

grab=$(curl -X GET 'https://api.openweathermap.org/data/2.5/weather?q=Sydney,NSW,AU&units=metric&appid=2fc5554698ddb34d6a9eedec75b01e2f')
json=$(echo $grab | jq '{City: .name, Weather:.weather[].description, Temp: .main.temp}')
echo $json
formated=$(echo $json | jq -c -j '(.City+" - "+.Weather+ " ", .Temp, " C°\n")') 
~/uvar.sh -n WEATHER -v "$formated"

echo -e $(date +"%d-%b-%Y %T") $(basename $0) "Ended\n"



