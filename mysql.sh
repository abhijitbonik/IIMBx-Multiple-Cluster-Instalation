
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

