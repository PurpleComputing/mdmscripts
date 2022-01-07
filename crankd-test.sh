#!/bin/sh

# Setting LaunchDaemon Path
LDPath="/Library/LaunchDaemons/com.googlecode.pymacadmin.crankd.plist"
PrefsPath="/Library/Preferences/com.googlecode.pymacadmin.crankd.plist"
PyScriptPath="/Library/Application Support/crankd/CrankTools.py"
ShScriptPath="/Library/Caches/com.purplecomputing.mdm/Apps/mountscript.sh"

# Making Purple Cache directories for in the event that the helper script hasn't been run
mkdir -p /Library/Caches/com.purplecomputing.mdm/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Logs/
mkdir -p /Library/Caches/com.purplecomputing.mdm/Apps/

# Clone the pymacadmin git & Install crankd
cd /Library/Caches/com.purplecomputing.mdm/Apps/
git clone https://github.com/acdha/pymacadmin.git
cd /Library/Caches/com.purplecomputing.mdm/Apps/pymacadmin
sudo ./install-crankd.sh

# Create the launchdaemon
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $LDPath
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $LDPath
echo '<plist version="1.0">' >> $LDPath
echo '<dict>' >> $LDPath
echo '    <key>KeepAlive</key>' >> $LDPath
echo '    <true/>' >> $LDPath
echo '    <key>Label</key>' >> $LDPath
echo '    <string>com.googlecode.pymacadmin.crankd</string>' >> $LDPath
echo '    <key>ProgramArguments</key>' >> $LDPath
echo '    <array>' >> $LDPath
echo '        <string>/usr/local/sbin/crankd.py</string>' >> $LDPath
echo '    </array>' >> $LDPath
echo '    <key>RunAtLoad</key>' >> $LDPath
echo '    <true/>' >> $LDPath
echo '</dict>' >> $LDPath
echo '</plist>' >> $LDPath

# Set launchdaemon ownership and permissions
sudo chmod 644 $LDPath
sudo chown root:wheel $LDPath

# Create the preferences file
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $PrefsPath
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $PrefsPath
echo '<plist version="1.0">' >> $PrefsPath
echo '    <dict>' >> $PrefsPath
echo '        <key>SystemConfiguration</key>' >> $PrefsPath
echo '        <dict>' >> $PrefsPath
echo '            <key>State:/Network/Global/IPv4</key>' >> $PrefsPath
echo '            <dict>' >> $PrefsPath
echo '                <key>method</key>' >> $PrefsPath
echo '                    <array>' >> $PrefsPath
echo '                        <string>CrankTools</string>' >> $PrefsPath
echo '                        <string>OnNetworkLoad</string>' >> $PrefsPath
echo '                    </array>' >> $PrefsPath
echo '            </dict>' >> $PrefsPath
echo '        </dict>' >> $PrefsPath
echo '    </dict>' >> $PrefsPath
echo '</plist>' >> $PrefsPath


# Create the python script
echo '</plist>' >> $$PyScriptPath
echo '#!/usr/bin/env python' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'CrankTools.py' >> $PyScriptPath
echo 'The OnNetworkLoad method is called from crankd on a network state change, all other' >> $PyScriptPath
echo 'methods assist it. Modified from Gary Larizza’s script (https://gist.github.com/glarizza/626169).' >> $PyScriptPath
echo 'Last Revised - 10/07/2013' >> $PyScriptPath
echo 'author = ‘Graham Gilbert (graham@grahamgilbert.com)’ version = ‘0.6’' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'import syslog import subprocess from time import sleep' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'syslog.openlog("CrankD")' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'class CrankTools(): """The main CrankTools class needed for our crankd config plist"""' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'def mountRun(self):' >> $PyScriptPath
echo '    """Checks for an active network connection and calls mountscript if it finds one.' >> $PyScriptPath
echo '        If the network is NOT active, it logs an error and exits' >> $PyScriptPath
echo '    ---' >> $PyScriptPath
echo '    Arguments: None' >> $PyScriptPath
echo '    Returns:  Nothing' >> $PyScriptPath
echo '    """' >> $PyScriptPath
echo '    import subprocess' >> $PyScriptPath
echo "    subprocess.call(['sh', "$ShScriptPath"]) # Thanks @Jim Dennis for suggesting the []" >> $PyScriptPath
echo '    if self.LinkState():' >> $PyScriptPath
echo '        self.callCmd(command)' >> $PyScriptPath
echo '    else:' >> $PyScriptPath
echo '        syslog.syslog(syslog.LOG_ALERT, "Internet Connection Not Found, Puppet Run Exiting...")' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'def callCmd(self, command):' >> $PyScriptPath
echo '    """Simple utility function that calls a command via subprocess' >> $PyScriptPath
echo '    ---' >> $PyScriptPath
echo '    Arguments: command - A list of arguments for the command' >> $PyScriptPath
echo '    Returns: Nothing' >> $PyScriptPath
echo '    """' >> $PyScriptPath
echo '    task = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)' >> $PyScriptPath
echo '    task.communicate()' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'def LinkState(self):' >> $PyScriptPath
echo '    """This utility returns the status of the passed interface.' >> $PyScriptPath
echo '    ---' >> $PyScriptPath
echo '    Arguments:' >> $PyScriptPath
echo '        None' >> $PyScriptPath
echo '    Returns:' >> $PyScriptPath
echo '        status - The return code of the subprocess call' >> $PyScriptPath
echo '    """' >> $PyScriptPath
echo '    ' >> $PyScriptPath
echo '    theState = False' >> $PyScriptPath
echo '    ' >> $PyScriptPath
echo '    for interface in range(0, 20):' >> $PyScriptPath
echo '        interface = str(interface)' >> $PyScriptPath
echo '        adapter = 'en' + interface' >> $PyScriptPath
echo '        print 'checking adapter '+adapter' >> $PyScriptPath
echo '        if not subprocess.call(["ipconfig", "getifaddr", adapter]):' >> $PyScriptPath
echo '            theState = True' >> $PyScriptPath
echo '            break' >> $PyScriptPath
echo ' ' >> $PyScriptPath    
echo '    return theState' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo 'def OnNetworkLoad(self, *args, **kwargs):' >> $PyScriptPath
echo '    """Called from crankd directly on a Network State Change. We sleep for 10 seconds to ensure that' >> $PyScriptPath
echo '        an IP address has been cleared or attained, and then perform a Puppet run and a Munki run.' >> $PyScriptPath
echo '    ---' >> $PyScriptPath
echo '    Arguments:' >> $PyScriptPath
echo '        *args and **kwargs - Catchall arguments coming from crankd' >> $PyScriptPath
echo '    Returns:  Nothing' >> $PyScriptPath
echo '    """' >> $PyScriptPath
echo '    sleep(10)' >> $PyScriptPath
echo '    self.mountRun()' >> $PyScriptPath
echo 'def main(): crank = CrankTools() crank.OnNetworkLoad()' >> $PyScriptPath
echo ' ' >> $PyScriptPath
echo "if name == 'main':" >> $PyScriptPath
echo 'main()' >> $PyScriptPath

# Set the owner and load the launchdaemon
sudo chown root:wheel $PyScriptPath
sudo launchctl load $LDPath