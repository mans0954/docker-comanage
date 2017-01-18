#!/bin/bash

NUMTABLES=`PGPASSWORD=comanage psql comanage -t -c "SELECT count(*) FROM pg_catalog.pg_tables where tableowner='comanage';" -h postgres -U comanage`
echo "$NUMTABLES tables"

# Not sure what happens if the postgres container is existing, but the comanage container is new?
if [[ $NUMTABLES -eq 0 ]]; then
	echo "Initialising Database";
	pushd /srv/comanage/app/;
	su -s "/bin/bash" -c "./Console/cake database" www-data;
	./Console/cake setup --admin-given-name=Alfred --admin-family-name=Wessex --admin-username=admin --enable-pooling=no;
	popd;
fi

env -i LANG=C PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin apache2ctl -D FOREGROUND

