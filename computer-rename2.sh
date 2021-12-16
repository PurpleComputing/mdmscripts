#!/bin/sh
FullName=$(sudo -u $(stat -f "%Su" /dev/console) id -F)
ComputerModel=$(/usr/sbin/system_profiler SPHardwareDataType | grep 'Model Name' | cut -d":" -f2)
ComputerName=$(echo $FullName$ComputerModel | sed -e "s/ /-/g")
sudo /usr/sbin/scutil --set HostName "$ComputerName"
sudo /usr/sbin/scutil --set LocalHostName "$ComputerName"
sudo /usr/sbin/scutil --set ComputerName "$ComputerName"

/usr/sbin/scutil --set HostName "$computerName"
/usr/sbin/scutil --set LocalHostName "$computerName"
/usr/sbin/scutil --set ComputerName "$computerName"
