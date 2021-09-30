#!/bin/bash
###
# File: Install or update to the latest version - Microsoft Products
# File Created: 2021-07-01 15:58:40
# Usage : Install Office365 applications in the last version available on macadmins site.
# Parameters :
#
# full : Install the full suite
# word : Install Word
# excel : Install Excel
# powerpoint : Install Powerpoint
# onedrive : Install OneDrive
# outlook : Install Outlook
# onenote : Install OneNote
# teams : Install Teams
# remote-desktop :  Install MS Remote Desktop
#
# full-oc : Install the full suite with open console
# word-oc : Install Word with open console
# excel-oc : Install Excel with open console
# powerpoint-oc : Install Powerpoint with open console
# onedrive-oc : Install OneDrive with open console
# outlook-oc : Install Outlook with open console
# onenote-oc : Install OneNote with open console
# teams-oc : Install Teams with open console
# remote-desktop-oc :  Install MS Remote Desktop
#
# full-2016 : Install the 2016 full suite
# word-2016 : Install Word 2016
# excel-2016 : Install Excel 2016
# powerpoint-2016 : Install Powerpoint 2016
# outlook-2016 : Install Outlook 2016
#
# full-2016-oc : Install the 2016 full suite with open console
# word-2016-oc : Install Word 2016 with open console
# excel-2016-oc : Install Excel 2016 with open console
# powerpoint-2016-oc : Install Powerpoint 2016 with open console
# outlook-2016-oc : Install Outlook 2016 with open console
#
# full-2011 : Install the 2016 full suite
# full-2011-oc : Install the 2016 full suite with open console
#
# Example : ./Install or update to the latest version - Microsoft Products full
# Example : ./Install or update to the latest version - Microsoft Products word excel powerpoint
# Author: Benoit-Pierre Studer
# -----
# HISTORY:
# 2020-07-27	Benoit-Pierre Studer	Fixed typos
# 2020-07-23	Benoit-Pierre Studer	Added SHA256 check
# 2021-06-30	Martyn Watts			Added Installed version checks to avoid installing if not needed
# 2021-07-01	Martyn Watts			Added Dock Icon creation using dockutil (Prerequisite install)
# 2021-07-09	Martyn Watts			Added DEPNotify Progress Output
# 2021-09-24	Martyn Watts			Added Check to see if dockutil is installed to make the script more resilient
# 2021-09-28	Martyn Watts			Added Check for full-oc (Full Install with Open Console for TeamViewer Installs) also added better logging
###

###

# Check OS version
OSvers=$( sw_vers -productVersion )




