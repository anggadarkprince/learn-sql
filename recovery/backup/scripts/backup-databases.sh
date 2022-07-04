#!/bin/bash
folder_name=/home/backup/databases/$(date +%Y)/$(date +%Y%m)/"$(date +%Y-%m-%d)-$(date +%H:%M)"
mkdir -p $folder_name && cd $folder_name
mysql -N -e 'show databases' | 
while read dbname; 
do 
  if [ $dbname != "mysql" ] && [ $dbname != "information_schema" ] && [ $dbname != "performance_schema" ] && [ $dbname != "sys" ]
    then 
      mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > "$dbname".sql; 
      [[ $? -eq 0 ]] && gzip "$dbname".sql; 
  fi 
done
find /home/backup/databases/ -mindepth 2 -type d -mtime +14 | xargs rm -rf;