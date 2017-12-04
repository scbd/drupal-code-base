#!/bin/bash
php $APP_ROOT/sh/actions/security-checker.phar security:check $APP_ROOT/composer.lock

chmod -R 770 /var/www/html/tmp

echo "Composer init"

composer status -d=$APP_ROOT

# if server iport db
# rsync files

drush -r $APP_ROOT/web sset system.maintenance_mode 1 -y
echo "Drush config import"
drush -r $APP_ROOT/web -y cim
drush -r $APP_ROOT/web updatedb -y
 drush -r $APP_ROOT/web entup -y
echo "Drush cache clear and rebuild"
drush -r $APP_ROOT/web -y cr drush
drush -r $APP_ROOT/web sset system.maintenance_mode 0 -y
