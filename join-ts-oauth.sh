#!/bin/sh
echo "*** PURPLE LAUNCH TAILSCALE SCRIPT ***"
###############################################################################################
#
#                                                        ******      
#                                        *...../    /    ******               
# **************  *****/  *****/*****/***/*************/ ******  /**********      
# ******/..*****/ *****/  *****/********//******/ ,*****/******,*****  ,*****/    
# *****/    ***** *****/  *****/*****/    *****/   /**************************    
# *******//*****/ *************/*****/    *********************/*******./*/*  ())
# *************    ******/*****/*****/    *****/******/. ******   ********** (()))
# *****/                                  *****/                              ())
# *****/                                  *****/                                  
#
############################################################################################### 
# NOTICE: MAC SPECIFIC SCRIPT, USING MOSYLE VARIABLES
###############################################################################################
#TAILSCALEAUTHKEY=
#SESSIONEXPIRY=

APPNA="Tailscale"
DIR="/Applications/$APPNA.app"


if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo "$APPNA is installed."
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "$APPNA is not installed."
  /usr/local/bin/dialog dialog --title "Tailscale Error" --message "**Tailscale Application is missing.**\n\n Please install Tailscale from Self-Service.app and try again... \n\n" --alignment centre --centericon --small --icon warning --overlayicon "/Applications/Tailscale.app" --button1text "Okay" 
  exit 1
fi
## DO NOT CHANGE OR SHARE BELOW


currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
TSENGINEER=$(echo $currentUser)
uid=$(id -u "$currentUser")
runAsUser() {  
  if [ "$currentUser" != "loginwindow" ]; then
	launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
	echo "no user logged in"
	exit 1
  fi
}

ZDTICKETNO=$(/usr/local/bin/dialog dialog --title none --message "**Helpdesk Ticket Number Required**\n\n Please enter the Zendesk Ticket Number below without hash: \n\n" --alignment centre --centericon --small --ontop --infobuttontext "Cancel" --infobuttonaction "https://purplecomputing.com/support" --icon warning --overlayicon "/Applications/Tailscale.app" --textfield "Ticket" --quitoninfo --button1text "Continue")
ZDTICKETRAW0=$(echo $ZDTICKETNO | awk -F: '{print $2}')
ZDTICKETRAW=$(echo $ZDTICKETRAW0)

echo 
killall dialog Dialog
rm -rf /var/tmp/dialog.log
touch /var/tmp/dialog.log
chmod 777 /var/tmp/dialog.log
sleep 2

sudo -u $(stat -f "%Su" /dev/console) osascript <<EOF
tell application "Tailscale"
	activate
end tell
EOF
#runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale logout
sleep 2
runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale login --authkey $TAILSCALEAUTHKEY --hostname "purplesupportsession-ticket-$ZDTICKETRAW-engineer-$TSENGINEER" --advertise-tags="tag:$TSTAG?ephemeral=false&preauthorized=true"
runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale set --hostname "purplesupportsession-ticket-$ZDTICKETRAW-engineer-$TSENGINEER"

/usr/local/bin/dialog dialog --title "Tailscale Session Started" --message "**Session Control**\n\n Your session will end automatically based on the countdown below. \n\n **Leave this window open in the background whilst you are working...**" --alignment centre --centericon --big --icon warning --overlayicon "/Applications/Tailscale.app" --button1text "End Session Now" --timer $SESSIONEXPIRY --button1shellaction "launchctl asuser $(id -u "$currentUser") /Applications/Tailscale.app/Contents/MacOS/Tailscale logout"
sleep 3
runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale logout
sleep 3
runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale switch $TAILSCALENET

if [ -n "$ZTNETID" ]; then
    echo "ZeroTier Variable found"
    /usr/local/bin/zerotier-cli leave $ZTNETID
    sleep 5
    runAsUser /usr/local/bin/zerotier-cli leave $ZTNETID
else
    echo 
    exit 0
fi
