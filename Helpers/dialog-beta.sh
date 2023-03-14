#!/bin/bash

# CHECKS IF INSTALLOMATOR IS INSTALLED AND INSTALLS IF NOT
if [ ! -e "/usr/local/Installomator/Installomator.sh" ]; then
	curl -s https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Installomator.sh | bash
fi

# CHECKS IF DIALOG IS INSTALLED AND INSTALLS IF NOT
if [ ! -e "/usr/local/bin/dialog" ]; then
	/usr/local/Installomator/Installomator.sh dialog BLOCKING_PROCESS_ACTION=quit_kill NOTIFY=silent
fi

apps=(
	"$PAPPNAME,$PAPPPATH"
)

# Dialog display settings, change as desired
title="Installing $PAPPNAME"
message="Downloading and installing the latest version of $PAPPNAME."

# location of dialog and dialog command file
dialogApp="/usr/local/bin/dialog"
dialog_command_file="/var/tmp/dialog.log"

# check we are running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "This script should be run as root"
  exit 1
fi

# *** functions

# execute a dialog command
function dialog_command(){
  echo "$1"
  echo "$1"  >> $dialog_command_file
}

function finalise(){
  dialog_command "progresstext: Installed $PAPPNAME"
  dialog_command "progress: complete"
  dialog_command "button1text: Done"
  dialog_command "button1: enable" 
  exit 0
}

function appCheck(){
dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): wait"
while [ ! -e "$(echo "$app" | cut -d ',' -f2)" ]
do
	sleep 2
done
dialog_command "progresstext: \"$(echo "$app" | cut -d ',' -f1)\""
dialog_command "listitem: $(echo "$app" | cut -d ',' -f1): ✅"
progress_index=$(( progress_index + 1 ))
echo "at item number $progress_index"
}

# *** end functions

# set progress total to the number of apps in the list
progress_total=${#apps[@]}

# set icon based on whether computer is a desktop or laptop
hwType=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book")  
if [ "$hwType" != "" ]; then
  icon="SF=laptopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
  else
  icon="SF=desktopcomputer.and.arrow.down,weight=thin,colour1=#51a3ef,colour2=#5154ef"
fi

dialogCMD="$dialogApp -p --title \"$title\" \
--message \"$message\" \
--icon \"$icon\" \
--progress $progress_total \
--button1text \"Please Wait\" \
--button1disabled"

# create the list of apps
listitems=""
for app in "${apps[@]}"; do
  listitems="$listitems --listitem '$(echo "$app" | cut -d ',' -f1)'"
done

# final command to execute
dialogCMD="$dialogCMD $listitems"

echo "$dialogCMD"

# Launch dialog and run it in the background sleep for a second to let thing initialise
eval "$dialogCMD" &
sleep 2

progress_index=0

(for app in "${apps[@]}"; do
  step_progress=$(( 1 + progress_index ))
  dialog_command "progress: $step_progress"
  appCheck &
done

wait)

# all done. close off processing and enable the "Done" button
finalise
