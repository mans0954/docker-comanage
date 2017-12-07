#!/bin/bash

until [ -f /opt/raptor/web/keys/raptor-web-public.crt ]
do
     sleep 5
     echo "Waiting for Raptor web to come up"
done
keytool -import -noprompt -keystore /opt/raptor/mua/keys/authorised-keys.jks -storepass changeit -alias raptorweb -file /opt/raptor/web/keys/raptor-web-public.crt
/etc/init.d/raptormuad console
