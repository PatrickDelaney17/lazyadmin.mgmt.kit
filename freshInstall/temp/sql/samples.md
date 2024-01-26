   `sudo apt install sqlite3`
- https://singleboardbytes.com/373/install-sqlite-database-raspberry-pi.htm#:~:text=How%20to%20install%20SQLite%20Database%20on%20a%20Raspberry,8%20SQL%20EXIT.%20...%209%20Final%20Note.%20

- https://unix.stackexchange.com/questions/414443/how-to-write-sqlite-commands-in-a-shell-script
-  [output mode options](https://sqlite.org/cli.html)

```
# create db
sqlite3 lazyadmin.db 


BEGIN;
    CREATE TABLE tblUserMsgSettings(id INTEGER PRIMARY KEY AUTOINCREMENT, lastModified DATE DEFAULT (datetime('now','localtime')), MsgTypeShortName NVARCHAR(5),MsgTypeColorCode NVARCHAR(10));
COMMIT;

BEGIN;
INSERT INTO tblUserMsgSettings(MsgTypeShortName, MsgTypeColorCode) VALUES ('b','1;37');
INSERT INTO tblUserMsgSettings(MsgTypeShortName, MsgTypeColorCode) VALUES ('i','1;36');
INSERT INTO tblUserMsgSettings(MsgTypeShortName, MsgTypeColorCode) VALUES ('e','1;31');
INSERT INTO tblUserMsgSettings(MsgTypeShortName, MsgTypeColorCode) VALUES ('s','1;32');
INSERT INTO tblUserMsgSettings(MsgTypeShortName, MsgTypeColorCode) VALUES ('w','1;33');
COMMIT;

BEGIN;
    CREATE TABLE tblMsgColorCodes(id INTEGER PRIMARY KEY AUTOINCREMENT, Color NVARCHAR(15), ColorCode NVARCHAR(10));
COMMIT;

BEGIN;
    CREATE TABLE tblMsgType(id INTEGER PRIMARY KEY AUTOINCREMENT, msgName NVARCHAR(15), msgCode NVARCHAR(10), description NVARCHAR(150));
COMMIT;

BEGIN;
INSERT INTO tblMsgType(msgCode, msgName, description) VALUES ('b','basic', 'basic or standard messages displayed to user');
INSERT INTO tblMsgType(msgCode, msgName, description) VALUES ('i','info', 'information messages such up coming steps in script');
INSERT INTO tblMsgType(msgCode, msgName, description) VALUES ('e','error', 'error messages');
INSERT INTO tblMsgType(msgCode, msgName, description) VALUES ('s','success', 'success messages');
INSERT INTO tblMsgType(msgCode, msgName, description) VALUES ('w','warning', 'warning messages such as low disk space');
COMMIT;

SELECT * FROM tblMsgType;

BEGIN;
    CREATE TABLE tblEventLog(id INTEGER PRIMARY KEY AUTOINCREMENT, timeStamp DATE DEFAULT (datetime('now','localtime')), fk_eventType NVARCHAR(10), logMsg NVARCHAR(255), FOREIGN KEY(fk_eventType) REFERENCES tblMsgType(msgCode));
COMMIT;

COMMIT;
    INSERT INTO tblEventLog(fk_eventType, logMsg) VALUES ('b','0;34');
BEGIN

SELECT * FROM tblEventLog;


BEGIN;
    CREATE TABLE tblColorOptions(id INTEGER PRIMARY KEY AUTOINCREMENT, color NVARCHAR(25), colorCode NVARCHAR(10));
COMMIT;

BEGIN;
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Blue','0;34');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Dark Gray','1;30');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Black','0;30');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Red','0;31');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Green','0;32');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Brown/Orange','0;33');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Cyan','0;36');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Purple','0;35');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Yellow','1;33');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('White','1;37');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Red','1;31');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Green','1;32');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Blue','1;34');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Purple','1;35');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Cyan','1;36');
INSERT INTO tblColorOptions(color, colorCode) VALUES ('Light Gray','0;37');
COMMIT;

SELECT * FROM tblColorOptions;


BEGIN;
    CREATE TABLE tblLogTheme(id INTEGER PRIMARY KEY AUTOINCREMENT, isActive NOT NULL BOOLEAN DEFAULT 0, name NVARCHAR(25), groupId INT NOT NULL, MsgType NVACHAR(5), colorCode NVARCHAR(10), FOREIGN KEY(MsgType) REFERENCES tblMsgType(msgCode) ); ##NEEDS COLOR Tiedback per msg type as FK
COMMIT;

BEGIN;
INSERT INTO tblLogTheme(isActive, name, ,colorCode, groupId, MsgType) VALUES ('1','default',1;37', 0, 'b');
INSERT INTO tblLogTheme(isActive, name, ,colorCode, groupId, MsgType) VALUES ('1','default',1;36', 0, 'i');
INSERT INTO tblLogTheme(isActive, name, ,colorCode, groupId, MsgType) VALUES ('1','default',1;31', 0, 'e');
INSERT INTO tblLogTheme(isActive, name, ,colorCode, groupId, MsgType) VALUES ('1','default',1;32', 0, 's');
INSERT INTO tblLogTheme(isActive, name, ,colorCode, groupId, MsgType) VALUES ('1','default',1;33', 0, 'w');
COMMIT;
BEGIN;
INSERT INTO tblLogTheme(name, ,colorCode, groupId, MsgType) VALUES ('halloween',1;37', 1, 'b');
INSERT INTO tblLogTheme(name, ,colorCode, groupId, MsgType) VALUES ('halloween',1;35', 1, 'i');
INSERT INTO tblLogTheme(name, ,colorCode, groupId, MsgType) VALUES ('halloween',1;31', 1, 'e');
INSERT INTO tblLogTheme(name, ,colorCode, groupId, MsgType) VALUES ('halloween',0;33', 1, 's');
INSERT INTO tblLogTheme(name, ,colorCode, groupId, MsgType) VALUES ('halloween',1;33', 1, 'w');
COMMIT;

SELECT * FROM tblLogTheme;

```


NOTE CREATE ACTIVE THEME TABLE TO REDUCE REDUNDANCY - 1 key value pair

BEGIN;
DELETE FROM <table_name>;
COMMIT;

DROP TABLE IF EXISTS <table_name>;

- List Databases
.databases

- List tables
.tables

- script example connects to db and list table values back in terminal
```sh
#!/bin/sh
echo ""
echo "-----Listing All Color Options-------"
echo "TABLE NAME: tblColorOptions"
echo "-------------------------------------"
echo ""
VAR=$(sqlite3 /home/pi/lazyadmin.db <<'END_SQL'
.timeout 2000
.mode column
.width 2 12 5
.headers on
SELECT * FROM tblColorOptions;
END_SQL
)

echo "$VAR"
echo ""

```


```for i ... ; do sqlite3 my_db.sqlite "SELECT * FROM \"${i}\""; done```
start=`date +%s`
logPath=~/$laLogPath
d=$(date +%Y-%m-%d)
end=`date +%s`

localVersion=$(cat  $logPath/versionLog.json | jq '.commit')

today=$d
time_to_run=$(calc_runtime $start $end)
hole=$(pihole -c -j)

json=$( jq -n \
                  --arg dt "$today" \
                  --arg v $localVersion \
                  --arg rt "$time_to_run" \
                  -- dns "$hole"
                  '{date: $dt, version: $v, scriptRunTime: $rt, dnsStats: [ $dns ]}' )
echo $json

hole=$(pihole -c -j)
x='"piholeStats":['$hole
x=$x']'
jq -n --arg var "$x" '{$
.0}'




 0                

