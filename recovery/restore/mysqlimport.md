## mysqlimport
The `mysqlimport` client provides a command-line interface to the LOAD DATA SQL statement.
The database and tables must defined on the first place.

## Restore data
- syntax: `$> mysqlimport [options] db_name textfile1 [textfile2 ...]`
- execute table structure first `$> mysql sandbox_db < settings.sql`
- another table `$> mysql sandbox_db < users.sql`
- import the data `$> mysqlimport sandbox_db /var/lib/mysql-files/settings.txt /var/lib/mysql-files/users.txt`

## Source backup
- `$> mysqldump --tab=/var/lib/mysql-files sandbox_db`


## Use `LOAD DATA` command
## Restore data
- `mysql> USE db1;`
- `mysql> LOAD DATA INFILE 't1.txt' INTO TABLE t1;`

## Source backup
- `mysql> SELECT * INTO OUTFILE 'file_name' FROM tbl_name`