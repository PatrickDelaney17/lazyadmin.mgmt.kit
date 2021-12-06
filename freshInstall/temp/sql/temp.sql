

-- # From the outside sqlite3 "/etc/pihole/pihole-FTL.db .headers on" "SELECT domain,count(domain) FROM queries WHERE (STATUS == 4) GROUP BY domain ORDER BY count(domain) DESC LIMIT 5" 

/*

ref: https://docs.pi-hole.net/database/ftl/#supported-status-types

QUICK REF Status Codes

1	Blocked	❌	Domain contained in gravity database
4	Blocked	❌	Domain matched by a regex blacklist filter
5	Blocked	❌	Domain contained in exact blacklist
9	Blocked	❌	Domain contained in gravity database (Blocked during deep CNAME inspection)
10	Blocked	❌	Domain matched by a regex blacklist filter (Blocked during deep CNAME inspection)
11	Blocked	❌	Domain contained in exact blacklist (Blocked during deep CNAME inspection)

*/

-- BEGIN with Selecting the most frequent blocked --

sqlite3 "/etc/pihole/pihole-FTL.db" ".headers on" "SELECT domain,count(domain) FROM queries WHERE (STATUS == 4) GROUP BY domain ORDER BY count(domain) DESC LIMIT 1" 

VAR=$(sqlite3 "/etc/pihole/pihole-FTL.db" "SELECT domain, count(domain) FROM queries WHERE (STATUS == 4) GROUP BY domain ORDER BY count(domain) DESC LIMIT 5")


VAR=$(sqlite3 "/etc/pihole/pihole-FTL.db" "SELECT domain, count(domain) FROM queries WHERE (STATUS == 5) GROUP BY domain ORDER BY count(domain) DESC LIMIT 5")


sqlite3 "/etc/pihole/pihole-FTL.db" ".headers on" "SELECT domain FROM queries WHERE (domain LIKE %\"${VAR}\"%) GROUP BY domain ORDER BY count(domain) DESC LIMIT 50"

VAR=$(sqlite3 "/etc/pihole/pihole-FTL.db" ".headers on" "SELECT domain FROM queries WHERE (STATUS == 4) GROUP BY domain ORDER BY count(domain) DESC LIMIT 3")

sqlite3 "lazyadmin.db" "INSERT INTO tblEventLog(fk_eventType, logMsg) VALUES ('i','captured biggest hit domain from regex table: \${VAR}\ and attempting to update exact match in pihole.db');"

sqlite3 "lazyadmin.db" ".headers on" "SELECT * FROM tblEventLog"
method 

--code works--
--https://www.educba.com/bash-split-string/

str=$VAR
echo "The string we are going to split by double pipe '||' is: $str"
delimiter=" "
conCatString=$str$delimiter
splitMultiChar=()
while [[ $conCatString ]]; do
splitMultiChar+=( "${conCatString%%"$delimiter"*}" )
conCatString=${conCatString#*"$delimiter"}
done
echo "Print out the different words separated by double pipe '|'"
for word in "${splitMultiChar[*]}"; do
echo $word
done

now need to loop insert

--next

str=$VAR
echo "The string we are going to split by double pipe '||' is: $str"
delimiter="|"
conCatString=$str$delimiter
splitMultiChar=()
while [[ $conCatString ]]; do
splitMultiChar+=( "${conCatString%%"$delimiter"*}" )
conCatString=${conCatString#*"$delimiter"}
done
echo "Print out the different words separated by double pipe '|'"
for word in "${splitMultiChar[@]}"; do
count=0
base=1
    x=$word; 98

    url=$null;

    if [[ $count -lt $base ]]; then   
    echo "wait for next round, url --> ${x}";
    url=$x;   
     (( count += 2 ))
     echo "count is now $count"
    else  
      count=0 
       echo -e "URL: ${url} Count: ${x}";
   fi  
done


msg() {
	count=0;
    x=$$word;
    url=null;
    if [[$count -lt 1]];  
    then
    echo "wait for next round, url --> $1";
    $url=$x;
    $count=1;
    else  
      $count=0;
       echo -e "URL: ${url} Count: ${GREEN}${x}${NOCOLOR}";
   fi 
}

 if [ -z "$partition_list" ]; then
            partition_list="'${VAR}'"
        else
            partition_list="${partition_list},'${VAR}'"
        fi