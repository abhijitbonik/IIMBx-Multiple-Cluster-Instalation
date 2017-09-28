# IIMbx-Multiple-Cluster-Instation

This repository contains scripts for automating the installation and configuration of MySQL, IIMBx (2 instances of drupal), HAProxy. It also configures one instance of drupal as NFS Server while other has a NFS client.

The cluster_install.sh file is a shell scripting instalation file that we need to run.

Use following command to run the script.
```
./cluster_install.sh
```

The cluster_install.sh will call the required files and install and configure the clusters on multiple machines.

A brief description of scripts that will run are given below:
1) Mysql Script (mysql.sh) : It will install the mysql server to the cloud that is allocated for it.
  -- Check list of Grants on mysql server using -
     ``` 
     select user, host from mysql.user;
     ```    
2) IIMBx instalation script (web.sh): This script will run on two VMs, web 1 and web 2 
3) Load balancing using HAProxy (haproxy.sh): This script configures HAProxy using roundrobin algoirthm. So, while browsing the site, web1 and web2 will be used alternately.
5) Setting up NFS Client (nfs_client.sh): Configures web 1 as NFS client
6) Setting up NFS Server (nfs_server.sh): Configures web 2 as NFS server

Finally, the site is accessed using the IP address of the machine on which HAProxy is configured. 



