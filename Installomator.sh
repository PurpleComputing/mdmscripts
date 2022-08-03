#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   Installomator.sh -- Installs or updates Installomator
#
# SYNOPSIS
#   sudo Installomator.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.7
#
#   - 1.0 Michael Tanner, 03.08.2022 Initial Build
#
####################################################################################################
# Script to download and install 1Password 7.
# Only works on Intel systems.
#

cd /Library/Caches/com.purplecomputing.mdm/
mkdir -p Apps
cd Apps
rm -rf Installomator*
REPO=Installomator/Installomator
DLURL=$(curl -s https://api.github.com/repos/${REPO}/releases/latest | awk -F\" '/browser_download_url.*.pkg/{print $(NF-1)}')
echo Download is $DLURL
curl -L $DLURL -O
installer -pkg Installomator*.pkg -target /
rm -rf Installomator*
/usr/local/Installomator/Installomator.sh -v
