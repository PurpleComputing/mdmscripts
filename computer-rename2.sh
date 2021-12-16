#!/bin/sh

FullName=$(sudo -u $(stat -f "%Su" /dev/console) id -F)
ComputerModel=$(/usr/sbin/system_profiler SPHardwareDataType | grep 'Model Name' | cut -d":" -f2)
ComputerName=$(echo $FullName$ComputerModel | sed -e "s/ /-/g" | sed -e "s/\./-/g" )
/usr/sbin/scutil --set HostName "$ComputerName"
/usr/sbin/scutil --set LocalHostName "$ComputerName"
/usr/sbin/scutil --set ComputerName "$ComputerName"
