#!/bin/bash

if ! cd ~/dev; then
mkdir ~/dev
fi


sudo add-apt-repository ppa:bashtop-monitor/bashtop
sudo apt update
sudo apt install bashtop

git clone https://github.com/MatMoul/g810-led.git
cd g810-led
make bin # for hidapi
sudo make install
cd
cat > ~/.keyboard_rgp <<EOL
# Slap that keyboard bitch with rainbow colours, place in ~/.profile the following: g213-led -p .keyboard_rgb 
r 1 00FFFF
r 2 FFFF00
r 3 FFFFFF
r 4 FF0000
r 5 78FFFF
EOL

 
