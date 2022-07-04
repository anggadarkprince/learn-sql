## mysqlpump - A Database Backup Program
https://dev.mysql.com/doc/refman/8.0/en/mysqlpump.html
The mysqlpump client utility performs logical backups, producing a set of SQL statements that can be executed 
to reproduce the original database object definitions and table data. 
It dumps one or more MySQL databases for backup or transfer to another SQL server. 

## Basic usage
`mysqlpump [options] db_name [tbl_name ...]`\
`mysqlpump [options] --databases db_name ...`\
`mysqlpump [options] --all-databases`\

### Dump single database
This command will not generate `use database` statement, you can select different database name when import\
- syntax: `sudo mysqlpump -u[user] -p[password] -h[hostname] [database] > [filename]`
- `$> mysqlpump test_db > dump.sql`
- dump remotely: `$> mysqlpump -uroot -p -h192.168.1.88 learn_db > backup_db.sql`

### Dump with --databases option
This command will `create database` if not exist and run `use database` by its source name, be careful when restore!
- syntax: `mysqlpump --databases [dbname1] [dbname2] [dbname...] > [filename]`
- `$> mysqlpump --databases db1 > backup.sql`
- `$> mysqlpump --databases db1 db2 db3 > backups.sql`

### Dump will --all-databases option
This command will `create database` if not exist and run `use database` by its source name, be careful when restore!
- syntax: `mysqlpump --all-databases > [filename]`
- `$> mysqlpump --all-databases > backup.sql`
- exclude some database `$> mysqlpump --all-databases --exclude-databases=db1,db2 > backup.sql`

### Dump single database and specific tables
This command will not generate `use database` statement, you can select different database name when import
- syntax: `mysqlpump [dbname] [table1] [table2] [table...] > dump.sql`
- `$> mysqlpump test t1 t3 t7 > dump.sql`

### Output name (in ASCII format)
- syntax: `mysqlpump --databases [dbname] --result-file=[filename]`
- `$> mysqlpump --databases [dbname] --result-file=/home/backup.sql`