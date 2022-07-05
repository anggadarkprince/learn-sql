## Server Replica Setup
- **ip**: 157.245.52.72
- **host**: database2

> -- continue steps from server-source (1)

### Setting replication configuration
`mysql> SET GLOBAL server_id = 2;`

or in `my.cnf` file to survive when mysql shutdown/restart:

```ini
[mysqld]
server-id=2
```

> -- move steps to server-source (2)\
> ...\
> -- continue steps from server-source (3)

### Restoring source snapshot
To make the replica catch up the data source quickly, restore the snapshot of the source 
(in case not yet triggered recovery process from source server)
- `$> mysql -uroot -p < source-backup.sql`

### Start replica
- In order to start the replication set source address, put credential, log file and position:
```mysql
mysql> CHANGE REPLICATION SOURCE TO
    ->     SOURCE_HOST='157.245.196.139',
    ->     SOURCE_USER='repl',
    ->     SOURCE_PASSWORD='password',
    ->     SOURCE_LOG_FILE='mysql-bin.000003',
    ->     SOURCE_LOG_POS=73;
```
- Start the replica `mysql> START REPLICA;`
