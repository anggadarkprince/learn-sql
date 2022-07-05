## Server Replica 1 Setup
- **ip**: 157.245.52.72
- **host**: database2

>-- continue steps from server-source (1)

### Set read-only (optional to make consistency)
- `mysql> SET @@GLOBAL.read_only = ON;`
- `$> mysqladmin -uroot -p shutdown`

### Setting replication configuration
- `mysql> SET GLOBAL server_id = 2;`
- `mysql> SET GLOBAL gtid_mode = ON;`
- `mysql> SET GLOBAL enforce-gtid-consistency = ON;`
- `mysql> SET GLOBAL skip_replica_start = OFF;`

or in `my.cnf` file to survive when mysql shutdown/restart:
```ini
[mysqld]
server-id=2
gtid_mode=ON
enforce-gtid-consistency=ON
skip_replica_start=OFF -- manual start replica, when mysql server start
```

## Start & prepare replica
To prevent the replica to write binlog that received from source, 
enable it if this replica also as a source for other replicas\
- `$> service mysql start --log-replica-updates=OFF`
- `$> service mysql start`

> -- move steps to server-source (2)\
> ...\
> -- continue steps from server-source (3)

- Set replica's source configuration:
```mysql
mysql> CHANGE REPLICATION SOURCE TO
    ->     SOURCE_HOST='157.245.196.139',
    ->     SOURCE_PORT = 3306,
    ->     SOURCE_USER='repl',
    ->     SOURCE_PASSWORD='password',
    ->     SOURCE_AUTO_POSITION=1;
```

### Filter the specific database table to be replicated
- `mysql> CHANGE REPLICATION FILTER REPLICATE_WILD_DO_TABLE = ('db1.%');`
- Or select specific channel `mysql> CHANGE REPLICATION FILTER REPLICATE_WILD_DO_TABLE = ('db1.%') FOR CHANNEL "source_1";`

### Start replica
- `mysql> START REPLICA;`
- `mysql> SET @@GLOBAL.read_only = OFF;`

> -- move steps to server-source (4)

## Replication Rules (REPLICA FILTER)
See: scaling/replication/global-transaction-identifier/server-replica2.md