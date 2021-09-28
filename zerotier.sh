#!/bin/sh
#########################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   ZeroTier Install Script
#
# SYNOPSIS
# zerotier.sh
#
#########################################################################
#
# HISTORY
#
#   Version: 1.1
#
#   - 1.0 Martyn Watts, 25.06.2021 Initial Script Template Build
#   - 1.1 Michael Tanner, 28.09.2021 Implement ZeroTier Install Script
#
#########################################################################
# Script to download and install 1Password 7.
#
curl -o /tmp/apps/ZT.pkg https://download.zerotier.com/dist/ZeroTier%20One.pkg
installer -pkg /tmp/apps/ZT.pkg -target /
rm -rf /tmp/apps/ZT.pkg
sleep 2s
/usr/local/bin/zerotier-cli join $@
