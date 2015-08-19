#!/bin/bash

wallpapers=true
earthporn=true


touch downloadedWallpapers.txt;
rm wallpapers.txt
touch wallpapers.txt
clear;
echo "Starting reddit RSS retrieval at `date`"
if [ wallpapers ]; then
curl --silent https://www.reddit.com/r/wallpapers/new/.rss | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' >> wallpapers.txt
fi

if [ earthporn  ]; then
curl --silent https://www.reddit.com/r/earthporn/new/.rss | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' >> wallpapers.txt
fi

for line in $(cat wallpapers.txt)
do
	if ! grep -q "$line" downloadedWallpapers.txt;
		then
		wget -P wallpapers-pending/ "$line";
		echo "Found wallpaper at $line"
		echo "$line" >> downloadedWallpapers.txt;
		osascript -e 'display notification "Finished downloading new wallpaper" with title "New Wallpaper Downloaded"'
	fi
done
echo -e "Finished processing wallpapers at `date`.\n" 
