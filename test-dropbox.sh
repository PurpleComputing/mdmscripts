#!/bin/sh
curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15" -L https://dl-web.dropbox.com/installer?build_no=131.4.3968&plat=mac&tag=DBPREAUTH%3A%3Achrome%3A%3AeJyrVkosLcmIL8nPTs1TslJQKi4oSDUwKglP9nALC88z9PEtiExLDshLzK0yi_APqQjTMzQzNjKxMDAxsVTSASpPLS7OzM-Lz0wBaja0tDCzMDIyNDQzMQYqs7Q0NjewNDYzNTE2MjAxNTMwNTQCIstaAEDVIKE~%40META&tag_token=AVJC7OhbTB-egpL1UZKEi2J8d -o /var/tmp/DropBoxInstaller.dmg
hdiutil attach /var/tmp/DropBoxInstaller.dmg
cd /Volumes/Dropbox Installer/Dropbox.app/Contents/MacOS/
./Dropbox Installer
hdiutil detach /Volumes/Dropbox Installer/
rm -rf /var/tmp/DropBoxInstaller.dmg
exit 0
