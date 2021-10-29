#!/bin/bash

# Set Pashua config location
PashuaConfig=/tmp/Pashua.config

# Download Pashua from our repo.
curl -o /tmp/Pashua.zip https://raw.githubusercontent.com/PurpleComputing/mdmscripts/main/Helpers/Pashua.zip

# Extract Pashua
cd /tmp
unzip Pashua.zip

# Create Pashua config file
echo "*.title=Gathering User Info" >> $PashuaConfig
echo "*.autoclosetime = 5" >> $PashuaConfig
echo "*.floating = 1" >> $PashuaConfig
echo "fullname.type = textfield" >> $PashuaConfig
echo "fullname.label = Enter your full name" >> $PashuaConfig
echo "fullname.default = Firstname Lastname" >> $PashuaConfig
echo "fullname.width = 340" >> $PashuaConfig
echo "email.type = textfield" >> $PashuaConfig
echo "email.label = Enter your email address" >> $PashuaConfig
echo "email.default = name@domain.com" >> $PashuaConfig
echo "email.width = 340" >> $PashuaConfig

# Launch Pashua to gather the info

/tmp/Pashua.app/Contents/MacOS/Pashua $PashuaConfig

# OLD METHOD - Open a dialog window asking for the email address of the user and assign to the UserID variable
# OLD METHOD - UserID=$(osascript -e 'display dialog "Please enter the email address for the person who will be using this computer" with title "Computer Assignment Question 1 of 2" default answer "@berkshireifa.com" buttons {"Next"} default button 1' | cut -f3 -d":")

# OLD METHOD - Open a dialog window asking for the Full Name of the user and assign to the realName variable
# OLD METHOD - realName=$(osascript -e 'display dialog "Please enter the full name for the person who will be using this computer" with title "Computer Assignment Question 2 of 2" default answer "Firstname Lastname" buttons {"Next"} default button 1' | cut -f3 -d":")

# Use jamf recon to set the UserID variable to the endUsername [Assigned User] parameter, also send the Full Name and Email Address
# jamf recon -endUsername "${UserID}" -realname "${realName}" -email "${UserID}"

# Other options include
# -assetTag The Asset Tag of the computer
# -position The Position (Job Title) of the primary user
# -building The text representation of a Building in the JSS
# -department The text representation of a Department in the JSS
# -phone The Phone number of the primary user
# -room The Room that the computer is in