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
