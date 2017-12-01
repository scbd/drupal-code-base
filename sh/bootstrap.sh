#!/bin/bash
php security-checker.phar security:check ../composer.lock
echo "Composer init"

composer status -d=$APP_ROOT

# echo "change path to web"
# cd web

cd /var/www/html/web
echo "Drush config import"
drush -r -y cim
echo "Drush cache clear and rebuild"
drush -r -y cr drush
