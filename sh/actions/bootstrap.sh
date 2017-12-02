#!/bin/bash
php security-checker.phar security:check $APP_ROOT/composer.lock
echo "Composer init"

composer status -d=$APP_ROOT

# if server iport db
# rsync files

echo "Drush config import"
drush -r $APP_ROOT/web -y cim
echo "Drush cache clear and rebuild"
drush -r $APP_ROOT/web -y cr drush
