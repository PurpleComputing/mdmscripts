#!/bin/sh
echo Tidying Default Dock... >> /var/tmp/depnotify.log
/usr/local/bin/dockutil --remove 'Pages' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Numbers' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Keynote' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Podcasts' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Music' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'System Preferences' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'TV' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Calendar' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Contacts' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Photos' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Reminders' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Notes' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'App Store' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Messages' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'FaceTime' --allhomes --no-restart
sleep .5
/usr/local/bin/dockutil --remove 'Mail' --allhomes --no-restart
sleep 1
