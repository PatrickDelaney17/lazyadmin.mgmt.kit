# Utils 
> Optional but may provide useful based on your needs.


__Why use this?__
This is a nice way to make sure workloads depending on network connectivity have it, if your network is undergoing updates that disconnect the device and it fails to establish back to the network on it's own, this script/service is intended to help fill that gap. In my case Pihole dns containers were not accessable after a few days with routine maintenance and a simple reconnect using the service was a gentle way to resolve the issue instead of a hard restart.

__

## Network Checker Script
DRAFT 

### steps

1. Review the follow files, update the settings as you see fit including the final action if you do not want a reboot or shutdown.
2. default settings and how to override them
 <table here with description of the parameter, file, and example options>
3. Once ready copy the following scripts to the default locations (or to your prefered location)
   <how to copy the scripts or network-monitor.service> file to keep in sync with your local project location while not impacting your git settings...creating an manual steps and creating an alias
      3.1 manual command
      ```sh
      sudo cp ~/Documents/Repos/lazyadmin.mgmt.kit/network-monitor.service /etc/systemd/system/network-monitor.service
      ```
4. create a log rotate file
 > add the following
 ```text
 /var/log/network-check.log {
    weekly
    size 10M
    rotate 4
    compress
    missingok
    notifempty
}
 ```
5. create the service
6. reload the service or restart
7. verification checklist
  > how you know its working as it should and not over logging etc.
8 monitor usage
   
Review the following files. Ensure the code looks correct on the following files. I want to make sure the network-monitor.service runs the network-check.sh every 15 minutes but no longer than for 5 minutes. If the raspberry pi is rebooted i want to make sure the service will restart by default. Please provide updated files or steps if anything needs to change.

Create a readme.md file that clearly captures all the necessary context around the code, the problem it solves, and how to use it. The readme.md should be concise with clear, direct, and meet the requirements below so that anyone at any technical level can use this solution. Keep in mind for details involving terminal commands such as copy, the project name this code resides in is called lazyadmin.mgmt.kit, the network-monitor code is within a directory in the project called "utils".

- steps to take as a new user configuring the network-check automation service
- a table that defines the files, usage in the process
- a table that defines parameters, brief description including the default value if left unset, and example values if you want to override or change them
- how to verify everything is working as intended (commands to run and expected output if successful) for example if the service is running or ran, view logs etc...
- common commands to support troubleshooting 
- steps to take when making updates and how to keep the scripts in sync with you local project (alias commands) assuming future enhancemnets need to be made locally or pulled from git to replace the existing files.
- finally, how to remove/delete everything if someone no longer wants to use it. 


#### reload restart service
```sh
sudo systemctl daemon-reload
sudo systemctl restart network-monitor.service
```
__verify running appropriately__
```sh
sudo systemctl status network-monitor.service

```
> or use `journalctl` to see the logs for your service and confirm it is behaving as expected:
```sh
sudo journalctl -u network-monitor.service

```

 ___example output__
you should see something like in your terminal indicating success or issues
Output will be:

active (if running)
inactive or failed (if not running) - see troubleshooting section for help on failed or inactive

```
network-monitor.service - Monitor network and restart on failure
     Loaded: loaded (/etc/systemd/system/network-monitor.service; disabled; preset: enabled)
     Active: activating (auto-restart) (Result: exit-code) since Sun 2024-11-24 13:48:52 EST; 14s ago
    Process: 4624 ExecStart=/usr/local/bin/network-check.sh (code=exited, status=203/EXEC)
   Main PID: 4624 (code=exited, status=203/EXEC)

```

__check your logs__
> view logs from terminal
```sh
cat /var/log/network-check.log
```
>  Verify that logs are now written at the desired interval with tail? 
```sh
sudo tail -f /var/log/network-check.log
```

### troubleshooting
TODO  

### extras (optional)
* creating alias with bashrc and zsh

```sh
echo "alias update-network-check='sudo cp ~/Documents/Repos/lazyadmin.mgmt.kit/network-check.sh /usr/local/bin/network-check.sh && sudo chmod +x /usr/local/bin/network-check.sh'" >> ~/.bashrc




```
<zsh example here>

> Whenever you make changes to network-check.sh in your project directory, this will ensure the /usr/local/bin/network-check.sh always contains the latest updates.
```sh 
update-network-check
``` 

cp ~/Documents/Repos/lazyadmin.mgmt.kit/network-check.sh /usr/local/bin/

sudo chmod +x /opt/network-monitor/network-check.sh
