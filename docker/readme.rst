======================
Apache Kafka component
======================

About
=====

**Apache Kafka** [1]_ is an open-source distributed event streaming platform. This container starts up a single-node Apache Kafka message broker - along with an
Apache Zookeeper component inside.

Version
-------
**Apache Kafka** binaries **version 3.0.0** [2]_ deployed on top of **Ubuntu 20.04 LTS** official base image ('Focal Fossa') available in Docker Hub [3]_.

License
-------
**Apache License 2.0**


Pre-requisites
==============

* *docker* installed
* access to DIGITbrain private docker repo (username, password) to pull the image:
  
  - ``docker login dbs-container-repo.emgora.eu``
  - ``docker pull dbs-container-repo.emgora.eu/apache-kafka:3.0.0``

Usage
=====

The preferred way to run this container :

``docker run -d --rm --name kafka --rm -e ADVERTISED_IP=xxx.xxx.xxx.xxx -p 9093:9093/tcp apache-kafka:3.0.0``

where ADVERTISED_IP is the IP address/domain name of the host where Kafka is accessible from clients (consumers/producers),
and port 9093 is the SSL port opened by Kafka. ADVERTISED_IP is typically a public IP of the host, where port 9093 is opened in the firewall.
The image uses a server certificate signed by DIGITbrain certificate authority by default that
can be replaced with other server certificate (see options below).

In a customized setup one can define further parameters:

.. code-block:: bash

    docker run -d --rm --name kafka \
	-e ADVERTISED_IP=193.xxx.xxx.xxx \ 
	-v my-data://home/kafka/data \
	-v my-certificates:/home/kafka/certificates/ \
	-p 19093:9093/tcp -e SSL_PORT=19093 \
	apache-kafka:3.0.0


See parameters and volumes below for explanation.


Security
========
The image uses **SSL/TLS mutual authentication**.
It contains a server certificate signed by DIGITbrain certificate authority, but obviously host name verification will fail (use ssl.endpoint.identification.algorithm= to disable it if needed). 
You should use the server certificate of your own (see Volumes below how to override it).

In Kafka clients you may use client-ssl.properties file like below:

.. code-block:: bash

  security.protocol=SSL
  ssl.endpoint.identification.algorithm=
  ssl.keystore.location=./config/kafka-client.keystore.jks
  ssl.keystore.password=keystorepass
  ssl.truststore.location=./config/kafka-client.truststore.jks
  ssl.truststore.password=truststorepass

Configuration
-------------

Parameters
----------

.. list-table:: 
   :header-rows: 1

   * - Name
     - Default value
     - Comment
   * - ``ADVERTISED_IP``
     - 127.0.0.1
     - IP address/domain name of the host
   * - ``SSL_PORT``
     - 9093
     - SSL_PORT is advertised to clients

Ports
-----
.. list-table:: 
  :header-rows: 1

  * - Container port
    - Host port bind example
    - Comment
  * - SSL
    - ``-p 19093:9093``
    - Default Kafka SSL port 9093 is opened as port 13306 on the host. Note that this port is "advertised" (SSL_PORT) for clients. 

Volumes
-------

The container might use the following volume mounts.

.. list-table:: 
   :header-rows: 1

   * - Name
     - Volume mount
     - Comment
   * - *certificates*    
     - -v certificates_directory_on_host:/home/kafka/certificates/  
     - This directory must contain two Java keystore (JKS) files with names: kafka-server.keystore.jks and kafka-server.truststore.jks. 
   * - *data*    
     - -v data_directory_on_host:/home/kafka/data  
     - Kafka and Zookeeper data. Use this directory to persist Kafka data (will survive container restarts).
   * - *logs*    
     - -v logs_directory_on_host:/home/kafka/logs 
     - Kafka and Zookeeper logs, in log4j format. 

References
==========

.. [1] https://kafka.apache.org/

.. [2] https://dlcdn.apache.org/kafka/3.0.0/

.. [3] https://hub.docker.com/_/ubuntu
