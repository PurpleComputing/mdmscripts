#!/bin/sh
echo "*** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
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
#TSSERVERIP=

APPNA="Tailscale"
DIR="/Applications/$APPNA.app"
IP1=8.8.8.8
IP2=$(echo "$TSSERVERIP")

currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
TSUSER=$(echo $currentUser)
uid=$(id -u "$currentUser")
runAsUser() {
  if [ "$currentUser" != "loginwindow" ]; then
	launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
	echo "no user logged in"
	exit 1
  fi
}

if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo "$APPNA is installed."
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "$APPNA is not installed."
  exit 1
fi

sudo -u $(stat -f "%Su" /dev/console) osascript <<EOF
tell application "Tailscale"
	activate
end tell
EOF

#start first ping, remember its pid
ping -W 1 -c 1 $IP1 >/dev/null&
PID1=$!

# start second ping, remember its pid
ping -W 1 -c 1 $IP2 >/dev/null&
PID2=$!

# wait for pings to finish
if wait $PID1
then echo $IP1 is reachable, internet is working;
	else
	echo NO INTERNET... Exit..
	exit 1
fi

if wait $PID2
then echo $IP2 is reachable, internet is working and user is authenticated;
	exit 0
	else
	echo NO AUTH AUTHENTICATING
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale logout && killall Tailscale
	sleep 10
	sudo -u $(stat -f "%Su" /dev/console) osascript <<EOF
	tell application "Tailscale"
		activate
	end tell
	EOF
	sleep 5
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale up --authkey $TAILSCALEAUTHKEY --reset
fi
