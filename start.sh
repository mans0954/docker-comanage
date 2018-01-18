#!/bin/bash

until PGPASSWORD=${DB_PASSWORD} psql -h ${DB_HOST} -U ${DB_USER} -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - initialising"

NUMTABLES=`PGPASSWORD=${DB_PASSWORD} psql ${DB_NAME} -t -c "SELECT count(*) FROM pg_catalog.pg_tables where tableowner='comanage';" -h ${DB_HOST} -U ${DB_USER}`
echo "$NUMTABLES tables"

# Not sure what happens if the postgres container is existing, but the comanage container is new?
if [[ $NUMTABLES -eq 0 ]]; then
	echo "Initialising Database";
	pushd /srv/comanage/app/;
	su -s "/bin/bash" -c "./Console/cake database" www-data;
	./Console/cake setup --admin-given-name=${ADMIN_GIVEN_NAME} --admin-family-name=${ADMIN_FAMILY_NAME} --admin-username=${ADMIN_USERNAME} --enable-pooling=no;
	popd;
fi

# Start Shibd
/etc/init.d/shibd start

env -i LANG=C PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin apache2ctl -D FOREGROUND

