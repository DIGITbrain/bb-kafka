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

* docker
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

In a customized setup one can define other parameters:

.. code-block:: bash

    docker run -d --rm --name kafka \
	-e ADVERTISED_IP=193.xxx.xxx.xxx \ 
	-v my-data://home/kafka/data \
	-v my-certificates:/home/kafka/certificates/ \
	-e PLAINTEXT_PORT=19092 -p 19093:19093/tcp -e SSL_PORT=19093 -p 19092:19092/tcp \
	apache-kafka:3.0.0

See parameters and volumes below for explanation.

Parameters
----------

The container has the following parameters, passed as environment variables.

.. list-table:: Parameters
   :header-rows: 1

   * - Name
     - Default value
     - Comment
   * - ``ADVERTISED_IP``
     - 127.0.0.1
     - IP address/domain name of the host
   * - ``SSL_PORT``
     - 9093
     - Port for encrypted traffic that uses TLS/SSL client authentication. See volumes for certificates.
   * - ``PLAINTEXT_PORT``
     - 9092
     - Non-encrypted, unauthentucated port to access Kafka. Unsecure.


Volumes
-------

The container might use the following volume mounts.

.. list-table:: Volumes
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

[1] https://kafka.apache.org/

[2] https://dlcdn.apache.org/kafka/3.0.0/

[3] https://hub.docker.com/_/ubuntu
