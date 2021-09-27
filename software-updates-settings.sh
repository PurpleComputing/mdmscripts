#!/bin/sh
deplog="/var/tmp/depnotify.log"
echo "Status: Changing Software Update Settings" >> ${deplog}
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool false
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
/usr/bin/defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool true
Sleep 2
echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
