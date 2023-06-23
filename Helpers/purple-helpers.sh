#!/bin/bash

# SERVICE SCRIPT CALLED BY OTHER SCRIPTS

# Remove Old Files
echo Making App Support Directories
mkdir -p /Library/Application\ Support/Purple/
echo Cleaning App Support Cache and Log Directories
rm -rf /Library/Application\ Support/Purple/*
cd /Library/Application\ Support/Purple/
rm -rf /Library/Application\ Support/Purple/create-ticket.sh

# Pull latest files
echo Downloading Image Files
curl -s -o /Library/Application\ Support/Purple/logo.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo.png
curl -s -o /Library/Application\ Support/Purple/logo-dark.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo-dark.png
curl -s -o /Library/Application\ Support/Purple/purple-icon.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/purple-icon.png
curl -s -o /Library/Application\ Support/Purple/light-pmos.png https://raw.githubusercontent.com/PurpleComputing/image-repo/main/light-pmos.png
curl -s -o /Library/Application\ Support/Purple/dark-pmos.png https://raw.githubusercontent.com/PurpleComputing/image-repo/main/dark-pmos.png

echo Downloading Scripts
curl -s -o /Library/Application\ Support/Purple/launch-dep.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep.sh
curl -s -o /Library/Application\ Support/Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
curl -s -o /Library/Application\ Support/Purple/zt-dialog.sh https://raw.githubusercontent.com/PurpleComputing/helpful-scripts/main/zt-dialog.sh
curl -s -o /Library/Application\ Support/Purple/join-zt-network.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/join-zt-network.sh
curl -s -o /Library/Application\ Support/Purple/create-ticket.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/create-ticket.sh

echo Execute Helper Files
curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/swda-deploy.sh | bash # INSTALLS SWDA
curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/support-app.sh | bash

echo Making Cache and Log Directories
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /tmp/purple-logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/

rm /var/tmp/depnotify.log
touch /var/tmp/depnotify.log

# Give full permissions
chmod -R 777 /Library/Application\ Support/Purple/
chmod -R 777 /Library/Caches/com.purplecomputing.mdm/
chmod -R 777 /Library/Logs/com.purplecomputing.mdm/
chmod 777 /var/tmp/depnotify.log
chmod 777 /Library/Application\ Support/Purple/create-ticket.sh

rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/*
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/.appinstallname
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/pkg
mkdir -p /Library/Caches/com.purplecomputing.mdm/Scripts/
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/$SCRIPTNAME
rm -rf /Library/Caches/com.purplecomputing.mdm/Scripts/brandDEPinstall.sh
