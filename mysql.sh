
#making the gui promt of mysql instalation non interactive
#and provide the password on debconf-set-selections
export DEBIAN_FRONTEND="noninteractive"

sudo -S <<< $1 apt-get update
sudo -S <<< $1 apt-get install -y debconf

sudo -S <<< $1 debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo -S <<< $1 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

sudo -S <<< $1 apt-get update
sudo -S <<< $1 apt-get install -y mysql-server

echo "Downloaing IIMbx database from Git Lab"
wget http://gitlab.cse.iitb.ac.in/mangeshg/iimbx/raw/master/iimbx_21082017.sql

echo "Creating a iimbx database"
mysql -uroot -proot -e "CREATE DATABASE iimbx ;"

echo "Importing the database on Mysql server"
mysql -u root -proot iimbx < iimbx_21082017.sql


echo "Commenting the bind bind-address to 127.0.0.1 for enabling remote log in"
sudo -S <<< $1 sed -i '/bind-address/c\\#bind-address		= 127.0.0.1' /etc/mysql/mysql.conf.d/mysqld.cnf

#for now please change the ip address with web 1 and web 2 ipddress
echo "Setting Permission for web 1"
mysql -uroot -proot -e " GRANT ALL ON *.* TO root@'10.129.26.103' IDENTIFIED BY 'root';"

echo "Setting permisiion for Web2"
mysql -uroot -proot -e " GRANT ALL ON *.* TO root@'10.129.26.103' IDENTIFIED BY 'root';"
