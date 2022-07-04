## myloader
https://github.com/mydumper/mydumper
https://github.com/mydumper/mydumper/blob/master/docs/myloader_usage.rst

## Basic usage
### Load dump connection
`$> myloader -u root -p '' -h 127.0.0.1 --port 3306`

### Load directory source
`$> myloader --directory=/home/export-20220704-060131`

### Load and force overwriting
`$> myloader --directory=/home/export-20220704-060131 --overwrite-tables`

### Load into specific database
For use with single database dumps.  When using with multi-database dumps 
that have duplicate table names in more than one database it may cause errors.
`$> myloader --directory=/home/export-20220704-055328 --database=sso --overwrite-tables`

### Load into a specific database from source
Database to restore, useful in combination with --database.
`$> myloader --directory=/home/export-20220704-055328 --source-db=tci_sso_v1 --database=sso --overwrite-tables`

### Custom thread number when restoring schemas (default: 4)
`$> myloader --directory=/home/export-20220704-055328 --threads=10`

### Number of INSERT queries to execute per transaction (default: 1000)
`$> myloader --directory=/home/export-20220704-055328 --queries-per-transaction=2000`

### The verbosity of messages (default: 2)
0 = silent, 1 = errors, 2 = warnings, 3 = info.
`$> myloader --directory=/home/export-20220704-055328 --verbose`
