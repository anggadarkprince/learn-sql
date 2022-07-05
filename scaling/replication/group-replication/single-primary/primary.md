## Server Primary Setup
- **ip**: 157.245.196.139
- **host**: database1

Acquired uuid as group replication name later
- `mysql> SELECT UUID();`
- `mysql> INSTALL PLUGIN group_replication SONAME 'group_replication.so';`
- `mysql> STOP REPLICA; RESET REPLICA ALL;` - if before asynchronous replication channels is running

### Group replication setup
```ini
[mysqld]
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY"

# replication infrastructure settings
server_id = 1
gtid_mode=ON
enforce-gtid-consistency=ON
binlog_checksum=NONE -- disable checksum events written to binary log

# version of MySQL earlier than 8.0.3, or make sure the value is
log_bin=binlog
log_slave_updates=ON
binlog_format=ROW
master_info_repository=TABLE
relay_log_info_repository=TABLE
transaction_write_set_extraction=XXHASH64

# group replication settings
plugin_load_add='group_replication.so' -- alternatively install plugins manually
group_replication_group_name="2106a166-f75e-11ec-9e42-4ab7d5a7ef11"
group_replication_start_on_boot=off  -- instructs the plugin to not start operations automatically when the server starts
group_replication_local_address= "157.245.196.139:33061"  -- sets the network address and port which the member uses for internal communication with other members in the group.
group_replication_group_seeds= "157.245.196.139:33061,157.245.52.72:33061,167.99.81.228:33061" -- sets the hostname and port of the group members which are used by the new member to establish its connection to the group.
group_replication_ip_whitelist = "157.245.196.139,157.245.52.72,167.99.81.228"
group_replication_bootstrap_group=off  --  instructs the plugin whether to bootstrap the group or not.

bind-address = "157.245.196.139"
report_host = "157.245.196.139" -- set specific ip as report host rather than computer name
```

### Create user credentials
- `mysql> SET SQL_LOG_BIN=0;` - disable binary logging in order to create the replication user separately on each instance (optional)
- `mysql> CREATE USER 'rpl_user'@'%' IDENTIFIED BY 'password';`
- `mysql> GRANT REPLICATION SLAVE ON *.* TO 'rpl_user'@'%';`
- `mysql> GRANT CONNECTION_ADMIN ON *.* TO 'rpl_user'@'%';`
- `mysql> GRANT BACKUP_ADMIN ON *.* TO 'rpl_user'@'%';`
- `mysql> GRANT GROUP_REPLICATION_STREAM ON *.* TO 'rpl_user'@'%';`
- `mysql> FLUSH PRIVILEGES;`
- `mysql> SET SQL_LOG_BIN=1;`

### Set user for use with distributed recovery (can be set when bootstrapping)
`mysql> CHANGE REPLICATION SOURCE TO SOURCE_USER='rpl_user', SOURCE_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';`

### Bootstrapping the group
- `mysql> SET GLOBAL group_replication_bootstrap_group=ON;`
- `mysql> START GROUP_REPLICATION;`\
  or include user to connect the group:\
  `mysql> START GROUP_REPLICATION USER='rpl_user', PASSWORD='password';`
- `mysql> SET GLOBAL group_replication_bootstrap_group=OFF;`

## Check group state & monitoring
- `mysql> SELECT * FROM performance_schema.replication_group_members;`
- `mysql> SHOW STATUS LIKE 'group_replication_primary_member';`
- `mysql> SELECT * FROM performance_schema.replication_group_member_stats`
- `mysql> SELECT * FROM performance_schema.replication_connection_status;`
- `mysql> SELECT * FROM performance_schema.replication_applier_status;`

## Test replication
Add some test data:
- `mysql> CREATE DATABASE test;`
- `mysql> USE test;`
- `mysql> CREATE TABLE users (id INT PRIMARY KEY, name TEXT NOT NULL);`
- `mysql> INSERT INTO users VALUES (1, 'Angga Ari Wijaya');`



## Administration Functions
### Check **gtid** position
- `mysql> SHOW BINLOG EVENTS;`
- `mysql> SELECT @@global.gtid_executed;`

### Change primary
`mysql> SELECT group_replication_set_as_primary(member_uuid);`

### Change mode single - multi primary
- `mysql> SELECT group_replication_switch_to_single_primary_mode();`
- `mysql> SELECT group_replication_switch_to_single_primary_mode(member_uuid);`

### Stop replication
`mysql> STOP GROUP_REPLICATION;`

### Restart a group
Consider all member are leave the group, then which member should be started if multi-primary. 
Find the biggest **gtid** on all server:
- `mysql> SELECT @@GLOBAL.GTID_EXECUTED;`
- `mysql> SELECT received_transaction_set FROM \
               performance_schema.replication_connection_status WHERE \
               channel_name="group_replication_applier";`

- Then bootstrap from that server:
    - `mysql> SET GLOBAL group_replication_bootstrap_group=ON;`
    - `mysql> START GROUP_REPLICATION;`
    - `mysql> SET GLOBAL group_replication_bootstrap_group=OFF;`
    - `mysql> SELECT * FROM performance_schema.replication_group_members;`

- On each member:
    - `mysql> START GROUP_REPLICATION;`
    - `mysql> SELECT * FROM performance_schema.replication_group_members;`