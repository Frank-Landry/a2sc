#!/bin/bash
SITENAME=$1
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
      DocumentRoot /var/www/html/$SITENAME/web
      ServerName $SITENAME
      ErrorLog ${APACHE_LOG_DIR}/error.log
      CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
_EOF_
  echo "127.0.0.1    $SITENAME" >> /mnt/c/Windows/System32/drivers/etc/hosts
  cd /etc/apache2
  a2ensite $SITENAME
  cd /var/www/html 
  /mnt/c/ProgramData/ComposerSetup/bin/composer create-project drupal/recommended-project $SITENAME --no-install
  echo "Done creating service $SITENAME"
  exit 1 
fi
