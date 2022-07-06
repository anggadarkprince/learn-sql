## Percona Monitoring and Management

### PMM Architecture Overview
The PMM tool uses a client-server model which makes it easy to scale monitoring across several 
databases hosted on various remote hosts.
- **PMM Server**: The Percona (PMM) Marketplace App deploys an instance of the PMM Server, which includes the Grafana web 
interface to visualize all the data collected from the databases it monitors.
- **PMM Client**: You will need to install the PMM Client on any Linode that hosts a database that you would like to monitor. 
The PMM Client will help you connect to the PMM Server and relay host and database performance metrics to the PMM Server.

### Installing PMM
- Nodes:
    * Server (monitoring): 174.138.17.7
    * Client (mysql): 209.97.165.241
- Install PMM Server: 
    * Applies to: All Docker compatible *nix based systems
    * curl -fsSL https://www.percona.com/get/pmm | /bin/bash
    * Running on https://174.138.17.7:443 with user default: `admin` and password `admin`
- Install PMM Client (where MySql running):
    * `$> wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb`
    * `$> sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb`
    * `$> sudo apt-get update`
    * `$> sudo apt-get install pmm2-client`
- Connect Client to Server\
`$> sudo pmm-admin config --server-insecure-tls --server-url=https://admin:admin@174.138.17.7`
- Create a PMM user for monitoring
    * `mysql> CREATE USER 'pmm'@'localhost' IDENTIFIED BY 'pass' WITH MAX_USER_CONNECTIONS 10;`
    * `mysql> GRANT SELECT, PROCESS, SUPER, REPLICATION CLIENT, RELOAD, BACKUP_ADMIN ON *.* TO 'pmm'@'localhost';`
    * `mysql> GRANT SELECT, PROCESS, SUPER, REPLICATION CLIENT, RELOAD, BACKUP_ADMIN ON *.* TO 'pmm'@'localhost';`
    * `$> sudo pmm-admin add mysql --username=pmm --password=pass --query-source=perfschema`