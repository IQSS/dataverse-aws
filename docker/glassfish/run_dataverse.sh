#!/bin/sh

ASADMIN=${GLASSFISH_ROOT}/bin/asadmin

dvinstall/glassfish-setup.sh
# use non-standard ports to make service unavailable until correct DOI credentials in place
#${ASADMIN} set server.http-service.http-listener.http-listener-1.port=60001
#${ASADMIN} set server.http-service.http-listener.http-listener-2.port=60002
${ASADMIN} deploy dvinstall/dataverse.war

ulimit -n 32768
LANG=en_US.UTF-8; export LANG

[ "x${DOI_AUTHORITY}"x != "x" ] && curl -X PUT -d "${DOI_AUTHORITY}" http://localhost:8080/api/admin/settings/:Authority

# reset solr location
echo ""
curl -X PUT -d ${SOLR_HOST}:8983 http://localhost:8080/api/admin/settings/:SolrHostColonPort
echo ""
echo ""

# destructively reindex solr
curl http://localhost:8080/api/admin/index/clear
echo ""
echo ""
curl http://localhost:8080/api/admin/index
echo ""
echo ""

# delete old credentials before creating new ones
"${ASADMIN}" delete-jvm-options "-Ddoi.username=apitest"
"${ASADMIN}" create-jvm-options "-Ddoi.username=${DOI_USERNAME}"

"${ASADMIN}" delete-jvm-options "-Ddoi.password=apitest"
"${ASADMIN}" create-jvm-options "-Ddoi.password=${DOI_PASSWORD}"

# If SMTP_USER was set, enable auth
if [ "x${SMTP_USER}" != "x" ];
then
    "${ASADMIN}" delete-javamail-resource mail/notifyMailSession
    #"${ASADMIN}" create-javamail-resource server.resources.mail-resource.mail/notifyMailSession.user=${SMTP_USER}
    # From https://java.net/jira/browse/GLASSFISH-13622
    "${ASADMIN}" create-javamail-resource --mailhost ${SMTP_SERVER} \
        --fromaddress ${SMTP_EMAIL} --mailuser ${SMTP_USER} \
        --property mail.smtp.host=${SMTP_SERVER}:mail.smtp.starttls.enable=true:mail.smtp.auth=true:mail.smtp.password=${SMTP_PASSWORD} \
        mail/notifyMailSession

fi

"${ASADMIN}" stop-domain "${GLASSFISH_DOMAIN}"
#${ASADMIN} set server.http-service.http-listener.http-listener-1.port=8080
#${ASADMIN} set server.http-service.http-listener.http-listener-2.port=8181
"${ASADMIN}" start-domain --verbose "${GLASSFISH_DOMAIN}"

