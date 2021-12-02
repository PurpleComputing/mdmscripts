#!/bin/bash

# Remove Old Files
echo Making App Support Directories
mkdir -p /Library/Application\ Support/Purple/
echo Cleaning App Support Cache and Log Directories
rm -rf /Library/Application\ Support/Purple/*

# Pull latest files
echo Downloading Image Files
curl -o /Library/Application\ Support/Purple/logo.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo.png
curl -o /Library/Application\ Support/Purple/logo-dark.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo-dark.png
curl -o /Library/Application\ Support/Purple/purple-icon.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/purple-icon.png
echo Downloading Scripts
curl -o /Library/Application\ Support/Purple/launch-dep.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep.sh
curl -o /Library/Application\ Support/Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
echo Making Cache and Log Directories
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /tmp/purple-logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
echo Linking Log Folders
ln -s /Library/Logs/com.purplecomputing.mdm/ /tmp/purple-logs/
ln -s /Library/Logs/com.purplecomputing.mdm/ /Library/Caches/com.purplecomputing.mdm/Logs/

touch /var/tmp/depnotify.log

# Give full permissions
chmod -R 777 /Library/Application\ Support/Purple/
chmod -R 777 /Library/Caches/com.purplecomputing.mdm/
chmod -R 777 /Library/Logs/com.purplecomputing.mdm/
chmod 777 /var/tmp/depnotify.log