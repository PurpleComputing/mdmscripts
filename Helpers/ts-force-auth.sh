#!/bin/sh
echo "Start: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
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

# VARIABLES IN USE FROM CONSOLE
# TAILSCALEAUTHKEY
# TSSERVERIP

# DEFAULT VARIABLES
APPNA="Tailscale"
DIR="/Applications/$APPNA.app"
IP1=8.8.8.8
IP2=$(echo "$TSSERVERIP")
DT0=$(date)
echo "Execution Record for $DT0"

# SOURCES USER INFO FOR RUNASUSER COMMAND BELOW
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
uid=$(id -u "$currentUser")

# SIMPLIFIES RUN AS USER COMMAND FOR STANDARD USER ACCOUNTS WITHOUT SUDO RIGHTS
runAsUser() {
  if [ "$currentUser" != "loginwindow" ]; then
	launchctl asuser "$uid" sudo -u "$currentUser" "$@"
  else
  	echo 
	echo "no user logged in"
	echo 
	echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
	echo 
	exit 1
  fi
}

# CHECKS TAILSCALE IS PRESENT ON THE DEVICE
if [ -d "$DIR" ]; then
  ### Take action if $DIR exists ###
  echo 
  echo "$APPNA is installed."
  echo 
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo 
  echo "$APPNA is not installed."
  echo 
  echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
  echo 
  exit 1
fi

# OPENS TAILSCALE BEFORE CHECKS
runAsUser osascript -e 'tell application "Tailscale"' -e 'activate' -e 'end tell'

# GIVES TAILSCALE TIME TO OPEN AND CONNECT IF EMPLOYEE AUTHED
sleep 20

# PING GOOGLE FOR NEXT CHECK
PING1=$(ping -c 1 "$IP1" | grep -c from)

# PING TAILSCALE VPR FOR FIRST ATTEMPT
PING2=$(ping -c 1 "$IP2" | grep -c from)

# INTERNET CHECK
if [ "$PING1" -eq "1" ]; then
	echo 
	echo Internet is working
	echo 
else
	echo 
	echo NO INTERNET... Exit..
	echo 
	echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
	echo 
	exit 1
fi

# TAILSCALE ALREADY AUTHED CHECK
if [ "$PING2" -eq "1" ]; then
	echo 
	echo Server $IP2 is reachable, internet is working
	echo and the user is already authenticated
	echo 
	echo NO INTERVENTION WAS NEEDED
	echo 
	echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
	echo 
	exit 0

else
	echo 
	echo NO AUTH AUTHENTICATING...
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale logout
	killall Tailscale
	sleep 5
	runAsUser osascript -e 'tell application "Tailscale"' -e 'activate' -e 'end tell'
	sleep 20
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale up --authkey "$TAILSCALEAUTHKEY" --reset
	echo 
fi

# PING TAILSCALE VPR AFTER FIRST ATTEMPT
PING3=$(ping -c 1 "$IP2" | grep -c from)

# TAILSCALE FINAL AUTH CHECK
if [ "$PING3" -eq "1" ]; then
	echo 
	echo Server $IP2 is now reachable 
	echo internet is working and user is authenticated
	echo 
	echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"
	echo 
	exit 0
else
	echo 
	echo NO AUTH AUTHENTICATING...
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale logout
	killall Tailscale
	sleep 5
	runAsUser osascript -e 'tell application "Tailscale"' -e 'activate' -e 'end tell'
	sleep 20
	runAsUser /Applications/Tailscale.app/Contents/MacOS/Tailscale up --authkey "$TAILSCALEAUTHKEY" --reset
	echo 
fi

echo "End: *** PURPLE LAUNCH TAILSCALE FORCE AUTH SCRIPT ***"

exit 0
