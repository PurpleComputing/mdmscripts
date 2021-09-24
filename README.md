# MDM Scripts - Public Repository

This repository is a resource that allows us to distribute scripts across multiple MDM tenants with a single point of hosting.

## Firefox.sh
#### Install Firefox
This script is designed to silently install/update Firefox to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/Firefox.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Firefox.sh && sudo chmod /tmp/Firefox.sh && sudo /tmp/Firefox.sh`

## LibreOffice.sh
#### Install LibreOffice
This script is designed to silently install/update LibreOffice to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/LibreOffice.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/LibreOffice.sh && sudo chmod /tmp/LibreOffice.sh && sudo /tmp/LibreOffice.sh`

## google-chrome.sh
#### Install Google Chrome
This script is designed to silently install/update Google Chrome to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/google-chrome.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/google-chrome.sh && sudo chmod /tmp/google-chrome.sh && sudo /tmp/google-chrome.sh`

## office-install.sh
#### Install Microsoft Office Suite
This script is now redirected to microsoft-apps.sh
##### Command to execute:
`NO LONGER USED`

## microsoft-apps.sh
#### Install Microsoft Apps
This script is designed to silently install/update Microsoft Apps to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/microsoft-apps.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/microsoft-apps.sh && sudo chmod /tmp/microsoft-apps.sh && sudo /tmp/microsoft-apps.sh [PARAM]`

Parameters:
* `full` : Install the full suite
* `word` : Install Word
* `excel` : Install Excel
* `powerpoint` : Install Powerpoint
* `onedrive` : Install OneDrive
* `outlook` : Install Outlook
* `onenote` : Install OneNote
* `teams` : Install Teams

## Acrobat-DC-Update.sh
#### Update Adobe Acrobat DC
This script is designed to silently update Adobe Acrobat DC to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/Acrobat-DC-Update.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Acrobat-DC-Update.sh && sudo chmod /tmp/Acrobat-DC-Update.sh && sudo /tmp/Acrobat-DC-Update.sh`

## 1-password.sh
#### Install or Update 1Password 7
This script is designed to silently install or update 1Password 7 to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/1-password.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/1-password.sh && sudo chmod /tmp/1-password.sh && sudo /tmp/1-password.sh`

## bt-cloud-phone.sh
#### Install or Update BT Cloud Phone
This script is designed to silently install or update BT Cloud Phone to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/bt-cloud-phone.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/bt-cloud-phone.sh && sudo chmod /tmp/bt-cloud-phone.sh && sudo /tmp/bt-cloud-phone.sh`

## Rosetta2.sh / Rosetta2-JAMF.sh
#### Install Rosetta2 on required hardware
This script is designed to silently install Rosetta2 onto an Apple Silicon MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/Rosetta2.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Rosetta2.sh && sudo chmod /tmp/Rosetta2.sh && sudo /tmp/Rosetta2.sh`
##### or
`sudo curl -o /tmp/Rosetta2-JAMF.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Rosetta2-JAMF.sh && sudo chmod /tmp/Rosetta2-JAMF.sh && sudo /tmp/Rosetta2-JAMF.sh`
