## Error member connection
- **[GCS]** Error connecting to all peers. **Member join failed**. Local port: 33061'
- **ERROR 2002 (HY000)**: Can't connect to local MySQL server through socket **'/var/run/mysqld/mysqld.sock'** (111)

- [x] **Solution**:
    - Check the `group_replication_group_seeds` and `group_replication_ip_whitelist` is contains all server ip and restart if new value added
    - Check `firewall` and `port blocking` (ufw, ip tables or other firewall app)

## Misconfiguration error
- ERROR 3092 (HY000): The server is not configured properly to be an active member of the group.

- [x] **Solution**:
    - Check `error.log` of mysql `/var/log/mysql/error.log`


## This member has more executed transactions
- **error.log** - This member **has more executed transactions** than those present in the group. Local transactions: 1d30099a-f5bd-11ec-93de-4ab7d5a7ef11:1-249

- [x] **Solution**:
    - Skipping transaction with GTIDs: see **global-transaction-identifier/failing-transaction.txt**


## Restore backup on replica error (1)
- **ERROR 3546 (HY000)** at line 26: **@@GLOBAL.GTID_PURGED cannot be changed**: the added gtid set must not overlap with @@GLOBAL.GTID_EXECUTED

- [x] **Solution**:
    - Reset replica: `mysql> reset master;`


## Restore backup on replica error (2)
- **ERROR 1776 (HY000)** at line 35: Parameters MASTER_LOG_FILE, MASTER_LOG_POS, RELAY_LOG_FILE and RELAY_LOG_POS cannot be set when MASTER_AUTO_POSITION is active.

- [x] **Solution**:
    - Reset replica: `mysql> stop replica;` then `reset replica all;`


## Invalid credential
- Fatal error: **Invalid (empty) username** when attempting to connect to the master server. Connection attempt terminated. Error_code: MY-013117

- [x] **Solution**:
    - Set replication source command `CHANGE REPLICATION SOURCE TO SOURCE_USER='rpl_user', SOURCE_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';`
    - wrong source username / password, forgot execute `CHANGE REPLICATION SOURCE TO...` after reset master