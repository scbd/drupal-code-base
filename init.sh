#!/bin/bash
echo "Wait for db"
set -e

openssl enc -d -aes-256-cbc -in config.tgz.enc -k $SRCKEY | tar xz

exec "$@"

if [ -f "/run/secrets/settings.php" ]
then
	./wait-for-it.sh drupal-1.cluster-c1c5sybjelgu.us-east-1.rds.amazonaws.com:3306 --timeout=0 --strict -- sh ./bootstrap.sh
else
	./wait-for-it.sh DRUPAL_mariadb:3306 --timeout=0 --strict -- sh ./bootstrap.sh
fi
