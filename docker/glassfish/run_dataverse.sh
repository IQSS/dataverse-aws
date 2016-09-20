#!/bin/sh

ASADMIN=${GLASSFISH_ROOT}/bin/asadmin

dvinstall/glassfish-setup.sh
${ASADMIN} deploy dvinstall/dataverse.war

ulimit -n 32768
LANG=en_US.UTF-8; export LANG

if [ "${DVN_INIT}"x == "true"x ]; then
    cd dvinstall && ./setup-all.sh
    psql -U ${DB_USER} -h ${DB_HOST} -d ${DB_NAME} -f dvinstall/reference_data.sql
fi
${ASADMIN} stop-domain ${GLASSFISH_DOMAIN}
$ASADMIN start-domain --verbose ${GLASSFISH_DOMAIN}
