## Server Replica 2 Setup
- **ip**: 167.99.81.228
- **host**: database3

> -- we assume third server join along way after current replication running (scaling up)
> -- and large data exist on current source-replica1 servers
> -- continue steps from server-source (1)

### Set read-only (optional to make consistency)
- `mysql> SET @@GLOBAL.read_only = ON;`
- `$> mysqladmin -uroot -p shutdown`

### Setting replication configuration
- `mysql> SET GLOBAL server_id = 3;`
- `mysql> SET GLOBAL gtid_mode = ON;`
- `mysql> SET GLOBAL enforce-gtid-consistency = ON;`
- `mysql> SET GLOBAL skip_replica_start = OFF;`

or in `my.cnf` file to survive when mysql shutdown/restart:

-- https://dev.mysql.com/doc/refman/8.0/en/replication-gtids-failover.html
-- Copying data and transactions to the replica: either Data Set or Transaction History
-- sometimes we need to reset the replica
-- RESET REPLICA makes the replica forget its position in the source's binary log.

### Start replica
- Start the MySql server: `$> service mysql start`
- Set replica's source configuration:
```mysql
mysql> CHANGE REPLICATION SOURCE TO
    ->     SOURCE_HOST='157.245.52.72',
    ->     SOURCE_PORT = 3306,
    ->     SOURCE_USER='repl',
    ->     SOURCE_PASSWORD='password',
    ->     SOURCE_AUTO_POSITION=1,
    ->     SOURCE_SSL=1; -- enable SSL
```
- Start the replica: `mysql> START REPLICA;`

## Replication Rules (REPLICA FILTER)
In order to apply the filter, it should stop replica sql thread:
- `mysql> STOP REPLICA SQL_THREAD FOR CHANNEL '';`
- Set filter to which db or table is replicated
```mysql
mysql> CHANGE REPLICATION FILTER
    ->      REPLICATE_DO_DB = (ecommerce, purchasing);
    ->      REPLICATE_IGNORE_DB = (system_logs, sandbox);
    ->      REPLICATE_DO_TABLE = (ecommerce.users, ecommerce.products, purchasing.vendors);
    ->      REPLICATE_IGNORE_TABLE = (ecommerce.logs, purchasing.logs);
    ->      REPLICATE_WILD_DO_TABLE = (wild_tbl_list);
    ->      REPLICATE_WILD_IGNORE_TABLE = (wild_tbl_list);
    ->      REPLICATE_REWRITE_DB = ((ecommerce, e_commerce_v1));
    ->      FOR CHANNEL '';
```
- restart the sql thread again: `mysql> START REPLICA SQL_THREAD FOR CHANNEL '';`