echo "Downloading package for Drupal instalation"
echo "Installing Debian/Ubuntu packages..."

#following command will install Apache2, Mysql server ,  Php7.0, all php package require for Drupal 
sudo -S <<< $1 apt-get update
sudo -S <<< $1 apt-get --yes install apache2 
sudo -S <<< $1 apt-get --yes install curl 
sudo -S <<< $1 apt-get --yes install php7.0 
sudo -S <<< $1 apt-get --yes install php7.0-mysql php7.0-xml 
sudo -S <<< $1 apt-get --yes install php7.0-gd php7.0-mbstring 
sudo -S <<< $1 apt-get --yes install libapache2-mod-php snmp 
sudo -S <<< $1 apt-get --yes install libsnmp-dev php7.0-cli 
sudo -S <<< $1 apt-get --yes install php7.0-curl php-mcrypt

#acttivating the firewall using Apache Full protection
echo "Applying Apache Full firewall"
sudo -S <<< $1 ufw allow in "Apache Full"

#The following command will replace a line so that the server can access the index.php from root location
sudo -S <<< $1 sed -i '/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/c\DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm' /etc/apache2/mods-available/dir.conf

#The following comman will set allow_url_fopen to Off in php.ini file
#sed editor is used for editing the file

echo " Modifying the php.ini file"     
sudo -S <<< $1 sed -i 's/allow_url_fopen\s*=.*/allow_url_fopen=Off/g' /etc/php/7.0/apache2/php.ini
sudo -S <<< $1 sed -i 's/expose_php\s*=.*/expose_php=Off/g' /etc/php/7.0/apache2/php.ini

#setting apache url rewrite mode
echo "Setting up the Apache mod_rewrite for Drupal clean urls..."
sudo -S <<< $1 a2enmod rewrite

#it will add the servername name and override all permission in the virtual host
sudo -S <<< $1 sed -i '/#ServerName www.example.com/c\\t ServerName  localhost' /etc/apache2/sites-available/000-default.conf

#adding root to /var/www/html/iimbx
sudo -S <<< $1 sed -i '/DocumentRoot /var/www/html/c\\t DocumentRoot /var/www/html/iimbx' /etc/apache2/sites-available/000-default.conf

sudo -S <<< $1 sed -i '13 a \\t <Directory /var/www/html>' /etc/apache2/sites-available/000-default.conf
sudo -S <<< $1 sed -i '14 a \\t\t	AllowOverride All' /etc/apache2/sites-available/000-default.conf
sudo -S <<< $1 sed -i '15 a \\t	</Directory>' /etc/apache2/sites-available/000-default.conf


#restart the apache server
echo "Restarting the apache server"  
sudo -S <<< $1 service apache2 restart

#following command will download the iimbx archive from git lab into the directory where this bash script is located
echo "Downloaing IIMbx from Git Lab"
wget http://gitlab.cse.iitb.ac.in/mangeshg/iimbx/repository/archive.tar.gz


#create a directory under /var/www/html
#extract the contents ot that directory
#use strip-components to eliminate the root folder in the zip file
echo "Extracting the zip file and placing it in /var/www/html/iimbx"
sudo -S <<< $1 mkdir /var/www/html/iimbx/
sudo -S <<< $1 chmod 777 -R /var/www/html/iimbx/
sudo -S <<< $1 tar -pxvf archive.tar.gz -C /var/www/html/iimbx --strip-components=1

echo "Creating new setting.php file for iimbx and providing permissions"
sudo -S <<< $1 rm /var/www/html/iimbx/sites/default/settings.php
sudo -S <<< $1 cp /var/www/html/iimbx/sites/default/default.settings.php /var/www/html/iimbx/sites/default/settings.php
sudo -S <<< $1 chmod 777 -R /var/www/html/iimbx/