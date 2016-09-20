FROM centos

# Install Solr
RUN wget https://archive.apache.org/dist/lucene/solr/4.6.0/solr-4.6.0.tgz
RUN tar xvf solr-4.6.0.tgz
RUN mv solr-4.6.0 /usr/local/
# Put dataverse specific schema in place
RUN wget https://github.com/IQSS/dataverse/releases/download/v4.4/schema.xml
RUN mv schema.xml /usr/local/solr-4.6.0/example/solr/collection1/conf/
WORKDIR /usr/local/solr-4.6.0/example/

# Edit requestHeaderSize in jetty.xml to 102400
