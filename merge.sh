#!/bin/bash
# simple script for merging all .mp4 files in its folder into a file named after the folder
# example : 
#   myFolder -*
#             |
#             *- merge.sh
#             *- part1.mp4  
#             *- part2.mp4  
#             *- part3.mp4  
#             ...  
#
#   results in ...
#
#   myFolder -*
#             |
#             *- myFolder.mp4  
#             *- merge.sh
#             *- files.txt
#             *- myFolder-(1).mp4  
#             *- myFolder-(2).mp4  
#             *- myFolder-(3).mp4  
#             ...  

echo 'looking for .mp4 files ...'
if [ $(find ./ -name '*.mp4' | wc -l) -gt 0 ]
then
    echo "found some!"
else
    echo "no .mp4 files were found!"
    exit 125
fi

echo 'creating backup ...'
cp -r "${PWD}" "${PWD} (backup)"
# making preparations ...
folder=${PWD##*/}
a=1

echo 'renaming files ...'
for i in `ls -v *.mp4`; do 
    new=$(printf "$folder-(%d).mp4" "$a")
    mv -i -- "$i" "$new"
    let a=a+1
done;

echo 'creating files list ...'
ls -v -b *.mp4 | sed 's/^/file .\//' > files.txt

echo "merging ($a) files ..."
ffmpeg -f concat -safe 0 -i files.txt -c copy "$folder.mp4" -loglevel fatal
