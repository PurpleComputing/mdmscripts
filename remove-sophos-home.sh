#!/bin/bash
echo "Remove Sophos Home"
sudo pkill -9 "Sophos*"
sudo rm -r /Library/Sophos\ Anti-Virus
sudo rm -r /Library/LaunchDaemons/com.sophos.*
sudo rm -r /Library/LaunchAgents/com.sophos.*
sudo rm -r /Library/Preferences/com.sophos.*
sudo rm -r /Library/Logs/Sophos\ Anti-Virus.log
sudo rm -r ~/Library/Logs/Sophos\ Anti-Virus/Scans/
sudo rm -r /Library/Application\ Support/Sophos/
sudo rm -r /Applications/Sophos
sudo rm -r /Applications/Sophos\ Anti-Virus.app
sudo rm -r /Applications/Sophos\ Home.app
sudo rm -r /Applications/Remove\ Sophos\ Anti-Virus.app/
sudo rm -r /Applications/Remove\ Sophos\ Home.app/
sudo rm -r /Library/SophosCBR
sudo rm -r /var/db/receipts/com.sophos.*
sudo rm -r /Library/Extensions/Sophos*
sudo rm -r /Library/Frameworks/SAVI-pyexec.framework 
sudo rm -r /Library/Frameworks/SAVI.framework 
sudo rm -r /Library/Frameworks/SophosGenericsCommon.framework
sudo rm -r /Library/Frameworks/SophosGenericsCore.framework
