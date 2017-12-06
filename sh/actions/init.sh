#!/bin/bash
set -e
su www-data
if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [ -f "$APP_ROOT/config.tgz.enc" ]
then
    if [ -f "/run/secrets/settings.php" ]
    then
      echo "Decrypt config -- "$APP_ROOT
      sudo -u www-data openssl enc -d -aes-256-cbc -in config.tgz.enc -k `cat /run/secrets/SRCKEY` | tar xz
      #rm config.tgz.enc
      sudo -u www-data mv config/config/* /var/www/files/config/sync_dir
      rm -rf config
    fi
fi

$APP_ROOT/sh/actions/wait-for-it.sh DRUPAL_nginx:80 --timeout=0 --strict -- sh $APP_ROOT/sh/actions/bootstrap.sh

exec "$@"
