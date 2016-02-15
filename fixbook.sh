#!/bin/bash

NAME=$1
NAME=${NAME%.*}
ffmpeg -i "$1" -f mp3 -acodec libmp3lame -ab 128000 -ar 44100 "$NAME.mp3"
mp3splt -t 5.0 -a -d "$NAME" "$NAME.mp3"
