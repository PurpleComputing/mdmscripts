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
