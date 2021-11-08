#!/bin/sh

# Starter Script
echo ""
echo "-----Listing All Message Types-------"
echo "TABLE NAME: tblMsgType"
echo ""
sqlite3 /home/pi/lazyadmin.db <<'END_SQL'
.timeout 2000
.mode column
.width 2 5 5
.headers on
SELECT * FROM tblMsgType;
END_SQL
echo ""

`https://docs.pi-hole.net/database/ftl/#supported-status-types`

sqlite3 "/etc/pihole/pihole-FTL.db" "SELECT domain,count(domain) FROM queries WHERE (STATUS == 4 OR STATUS == 5 OR STATUS == 11) GROUP BY domain ORDER BY count(domain) DESC LIMIT 10"