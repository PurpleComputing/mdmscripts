# MDM Scripts - Public Repository

This repository is a resource that allows us to distribute scripts across multiple MDM tenants with a single point of hosting.

## Firefox.sh
#### Install Firefox
This script is designed to silently install/update Firefox to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/Firefox.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Firefox.sh && sudo chmod +x /tmp/Firefox.sh && sudo /tmp/Firefox.sh [options]`

## LibreOffice.sh
#### Install LibreOffice
This script is designed to silently install/update LibreOffice to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/LibreOffice.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/LibreOffice.sh && sudo chmod +x /tmp/LibreOffice.sh && sudo /tmp/LibreOffice.sh [options]`

## google-chrome.sh
#### Install Google Chrome
This script is designed to silently install/update Google Chrome to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/google-chrome.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/google-chrome.sh && sudo chmod +x /tmp/google-chrome.sh && sudo /tmp/google-chrome.sh [options]`

## microsoft-apps.sh
#### Install Microsoft Apps
This script is designed to silently install/update Microsoft Apps to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/microsoft-apps.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/microsoft-apps.sh && sudo chmod +x /tmp/microsoft-apps.sh && sudo /tmp/microsoft-apps.sh [PARAM]`

Parameters:

#### For macOS 10.14 and newer
* `full` : Install the full suite
* `word` : Install Word
* `excel` : Install Excel
* `powerpoint` : Install Powerpoint
* `onedrive` : Install OneDrive
* `outlook` : Install Outlook
* `onenote` : Install OneNote
* `teams` : Install Teams
* `remote-desktop` :  Install MS Remote Desktop </br></br>
Appending `-oc` to any of the above parameters (eg. `full-oc`) will open the console logs for monitoring </br>(Used with TeamViewer Scripts)

#### For Mac OSX 10.10.0 - 10.13.6
* `full-2016` : Install the 2016 full suite
* `word-2016` : Install Word 2016
* `excel-2016` : Install Excel 2016
* `powerpoint-2016` : Install Powerpoint 2016
* `outlook-2016` : Install Outlook 2016 </br></br>
Appending `-oc` to any of the above parameters (eg. `full-2016-oc`) will open the console logs for monitoring </br>(Used with TeamViewer Scripts)


#### For Mac OSX 10.6.8 - 10.9.5
* `full-2011` : Install the 2016 full suite </br></br>
Appending `-oc` to the above parameter (eg. `full-2011-oc`) will open the console logs for monitoring </br>(Used with TeamViewer Scripts)

## Acrobat-DC-Update.sh
#### Update Adobe Acrobat DC
This script is designed to silently update Adobe Acrobat DC to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/Acrobat-DC-Update.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Acrobat-DC-Update.sh && sudo chmod +x /tmp/Acrobat-DC-Update.sh && sudo /tmp/Acrobat-DC-Update.sh`

## 1-password.sh
#### Install or Update 1Password 7
This script is designed to silently install or update 1Password 7 to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/1-password.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/1-password.sh && sudo chmod +x /tmp/1-password.sh && sudo /tmp/1-password.sh [options]`

## bt-cloud-phone.sh
#### Install or Update BT Cloud Phone
This script is designed to silently install or update BT Cloud Phone to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/bt-cloud-phone.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/bt-cloud-phone.sh && sudo chmod +x /tmp/bt-cloud-phone.sh && sudo /tmp/bt-cloud-phone.sh [options]`

## scansnap-home.sh
#### Install or Update ScanSnap Home
This script is designed to silently install or update ScanSnap Home to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/scansnap-home.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/scansnap-home.sh && sudo chmod +x /tmp/scansnap-home.sh && sudo /tmp/scansnap-home.sh [options]`

## Rosetta2.sh
#### Install Rosetta2 on required hardware
This script is designed to silently install Rosetta2 onto an Apple Silicon MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
* `jamf` - will run a jamf recon at the end of the script to update the portal
##### Command to execute:
`sudo curl -o /tmp/Rosetta2.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Rosetta2.sh && sudo chmod +x /tmp/Rosetta2.sh && sudo /tmp/Rosetta2.sh [options]`

## computer-rename.sh [JAMF ONLY]
#### Renames a computer based on the JAMF user and MAC address
This script will rename a computer based on the JAMF user and MAC Address, it will need 3 Parameters to be passed through
* Parameter 4. A JAMF user with API permissions
* Parameter 5. The password for the account in Parameter 4
* Parameter 6. The JAMF Host URL
##### Command to execute:
`sudo curl -o /tmp/computer-rename.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/computer-rename.sh && sudo chmod +x /tmp/computer-rename.sh && sudo /tmp/computer-rename.sh`

