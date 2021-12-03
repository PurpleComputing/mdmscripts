# LAUNCH DEPNOTIFY FOR ENROLMENT
sed -i -e 's/Quit/Q*uit/' /var/tmp/depnotify.log
sed -i -e 's/Restart/R*estart/' /var/tmp/depnotify.log
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
open -a /Applications/Utilities/DEPNotify.app --args -fullScreen