## Semisync Replication
By default, replication is **asynchronous**, source never know when replica acquires the event and processing it
If set to fully synchronous then source will wait until all replica receive the update, will make longer delay to complete the transaction
with **semisync**, source only wait until at least 1 (can be configured) replica receive the update before commit the transaction


### Install plugins
- Activate plugins in **source**:\
  `mysql> INSTALL PLUGIN rpl_semi_sync_source SONAME 'semisync_source.so';`
- For uninstall plugin `mysql> UNINSTALL PLUGIN rpl_semi_sync_source;`

- Install plugins in **replica**:\
`mysql> INSTALL PLUGIN rpl_semi_sync_replica SONAME 'semisync_replica.so';`

- Plugins check in MySql Server:\
`mysql> SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE '%semi%';`


### Activate semisync `source` sever:
- `mysql> SELECT @@rpl_semi_sync_source_enabled;`
- `mysql> SET GLOBAL rpl_semi_sync_source_enabled = 1;`
- Or via my.cnf file:
```ini
[mysqld]
rpl_semi_sync_source_enabled=1
```


### Activate semisync `replica` server:
- `mysql> SELECT @@rpl_semi_sync_replica_enabled;`
- `mysql> SET GLOBAL rpl_semi_sync_replica_enabled = 1;`
- Or via my.cnf file:
```ini
[mysqld]
rpl_semi_sync_replica_enabled=1
```

### Restart thread replica
- `mysql> STOP SLAVE IO_THREAD;`
- `mysql> START SLAVE IO_THREAD;`


### Configure semisync and get status
https://dev.mysql.com/doc/refman/8.0/en/replication-semisync-interface.html
- `mysql> SHOW VARIABLES LIKE 'rpl_semi_sync%';`
- `mysql> SHOW STATUS LIKE 'Rpl_semi_sync%';`