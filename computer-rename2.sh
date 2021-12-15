#!/bin/sh
serial=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')
username=$(stat -f %Su /dev/console)
type=$(sysctl -n hw.model | cut -d "," -f 1 | tr -d '[0-9]_')
mac=$(networksetup -getmacaddress Wi-Fi | awk '{ field = substr($3,10,8) }; END{ print field }' | sed s/://g)
computerName="${username}-${type}-${mac}"

/usr/sbin/scutil --set HostName "$computerName"
/usr/sbin/scutil --set LocalHostName "$computerName"
/usr/sbin/scutil --set ComputerName "$computerName"