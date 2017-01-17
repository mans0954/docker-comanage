#!/bin/bash

su -s "/bin/bash" -c "pushd /srv/comanage/app/ && ./Console/cake database && popd" www-data
env -i LANG=C PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin apache2ctl start

