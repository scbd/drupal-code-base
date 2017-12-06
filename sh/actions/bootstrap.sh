echo "Wait for db"
if [ -f "/run/secrets/settings.php" ]
then
	$APP_ROOT/sh/actions/wait-for-it.sh drupal-1.cluster-c1c5sybjelgu.us-east-1.rds.amazonaws.com:3306 --timeout=0 --strict -- echo "AURORA is up"
else
	$APP_ROOT/sh/actions/wait-for-it.sh DRUPAL_mariadb:3306 --timeout=0 --strict -- echo "DRUPAL_mariadb is up"
fi
#!/bin/bash

echo "Drush security check"
php $APP_ROOT/sh/actions/security-checker.phar security:check $APP_ROOT/composer.lock

chmod -R 770 /var/www/html/tmp

echo "Composer init"
sudo -u www-data composer status -d=$APP_ROOT

# if server iport db
# rsync files
if [ -f "$APP_ROOT/config.tgz.enc" ]
then
  echo "Drush maintenance_mode on"
  drush -r $APP_ROOT/web sset system.maintenance_mode 1 -y
  echo "Drush config import"
  drush -r $APP_ROOT/web -y cim
  echo "Drush updatedb"
  drush -r $APP_ROOT/web updatedb -y
  echo "Drush entup"
  drush -r $APP_ROOT/web entup -y
  echo "Drush cache clear and rebuild"
  drush -r $APP_ROOT/web -y cr drush
  echo "Drush maintenance_mode off"
  drush -r $APP_ROOT/web sset system.maintenance_mode 0 -y
  rm $APP_ROOT/config.tgz.enc
fi

echo "ls -al /var/www/files/config/sync_dir"
ls -al /var/www/files/config/sync_dir
echo "ls -al /var/www/html"
ls -al /var/www/html

fmp-php -R
