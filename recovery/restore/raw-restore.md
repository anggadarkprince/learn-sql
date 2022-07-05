## Restore from a raw copy of MySql data

### Restore the database
- Stop mysql before restore `$> sudo systemctl stop mysql`
- Rename current data folder as backup `sudo mv /var/lib/mysql /var/lib/mysql_old`
- Create a new folder or data `$> sudo mkdir /var/lib/mysql`
- Restore mysql backup folder `$> sudo cp -R /var/backup/2022_07_13_backup/. /var/lib/mysql`
- Set folder ownership `$> sudo chown -R mysql:mysql /var/lib/mysql`
- Start mysql service `$> sudo systemctl start mysql`

### Test the backup
- Stop the mysql service `$> sudo mysql -u root -p`
- Check the database list `mysql> SHOW DATABASES;`