FROM openjdk:8

ENV TERM ${TERM:-xterm}

# Install Solr
RUN curl -L https://archive.apache.org/dist/lucene/solr/4.6.0/solr-4.6.0.tgz -o solr-4.6.0.tgz
RUN tar xvf solr-4.6.0.tgz
RUN mv solr-4.6.0 /usr/local/

# Put dataverse specific schema in place
RUN curl -L https://github.com/IQSS/dataverse/releases/download/v4.5/schema.xml -o schema.xml
RUN mv schema.xml /usr/local/solr-4.6.0/example/solr/collection1/conf/

# Edit requestHeaderSize in jetty.xml to 102400
RUN sed -i '/<New class="org.eclipse.jetty.server.bio.SocketConnector">/a <Set name="requestHeaderSize">102400</Set>' /usr/local/solr-4.6.0/example/etc/jetty.xml

# Start solr service
WORKDIR /usr/local/solr-4.6.0/example/
CMD /usr/bin/java -Xmx1024m -DSTOP.PORT=8079 -DSTOP.KEY=mustard -jar start.jar 2> /var/log/solr.log
