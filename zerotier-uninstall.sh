#!/bin/bash
################################################################################################
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
################################################################################################
# ZEROTIER FOR MAC UNINSTALL SCRIPT
################################################################################################

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

if [ "$UID" -ne 0 ]; then
	echo "Must be run as root; try: sudo $0"
	exit 1
fi

if [ ! -f '/Library/LaunchDaemons/com.zerotier.one.plist' ]; then
	echo 'ZeroTier One does not seem to be installed.'
	exit 1
fi

cd /

echo 'Stopping any running ZeroTier One service...'
launchctl unload '/Library/LaunchDaemons/com.zerotier.one.plist' >>/dev/null 2>&1
sleep 1
killall -TERM zerotier-one >>/dev/null 2>&1
sleep 1
killall -KILL zerotier-one >>/dev/null 2>&1

echo "Removing ZeroTier One files..."

rm -rf '/Applications/ZeroTier One.app'
rm -rf '/Applications/ZeroTier.app'
rm -f '/usr/local/bin/zerotier-one' '/usr/local/bin/zerotier-idtool' '/usr/local/bin/zerotier-cli' '/Library/LaunchDaemons/com.zerotier.one.plist'

rm -rf '/Library/Application Support/ZeroTier/One'

echo ZeroTier has been removed.

exit 0
