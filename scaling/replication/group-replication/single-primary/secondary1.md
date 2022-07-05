## Server Secondary Setup
- **ip**: 157.245.52.72
- **host**: database2

## Group replication setup
```ini
[mysqld]
disabled_storage_engines="MyISAM,BLACKHOLE,FEDERATED,ARCHIVE,MEMORY"

# replication configuration parameters
server_id=2
gtid_mode=ON
enforce_gtid_consistency=ON
binlog_checksum=NONE           # Not needed from 8.0.21

# group replication configuration
plugin_load_add='group_replication.so'
group_replication_group_name="2106a166-f75e-11ec-9e42-4ab7d5a7ef11"
group_replication_start_on_boot=off
group_replication_local_address= "157.245.52.72:33061"
group_replication_group_seeds= "157.245.196.139:33061,157.245.52.72:33061,167.99.81.228:33061"
group_replication_ip_whitelist = "157.245.196.139,157.245.52.72,167.99.81.228"
group_replication_bootstrap_group= off

bind-address = "157.245.52.72"
report_host = "157.245.52.72"
```

### Create user credentials
Required if this server is promoted as primary server.

### Set user for use with distributed recovery (can be set when bootstrapping)
`mysql> CHANGE REPLICATION SOURCE TO SOURCE_USER='rpl_user', SOURCE_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';`

### Join the group
Join the group no need run command `SET GLOBAL group_replication_bootstrap_group=ON;` (only primary run this command):\
`mysql> START GROUP_REPLICATION;`