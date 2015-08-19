#!/bin/bash

osascript -e 'display notification "Looking for new Wallpapers" with title "Scrape"'
touch downloadedWallpapers.txt;
clear;
echo "Starting reddit RSS retrieval at `date`"
curl --silent https://www.reddit.com/r/wallpapers/new/.rss | grep -o 'http:\/\/i\.imgur\.com\/[^&]*' > wallpapers.txt
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
