#!/bin/bash

until [ -f /opt/raptor/mua/keys/raptor-mua-public.crt ]
do
     sleep 5
     echo "Waiting for Raptor MUA to come up"
done

keytool -import -keystore /opt/raptor/ica/keys/authorised-keys.jks -storepass changeit -alias raptormua -file /opt/raptor/mua/keys/raptor-mua-public.crt
/etc/init.d/raptormuad console
