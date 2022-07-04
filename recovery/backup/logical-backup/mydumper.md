## mydumper
https://github.com/mydumper/mydumper
https://github.com/mydumper/mydumper/blob/master/docs/mydumper_usage.rst

## Basic usage
### Dump all database
`$> mydumper -u root -p '' -h 127.0.0.1 --port 3306`

### Dump specific databases
`$> mydumper -u root --database=sandbox,ecommerce`

### Dump specific tables
`$> mydumper --tables-list=sandbox.users,ecommerce.products`

### Compress and output
`$> mydumper --compress --outputdir=/home/backup/$(date +%Y-%m-%dT%H_%M_%S)`

### Custom thread number (default: 4)
`$> mydumper --threads=10`

### Split table into chunks of this many rows (default: unlimited)
`$> mydumper --rows=1000`

### Dump schema only
`$> mydumper --no-data`

### Include triggers, event, and routines
`$> mydumper --triggers --events --routines`

### Use complete INSERT statements that include column names
`$> mydumper --complete-insert`

### The verbosity of messages (default: 2)
0 = silent, 1 = errors, 2 = warnings, 3 = info.
`$> mydumper --directory=/home/export-20220704-055328 --verbose`


## Regex usage
### Dump all exclude some databases
- `$> mydumper --regex '^(?!(mysql\.|test\.|sys\.))'`

### Dump specific databases
- `$> mydumper --regex '^(sandbox_db|warehouse)'`

### Dump specific tables
- `$> mydumper --regex '^(tci_sso_v1\.prv_applications$|tci_purchasing_v3\.requisitions$)'`

### Dump tables
- `shell-py> util.dump_tables("sandbox_db", ["users", "products"], "/home/backup")`
