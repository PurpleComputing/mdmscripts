curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Safari/605.1.15" -L https://www.dropbox.com/download?plat=mac > /var/tmp/DropBoxInstaller.dmg
hdiutil attach /var/tmp/DropBoxInstaller.dmg
cd /Volumes/Dropbox Installer/Dropbox.app/Contents/MacOS/
./Dropbox Installer
hdiutil detach /Volumes/Dropbox Installer/
rm -rf /var/tmp/DropBoxInstaller.dmg
exit 0
