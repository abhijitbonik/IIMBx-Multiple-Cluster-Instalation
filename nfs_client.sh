#install nfs client

sudo -S <<< $1 apt-get update
sudo -S <<< $1 apt-get install nfs-common -y

#and mount the directory
sudo -S <<< $1 mount $2:/var/www/html/iimbx/sites/default/files /var/www/html/iimbx/sites/default/files