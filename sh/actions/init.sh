#!/bin/bash
set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [ -f "config.tgz.enc" ]
then
    echo "Decrypt config"
    openssl enc -d -aes-256-cbc -in $APP_ROOT/config.tgz.enc -k `cat /run/secrets/SRCKEY` | tar xz
    mv config $APP_ROOT/config
fi

echo "Wait for db"
if [ -f "/run/secrets/settings.php" ]
then
	$APP_ROOT/sh/actions/wait-for-it.sh drupal-1.cluster-c1c5sybjelgu.us-east-1.rds.amazonaws.com:3306 --timeout=0 --strict -- sh $APP_ROOT/sh/actions/bootstrap.sh
else
	$APP_ROOT/sh/actions/wait-for-it.sh DRUPAL_mariadb:3306 --timeout=0 --strict -- sh $APP_ROOT/sh/actions/bootstrap.sh
fi


exec "$@"
