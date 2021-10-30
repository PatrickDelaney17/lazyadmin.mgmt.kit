# ABOUT
 > Intended for initial set up on a new pi

 ## Pi Models Tested
  - RPI 3B
  - RBI 3B+

  ## Dependencies Installed

  - Git
  - PIHOLE Unbound 
  - SQLITE3
  - JQ

---

# Assumptions
- Configuring for the pi to be hardwired in 
- Nothing has been done but the basic image added to an SD card

 #  Basic Steps

 1. *Upon first time bootup - verify basics* 
  > - Starting up with monitor, Enable SSH, Skip the remaining steps for internet setup and updates, change your hostname (**write it down somewhere to remember for first time ssh**) and password to something unique and shutdown your pihole.
 2. *Hardwire pi into router and begin updates*
  > - using something like putty `ssh pi@<yourhostname>.local` 
  > - run update and upgrade 
  ``` 
  sudo apt-get update && sudo apt-get upgrade -y
  ```
  > - Reboot 
  ```
  sudo shutdown -r now
  ``` 
  > - ssh back into your pi
 2. *Install JQ & SQLITE3*
 ```
 sudo apt install -y jq 
 ``` 
 ```
 sudo apt install sqlite3
 ```
 3.  *Install Git*
 ```
 curl -sSL https://install.pi-hole.net | sudo bash
 ```
  > - [Install Git Official Doc](https://github.com/git-guides/install-git)
3. *Go Through Git First Time Set up*
> - Simple few steps to add your profile info on your machine...https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
4. Install Pihole
```
curl -sSL https://install.pi-hole.net | sudo bash
```
> - For all install options see the [official Pihole Doc](https://docs.pi-hole.net/main/basic-install/)
5. *Set up Reverse DNS (PIhole Unbound)* (Optional but recommended)
> - Follow the 3 steps here - https://docs.pi-hole.net/guides/dns/unbound/#setting-up-pi-hole-as-a-recursive-dns-server-solution
> - install, add root hints
> - *Configure:* update pihole conf with the info provided in the link 

```sh 
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```

# Update Pihole 
 > - Use the script found here to load the initial block list and white list on your pihole using the built in api

- create the script in the desired location
```
 > piholeDefaultList.sh
```
- open new script file 
```
sudo nano piholeDefaultList.sh
```
 - paste the code below inside your new script, then `ctrl s`, `ctrl x`
 ```sh
#!/bin/sh

NOCOLOR="\033[0m"
CYAN="\033[1;36m"

info_msg() {	
	for i in "$*"; do echo -e "${CYAN}[i] $i ${NOCOLOR}"; done
}

next(){
echo
echo	
}

info_msg "Update Block List"
next
pihole --regex '^adtrack(er|ing)?[0-9]*[_.-]' '^track(ing)?[0-9]*[_.-]' '^(.+[_.-])?adse?rv(er?|ice)?s?[0-9]*[_.-]' '^stat(s|istics)?[0-9]*[_.-]' '^(.+[_.-])?telemetry[_.-]' '^analytics?[_.-]' 'yyjvimo' 'adclick' 'doubleclick' 'screencaps.vscdns.com' '^https://adssettings' '^https://googleleads' '(\.|^)criteo$' '(\.|^)ezoic$' '^advert(s|is(ing|ements?))?[0-9]*[_.-]' '^pixels?[-.]' '^count(ers?)?[0-9]*[_.-]' 'amgdgt' 'zamanta' 'taboola'
next
pihole -b 'wo.vzwwo.com' 'api.zynga.com' 'zoom.zynga.com' 'service.idsync.analytics.yahoo.com' 'app-measurement.com' 'mesu.g.aaplimg.com'
next
info_msg "Block list has now been updated"
next 
info_msg "Update whitelist"
next
pihole -w 'intuit'
next
info_msg 'script complete, go to your pihole dashboard to confirm results'

 ```
  - Finally Run your script
```
    bash piholeDefaultList.sh
```