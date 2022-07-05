## Innodb Cluster
MySQL InnoDB Cluster provides a complete high availability solution for MySQL.
By using AdminAPI, which is included with MySQL Shell, you can easily configure and administer a group of at least three 
MySQL server instances to function as an InnoDB Cluster. 

### Prepare Server with MySql Server installed
- `157.245.196.139` - instance 1
- `157.245.52.72` - instance 2
- `206.189.35.68` - instance 3

### Install MySql Shell
- `$> sudo apt-get update`
- `$> sudo apt-get install mysql-shell` 
- Or install via snap `$> sudo snap install mysql-shell`

### Install MySql Router
- `$> sudo apt-get update`
- `$> sudo apt-get install mysql-router`

## Setup Innodb Cluster
Start with group replication and create cluster with in or create cluster directly from one of nodes then group replication auto created

### Setup server 1
- `$> mysqlsh`
- `mysql-py> \connect root@157.245.196.139`\
  or with command `shell.connect("root@157.245.196.139")`
- `mysql-py> dba.create_cluster("myCluster")`\
  if current instance doesn't meet the requirement of cluster, 
  it will error and need to run `configure_instance()` first
- Check current server if configurations for the cluster:\
`mysql-py> dba.check_instance_configuration()`
- Auto fix instance configuration by run command:\
`mysql-py> dba.configure_instance()`

### Setup server 2
- You can log in into server 2, or you can configure from any server:\
`mysql-py> dba.check_instance_configuration("root@157.245.52.72:3306")`
- Auto configure instance:\
`mysql-py> dba.configure_instance("root@157.245.52.72:3306")`

### Setup server 3
- You can log in into server 3, or you can configure from any server:
`mysql-py> dba.check_instance_configuration("root@206.189.35.68:3306")`
- Auto configure instance:\
`mysql-py> dba.configure_instance("root@206.189.35.68:3306")`


## Create New Cluster
After configure instances, from any server / instance that run mysql shell, for example start from server 1:
- Server 1 is auto added to cluster, when create cluster fail due to replication configuration, 
  set config manually then run the command again\
  `mysql-py> var cluster = dba.create_cluster("myCluster")`
- Add server 2\
  `mysql-py> cluster.add_instance("root@157.245.52.72:3306")`\
  when `gtid` empty or not match select to `Clone` the data
- Add server 3\
  `mysql-py> cluster.add_instance("root@206.189.35.68:3306")` 
- Show status of cluster status:\
  `mysql-py> cluster.status()`


## Bootstrap MySql Router
- Router can live outside the cluster, same server of the client app is recommended, and can be bootstrapped from any node of cluster:\
`$> mysqlrouter --bootstrap root@localhost:3306 --directory /tmp/myrouter --conf-use-sockets --account routerfriend --account-create always`

- If app and router live in the other server, then the app must connect to host 157.245.52.72 not the localhost (router) and related port\
`$> mysqlrouter --bootstrap root@157.245.52.72:3306 --directory /tmp/myrouter --conf-use-sockets --account routerfriend --account-create always`
```ini
Output:
### MySQL Classic protocol
- Read/Write Connections: localhost:6446, /tmp/myrouter/mysql.sock
- Read/Only Connections:  localhost:6447, /tmp/myrouter/mysqlro.sock

### MySQL X protocol
- Read/Write Connections: localhost:6448, /tmp/myrouter/mysqlx.sock
- Read/Only Connections:  localhost:6449, /tmp/myrouter/mysqlxro.sock
```
- Start the router `$> cd /tmp/myrouter` then `$> ./start.sh`


## Connect the Router from MySql Shell
Assume the application is running to connect the cluster via MySql Router:
- Connect the router (Read/Only Connections): `mysql-py> \c root@157.245.196.139:6447`
- Change to SQL mode: `mysql-py> \sql`
- Check connected server: `mysql-sql> SELECT @@hostname;` will showing instance handle Read/Only
- The connection seamlessly switches between read-only server node (round-robin)
- Connect the router (Read/Write Connections): `mysql-sql> \c root@157.245.196.139:6446`
- Check connected server: `mysql-sql> SELECT @@hostname;` will showing instance handle Read/Write

## Connect From Application
Set application setting database connection to MySql Router read-only / write connection, 
not the server directly. Each application server node is recommend to install one MySql Router
not in separate server or in cluster node due to speed of socket communication. 
Following the application test build with PHP (Codeigniter 4)
https://github.com/anggadarkprince/innodb-cluster-app-test.

## Managing Instance
### Remove instance
- `mysql-py> cluster.remove_instance('root@157.245.196.139:3306')`
- `mysql-py> cluster.status()`

### Rejoin instance
- `mysql-py> var cluster = dba.get_cluster('myCluster')`
- `mysql-py> cluster.rejoin_instance('root@157.245.196.139:3306')`
- `mysql-py> cluster.status()`

### A recovering cluster when all member offline
- `mysql-py> shell.connect('root@localhost:3310')`
- `mysql-py> cluster = dba.get_cluster()`
- `mysql-py> var cluster = dba.reboot_cluster_from_complete_outage()`
- `mysql-py> cluster.status()`