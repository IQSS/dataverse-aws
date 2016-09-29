FROM centos

EXPOSE 8080 4848 8181

ENV HOST_ADDRESS ${HOST_ADDRESS:-localhost}
ENV GLASSFISH_ROOT ${GLASSFISH_ROOT:-/usr/local/glassfish4}
ENV GLASSFISH_DOMAIN ${GLASSFISH_DOMAIN:-domain1}
ENV FILES_DIR ${FILES_DIR:-/usr/local/dvn/data}
ENV DB_NAME ${DB_NAME:-dvndb}
ENV DB_PORT ${DB_PORT:-5432}
ENV DB_HOST ${DB_HOST:-localhost}
ENV DB_USER ${DB_USER:-dvnuser}
ENV DB_PASS ${DB_PASS:-dvnsecret}
ENV RSERVE_HOST ${RSERVE_HOST:-localhost}
ENV RSERVE_PORT ${RSERVE_PORT:-6311}
ENV RSERVE_USER ${RSERVE_USER:-rserve}
ENV RSERVE_PASS ${RSERVE_PASS:-rserve}
ENV SMTP_SERVER ${SMTP_SERVER:-localhost}
ENV MEM_HEAP_SIZE ${MEM_HEAP_SIZE:-1024}

ENV DOI_AUTHORITY ${DOI_AUTHORITY}
ENV DOI_PASSWORD ${DOI_PASSWORD}
ENV DOI_USERNAME ${DOI_USERNAME}

ENV DVN_INIT false

# Install java-1.8.0 and set as default
RUN yum install -y java-1.8.0-openjdk-devel
#RUN alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java

# Install glassfish
RUN yum install -y unzip
RUN curl -L http://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip -o glassfish-4.1.zip
RUN unzip glassfish-4.1.zip
RUN mv glassfish4 /usr/local/
# Patch Weld for dataverse
RUN rm /usr/local/glassfish4/glassfish/modules/weld-osgi-bundle.jar
RUN curl -L http://central.maven.org/maven2/org/jboss/weld/weld-osgi-bundle/2.2.10.SP1/weld-osgi-bundle-2.2.10.SP1-glassfish4.jar -o weld-osgi-bundle-2.2.10.SP1-glassfish4.jar
RUN mv weld-osgi-bundle-2.2.10.SP1-glassfish4.jar /usr/local/glassfish4/glassfish/modules/weld-osgi-bundle.jar

# Install dataverse
RUN yum install -y perl
RUN curl -L https://github.com/IQSS/dataverse/releases/download/v4.5/dvinstall.zip -o dvinstall.zip
RUN unzip dvinstall.zip

# Install jq
RUN curl -L http://stedolan.github.io/jq/download/linux64/jq -o jq
RUN chmod u+x jq
RUN mv jq /usr/bin

# Install jdbc driver
RUN cp dvinstall/pgdriver/postgresql-9.1-902.jdbc4.jar /usr/local/glassfish4/glassfish/lib/
# Install jhove config
RUN cp dvinstall/jhove.conf /usr/local/glassfish4/glassfish/domains/domain1/config

# Specify volume for shared storage
VOLUME /data/dvn:/usr/local/dvn/data

# 
COPY run_dataverse.sh /run_dataverse.sh
RUN chmod u+x run_dataverse.sh

# 
CMD /run_dataverse.sh
