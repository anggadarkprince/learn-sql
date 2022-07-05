## Full Backup Versus Point-in-Time (Incremental) Recovery

A full recovery restores all data from a full backup. This restores the server instance to the state that it had 
when the backup was made. If that state is not sufficiently current, a full recovery can be followed by recovery of 
incremental backups made since the full backup, to bring the server to a more up-to-date state.

Incremental recovery is recovery of changes made during a given time span. This is also called point-in-time recovery 
because it makes a server's state current up to a given time. Point-in-time recovery is based on the binary log and 
typically follows a full recovery from the backup files that restores the server to its state when the backup was made. 
Then the data changes written in the binary log files are applied as incremental recovery to redo data modifications 
and bring the server up to the desired point in time. 

## Point in Time Recovery Using Binlog
The source of information for point-in-time recovery is the set of binary log files generated subsequent 
to the full backup operation.

### Restore from binlog
- Check binlog data `mysql> SHOW BINARY LOGS;`
- Check current binlog position `mysql> SHOW MASTER STATUS;`
- Applying binlog `$> mysqlbinlog /var/lib/mysql/binlog000001 | mysql -u root -p`
- Apply multiple binlog `$> mysqlbinlog binlog.000001 binlog.000002 | mysql -u root -p`
- Applying binlog from remote `$> mysqlbinlog --read-from-remote-server --host=host_name --port=3306  --user=root --password --ssl-mode=required  /var/lib/mysql/binlog000001 | mysql -u root -p`

### Editing binlog event
- Check binlog event `$> mysqlbinlog /var/lib/mysql/binlog000001 | more`
- Move binlog into separate file `$> mysqlbinlog /var/lib/mysql/binlog000001 > tmpfile`
- Edit copied event `$> nano tmpfile`
- Apply necessary binlog event `$> mysql -u root -p < tmpfile`

### Group multiple binlog event
- Group multiple binlog if necessary `$> mysqlbinlog binlog.000001 > /tmp/statements.sql`
- Add another binlog `$> mysqlbinlog binlog.000002 >> /tmp/statements.sql`
- Execute `$> mysql -u root -p -e "source /tmp/statements.sql"`


## Point-in-Time Recovery Using Event Positions
As an example, suppose that around 20:06:00 on March 11, 2022, an SQL statement was executed that deleted a table. 
You can perform a point-in-time recovery to restore the server up to its state right before the table deletion. 
These are some sample steps to achieve that: 
1. Restore the last full backup created before the point-in-time of interest (before 20:06:00 on March 11, 2022) and restart the server.
    - Let's assume before mysql is already backed up on 10:00 March 10, 2022 using `$> mysqldump --all-databases --source-data=2 > backup.sql`
    - Check last binlog file and position `$> less backup.sql` find comment: \
        `-- Position to start replication or point-in-time recovery from`\
        `-- CHANGE MASTER TO MASTER_LOG_FILE='binlog.000006', MASTER_LOG_POS=155;`
    - Note `binlog.00006` and position `155` are last position of backup
2. Find the precise binary log event position corresponding to the point in time up to which you want to restore your database.\
    - Run command `$> mysqlbinlog --start-datetime="2020-03-11 20:05:00" --stop-datetime="2020-03-11 20:08:00" --verbose /var/lib/mysql/binlog.000007 | grep -C 15 "DROP TABLE"` 
    - From the output of mysqlbinlog, the `DROP TABLE databases.table_name` statement can be found in the segment 
      of the binary log between the line `# at 232` and `# at 355`, which means the statement takes place after the log 
      position `232`, and the log is at position `355` after the `DROP TABLE` statement. 
    - Note statements in `binlog.000007` after position `232` and before `355` will be excluded
3. Apply the events in binary log file to the server, starting with the log position your found in step 1 
   (binlog file `binlog.00006` and position `155`)\
   `$> mysqlbinlog --start-position=155 --stop-position=232 /var/lib/mysql/binlog.00006 | mysql -u root -p`\
   The command recovers all the transactions from the starting position (last backup position) until just before 
   the stop position (before drop table).
4. Beyond the point-in-time recovery that has been finished, if you also want to reexecute all the statements after 
   your point-in-time of interest, use `mysqlbinlog` again to apply all the events after, we can leave `--stop-position`
   because we want to restore all data until last binlog file\
   `$> mysqlbinlog --start-position=355 /var/lib/mysql/bin.00006 | mysql -u root -p`