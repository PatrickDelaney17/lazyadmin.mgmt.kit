# **Network Monitor Automation Service**

This project provides a reliable way to monitor network connectivity on a Raspberry Pi and recover from failures. It checks if a specific host (e.g., `8.8.8.8`) is reachable and attempts reconnection when needed. If recovery fails, a configurable final action (e.g., reboot or shutdown) is performed. The solution includes a script, systemd service, and timer to run checks at defined intervals.

---

## **Steps to Configure the Network-Check Automation Service**

### **1. Clone the Project**
```bash
git clone <repository-url>
cd lazyadmin.mgmt.kit/utils
```

## 2. Copy the Files to the Correct Locations: Copy the necessary files into their appropriate system directories:

```bash
sudo cp network-check.sh /opt/network-monitor/
sudo chmod +x /opt/network-monitor/network-check.sh

sudo cp network-monitor.service /etc/systemd/system/
sudo cp network-monitor.timer /etc/systemd/system/
```

### Reload Systemd Daemon: This step ensures that the newly added service and timer files are recognized:

```bash
sudo systemctl daemon-reload
```
### Enable and Start the Timer and Service: To enable the service to start at boot and run on schedule:
```bash
sudo systemctl enable network-monitor.service &&\
sudo systemctl enable network-monitor.timer &&\
sudo systemctl start network-monitor.timer 
```
Verify the Service is Running: After completing the setup, confirm that the service is active:

sudo systemctl status network-monitor.service
sudo systemctl status network-monitor.timer

# Files and Their Usage
| File Name	| Description |
|--|--|
| network-check.sh	| The script that performs network checks, retries, and applies a final action after failures.|
| network-monitor.service |	Defines the service to execute the network-check.sh script.|
| network-monitor.timer | Defines the timer that schedules the service to run every 15 minutes.|

# Parameters
Parameter	Description	Default Value	Example Override
FINAL_ACTION	Final action to take after all retries fail. Options: reboot, shutdown.	reboot	FINAL_ACTION=shutdown
CHECK_INTERVAL	Frequency (in seconds) at which the timer triggers the script.	900 (15 min)	CHECK_INTERVAL=1800 (30 min)
How to Verify Everything is Working
Check the Timer Status: Ensure the timer is active and scheduled:

sudo systemctl list-timers --all
Check the Service Logs: View recent logs to confirm that the service is running correctly:

sudo journalctl -u network-monitor.service
Check Script Logs: Verify that the script logs are being generated correctly:

tail -f /var/log/network-check.log
Common Commands for Troubleshooting
Command	Description
sudo systemctl status network-monitor.service	Check the status of the service.
sudo systemctl status network-monitor.timer	Check the status of the timer.
sudo journalctl -u network-monitor.service	View logs for the service.
tail -f /var/log/network-check.log	Monitor the script’s log file in real-time.
sudo systemctl restart network-monitor.service	Manually restart the service.
sudo systemctl restart network-monitor.timer	Manually restart the timer.
Updating and Keeping Files in Sync
To make updates to the files locally or pull changes from Git:

Update Local Files: Make changes to the scripts in the lazyadmin.mgmt.kit/utils directory.

Copy Updated Files to System Locations: Use these commands to sync the changes:

sudo cp lazyadmin.mgmt.kit/utils/network-check.sh /opt/network-monitor/
sudo chmod +x /opt/network-monitor/network-check.sh

sudo cp lazyadmin.mgmt.kit/utils/network-monitor.service /etc/systemd/system/
sudo cp lazyadmin.mgmt.kit/utils/network-monitor.timer /etc/systemd/system/
Reload Systemd Configuration:

sudo systemctl daemon-reload
sudo systemctl restart network-monitor.timer
sudo systemctl restart network-monitor.service
Optional: Create Alias for Syncing Updates: Add the following alias to .bashrc or .zshrc for quick updates:

alias update-network-monitor="sudo cp lazyadmin.mgmt.kit/utils/network-check.sh /opt/network-monitor/ && sudo chmod +x /opt/network-monitor/network-check.sh && sudo cp lazyadmin.mgmt.kit/utils/network-monitor.service /etc/systemd/system/ && sudo cp lazyadmin.mgmt.kit/utils/network-monitor.timer /etc/systemd/system/ && sudo systemctl daemon-reload"
Reload your shell and use the alias:
```
source ~/.bashrc
update-network-monitor
```

# How to Remove/Delete Everything
## Stop and Disable the Timer and Service:
```bash
sudo systemctl stop network-monitor.timer &&\
sudo systemctl disable network-monitor.timer &&\
sudo systemctl stop network-monitor.service &&\
sudo systemctl disable network-monitor.service
```

## Remove Files: Delete the script, service, and timer files:
```bash
sudo rm /opt/network-monitor/network-check.sh &&\
sudo rm /etc/systemd/system/network-monitor.service &&\
sudo rm /etc/systemd/system/network-monitor.timer
```
## Reload Systemd Daemon:

```bash
sudo systemctl daemon-reload
```
# Verify Deletion: Ensure no timers or services are running:
```bash
sudo systemctl list-timers --all
sudo systemctl list-units --all | grep network-monitor
```

# Troubleshooting 
### error 
> ```$ sudo systemctl start network-monitor.timer```
terminal output 
```Failed to start network-monitor.timer: Unit network-monitor.timer has a bad unit file setting.
See system logs and 'systemctl status network-monitor.timer' for details.```
Try the following to inspect if all settings appear to have the correct values within the timer
```bash
sudo systemd-analyze verify /etc/systemd/system/network-monitor.timer
```

