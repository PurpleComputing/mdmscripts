#!/bin/bash -x
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   AdobeAcrobatUpdate.sh -- Updates Adobe Acrobat Pro DC
#
# SYNOPSIS
#   sudo AdobeAcrobatUpdate.sh
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.6
#
#   - v.1.0 Joe Farage, 23.01.2015
#   - v.1.1 Joe Farage, 08.04.2015 : support for new Adobe Acrobat DC
#   - v.1.2 Deej, 10.11.2017: fork Reader script for Adobe Acrobat DC
#   - v.1.3 amartin253, 10.15.2019: Modify Latest Version to be hardcoded until a new source path can be determined since Adobe 
#    seems to have abandoned support of the previous site.
#   - v.1.4 Martyn Watts, 24.06.2021: removed the sed -e 's/20//' as this was breaking the 2021 downloads (Lines 47 & 63)
#   - v.1.5 Martyn Watts, 05.07.2021: fixed the latest version lookup (Lines 41-43)
#   - v.1.6 Martyn Watts, 28.09.2021: Added Open Console Parameter to use with TeamViewer
#
####################################################################################################
# Script to download and install Adobe Acrobat Updates.
# Only works on Intel systems.

dmgfile="acrobat.dmg"
logfile="/Library/Logs/AdobeAcrobatDCUpdateScript.log"

if [[ $@ == "openconsole" ]]; then
	open ${logfile}
fi

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
    ## Get OS version and adjust for use with the URL string
    OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

    ## Set the User Agent string for use with curl
    userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

    # Get the latest Update available from Adobe's Acrobat Support page.
    # https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html
    latestver=$(curl -s https://helpx.adobe.com/acrobat/release-note/release-notes-acrobat-reader.html | grep -m2 -A3 '>Focus' | grep '<a href' | cut -f3 -d">" | sed 's/.*(//' | cut -f1 -d ")")


    echo "Latest Version is: $latestver"
   # latestvernorm=`echo ${latestver} | sed -e 's/20//'`
    latestvernorm=${latestver}
    # Get the version number of the currently-installed Adobe Acrobat, if any.
    if [ -e "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" ]; then
        currentinstalledver=`/usr/bin/defaults read /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app/Contents/Info CFBundleShortVersionString`
        echo "Current installed version is: $currentinstalledver"
        if [ ${latestvernorm} = ${currentinstalledver} ]; then
            echo "Adobe Acrobat DC is current. Exiting"
            exit 0
        fi
    else
        currentinstalledver="none"
        echo "Adobe Acrobat DC is not installed"
    fi


  # ARCurrVersNormalized=$( echo $latestver | sed -e 's/[.]//g' -e 's/20//' )
    ARCurrVersNormalized=$( echo $latestver | sed -e 's/[.]//g' )
    echo "ARCurrVersNormalized: $ARCurrVersNormalized"
    url=""
    url1="http://ardownload.adobe.com/pub/adobe/acrobat/mac/AcrobatDC/${ARCurrVersNormalized}/AcrobatDCUpd${ARCurrVersNormalized}.dmg"
    url2=""

    #Build URL  
    url=`echo "${url1}${url2}"`
    echo "Latest version of the URL is: $url"


    # Compare the two versions, if they are different or Adobe Acrobat is not present then download and install the new version.
    if [ "${currentinstalledver}" != "${latestvernorm}" ]; then
        /bin/echo "`date`: Current Acrobat DC version: ${currentinstalledver}" >> ${logfile}
        /bin/echo "`date`: Available Acrobat DC version: ${latestver} => ${latestvernorm}" >> ${logfile}
        /bin/echo "`date`: Downloading newer version." >> ${logfile}
        /usr/bin/curl -o /tmp/acrobat.dmg ${url}
        /bin/echo "`date`: Mounting installer disk image." >> ${logfile}
        /usr/bin/hdiutil attach /tmp/acrobat.dmg -nobrowse -quiet
        /bin/echo "`date`: Installing..." >> ${logfile}
        /usr/sbin/installer -pkg /Volumes/AcrobatDCUpd${ARCurrVersNormalized}/AcrobatDCUpd${ARCurrVersNormalized}.pkg -target /

        /bin/sleep 10
        /bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
        /usr/bin/hdiutil detach /Volumes/AcrobatDCUpd${ARCurrVersNormalized} -quiet
        /bin/sleep 10
        /bin/echo "`date`: Deleting disk image." >> ${logfile}
        /bin/rm /tmp/${dmgfile}

        #double check to see if the new version got updated
        newlyinstalledver=`/usr/bin/defaults read /Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app/Contents/Info CFBundleShortVersionString`
        if [ "${latestvernorm}" = "${newlyinstalledver}" ]; then
            /bin/echo "`date`: SUCCESS: Adobe Acrobat has been updated to version ${newlyinstalledver}" >> ${logfile}
       # /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "Adobe Acrobat Updated" -description "Adobe Acrobat has been updated." &
        else
            /bin/echo "`date`: ERROR: Adobe Acrobat update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
            /bin/echo "--" >> ${logfile}
            exit 1
        fi

    # If Adobe Acrobat is up to date already, just log it and exit.       
    else
        /bin/echo "`date`: Adobe Acrobat is already up to date, running ${currentinstalledver}." >> ${logfile}
        /bin/echo "--" >> ${logfile}
    fi  
else
    /bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
fi

exit 0
