#!/bin/sh

#Open ports

sudo ufw allow 8080/tcp
sudo ufw allow ssh


##Added
sudo add-apt-repository ppa:ultradvorka/ppa
sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update -y
sudo apt install screen -y
sudo apt install p7zip-full -y
sudo apt install whois -y
sudo apt install arp-scan -y
sudo apt-get install dh-autoreconf -y
sudo apt-get install tree -y
sudo apt install hardinfo -y
sudo apt install inetutils-traceroute -y
sudo apt install xclip -y
#hh command for history
#https://github.com/dvorka/hstr 
sudo apt-get install hh -y

sudo apt-get install ranger caca-utils highlight atool w3m poppler-utils mediainfo -y
#eval "$(fasd --init auto)" >> .bashrc
sudo apt-get install fasd -y

#Obtain currently installed packages
## sudo dpkg --get-selections|grep -v deinstal > Documents/all-packages.installed
#Reinstall previously installed packages
sudo apt install $(cat all-packages.installed|awk '{print $1}') -y

#Install dev libraries
sudo apt install libtool-bin libncurses-dev libxt-dev libgtk2.0-dev libatk1.0-dev libq-dev -y

#Install old kernel file purger
sudo apt-get install byobu -y
#Activate sensors on hardware
#To install --> sudo apt-get install lm-sensors
sudo sensors-detect
sudo apt install dateutils -y
#File preview in shell
sudo apt install bat -y
sudo apt install vim -y
sudo apt install git -y
sudo apt install glances -y
sudo apt install pgp -y
sudo apt install keepassxc -y

sudo apt install ssh -y
sudo apt install sqlite -y
#Hardware releveant into utility
sudo apt install hwloc -y
sudo apt install hunspell -y

#Install fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
#
sudo apt install suckless-tools -y
sudo apt install mpv -y

sudo apt install powerline -y
sudo apt install pv jq suckless-tools -y