## enrollment-cleanup.sh [JAMF ONLY]
#### Removes the downloaded and applied mobileconfig file and forces Safari to quit
This script will remove the downloaded and applied mobileconfig file and forces Safari to quit, it is required as Adobe Acrobat installer is sensitive to Safari being open and will cause a failed install.  We can't rely on the enrolling person remembering to close Safari.

##### Command to execute:
`sudo curl -o /tmp/enrollment-cleanup.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/enrollment-cleanup.sh && sudo chmod +x /tmp/enrollment-cleanup.sh && sudo /tmp/enrollment-cleanup.sh`

## lock-device.sh [JAMF ONLY]
#### Renames a computer based on the JAMF user and MAC address
This script will lock a computer using the JAMF API and can be called by an out of region smart group
* Parameter 4. A JAMF user with API permissions
* Parameter 5. The password for the account in Parameter 4
* Parameter 6. The JAMF Host URL
* Parameter 7. The Passcode to lock the device with

##### Command to execute:
`sudo curl -o /tmp/lock-device.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/lock-device.sh && sudo chmod +x /tmp/lock-device.sh && sudo /tmp/lock-device.sh`

## policy-order.sh [JAMF ONLY]
#### Runs JAMF policies in a specific order
This script will apply the policies in the order specified, populate parameter 4 with the policy id's separated with a space.

* Parameter 4 with the policy IDs or their custom triggers

##### Command to execute:
`sudo curl -o /tmp/policy-order.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/policy-order.sh && sudo chmod +x /tmp/policy-order.sh && sudo /tmp/policy-order.sh`

## add-printer.sh
#### Uses lpadmin to create a printer
This script will create a printer in CUPS using the standards listed here > https://www.cups.org/doc/man-lpadmin.html

options used in this example script are

* -p 'Destination'
* -D 'Description'
* -L 'Location'
* -o 'Option [printer-is-shared=false]'
* -E 'Encrypted connection'
* -v 'Printer URL'
* -m 'Driver [Only everwhere will be supported going forwards]'. 'everywhere' is the generic name for AirPrint

##### Command to execute:
`sudo curl -o /tmp/add-printer.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/add-printer.sh && sudo chmod +x /tmp/add-printer.sh && sudo /tmp/add-printer.sh`

## software-update-settings.sh
#### updates plist to change the App and OS software update settings
This script will set the policies software update settings with the following settings.

* AutomaticallyInstallMacOSUpdates - false
* AutomaticCheckEnabled -bool true
* AutomaticDownload -bool true
* CriticalUpdateInstall -bool true
* ConfigDataInstall -bool true
* AutoUpdate -bool true

##### Command to execute:
`sudo curl -o /tmp/software-update-settings.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/software-update-settings.sh && sudo chmod +x /tmp/software-update-settings.sh && sudo /tmp/software-update-settings.sh`

## zerotier.sh
#### Initial Install ZeroTier ONLY
This script is designed to silently install ZeroTier to an MDM enrolled Mac.
##### Command to execute:
`sudo curl -o /tmp/zerotier.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/zerotier.sh && sudo chmod +x /tmp/zerotier.sh && sudo /tmp/zerotier.sh [NETWORKID]`
#### A REBOOT IS REQUIRED FOR THE TLS CERT GENERATION

It is also advised that you add a custom command or script for "on User Sign In" to execute `/usr/local/bin/zerotier-cli join [NETWORK ID]`

Add the following custom command for Mosyle Attribute look up 
###### Title: Get ZT Client ID Number for Attributes 
###### Event: Every "Device Info" update
Command: `/usr/local/bin/zerotier-cli info`
###### Show the command response as an attribute on Device Info: TICK
###### Use the field below to enter the name of the attribute: ZeroTier ID

## zoom.sh
#### Install zoom
This script is designed to silently install/update zoom to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/zoom.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/zoom.sh && sudo chmod +x /tmp/zoom.sh && sudo /tmp/zoom.sh [options]`

## brave-browser.sh
#### Install Brave Browser
This script is designed to silently install/update Brave Browser to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/brave-browser.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/brave-browser.sh && sudo chmod +x /tmp/brave-browser.sh && sudo /tmp/brave-browser.sh [options]`

## balenaEtcher.sh
#### Install balenaEtcher
This script is designed to silently install/update balenaEtcher to an MDM enrolled Mac.
##### Options
* `openconsole` - will open the console for the logs to show
##### Command to execute:
`sudo curl -o /tmp/balenaEtcher.sh https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/balenaEtcher.sh && sudo chmod +x /tmp/balenaEtcher.sh && sudo /tmp/balenaEtcher.sh [options]`

