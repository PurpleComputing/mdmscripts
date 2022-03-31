#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   dockutil.sh -- Installs or updates dockutil
#
# SYNOPSIS
#   sudo dockutil.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.1
#
#   - 1.0 Michael Tanner, 31.03.21
#   - 1.1 Michael Tanner, 31.03.21 - Added Variables 
#
####################################################################################################
#
#
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/


APPINSTPATH=/Library/Caches/com.purplecomputing.mdm/Apps/
PRPLGITURL="https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers"

rm -rf $APPINSTPATHdockutil*.pkg
rm -rf /tmp/dockutil.pkg


os_ver=${1:-$(sw_vers -productVersion)}
if [[ "$os_ver" == 10.* ]]; then
	echo "Mac is running macOS Old School"
    INSTALLERNME=dockutil.pkg
    echo "Chosen $INSTALLERNME"
    curl -o $APPINSTPATH$INSTALLERNME $PRPLGITURL/$INSTALLERNME -s
elif [[ "$os_ver" == 11.* ]]; then
	echo "Mac is running macOS Big Sur"
    INSTALLERNME=dockutil.pkg
    echo "Chosen $INSTALLERNME"
    curl -o $APPINSTPATH$INSTALLERNME $PRPLGITURL/$INSTALLERNME -s
elif [[ "$os_ver" == 12.* ]]; then
	echo "Mac is running macOS Monterey"
    INSTALLERNME=dockutil-swift.pkg
    echo "Chosen $INSTALLERNME"
    curl -o $APPINSTPATH$INSTALLERNME $PRPLGITURL/$INSTALLERNME -s
    echo "Downloaded Dockutil Swift Version"
else
	echo "Mac is running macOS something new..."
    INSTALLERNME=dockutil-swift.pkg
    echo "Chosen $INSTALLERNME"
    curl -o $APPINSTPATH$INSTALLERNME $PRPLGITURL/$INSTALLERNME -s
    echo "Downloaded Dockutil Swift Version"
fi
sleep 3
installer -pkg $APPINSTPATH$INSTALLERNME -target /

rm -rf $APPINSTPATH$INSTALLERNME
