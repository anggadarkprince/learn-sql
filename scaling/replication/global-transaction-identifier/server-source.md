## Server Source Setup
- **ip**: 157.245.196.139
- **host**: database1

> -- setup user replication first same as binary-log-position-based (0)

### More user setup
- `mysql> CREATE USER 'repl'@'%' IDENTIFIED BY 'password' REQUIRE SSL;` -- use SSL
- `mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';`
- `mysql> ALTER USER 'repl'@'%' REQUIRE SSL;` -- alter existing user to use SSL

### Set read-only (optional to make consistency)
- `mysql> SET @@GLOBAL.read_only = ON;`
- `$> mysqladmin -uroot -p shutdown`

### Setting the source configuration
`mysql> SET GLOBAL server_id = 1;`
`mysql> SET GLOBAL gtid_mode = ON;`
`mysql> SET GLOBAL enforce-gtid-consistency = ON;`

### Filter database or table write to bin log (optional, can be filtered on the replica)
- Set in global variable `mysql> SET GLOBAL binlog_do_db = warehouse;`
- Configure in my.cnf file
```ini
[mysqld]
binlog_do_db=ecommerce
binlog_do_db=warehouse
binlog_ignore_db=sandbox
binlog_do_table=ecommerce.products
binlog_ignore_table=warehouse.logs
```
- Use startup parameter
`$> service mysql start --binlog-do-db=ecommerce --binlog-ignore-db=sandbox`

>-- move steps to server-replica (1)\
> ...\
>-- continue steps from server-replica (2)

## Start the source server
`$> service mysql start`

>-- move steps to server-replica (3)\
> ...\
>-- continue steps from server-replica (4)

### Remove read only state
If replica is locked because read only mode is active, bellow is the command to deactivate
- `mysql> SET @@GLOBAL.read_only = OFF;`
- `mysql> SET @@GLOBAL.super_read_only = OFF;`