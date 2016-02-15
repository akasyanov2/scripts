#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
# set me
pushd $1
FILES=*
OUTPUT=$2
for f in $FILES
do
  echo "$f"
  SONG=$(echo $f | sed -e 's/[^ A-Za-z0-9._-]/_/g')
  SONG=${SONG%.*}
  ffmpeg -i "$1/"$f"" -f mp3 -acodec libmp3lame -ab 192000 -ar 44100 "$OUTPUT/$SONG.mp3" >/dev/null 2>/dev/null
done
# restore $IFS
IFS=$SAVEIFS
popd
