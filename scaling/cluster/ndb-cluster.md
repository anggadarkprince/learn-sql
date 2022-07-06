## NDB Cluster
This chapter provides information about MySQL NDB Cluster, a high-availability, high-redundancy version of MySQL adapted 
for the distributed computing environment. MySQL NDB Cluster does not support InnoDB Cluster.
NDB Cluster is a technology that enables clustering of in-memory databases in a shared-nothing system.

NDB Cluster is designed not to have any single point of failure. In a shared-nothing system, each component is expected 
to have its own memory and disk. NDB Cluster integrates the standard MySQL server with an in-memory clustered storage 
engine called NDB (which stands for “Network DataBase”).

An NDB Cluster consists of a set of computers, known as hosts, each running one or more processes. 
These processes, known as nodes, may include MySQL servers (for access to NDB data), data nodes (for storage of the data), 
one or more management servers, and possibly other specialized data access programs.
The relationship of these components in an NDB Cluster is shown here:  

<img src="https://dev.mysql.com/doc/refman/8.0/en/images/cluster-components-1.png">

In addition, a MySQL server that is not connected to an NDB Cluster cannot use the NDB storage engine and cannot access 
any NDB Cluster data.

There are three types of cluster nodes, and in a minimal NDB Cluster configuration, there are at least three nodes, one of each of these types:
- **Management node**: The role of this type of node is to manage the other nodes within the NDB Cluster
- **Data node**: This type of node stores cluster data. There are as many data nodes as there are fragment replicas.
- **SQL node**: This is a node that accesses the cluster data. In the case of NDB Cluster, an SQL node is a traditional MySQL server that uses the NDBCLUSTER storage engine.

## Install MySql Cluster
### Using the APT Repository
- Install mysql apt config `$> sudo apt-get install mysql-apt-config`\
Or manually setup by download `https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb` then run\
`sudo dpkg -i /PATH/version-specific-package-name.deb`
- `$> sudo apt-get update`
- Installing MySQL NDB Cluster
    * Install the components for **SQL nodes**: `$> sudo apt-get install mysql-cluster-community-server`
    * Install the executables for **management nodes**: `$> sudo apt-get install mysql-cluster-community-management-server`
    * Install the executables for **data  nodes**: `$> sudo apt-get install mysql-cluster-community-data-node`
- Configuring and Starting MySQL NDB Cluster
    * All configuration files (like my.cnf) are under `/etc/mysql`
    * All binaries, libraries, headers, etc., are under `/usr/bin` and `/usr/sbin`
    * The data directory is `/var/lib/mysql`

### Using binary release
- Download MySql Cluster on https://dev.mysql.com/downloads/cluster/
- Eg. `cd /var/tmp && wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster_8.0.29-1ubuntu21.10_amd64.deb-bundle.tar`
- Installing MySQL NDB Cluster following this instruction: https://dev.mysql.com/doc/refman/8.0/en/mysql-cluster-install-linux-binary.html


## Configure MySql Cluster
### Configuration Schema
- Each data node or SQL node requires a `my.cnf` file that provides two pieces of information: a connection string that 
tells the node where to find the management node, and a line telling the MySQL server on this host to enable the NDBCLUSTER storage engine. 
- The management node needs a config.ini file telling it how many fragment replicas to maintain, how much memory to 
allocate for data and indexes on each data node, where to find the data nodes, where to save data to disk on each 
data node, and where to find any SQL nodes. 
- Node servers:
    * **Management Node**: 178.128.22.169
    * **Data Node 1**: 206.189.32.112
    * **Data Node 2**: 206.189.47.118
    * **SQL Node**: 209.97.165.241

### Configuring the data nodes and SQL nodes
- Do this configuration for `Data Node 1`, `Data Node 2`, and `SQL Node`
- Create configuration file: `$> nano /etc/my.cnf` or use existing file on `/etc/mysql/my.cnf`
- Edit the configuration:
```ini
[mysqld]
# Options for mysqld process:
ndbcluster                      # run NDB storage engine

[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=178.128.22.169  # location of management server
```

### Configuring management node
- `$> mkdir -p /var/lib/mysql-cluster`
- `$> cd /var/lib/mysql-cluster`
- Create configuration node `$> node config.ini`
- Edit the configuration
```ini
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2    # Number of fragment replicas
DataMemory=98M    # How much memory to allocate for data storage

[ndb_mgmd]
# Management process options:
HostName=178.128.22.169         # Hostname or IP address of management node
DataDir=/var/lib/mysql-cluster  # Directory for management node log files

[ndbd]
# Options for data node "1":    # (one [ndbd] section per data node)
HostName=206.189.32.112         # Hostname or IP address
NodeId=2                        # Node ID for this data node
DataDir=/usr/local/mysql/data   # Directory for this data node's data files

[ndbd]
# Options for data node "2":
HostName=206.189.47.118         # Hostname or IP address
NodeId=3                        # Node ID for this data node
DataDir=/usr/local/mysql/data   # Directory for this data node's data files

[mysqld]
# SQL node options:
HostName=209.97.165.241         # Hostname or IP address
                                # (additional mysqld connections can be
                                # specified for this node for various
                                # purposes such as running ndb_restore)
```


## Initial Startup of NDB Cluster
- On the management host run this command, This option requires that `--initial` or `--reload` also be specified:\
  `$> ndb_mgmd --initial -f /var/lib/mysql-cluster/config.ini`
- On each of the data node hosts: `$> ndbd`
- On sql node: `$> mysqld_safe &`
- Run ndb_mgm to access the cluster: `$> ndb_mgm`
- Check cluster status: `ndb_mgm> SHOW`
```ini
Connected to Management Server at: localhost:1186
Cluster Configuration
---------------------
[ndbd(NDB)]     2 node(s)
id=2    @206.189.32.112  (Version: 8.0.29-ndb-8.0.30, Nodegroup: 0, *)
id=3    @206.189.47.118  (Version: 8.0.29-ndb-8.0.30, Nodegroup: 0)

[ndb_mgmd(MGM)] 1 node(s)
id=1    @178.128.22.169  (Version: 8.0.29-ndb-8.0.30)

[mysqld(API)]   1 node(s)
id=4    @209.97.165.241  (Version: 8.0.29-ndb-8.0.30)
```

## Test The Cluster
- On the SQL node: `$> mysql -uroot -p`
- Run these queries:
```mysql
DROP TABLE IF EXISTS `City`;
CREATE TABLE `City` (
  `ID` int(11) NOT NULL auto_increment,
  `Name` char(35) NOT NULL default '',
  `CountryCode` char(3) NOT NULL default '',
  `District` char(20) NOT NULL default '',
  `Population` int(11) NOT NULL default '0',
  PRIMARY KEY  (`ID`)
) ENGINE=NDBCLUSTER DEFAULT CHARSET=latin1;

INSERT INTO `City` VALUES (1,'Kabul','AFG','Kabol',1780000);
INSERT INTO `City` VALUES (2,'Qandahar','AFG','Qandahar',237500);
INSERT INTO `City` VALUES (3,'Herat','AFG','Herat',186800);
```

## Safe Shutdown & Restart
- To shut down the cluster, enter the following command in the management node: `$> ndb_mgm -e shutdown`
- To restart the cluster on Unix platforms, run these commands:
    * On the management host: `$> ndb_mgmd -f /var/lib/mysql-cluster/config.ini`
    * On each of the data node hosts: `$> ndbd`
    * On the SQL host: `$> mysqld_safe &`
    * Use the `ndb_mgm` client to verify that both data nodes have started successfully. 