 
#!/bin/bash
pushd .; cd ~/Videos
youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' $1
popd
#Requirements:
#sudo apt install youtube-dl
#sudo apt install python3-q-text-as-data ffmpeg