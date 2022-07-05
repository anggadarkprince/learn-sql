## Raw copy MySql data

### Locate the Data Directory
- Login into mysql console `$> sudo mysql -u root -p`
- Select data location variable `mysql> select @@datadir;` (default value: `/var/lib/mysql/`)
or find string `$> sudo mysqld --verbose --help | grep ^datadir`

### Backup the database
- Stop the mysql service `$> sudo systemctl stop mysql`
- Create backup folder `$> mkdir -p /var/backup/2022_07_13_backup`
- Copy raw data `$> cp -R /var/lib/mysql/. /var/backup/2022_07_13_backup`
- Start mysql `$> systemctl start mysql`

### Move backup into another server
- Using ssh `$> rsync -v /var/backup/2022_07_13_backup 103.157.96.147:/home/backup/`
- Using scp `$> scp -r /var/backup/2022_07_13_backup root@103.157.96.147:/home/backup/`
- Or using netcat:
  * On the receiver: `$> nc -l 1234 | tar xf -`
  * On the sender: `$> tar cf - /var/backup/2022_07_13_backup | nc 103.157.96.147 1234`