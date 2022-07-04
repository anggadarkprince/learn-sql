## mysql import source

### Basic usage
`$> mysql [options] < [dump_file]`
`mysql> source [dump_file]`

- syntax: `mysql -u[user] -p[password] -h[hostname] [database] < [filename]`
- `$> mysql -uroot -p learn_db < learn_db.sql`

### Reload single database (without create database syntax)
Restore data only file, make sure the dumped file does not have `CREATE [DATABASE]` and `USE [DATABASE]` statement\
`$> mysql sandbox_db < dump.sql`

### Reload from a file that created by mysqldump 
Restore with the `--all-databases` or `--databases` option (create database statement included)\
`$> mysql < /home/backup.sql`

### Import and set variable on the fly
`$> mysql -uroot --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;SET SQL_MODE='ALLOW_INVALID_DATES';" wh_temp2 < warehouse.sql`

### Restore from binlog
`$> mysqlbinlog gbichot2-bin.000007 gbichot2-bin.000008 | mysql`

### Restore using `source` command
If the file is a single-database dump not containing `CREATE DATABASE` and `USE` statements, 
create the database first (if necessary): 
- `mysql> CREATE DATABASE IF NOT EXISTS db1;`
- `mysql> USE db1;`
- `mysql> source /home/backup.sql`