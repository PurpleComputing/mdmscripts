#!/bin/bash
arch=$(/usr/bin/arch)
if [ "$arch" == "arm64" ]; then
    echo "Apple Silicon - Installing Rosetta"
    echo "Apple Silicon - Installing Rosetta" >> ${deplog}
    sleep 1
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    echo "Rosetta 2 Now Installed" >> ${deplog}
    echo "Rosetta 2 Now Installed"
    sleep 5
elif [ "$arch" == "i386" ]; then
    echo "Intel - Skipping Rosetta" >> ${deplog}
    echo "Intel - Skipping Rosetta"
    sleep 1
else
    echo "Unknown Architecture" >> ${deplog}
    echo "Unknown Architecture"
    sleep 1
fi
exit 0
