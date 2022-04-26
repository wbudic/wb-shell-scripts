 
#!/bin/bash
pushd .; cd ~/Videos
#youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' $1
yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' $1
popd
#Requirements:
#sudo apt install python3-pip
#python3 -m pip install -U yt-dlp
#sudo apt install python3-q-text-as-data ffmpeg
#