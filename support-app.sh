#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Support App Install Script
#
# SYNOPSIS
# support-app.sh
# FOR INITIAL DEPLOYMENT OR ENROLMENT USE ONLY
#########################################################################
#


#Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Logs/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

curl -s -L -o /Library/Caches/com.purplecomputing.mdm/Apps/SA1.pkg https://github.com/root3nl/SupportApp/releases/download/v2.4.2/Support.2.4.2.pkg
curl -s -L -o /Library/Caches/com.purplecomputing.mdm/Apps/SA2.pkg https://github.com/root3nl/SupportApp/releases/download/v2.4.2/SupportHelper1.0.pkg


echo "-- INSTALLING SUPPORT APP --"

installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/SA1.pkg -target /
installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/SA2.pkg -target /

echo "Status: Cleaning up after the installer" >> ${logfile}
echo "Status: Cleaning up after the ZeroTier installer" >> $deplog
rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/SA1.pkg /Library/Caches/com.purplecomputing.mdm/Apps/SA2.pkg
sleep 1