function install_software () {
    SOFTWARE_ID=$1
    SOFTWARE_NAME=$2
    SOFTWARE_LOCATION=$3
    OPEN_CONSOLE=$4
    VERSION=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/cfbundleversion/text()' -)

echo "Script version: ${scriptver}" >> "${logfile}"
echo "Script version: ${scriptver}" >> ${deplog}
   
if [[ ${OPEN_CONSOLE} == "openconsole" ]]; then
	open ${logfile}
	open ${deplog}
fi


if [[ ${SOFTWARE_LOCATION} != "SUITE" ]]; then

# Get the version number of the currently-installed App, if any.
    if [[ -e "${SOFTWARE_LOCATION}" ]]; then
        echo "Checking Installed Version of ${SOFTWARE_NAME}" >> "${logfile}"
        echo "Status: Checking Installed Version of ${SOFTWARE_NAME}" >> ${deplog}


		CURRENTINSTALLEDVER=`/usr/bin/defaults read "${SOFTWARE_LOCATION}/Contents/Info" CFBundleVersion`
        echo "Current installed version is: $CURRENTINSTALLEDVER" >> "${logfile}"
        echo "Status: Current installed version is: $CURRENTINSTALLEDVER" >> ${deplog}
        if [[ ${VERSION} = ${CURRENTINSTALLEDVER} ]]; then
            echo "${SOFTWARE_NAME} is current. Exiting" >> "${logfile}"
            echo "Status: ${SOFTWARE_NAME} is current. Exiting" >> ${deplog}
            exit 0
        fi
	fi
fi
	    echo "Status: Installing ${SOFTWARE_NAME}" >> ${deplog}
	    echo "Installing ${SOFTWARE_NAME}" >> "${logfile}"
	   	URL=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/download/text()' -)
		SHA256=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/sha256/text()' -)
		echo "URL : ${URL}" >> "${logfile}"
		echo "Version : ${VERSION}" >> "${logfile}"
		echo "SHA256 : ${SHA256}" >> "${logfile}"

		cd ${TEMP_PATH}
		echo "Downloading ${SOFTWARE_NAME}" >> "${logfile}"
		echo "Status: Downloading ${SOFTWARE_NAME}" >> ${deplog}
		curl -s -L -o "${SOFTWARE_NAME}.pkg" ${URL}
		if [[ $? == 0 ]]; then
			echo ">> Done" >> "${logfile}"
		else
			echo "[ERROR] Curl command failed with: $curlResult" >> "${logfile}"
 	  		echo "Status: [ERROR] Curl command failed with: $curlResult" >> ${deplog}
			exit 1
		fi

		echo "Verifying Checksum" >> "${logfile}"
        echo "Status: Verifying Checksum" >> ${deplog}
		CHECKSUM=$(shasum -a 256 ${SOFTWARE_NAME}.pkg | awk -F" " '{print $1}')
	
		if [[ $CHECKSUM == $SHA256 ]]; then 
			echo ">> Checksum OK" >> "${logfile}"
            echo "Status: Checksum OK" >> ${deplog}
		else
			echo "[ERROR] Invalid checksum detected. Exiting..." >> "${logfile}"
            echo "Status: [ERROR] Invalid checksum detected. Exiting..." >> ${deplog}
			exit 1
		fi

		echo "Installing ${SOFTWARE_NAME}" >> "${logfile}"
        echo "Status: Installing ${SOFTWARE_NAME}" >> ${deplog}
		/usr/sbin/installer -pkg "${SOFTWARE_NAME}.pkg" -target /
		if [[ $? == 0 ]]; then
		    if [[ -e "/usr/local/bin/dockutil" ]]; then
				APPSHORTNAME=$(echo ${SOFTWARE_LOCATION} | cut -f3 -d'/' | sed -e 's/\.[^.]*$//')
				echo "Adding Dock Icon for ${APPSHORTNAME}" >> "${logfile}"
				echo "Status: Adding Dock Icon for ${APPSHORTNAME}" >> ${deplog}
				dockutil --remove "${APPSHORTNAME}" --allhomes
				sleep 5
				dockutil --add "${SOFTWARE_LOCATION}" --position 1 --allhomes
		    fi
			echo ">> Done" >> ${logfile}
		else
			echo "[ERROR] Unable to install ${SOFTWARE_NAME}" >> "${logfile}"
            echo "Status: [ERROR] Unable to install ${SOFTWARE_NAME}" >> ${deplog}
			exit 1
		fi
}

## Variables
MACADMINS_URL="https://macadmins.software/latest.xml"
TEMP_PATH="/tmp/apps"
deplog="/var/tmp/depnotify.log"
logfile="/tmp/OfficeInstallScript.log"
scriptver="3.2"
echo ${logfile}
echo ${scriptver}


# Main

if [[ -d "${TEMP_PATH}" ]]; then
    echo "Removing ${TEMP_PATH}"
    rm -rf ${TEMP_PATH}
fi
echo "Creating ${TEMP_PATH}"
mkdir ${TEMP_PATH}

echo "Downloading XML file" >> ${logfile}
LATEST_XML=$(curl -H "Accept: text/xml" -sfk ${MACADMINS_URL})
echo ">> Done" >> ${logfile}
echo "Collecting latest version" >> ${logfile}
LATEST_VERSION=$(echo "${LATEST_XML}" | xmllint --xpath "//latest/o365/text()" -)
echo "Latest version : ${LATEST_VERSION}" >> ${logfile}

