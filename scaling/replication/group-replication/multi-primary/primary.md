## Setup multi-primary group replication
The configuration goes same as **single-primary** and add the additional config:

### Setup from single-primary
run `single-primary` group replication and initiate multi-primary by run function:
- `mysql> SELECT group_replication_switch_to_single_primary_mode();`

### Setup from my.cnf file
Or configure mysql configuration file
```ini
[mysql]
group_replication_single_primary_mode = OFF
group_replication_enforce_update_everywhere_checks = ON
```