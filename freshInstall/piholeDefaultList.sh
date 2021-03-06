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
