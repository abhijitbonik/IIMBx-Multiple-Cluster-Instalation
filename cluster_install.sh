#provide the nfs ip adress. It will be on of the two ip addresses of Web servers where drupal will be installed

echo "Enter password for your current machine"
read -s currsyspassword

echo "Enter details of the machine for MySQL installation"
echo "Enter IP address: "
read mysqlipaddress
echo "Enter username: "
read mysqlusername
echo "Enter password: "
read -s mysqlpassword

echo "Enter details of the machine for Web 1"
echo "Enter IP address: "
read web1ipaddress
echo "Enter username: "
read web1username
echo "Enter password: "
read -s web1password

echo "Enter details of the machine for Web 2"
echo "Enter IP address: "
read web2ipaddress
echo "Enter username: "
read web2username
echo "Enter password: "
read -s web2password

echo "Enter details of the machine for HAProxy"
echo "Enter IP address: "
read haproxyipaddress
echo "Enter username: "
read haproxyusername
echo "Enter password: "
read -s haproxypassword

#!/bin/bash
#install sshpass for accessing remote by providing password as an argument
sudo -S <<< "$currsyspassword" apt-get install sshpass

#Copy the script to be executed on mysql server
sshpass -p "$mysqlpassword" scp mysql.sh $mysqlusername@$mysqlipaddress:~/

#changing mysql file permission on a remote machine 
sshpass -p "$mysqlpassword" ssh $mysqlusername@$mysqlipaddress chmod 777 /home/$mysqlusername/mysql.sh

#run the script  on mysql server.
sshpass -p "$mysqlpassword" ssh $mysqlusername@$mysqlipaddress /home/$mysqlusername/mysql.sh $mysqlpassword

#Copy the script to web 1
sshpass -p "$web1password" scp web.sh $web1username@$web1ipaddress:~/ 

#changing the file permission 
sshpass -p "$web1password" ssh $web1username@$web1ipaddress chmod 777 /home/$web1username/web.sh

#Execute the script on web 1
sshpass -p "$web1password" ssh $web1username@$web1ipaddress /home/$web1username/web.sh $web1password

#Copy the script to web 2
sshpass -p "$web2password" scp web.sh $web2username@$web2ipaddress:~/ 

#changing file permission
sshpass -p "$web2password" ssh $web2username@$web2ipaddress chmod 777 /home/$web2username/web.sh

#Execute the script on web 2
sshpass -p "$web2password" ssh $web2username@$web2ipaddress /home/$web2username/web.sh $web2password

#Copy the script to haproxy server
sshpass -p "$haproxypassword" scp haproxy.sh $haproxyusername@$haproxyipaddress:~/ 

#changing the permission
sshpass -p "$haproxypassword" ssh $haproxyusername@$haproxyipaddress chmod 777 /home/$haproxyusername/haproxy.sh

#Execute the script on haproxy server
sshpass -p "$haproxypassword" ssh $haproxyusername@$haproxyipaddress /home/$haproxyusername/haproxy.sh $haproxypassword $web1ipaddress $web2ipaddress


#Copy the script to nfs server
sshpass -p "$web2password" scp nfs_server.sh $web2username@$web2ipaddress:~/

#changing file permission
sshpass -p "$web2password" ssh $web2username@$web2ipaddress chmod 777 /home/$web2username/nfs_server.sh

#Execute the script in nfs server 
sshpass -p "$web2password" ssh $web2username@$web2ipaddress /home/$web2username/nfs_server.sh $web2password $web2ipaddress

#Copy the script to nfs client
sshpass -p "$web1password" scp nfs_client.sh $web1username@$web1ipaddress:~/

#chnaging the file permission on a remote machine
sshpass -p "$web1password" ssh $web1username@$web1ipaddress chmod 777 /home/$web1username/nfs_client.sh

#Execute the script on nfs client 
sshpass -p "$web1password" ssh $web1username@$web1ipaddress /home/$web1username/nfs_client.sh $web1password $web1ipaddress
