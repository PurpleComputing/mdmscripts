#!/bin/bash
###
# File: Install or update to the latest version - Microsoft Products
# File Created: 2021-07-01 15:58:40
# Usage : Install Office365 applications in the last version available on macadmins site.
# Parameters : 
# full : Install the full suite
# word : Install Word
# excel : Install Excel
# powerpoint : Install Powerpoint
# onedrive : Install OneDrive
# outlook : Install Outlook
# onenote : Install OneNote
# teams : Install Teams
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
###

###

function install_software () {
    SOFTWARE_ID=$1
    SOFTWARE_NAME=$2
    SOFTWARE_LOCATION=$3
    VERSION=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/cfbundleversion/text()' -)
    deplog="/var/tmp/depnotify.log"

if [[ ${SOFTWARE_LOCATION} != "SUITE" ]]; then

# Get the version number of the currently-installed App, if any.
    if [[ -e "${SOFTWARE_LOCATION}" ]]; then
        echo "Checking Installed Version of ${SOFTWARE_NAME}"
        echo "Status: Checking Installed Version of ${SOFTWARE_NAME}" >> ${deplog}


		CURRENTINSTALLEDVER=`/usr/bin/defaults read "${SOFTWARE_LOCATION}/Contents/Info" CFBundleVersion`
        echo "Current installed version is: $CURRENTINSTALLEDVER"
        echo "Status: Current installed version is: $CURRENTINSTALLEDVER" >> ${deplog}
        if [[ ${VERSION} = ${CURRENTINSTALLEDVER} ]]; then
            echo "${SOFTWARE_NAME} is current. Exiting"
            echo "Status: ${SOFTWARE_NAME} is current. Exiting" >> ${deplog}
            exit 0
        fi
	fi
fi
	    echo "Status: Installing ${SOFTWARE_NAME}" >> ${deplog}
	    echo "Installing ${SOFTWARE_NAME}"
	   	URL=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/download/text()' -)
		SHA256=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/sha256/text()' -)
		echo "URL : ${URL}"
		echo "Version : ${VERSION}"
		echo "SHA256 : ${SHA256}"

		cd ${TEMP_PATH}
		echo "Downloading ${SOFTWARE_NAME}"
		echo "Status: Downloading ${SOFTWARE_NAME}" >> ${deplog}
		curl -s -L -o "${SOFTWARE_NAME}.pkg" ${URL}
		if [[ $? == 0 ]]; then
			echo ">> Done"
		else
			echo "[ERROR] Curl command failed with: $curlResult"
 	  		echo "Status: [ERROR] Curl command failed with: $curlResult" >> ${deplog}
			exit 1
		fi

		echo "Verifying Checksum"
        echo "Status: Verifying Checksum" >> ${deplog}
		CHECKSUM=$(shasum -a 256 ${SOFTWARE_NAME}.pkg | awk -F" " '{print $1}')
	
		if [[ $CHECKSUM == $SHA256 ]]; then 
			echo ">> Checksum OK"
            echo "Status: Checksum OK" >> ${deplog}
		else
			echo "[ERROR] Invalid checksum detected. Exiting..."
            echo "Status: [ERROR] Invalid checksum detected. Exiting..." >> ${deplog}
			exit 1
		fi

		echo "Installing ${SOFTWARE_NAME}"
        echo "Status: Installing ${SOFTWARE_NAME}" >> ${deplog}
		/usr/sbin/installer -pkg "${SOFTWARE_NAME}.pkg" -target /
		if [[ $? == 0 ]]; then
		    if [[ -e "/usr/local/bin/dockutil" ]]; then
				APPSHORTNAME=$(echo ${SOFTWARE_LOCATION} | cut -f3 -d'/' | sed -e 's/\.[^.]*$//')
				echo "Adding Dock Icon for ${APPSHORTNAME}"
				echo "Status: Adding Dock Icon for ${APPSHORTNAME}" >> ${deplog}
				dockutil --remove "${APPSHORTNAME}" --allhomes
				sleep 5
				dockutil --add "${SOFTWARE_LOCATION}" --position 1 --allhomes
		    fi
			echo ">> Done"
		else
			echo "[ERROR] Unable to install ${SOFTWARE_NAME}"
            echo "Status: [ERROR] Unable to install ${SOFTWARE_NAME}" >> ${deplog}
			exit 1
		fi
}

## Variables
MACADMINS_URL="https://macadmins.software/latest.xml"
TEMP_PATH="/tmp/apps"

# Main

if [[ -d "${TEMP_PATH}" ]]; then
    echo "Removing ${TEMP_PATH}"
    rm -rf ${TEMP_PATH}
fi
echo "Creating ${TEMP_PATH}"
mkdir ${TEMP_PATH}

echo "Downloading XML file"
LATEST_XML=$(curl -H "Accept: text/xml" -sfk ${MACADMINS_URL})
echo ">> Done"
echo "Collecting latest version"
LATEST_VERSION=$(echo "${LATEST_XML}" | xmllint --xpath "//latest/o365/text()" -)
echo "Latest version : ${LATEST_VERSION}"

for param in "$@"; do
    case $param in 
        word)
            install_software "com.microsoft.word.standalone.365" "Word" "/Applications/Microsoft Word.app"
            ;;
        excel)
            install_software "com.microsoft.excel.standalone.365" "Excel" "/Applications/Microsoft Excel.app"
            ;;
        powerpoint)
            install_software "com.microsoft.powerpoint.standalone.365" "Powerpoint" "/Applications/Microsoft PowerPoint.app"
            ;;
        onedrive)
            install_software "com.microsoft.onedrive.standalone" "OneDrive" "/Applications/OneDrive.app"
            ;;
        onenote)
            install_software "com.microsoft.onenote.standalone.365" "OneNote" "/Applications/Microsoft OneNote.app"
            ;;
        outlook)
            install_software "com.microsoft.outlook.standalone.365" "Outlook" "/Applications/Microsoft Outlook.app"
            ;;
		teams)
			install_software "com.microsoft.teams.standalone" "Teams" "/Applications/Microsoft Teams.app"
			;;
        full)
            install_software "com.microsoft.office.suite.365" "Office365" "SUITE"
            ;;
        *)
            echo "unknown parameter"
            
            
    esac
done
echo "Cleaning up ${TEMP_PATH}"
rm -rf ${TEMP_PATH}
echo ">> Done"
/bin/sleep 5
echo "Command: DeterminateManualStep: 1" >> ${deplog}
exit 0