#!/bin/bash
SITENAME=$1
BASE='d10-master.local'
if [ $UID != 0 ]; then
  echo "Please run this script with sudo or as root"
  exit 0 
fi
if [ $SITENAME == "" ]; then
  echo "variable is empty or unset"
  exit 0
fi
if [ $SITENAME != "" ]; then 
  FILENAME="/etc/apache2/sites-available/"$SITENAME".conf"
  touch $FILENAME
  tee $FILENAME <<_EOF_
    <VirtualHost *:8080>
      DocumentRoot /var/www/html/$BASE/web
      ServerName $SITENAME
      ErrorLog ${APACHE_LOG_DIR}/error.log
      CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
_EOF_
  echo "127.0.0.1    $SITENAME" >> /mnt/c/Windows/System32/drivers/etc/hosts
  cd /var/www/html/$BASE/web/sites 
  mkdir $SITENAME
  cp default/default.settings.php $SITENAME/settings.php
  cd $SITENAME
  mkdir files
  cd /etc/apache2
  a2ensite $SITENAME
  echo "Done creating service $SITENAME"
  exit 1 
fi
