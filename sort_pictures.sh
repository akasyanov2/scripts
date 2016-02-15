#!/bin/bash

DIR="/Volumes/shared/Import/$1"
DEST="/Volumes/shared/Pictures"

# Find JPGs
find "$DIR" -type f \( -iname \*.jpg \) | while read f
do
  # Apply ignore filters
  if [[ $f == *"thumbs"* ]]; then
    echo "its a thumb. Ignoring."
    continue  
  fi
  # Extract date
  date=`~/Downloads/Image-ExifTool-10.02/exiftool "$f" | grep "Date"|grep "Original"| head -1 | awk '{print $4}' | awk -F":" '{print $1"-"$2}'`

  # Date is not stored
  # Retain old directory name
  if [ "$date" == "" ]; then
     DIR=$(dirname "${f}")
     DIR=$(basename "${DIR}")
     date="/unsorted/$DIR"
  fi
  echo "$f" "-" "$date"

  if [ ! -d "$DEST/$date" ] ; then
     echo "Creating Directory: $DEST/$date"
     mkdir "$DEST/$date"
  fi

  ctr=0
  filename=$(basename "$f")
  [[ $filename =~ \. ]] && ext="."${filename#*.};
  
  # Increase Counter if filename exists
  if [ -f "$DEST/$date/$filename" ] ; then
     # Check if images are the same
     diff "$DEST/$date/$filename" "$f" > /dev/null
     if [ $? == 1 ] ; then
        ctr=1
        while [ -f "$DEST/$date/${filename%%.*}_$ctr""$ext" ]; do
           ctr=$(($ctr + 1))
        done
     else
        echo "$f is identifical"
     fi
  fi
  if [ $ctr == 0 ]; then
     mv "$f" "$DEST/$date"
  else
     echo "File exists. Using "$DEST/$date/${f%%.*}_$ctr"$ext" 
     filename=$(basename "$f")
     [[ $filename =~ \. ]] && ext="."${filename#*.}; 
     mv "$f" "$DEST/$date/${filename%%.*}_$ctr""$ext"; 
  fi
done
