#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/init.sh" ]]; then
# The following command will initialise the nami package,
# using comanage-inputs.json for inputs 
  nami_initialize net.cshoskin.comanage
  info "Starting comanage... "
  . /srv/comanage/local/start.sh

fi

exec tini -- "$@"
