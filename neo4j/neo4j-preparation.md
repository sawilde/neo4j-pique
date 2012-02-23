#Preparing neo4j for use with neo4j-pique in development and test

Get neo4j from http://neo4j.org/ and unpack it e.g. ~/apps/neo4j-community-1.6.

Download from https://github.com/jexp/neo4j-clean-remote-db-addon/downloads the version that matches your neo4j and unpack it, e.g. ~/apps/neo4j-community-1.6/plugins. 

Test it works by executing the neo4j.sh as directed in the instructions. 

Next is to make versions of neo4j available to just your application without having multiple copies populating your hard drive or with them interfering with each other; the following was paraphrased from [neoid](https://github.com/elado/neoid).

> mkdir dev
> cd dev
> ln -s ~/apps/neo4j-community-1.6/bin bin
> ln -s ~/apps/neo4j-community-1.6/lib lib
> ln -s ~/apps/neo4j-community-1.6/plugins plugins
> ln -s ~/apps/neo4j-community-1.6/system system
> mkdir conf
> cp ~/apps/neo4j-community-1.6/conf/* conf
> mkdir data
> cd ..
> mkdir test
> cd test
> ln -s ~/apps/neo4j-community-1.6/bin bin
> ln -s ~/apps/neo4j-community-1.6/lib lib
> ln -s ~/apps/neo4j-community-1.6/plugins plugins
> ln -s ~/apps/neo4j-community-1.6/system system
> mkdir conf
> cp ~/apps/neo4j-community-1.6/conf/* conf
> mkdir data
> cd ..

Then we need to make them run on individual ports so we can control which instance is being used during development and (if necessary) test.

edit dev/conf/neo4j-server.properties and set the port (org.neo4j.server.webserver.port) to 7480.

add the following two lines to the bottom of the file

> org.neo4j.server.thirdparty_jaxrs_classes=org.neo4j.server.extension.test.delete=/cleandb
> org.neo4j.server.thirdparty.delete.key=secret-key

edit test/conf/neo4j-server.properties and set the port (org.neo4j.server.webserver.port) to 7481.

add the following two lines to the bottom of the file

> org.neo4j.server.thirdparty_jaxrs_classes=org.neo4j.server.extension.test.delete=/cleandb
> org.neo4j.server.thirdparty.delete.key=secret-key

NOTE: if you can't use these port numbers then you will need to change the ENV["NEO4J_URL"] entries in config/environments/development.rb and config/environments/test.rb where applicable.

NOTE: if you wish to use SSL then choose your own ports.

You should now be able to start the neo4j servers. When you run them for the first time it may produce warnings about locks on log files, this warning only appears when the data directory is empty

Test the rspec test using rake (with or without spork)

