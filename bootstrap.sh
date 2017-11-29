#!/bin/bash
echo "Composer update"
composer update
# echo "change path to web"
# cd web
echo "Drush config import"
drush -r "/var/www/html/web" cim
echo "Drush cache clear and rebuild"
drush -r "/var/www/html/web" cr
