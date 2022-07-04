#!/bin/bash

# this file
# a) gets all databases from mysql
# b) gets all tables from all databases in a)
# c) creates sub folders for every database in a)
# d) dumps every table from b) in a single file
    # this is a mixture of scripts from Trutane (http://stackoverflow.com/q/3669121/138325) 
    # and Elias Torres Arroyo (https://stackoverflow.com/a/14711298/8398149)

# usage: 
# sk-db.bash parameters
# where parameters are:

# d "dbs to leave"
# t " tables to leave"
# u "user who connects to database"
# h "db host"
# f "/backup/folder"



user='root'
host='localhost'
backup_folder='/home/backup'
leave_dbs=(information_schema mysql sys performance_schema)
leave_tables=()
while getopts ":d:t:u:h:f:" opt; do
  case $opt in
    d) leave_dbs=( $OPTARG )
    ;;
    t) leave_tables=( $OPTARG )
    ;;
    u) user=$OPTARG
    ;;
    h) host=$OPTARG
    ;;
    f) backup_folder=$OPTARG
    ;;

    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done
echo '****************************************'
echo "Database Backup with these options"
echo "Host $host"
echo "User $user"
echo "Backup in $backup_folder"
echo '----------------------------------------'
echo "Databases to emit:"
printf "%s\n" "${leave_dbs[@]}"
echo '----------------------------------------'
echo "Tables to emit:"
printf "%s\n" "${leave_tables[@]}"
echo '----------------------------------------'


BACKUP_DIR=$backup_folder/$(date +%Y-%m-%dT%H_%M_%S);
CONFIG_FILE=/home/db-config.cnf

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}


test -d "$BACKUP_DIR" || mkdir -p "$BACKUP_DIR"
# Get the database list, exclude information_schema
database_count=0
tbl_count=0

for db in $(mysql --defaults-extra-file=$CONFIG_FILE -B -s -u $user -e 'show databases' )
do
    if [ $(contains "${leave_dbs[@]}" "$db") == "y" ]; then
        echo "leave database $db as requested"
    else

       # dump each database in a separate file
       (( database_count++ ))
       DIR=$BACKUP_DIR/$db
       [ -n "$DIR" ] || DIR=.

       test -d $DIR || mkdir -p $DIR

       echo
       echo "Dumping tables into separate SQL command files for database '$db' into dir=$DIR"

       # store password inline command or separated file $CONFIG_FILE
       # for t in $(mysql --defaults-extra-file=$CONFIG_FILE -NBA -h $host -u $user -D $db -e 'show tables')
       for t in $(mysql -NBA -h $host -u $user -D $db -e 'show tables')
       do
           if [ $(contains "${leave_tables[@]}" "$db.$t") == "y" ]; then
               echo "leave table $db.$t as requested"
           else
               echo "DUMPING TABLE: $db.$t"
               mysqldump --defaults-extra-file=$CONFIG_FILE -h $host -u $user $db $t  > $DIR/$db.$t.sql
               tbl_count=$(( tbl_count + 1 ))
           fi
       done

       echo "Database $db is finished"
       echo '----------------------------------------'

    fi
done
echo '----------------------------------------'
echo "Backup completed"
echo '**********************************************'