for param in "$@"; do
    case $param in 
        word)
            install_software "com.microsoft.word.standalone.365" "Word" "/Applications/Microsoft Word.app" "noconsole"
            ;;
        excel)
            install_software "com.microsoft.excel.standalone.365" "Excel" "/Applications/Microsoft Excel.app" "noconsole"
            ;;
        powerpoint)
            install_software "com.microsoft.powerpoint.standalone.365" "Powerpoint" "/Applications/Microsoft PowerPoint.app" "noconsole"
            ;;
        onedrive)
            install_software "com.microsoft.onedrive.standalone" "OneDrive" "/Applications/OneDrive.app" "noconsole"
            ;;
        onenote)
            install_software "com.microsoft.onenote.standalone.365" "OneNote" "/Applications/Microsoft OneNote.app" "noconsole"
            ;;
        outlook)
            install_software "com.microsoft.outlook.standalone.365" "Outlook" "/Applications/Microsoft Outlook.app" "noconsole"
            ;;
	teams)
	    install_software "com.microsoft.teams.standalone" "Teams" "/Applications/Microsoft Teams.app" "noconsole"
	    ;;
        full)
            install_software "com.microsoft.office.suite.365" "Office365" "SUITE" "noconsole"
            ;;
        word-oc)
            install_software "com.microsoft.word.standalone.365" "Word" "/Applications/Microsoft Word.app" "openconsole"
            ;;
        excel-oc)
            install_software "com.microsoft.excel.standalone.365" "Excel" "/Applications/Microsoft Excel.app" "openconsole"
            ;;
        powerpoint-oc)
            install_software "com.microsoft.powerpoint.standalone.365" "Powerpoint" "/Applications/Microsoft PowerPoint.app" "openconsole"
            ;;
        onedrive-oc)
            install_software "com.microsoft.onedrive.standalone" "OneDrive" "/Applications/OneDrive.app" "openconsole"
            ;;
        onenote-oc)
            install_software "com.microsoft.onenote.standalone.365" "OneNote" "/Applications/Microsoft OneNote.app" "openconsole"
            ;;
        outlook-oc)
            install_software "com.microsoft.outlook.standalone.365" "Outlook" "/Applications/Microsoft Outlook.app" "openconsole"
            ;;
	teams-oc)
	    install_software "com.microsoft.teams.standalone" "Teams" "/Applications/Microsoft Teams.app" "openconsole"
	    ;;
        full-oc)
            install_software "com.microsoft.office.suite.365" "Office365" "SUITE" "openconsole"
            ;;     
        word-2016)
            install_software "com.microsoft.word.standalone.2016" "Word" "/Applications/Microsoft Word.app" "noconsole"
            ;;
        excel-2016)
            install_software "com.microsoft.excel.standalone.2016" "Excel" "/Applications/Microsoft Excel.app" "noconsole"
            ;;
        powerpoint-2016)
            install_software "com.microsoft.powerpoint.standalone.2016" "Powerpoint" "/Applications/Microsoft PowerPoint.app" "noconsole"
            ;;
        outlook-2016)
            install_software "com.microsoft.outlook.standalone.2016" "Outlook" "/Applications/Microsoft Outlook.app" "noconsole"
            ;;
        full-2016)
            install_software "com.microsoft.office.suite.2016" "Office2016" "SUITE" "noconsole"
            ;;
         word-2016-oc)
            install_software "com.microsoft.word.standalone.2016" "Word" "/Applications/Microsoft Word.app" "openconsole"
            ;;
        excel-2016-oc)
            install_software "com.microsoft.excel.standalone.2016" "Excel" "/Applications/Microsoft Excel.app" "openconsole"
            ;;
        powerpoint-2016-oc)
            install_software "com.microsoft.powerpoint.standalone.2016" "Powerpoint" "/Applications/Microsoft PowerPoint.app" "openconsole"
            ;;
        outlook-2016-oc)
            install_software "com.microsoft.outlook.standalone.2016" "Outlook" "/Applications/Microsoft Outlook.app" "openconsole"
            ;;
        full-2016-oc)
            install_software "com.microsoft.office.suite.2016" "Office2016" "SUITE" "openconsole"
            ;;
 	full-2011)
             install_software "com.microsoft.outlook.suite.2011" "Office2011" "SUITE" "noconsole"
            ;;
 	full-2011-oc)
             install_software "com.microsoft.outlook.suite.2011" "Office2011" "SUITE" "openconsole"
            ;;
        remote-desktop)
             install_software "com.microsoft.remotedesktop.standalone" "Microsoft Remote Desktop" "/Applications/Microsoft Remote Desktop.app" "noconsole"
            ;;
        remote-desktop-oc)
             install_software "com.microsoft.remotedesktop.standalone" "Microsoft Remote Desktop" "/Applications/Microsoft Remote Desktop.app" "openconsole"
            ;;
        *)
            echo "unknown parameter"
            
            
    esac
done
echo "Cleaning up ${TEMP_PATH}" >> ${logfile}
rm -rf ${TEMP_PATH}
echo ">> Done" >> ${logfile}
/bin/sleep 5
echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0
