#!/bin/bash
echo "starting to build stack $1" \
	#&& docker build -t dataverse:latest docker/glassfish \
	#&& docker tag dataverse:latest vtti/dataverse:latest \
	#&& docker push vtti/dataverse:latest \
	#&& docker build -t dataverse-solr:latest docker/solr \
	#&& docker tag dataverse-solr:latest vtti/dataverse-solr:latest \
	#&& docker push vtti/dataverse-solr:latest \
	aws cloudformation create-stack --stack-name $1 \
		--template-body file://./dataverse.json \
		--parameters \
			ParameterKey=AdvertisedIPAddress,ParameterValue=private \
			ParameterKey=AllowSSHFrom,ParameterValue=0.0.0.0/0 \
			ParameterKey=ClusterSize,ParameterValue=3 \
			ParameterKey=DataverseAdminEmail,ParameterValue=dataverse@mailinator.com \
			ParameterKey=DiscoveryURL,ParameterValue=`curl -s -L https://discovery.etcd.io/new?size=3` \
			ParameterKey=DockerRepoStringGlassfish,ParameterValue=vtti/dataverse \
			ParameterKey=DockerRepoStringSolr,ParameterValue=vtti/dataverse-solr \
			ParameterKey=DockerTagGlassfish,ParameterValue=latest \
			ParameterKey=DockerTagSolr,ParameterValue=latest \
			ParameterKey=DOIAuthority,ParameterValue=10.5072/FK2 \
			ParameterKey=DOIPassword,ParameterValue=apitest \
			ParameterKey=DOIUsername,ParameterValue=apitest \
			ParameterKey=EmailAddress,ParameterValue=dataverse@mailinator.com \
			ParameterKey=EmailPassword,ParameterValue= \
			ParameterKey=EmailServer,ParameterValue=mail.mailinator.com \
			ParameterKey=EmailUser,ParameterValue= \
			ParameterKey=InstanceType,ParameterValue=t2.medium \
			ParameterKey=KeyPair,ParameterValue=dataverse-shared \
			ParameterKey=PostgreSQLAllocatedStorage,ParameterValue=5 \
			ParameterKey=PostgreSQLDataversePassword,ParameterValue=root1234 \
			ParameterKey=PostgreSQLMultiAZ,ParameterValue=No \
			ParameterKey=PostgreSQLPassword,ParameterValue=root1234 \
			ParameterKey=PostgreSQLServerInstanceType,ParameterValue=db.m4.large \
			ParameterKey=SolrInstanceType,ParameterValue=t2.medium \
			ParameterKey=CertificateId,ParameterValue= \
		--capabilities=CAPABILITY_IAM
			#ParameterKey=DBSnapshotName,ParameterValue=arn:aws:rds:us-east-1:116738740634:snapshot:dvn0-2016-10-05-16-23 \
