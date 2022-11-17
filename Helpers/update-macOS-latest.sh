#DEVSCRIPT

#CHECKS FOR REQUIRED FILES
if [ ! -e "/usr/local/Installomator/Installomator.sh" ]; then
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Installomator.sh?v=123$(date +%s) | bash
fi
if [ ! -e "/usr/local/bin/dialog" ]; then
	/usr/local/Installomator/Installomator.sh swiftdialog NOTIFY=silent BLOCKING_PROCESS_ACTION=kill
fi
if [ ! -e "/Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify" ]; then
	/usr/local/Installomator/Installomator.sh depnotify NOTIFY=silent BLOCKING_PROCESS_ACTION=kill
fi

if [ "$SHOWDIALOG" == "Y" ]; then
	echo "Dialog will open"
	/usr/local/bin/dialog dialog --title "Purple Managed macOS Updates" --message "**WARNING: Restart Required** \n\nYou are about to install an OS update which could take up to 1 hour 30 minutes to install. \n\n Please confirm you have saved all work and wish to continue?" --icon "https://www.apple.com/newsroom/images/product/os/macos/standard/Apple-WWDC22-macOS-Ventura-Spotlight-show-220606_big.jpg.large.jpg" --overlayicon warning --ontop --button1text "Continue" --button1shellaction "curl -s https://raw.githubusercontent.com/grahampugh/erase-install/main/erase-install.sh | sudo bash /dev/stdin --reinstall --current-user --depnotify --check-power --power-wait-limit 180 --update" --button2text "Later"

else
	echo "Dialog will not open"
	echo Continuing...
	curl -s https://raw.githubusercontent.com/grahampugh/erase-install/main/erase-install.sh | sudo bash /dev/stdin --reinstall --current-user --depnotify --check-power --power-wait-limit 180 --update
fi

#PROMPTS WITH INSTALL

#EXITS
exit 0
