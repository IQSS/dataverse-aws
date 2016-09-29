#!/bin/sh

ASADMIN=${GLASSFISH_ROOT}/bin/asadmin

dvinstall/glassfish-setup.sh
# use non-standard ports to make service unavailable until correct DOI credentials in place
${ASADMIN} set server.http-service.http-listener.http-listener-1.port=60001
${ASADMIN} set server.http-service.http-listener.http-listener-2.port=60002
${ASADMIN} deploy dvinstall/dataverse.war

ulimit -n 32768
LANG=en_US.UTF-8; export LANG

[ "${DOI_AUTHORITY}"x != ""x ] && curl -X PUT -d "${DOI_AUTHORITY}" http://localhost:8080/api/admin/settings/:Authority

# delete old credentials before creating new ones
"${ASADMIN}" delete-jvm-options "-Ddoi.username=apitest"
"${ASADMIN}" create-jvm-options "-Ddoi.username=${DOI_USERNAME}"

"${ASADMIN}" delete-jvm-options "-Ddoi.password=apitest"
"${ASADMIN}" create-jvm-options "-Ddoi.password=${DOI_PASSWORD}"

"${ASADMIN}" stop-domain "${GLASSFISH_DOMAIN}"
${ASADMIN} set server.http-service.http-listener.http-listener-1.port=8080
${ASADMIN} set server.http-service.http-listener.http-listener-2.port=8181
"${ASADMIN}" start-domain --verbose "${GLASSFISH_DOMAIN}"
