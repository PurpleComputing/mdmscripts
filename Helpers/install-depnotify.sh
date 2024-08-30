#!/bin/bash

# URL of the .pkg file to download
downloadUrl="https://store.prpl.uk/DEPNotify.pkg"

# Destination directory to store the downloaded .pkg file
destinationDirectory="/tmp/pkg-install"

# Create the destination directory if it doesn't exist
mkdir -p "$destinationDirectory"

# Download the .pkg file
curl -o "$destinationDirectory/DEPNotify.pkg" "$downloadUrl"

# Install the .pkg file
installer -pkg "$destinationDirectory/DEPNotify.pkg" -target /

rm -rf "$destinationDirectory/DEPNotify.pkg"
