#DEVSCRIPT

EIRUNCOMMAND="curl -s https://raw.githubusercontent.com/grahampugh/erase-install/main/erase-install.sh | sudo bash /dev/stdin --depnotify --check-power --power-wait-limit 180 ---erase --current-user --os=$MOSVERSION"
# VERSION MUST BE PASSED THROUGH CONSOLE (EXPORTED) FOR $MOSVERSION

export EIRUNCOMMAND
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
	/usr/local/bin/dialog dialog --title "Purple Managed macOS Erase" --message "**WARNING: MAC WILL SELF DESTRUCT!** \n\nYou are about to erase and re-install your Mac which could take up to 1 hour 30 minutes to complete. \n\n Please confirm you have saved all work to the cloud and have a full backup (if required)?" --blurscreen --icon "https://www.apple.com/newsroom/images/product/os/macos/standard/Apple-WWDC22-macOS-Ventura-Spotlight-show-220606_big.jpg.large.jpg" --overlayicon xmark.circle --ontop --button1text "Continue" --button1shellaction "$EIRUNCOMMAND" --button2text "Later"

else
	echo "Dialog will not open"
	echo Continuing...
	$EIRUNCOMMAND
fi

#PROMPTS WITH INSTALL

#EXITS
exit 0
