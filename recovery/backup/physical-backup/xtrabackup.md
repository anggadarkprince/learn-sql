## XtraBackup
https://docs.percona.com/percona-xtrabackup

## Basic usage (full backup)
### Backup source data
- `$> xtrabackup --user=root --password= --backup --datadir=/var/lib/mysql --target-dir=/home/backup/`
- `$> xtrabackup --user=root --password= --backup --target-dir=/home/backup/ --no-server-version-check`

### Preparing backup result for restore
`$> xtrabackup --prepare --target-dir=/data/backup/`


## Compressed backup
### Perform backup
The --compress uses the `qpress` tool that you can install via the percona-release package configuration tool
`$> xtrabackup --backup --compress --target-dir=/data/compressed/`
`$> xtrabackup --backup --compress --compress-threads=4 --target-dir=/data/compressed/`

## Preparing backup result for restore
`$> xtrabackup --decompress --target-dir=/data/compressed/`
`$> xtrabackup --prepare --target-dir=/data/compressed/`


## Incremental backup
You can perform many incremental backups between each full backup, so you can set up a backup process such as a 
full backup once a week and an incremental backup every day, or full backups every day and incremental backups every hour.

### Initial full backup
`$> xtrabackup --backup --target-dir=/data/backup/base`

### Continue incremental from base-dir
- `$> xtrabackup --backup --target-dir=/data/backup/inc1 --incremental-basedir=/data/backup/base`
- Use last incremental to the next incremental
`$> xtrabackup --backup --target-dir=/data/backups/inc2 --incremental-basedir=/data/backups/inc1`


## Partial backup
xtrabackup supports taking partial backups when the `innodb_file_per_table` option is enabled
- Use the `--tables` option to list the table names
- Use the `--tables-file` option to list the tables in a file
- Use the `--databases` option to list the databases
- Use the `--databases-file` option to list the databases

### The –tables Option
`$> xtrabackup --backup --target-dir=/data/backup/ --tables="^sanbox[.].*"`

### The –tables-file Option
The --tables-file option specifies a file that can contain multiple table names, one table name per line in the file. 
`$> echo "mydatabase.mytable" > /tmp/tables.txt`
`$> xtrabackup --backup --tables-file=/tmp/tables.txt`

### The –databases
`$> xtrabackup --backup --databases='mysql sys performance_schema test'`

### The --databases-file Option
The –databases-file option specifies a file that can contain multiple databases and 
tables in the databasename[.tablename] format, one element name per line in the file.
`$> xtrabackup --backup --databases-file=/tmp/databases.txt`