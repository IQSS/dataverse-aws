#!/bin/sh

ASADMIN=${GLASSFISH_ROOT}/bin/asadmin

dvinstall/glassfish-setup.sh
${ASADMIN} deploy dvinstall/dataverse.war

ulimit -n 32768
LANG=en_US.UTF-8; export LANG

[ "${DOI_AUTHORITY}"x != ""x ] && curl -X PUT -d "${DOI_AUTHORITY}" http://localhost:8080/api/admin/settings/:Authority

"${ASADMIN}" stop-domain "${GLASSFISH_DOMAIN}"

# delete old credentials before creating new ones
[ "${DOI_USERNAME}"x != ""x ] && "${ASADMIN}" delete-jvm-options "-Ddoi.username=apitest"
[ "${DOI_USERNAME}"x != ""x ] && "${ASADMIN}" create-jvm-options "-Ddoi.username=${DOI_USERNAME}"

[ "${DOI_PASSWORD}"x != ""x ] && "${ASADMIN}" delete-jvm-options "-Ddoi.password=apitest"
[ "${DOI_PASSWORD}"x != ""x ] && "${ASADMIN}" create-jvm-options "-Ddoi.password=${DOI_PASSWORD}"

"${ASADMIN}" start-domain --verbose "${GLASSFISH_DOMAIN}"