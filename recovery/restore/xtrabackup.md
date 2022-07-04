## XtraBackup
https://docs.percona.com/percona-xtrabackup

## Backup
see: recovery/backup/physical-backup/xtrabackup.md

## Basic usage (restoring)
The `datadir` must be empty before restoring the backup. 
Also it’s important to note that MySQL server needs to be shut down before restore is performed.

### Preparing backup result for restore
`$> xtrabackup --prepare --target-dir=/data/backup/`

### Restoring backup
`$> xtrabackup --copy-back --target-dir=/data/backup/`
`$> xtrabackup --move-back --target-dir=/data/backup/`

### Using rsync to restore
`$> rsync -avrP /data/backup/ /var/lib/mysql/`
`$> chown -R mysql:mysql /var/lib/mysql`


## Restore incremental backup
### Preparing base backup
`$> xtrabackup --prepare --apply-log-only --target-dir=/data/backup/base`

### Preparing incremental backup
- `$> xtrabackup --prepare --apply-log-only --target-dir=/data/backup/base --incremental-dir=/data/backup/inc1`
- `--apply-log-only` should be used when merging all incrementals except the last one. 
`$> xtrabackup --prepare --target-dir=/data/backup/base --incremental-dir=/data/backup/inc2`

### Restore the backup
`$> xtrabackup --copy-back --target-dir=/data/backup/`
`$> chown -R mysql:mysql /var/lib/mysql`


## Restore compressed backup
## Preparing backup result for restore
`$> xtrabackup --decompress --target-dir=/data/compressed/`
`$> xtrabackup --prepare --target-dir=/data/compressed/`

### Restore the backup
`$> xtrabackup --copy-back --target-dir=/data/compressed/`
`$> chown -R mysql:mysql /var/lib/mysql`


## Restore partial backup
When you use the –prepare option on a partial backup, you will see warnings about tables that don’t exist.
`xtrabackup --prepare --export --target-dir=/path/to/partial/backup`

### Restore the backup
Restoring should be done by restoring individual tables in the partial backup to the server.
https://docs.percona.com/percona-xtrabackup/latest/xtrabackup_bin/restoring_individual_tables.html#restoring-individual-tables
- It can also be done by copying back the prepared backup to a “clean” datadir\
`$> sudo mysql --initialize --user=mysql` Once you start the server, you may see mysql complaining about missing tablespaces:
- In order to clean the orphan database from the data dictionary, you must manually create the missing database 
directory and then DROP this database from the server.\
`$> mkdir /var/lib/mysql/test1/d2`
- Example of dropping the database from the server:\
`$> DROP DATABASE d2;`
