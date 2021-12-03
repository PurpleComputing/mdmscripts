# LAUNCH DEPNOTIFY FOR ENROLMENT
sudo -u $(stat -f "%Su" /dev/console) /bin/sh <<'END'
open -a /Applications/Utilities/DEPNotify.app --args -fullScreen