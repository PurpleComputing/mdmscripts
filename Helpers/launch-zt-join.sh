#!/bin/sh
cd /Library/Application\ Support/Purple/
if [ "$SHOWDIALOG" == "Y" ]; then
    echo "Dialog will open"
    ./zt-dialog.sh &
    ./join-zt-network.sh
    exit 0
else
    echo "Dialog will not open"
    ./join-zt-network.sh
    exit 0
fi
