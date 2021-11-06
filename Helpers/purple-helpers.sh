#!/bin/bash

# Remove Old Files
mkdir -p /Library/Application\ Support/Purple/
rm -rf /Library/Application\ Support/Purple/*
rm -rf /Library/Caches/com.purplecomputing.mdm/Logs/

# Pull latest files
curl -o /Library/Application\ Support/Purple/logo.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo.png
curl -o /Library/Application\ Support/Purple/logo-dark.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo-dark.png
curl -o /Library/Application\ Support/Purple/purple-icon.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/purple-icon.png
curl -o /Library/Application\ Support/Purple/launch-dep.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep.sh
curl -o /Library/Application\ Support/Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps
mkdir -p /Library/Logs/com.purplecomputing.mdm/
ln -s /Library/Logs/com.purplecomputing.mdm/ /tmp/purple-logs/
ln -s /Library/Logs/com.purplecomputing.mdm/ /Library/Caches/com.purplecomputing.mdm/Logs/

# Give full permissions
chmod -R 777 /Library/Application\ Support/Purple/
chmod -R 777 /Library/Caches/com.purplecomputing.mdm/
chmod 777 /var/tmp/depnotify.log