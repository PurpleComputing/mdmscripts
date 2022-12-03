#!/bin/bash
VARTITLE="Create Ticket"
VARURL="https://www.cognitoforms.com/PurpleComputingLimited/contactandsupportform"
VARLOGO="https://raw.githubusercontent.com/PurpleComputing/image-repo/main/logo-padded.png"

/usr/local/bin/dialog dialog --webcontent $VARURL --big --title "$VARTITLE"  --message "" --icon $VARLOGO --overlayicon SF=envelope.badge.shield.half.filled --button1text "Close" --infobuttontext "Open in Browser" --infobuttonaction "https://purplecomputing.com/support" -d --ontop 
