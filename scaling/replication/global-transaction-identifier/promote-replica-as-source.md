## Scenario
- Consider exists a **source**, and **replica1**, **replica2**, **replica3**,
- Then source is offline and `replica1` need to be promoted become new `source`

### Initial setup when replica is running
- Disable replica log update `--log-replica-updates=OFF`

### Promote replica1 by the stopping the replica and reset master, on replica1:
- `mysql> STOP REPLICA`
- `mysql> RESET MASTER`

### Make sure all replicas process any statements in their relay log, each replica:
- `mysql> STOP REPLICA IO_THREAD`
- `mysql> SHOW PROCESSLIST` -- until you see "Has read all relay log"

### Change other replica source, replica2:
`mysql> STOP REPLICA`
`mysql> CHANGE REPLICATION SOURCE TO SOURCE_HOST='replica1' ...`
`mysql> START REPLICA`

### If "source" available, then make it as replica1:
`mysql> CHANGE REPLICATION SOURCE TO SOURCE_HOST='replica1' ...`

### Consider making source (currently as replica1) as source again
Use the preceding procedure as if replica1 (currently as source) was unavailable
and source (currently as replica1) was to be the new source, in the source (currently as replica1):
- `mysql> STOP REPLICA`
- `mysql> RESET MASTER`

### Make replica1 (currently source) as original replica1:
`mysql> CHANGE REPLICATION SOURCE TO SOURCE_HOST='source' ...`