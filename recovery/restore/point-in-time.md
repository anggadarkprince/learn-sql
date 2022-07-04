## Full Versus Point-in-Time (Incremental) Recovery

A full recovery restores all data from a full backup. This restores the server instance to the state that it had 
when the backup was made. If that state is not sufficiently current, a full recovery can be followed by recovery of 
incremental backups made since the full backup, to bring the server to a more up-to-date state.

Incremental recovery is recovery of changes made during a given time span. This is also called point-in-time recovery 
because it makes a server's state current up to a given time. Point-in-time recovery is based on the binary log and 
typically follows a full recovery from the backup files that restores the server to its state when the backup was made. 
Then the data changes written in the binary log files are applied as incremental recovery to redo data modifications 
and bring the server up to the desired point in time. 