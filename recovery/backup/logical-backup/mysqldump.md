## mysqldump - A Database Backup Program
https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

## Basic usage
`mysqldump [options] db_name [tbl_name ...]`\
`mysqldump [options] --databases db_name ...`\
`mysqldump [options] --all-databases`\

### Dump single database
This command will not generate `use database` statement, you can select different database name when import\
- syntax: `sudo mysqldump -u[user] -p[password] -h[hostname] [database] > [filename]`
- `$> $> mysqldump test_db > dump.sql`
- schema only, without data: `$> $> mysqldump test_db --no-data > dump.sql`
- dump remotely: `$> mysqldump -uroot -p -h192.168.1.88 learn_db > backup_db.sql`

### Dump with --databases option
This command will `create database` if not exist and run `use database` by its source name, be careful when restore!
- syntax: `mysqldump --databases [dbname1] [dbname2] [dbname...] > [filename]`
- `$> mysqldump --databases db1 > backup.sql`
- `$> mysqldump --databases db1 db2 db3 > backups.sql`

### Dump will --all-databases option
This command will `create database` if not exist and run `use database` by its source name, be careful when restore!
- syntax: `mysqldump --all-databases > [filename]`
- `$> mysqldump --all-databases > backup.sql`

### Dump single database and specific tables
This command will not generate `use database` statement, you can select different database name when import
- syntax: `mysqldump [dbname] [table1] [table2] [table...] > dump.sql`
- `$> mysqldump test t1 t3 t7 > dump.sql`

### Output name (in ASCII format)
- syntax: `mysqldump --databases [dbname] --result-file=[filename]`
- `$> mysqldump --databases [dbname] --result-file=/home/backup.sql`

### Dump with `--tab` option
Wil export 2 files, sql table structure and text-based data of the table.\
- `$> mysqldump --tab=/var/lib/mysql-files db1`
- same output as `mysql> SELECT * INTO OUTFILE 'file_name' FROM tbl_name`

## Replication dump
### Dump source / master data
Used to dump a replication source server to produce a dump file that can be used to set up 
another server as a replica of the source.
- `$> mysqldump --all-databases --source-data > dbdump.sql`
- `$> mysqldump --all-databases --source-data=2 > dbdump.sql`
If the option value is 2, the `CHANGE REPLICATION SOURCE TO` statement is written as an SQL comment, 
it has no effect when the dump file is reloaded, but usefull when start replication or point-in-time recovery.
The output will contain something like:\
`-- Position to start replication or point-in-time recovery from`\
`-- CHANGE MASTER TO MASTER_LOG_FILE='binlog.000006', MASTER_LOG_POS=1173349;`

### Compress dump output
- `$> mysqldump --all-databases --source-data=2 | gzip > dbdump.db.gz`

### Delete binary logs after backup
- Delete the binary logs by sending a `PURGE BINARY LOGS` statement to the server after performing the dump operation,
The options automatically enable `--source-data`. Deleting the MySQL binary logs with `mysqldump --delete-master-logs` 
can be dangerous if your server is a replication source server, because replicas might not yet fully have processed 
the contents of the binary log.
`$> mysqldump --all-databases --delete-source-logs --source-data | gzip > dbdump.db.gz`

### Dump replica / slave data
The options are similar to `--source-data`, except that they are used to dumping a replica server to produce a dump file 
that can be used to set up another server as a replica that has the same source as the dumped server.
- `$> mysqldump --all-databases --dump-replica > dbdump.sql`
- Add a `stop replica` before and `start replica` statement after dumping process
`$> mysqldump --all-databases --dump-replica --apply-replica-statements | gzip > dbdump-replica.db.gz`


## Transaction Dump
### Single transaction
This option sets the transaction isolation mode to [REPEATABLE READ](url=https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html#isolevel_repeatable-read) 
and sends a `START TRANSACTION` SQL statement to the server before dumping data.
- `$> mysqldump --all-databases --source-data --single-transaction > dbdump.sql`

### Quick option
For large tables combine with `--quick` to retrieve rows for a table from the server a row at a time rather than 
retrieving the entire row set and buffering it in memory before writing it out
(`--quick` is enabled by default, use `--skip-quick` to disable), it also included in `--opt` which also enable by default. 
- `$> mysqldump --all-databases --source-data --single-transaction --quick > dbdump.sql`
- More compact output `--compact`:\
`$> mysqldump --all-databases --source-data --single-transaction --quick --compact | gzip > dbdump.db.gz`


## Backup - Restore Script Example
### Dumping script: each database
- Get list of databases: `mysql -N -e 'show databases'`
- Loop database strings: `while read dbname; do ... done`
- Dumping database by variable: `mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > "$dbname".sql;`
- Combine all script: `mysql -N -e 'show databases' | while read dbname; do mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > /home/backup/"$dbname".sql; done`
- Compress the resut: `mysql -N -e 'show databases' | while read dbname; do mysqldump --complete-insert --routines --triggers --single-transaction "$dbname" > /home/backup/"$dbname".sql; [[ $? -eq 0 ]] && gzip "$dbname".sql; done`

### Restore script: this overwrites the databases!
Find files by its extension then loop through the file and restore the file
`for sql in *.sql; do dbname=${sql/\.sql/}; echo -n "Now importing $dbname ... "; mysql $dbname < $sql; echo " done."; done`


## mysqldump cheatsheet
### Making copy of a database
Do not use `--databases` on the mysqldump command line because that causes `USE` db1 to be included in the dump file, 
which overrides the effect of naming db2 on the mysql command line. 
- `$> mysqldump db1 > dump.sql`
- `$> mysqladmin create db2`
- `$> mysql db2 < dump.sql`

### Copy a Database from one Server to Another
- On Server 1: `$> mysqldump --databases db1 > dump.sql`
- Copy the dump file from Server 1 to Server 2. 
- On Server 2: `$> mysql < dump.sql`

Use of `--databases` with the mysqldump command line causes the dump file to include `CREATE DATABASE` and `USE` statements 
that create the database if it does exist and make it the default database for the reloaded data:
- On Server 1: `$> mysqldump db1 > dump.sql`
- On Server 2: `$> mysqladmin create db1`
- On Server 2: `$> mysql db1 < dump.sql`

### Dumping Table Definitions and Content Separately
- `$> mysqldump --no-data test > dump-defs.sql`
- `$> mysqldump --no-create-info test > dump-data.sql`

### Using mysqldump to Test for Upgrade Incompatibilities
- On the production server: `mysqldump --all-databases --no-data --routines --events > dump-defs.sql`
- On the upgraded server: `mysql < dump-defs.sql`

After you have verified that the definitions are handled properly, dump the data and try to 
load it into the upgraded server. 
- `$> mysqldump --all-databases --no-create-info > dump-data.sql`
- `$> mysql < dump-data.sql`
