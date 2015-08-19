#!/bin/bash

# Parameter Setup
wallpapers=true
earthporn=true

# File Setup
touch downloadedWallpapers.txt;
rm wallpapers.txt
rm imgur.txt
touch wallpapers.txt
touch imgur.txt

# Clear the terminal
clear;

echo "Starting reddit RSS retrieval at `date`"
if [ wallpapers ]; then
	curl --silent https://www.reddit.com/r/wallpapers/new/.rss >> walls.txt
fi
if [ earthporn  ]; then
	curl --silent https://www.reddit.com/r/earthporn/new/.rss | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' >> walls.txt
fi

cat walls.txt | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' >> wallpapers.txt

cat walls.txt | grep -o 'http:\/\/imgur\.com\/[^&]*' >> imgur.txt
for line in $(cat imgur.txt)
do
	curl --silent $line | grep 'image_src' | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' | sed 's/"\/>//' >> wallpapers.txt
done

i=0
for line in $(cat wallpapers.txt)
do
	if ! grep -q "$line" downloadedWallpapers.txt;
		then
		wget -P wallpapers-pending/ "$line";
		echo "Found wallpaper at $line"
		echo "$line" >> downloadedWallpapers.txt;
		i++
	fi
done
	if [ $i != 0 ]; then
		osascript -e 'display notification "Finished downloading '$i' new wallpaper(s)" with title "New Wallpaper(s) Downloaded"'
	fi
echo -e "Finished processing wallpapers at `date`.\n" 
