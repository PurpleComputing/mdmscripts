#!/bin/bash
# Remove Old Files
rm -rf /Library/Application\ Support/Purple/*
# Pull latest files
curl -o /Library/Application\ Support/Purple/logo.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo.png
curl -o /Library/Application\ Support/Purple/logo-dark.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/logo-dark.png
curl -o /Library/Application\ Support/Purple/purple-icon.png https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/PurpleLogos/purple-icon.png
curl -o /Library/Application\ Support/Purple/launch-dep.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep.sh
curl -o /Library/Application\ Support/Purple/launch-dep-en.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/launch-dep-en.sh
# Give full permissions
chmod -R 777 /Library/Application\ Support/Purple/