#!/bin/bash
echo "Composer update"
composer update
# echo "change path to web"
# cd web
echo "Drush config import"
drush -r -y "/var/www/html/web" cim
echo "Drush cache clear and rebuild"
drush -r -y "/var/www/html/web" cr