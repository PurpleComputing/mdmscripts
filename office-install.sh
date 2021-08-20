#!/bin/bash
###
# File: Get-Office-Last-Version.sh
# File Created: 2020-07-17 10:35:40
# Usage : Install Office365 applications in the last version available on macadmins site.
# Parameters : 
# full : Install the full suite
# word : Install Word
# excel : Install Excel
# powerpoint : Install Powerpoint
# onedrive : Install OneDrive
# outlook : Install Outlook
# onenote : Install OneNote
# Example : ./Get-Office-Last-Version.sh full
# Example : ./Get-Office-Last-Version.sh word excel powerpoint
# Author: Benoit-Pierre Studer
# -----
# HISTORY:
# 2020-07-27	Benoit-Pierre Studer	Fixed typos
# 2020-07-23	Benoit-Pierre Studer	Added SHA256 check
###

###

function install_software () {
    SOFTWARE_ID=$1
    SOFTWARE_NAME=$2
    echo "Installing ${SOFTWARE_NAME}"
    URL=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/download/text()' -)
    VERSION=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/cfbundleversion/text()' -)
    SHA256=$(echo "${LATEST_XML}" | xmllint --xpath '//latest/package[id="'${SOFTWARE_ID}'"]/sha256/text()' -)
    echo "URL : ${URL}"
    echo "Version : ${VERSION}"
    echo "SHA256 : ${SHA256}"

    cd ${TEMP_PATH}
    echo "Downloading ${SOFTWARE_NAME}"
    curl -s -L -o "${SOFTWARE_NAME}.pkg" ${URL}
    if [[ $? == 0 ]]; then
        echo ">> Done"
    else
        echo "[ERROR] Curl command failed with: $curlResult"
        exit 1
    fi

    echo "Verifying Checksum"
    CHECKSUM=$(shasum -a 256 ${SOFTWARE_NAME}.pkg | awk -F" " '{print $1}')
    
    if [[ $CHECKSUM == $SHA256 ]]; then 
        echo ">> Checksum OK"
    else
        echo "[ERROR] Invalid checksum detected. Exiting..."
        exit 1
    fi

    echo "Installing ${SOFTWARE_NAME}"
    /usr/sbin/installer -pkg "${SOFTWARE_NAME}.pkg" -target /
    if [[ $? == 0 ]]; then
        echo ">> Done"
    else
        echo "[ERROR] Unable to install ${SOFTWARE_NAME}"
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
            install_software "com.microsoft.word.standalone.365" "Word"
            ;;
        excel)
            install_software "com.microsoft.excel.standalone.365" "Excel"
            ;;
        powerpoint)
            install_software "com.microsoft.powerpoint.standalone.365" "Powerpoint"
            ;;
        onedrive)
            install_software "com.microsoft.onedrive.standalone" "OneDrive"
            ;;
        onenote)
            install_software "com.microsoft.onenote.standalone.365" "OneNote"
            ;;
        outlook)
            install_software "com.microsoft.outlook.standalone.365" "Outlook"
            ;;
        full)
            install_software "com.microsoft.office.suite.365" "Office365"
            ;;
        *)
            echo "unknown parameter"
    esac
done
echo "Cleaning up ${TEMP_PATH}"
rm -rf ${TEMP_PATH}
echo ">> Done"
exit 0
