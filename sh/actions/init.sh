#!/bin/bash
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi
ls -al
if [ -f "$APP_ROOT/config.tgz.enc" ]
then
    if [ -f "/run/secrets/settings.php" ]
    then
      echo "Decrypt config -- "$APP_ROOT
      openssl enc -d -aes-256-cbc -in config.tgz.enc -k `cat /run/secrets/SRCKEY` | tar xz
      rm config.tgz.enc
      mv config/config/* /var/www/files/config/sync_dir
      rm -rf config
      ls -al
    fi
fi

ls -al /var/www/files/config/sync_dir
echo "Wait for db"
if [ -f "/run/secrets/settings.php" ]
then
	$APP_ROOT/sh/actions/wait-for-it.sh drupal-1.cluster-c1c5sybjelgu.us-east-1.rds.amazonaws.com:3306 --timeout=0 --strict -- sh $APP_ROOT/sh/actions/bootstrap.sh
else
	$APP_ROOT/sh/actions/wait-for-it.sh DRUPAL_mariadb:3306 --timeout=0 --strict -- sh $APP_ROOT/sh/actions/bootstrap.sh
fi


exec "$@"
