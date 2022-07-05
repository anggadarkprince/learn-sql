## Server Source Setup
- **ip**: 157.245.196.139
- **host**: database1

### Setting the source configuration
`mysql> SET GLOBAL server_id = 1;`

> -- move steps to server-replica (1)\
> -- continue steps from server-replica (2)

### Creating user for replication: `mysql_native_password`
- `mysql> SET sql_log_bin = 0;` -- exclude account management statement to binlog (optional)
- `mysql> CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'password';`
- `mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';`
- `mysql> SET sql_log_bin = 1;`

#### Using `caching_sha2_password` with SSL
If you like to use default mysql8 password plugin and require secure connection then replace user creation command with:\
`mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password' REQUIRE SSL;`

#### Change user to use `mysql_native_password` or necessary access
If default user use default plugin and want to move to `mysql_native_password` and can be accessed from anywhere the run:
- `mysql> ALTER USER root IDENTIFIED WITH mysql_native_password BY 'password';`
- `mysql> RENAME USER 'root'@'localhost' TO 'root'@'%';`


## Backup source server
### Obtaining the replication source binary log coordinate
`mysql> FLUSH TABLES WITH READ LOCK;`

### Acquired coordinate in other session
`mysql > SHOW MASTER STATUS;`

| File             	| Position 	| Binlog_Do_DB 	| Binlog_Ignore_DB 	|
|------------------	|----------	|--------------	|------------------	|
| mysql-bin.000003 	| 73       	| test         	| manual,mysql     	|


### Source data snapshot
- `$> mysqldump --all-databases --source-data > dbdump.db`
- `mysql> UNLOCK TABLES;`
- Restore the snapshot directly to replica server\
  `$> mysql -h 157.245.52.72 < dbdump.db`\
  or use `rsync`, `scp`, `nc` to restore the snapshot in replica server directly

> -- move steps to server-replica (3)