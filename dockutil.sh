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
#   Version: 1.0
#
#   - 1.0 Michael Tanner, 31.03.21
#
####################################################################################################
#
#
#

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg
rm -rf /tmp/dockutil.pkg

os_ver=${1:-$(sw_vers -productVersion)}
if [[ "$os_ver" == 10.* ]]; then
	echo "macOS Old School"
    curl -o /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/dockutil.pkg
elif [[ "$os_ver" == 11.* ]]; then
	echo "macOS Big Sur"
    curl -o /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/dockutil.pkg
elif [[ "$os_ver" == 12.* ]]; then
	echo "macOS Monterey"
    curl -o /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/dockutil-swift.pkg
    echo "Downloaded Dockutil Swift Version"
else
	echo "(Mac) OS X something"
    curl -o /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/dockutil-swift.pkg
    echo "Downloaded Dockutil Swift Version"
fi
sleep 10
installer -pkg /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg -target /

rm -rf /Library/Caches/com.purplecomputing.mdm/Apps/dockutil.pkg
