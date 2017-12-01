#!/bin/bash
php security-checker.phar security:check ../composer.lock
echo "Composer update "

FILE=/run/secrets/settings.php
if [ -f $FILE ]; then
   composer update -d=$APP_ROOT --no-dev
else
   composer update -d=$APP_ROOT
fi

# echo "change path to web"
# cd web

cd /var/www/html/web
echo "Drush config import"
drush -r -y cim
echo "Drush cache clear and rebuild"
drush -r -y cr drush
