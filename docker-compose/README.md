# Configurations

- Single-node: 1 Kafka broker + 1 Zookeeper: single-node-kafka-docker-compose.yml
- Multi-node: 5 Kafka broker + 1 Zookeeper: five-node-kafka-docker-compose.yml


## Test

CREATE TOPIC:
   > docker exec <kafka-container-id> kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 2 --topic test2
   docker exec <kafka-container-id> kafka-topics.sh --list --zookeeper zookeeper:2181

EXTERNAL network:
   > $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list <public_ip>:9092 --topic test
   $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server <public_ip>:9092 --topic test --from-beginning

INTERNAL network:
   > docker exec -it <kafka-container-id> kafka-console-producer.sh --broker-list localhost:39092 --topic test
   docker exec <kafka-container-id> kafka-console-consumer.sh --bootstrap-server localhost:39092 --topic test --from-beginning


See also: https://rmoff.net/2018/08/02/kafka-listeners-explained/


# TLS (under development)

Certificates must be put into JKS (Java Keystores). PKCS12 format is supported (as of Java9).

Create keystore and private key for the server (broker):

> keytool -keystore __kafka.broker.jks__ -alias localhost -validity __365__ -genkey -keyalg RSA -storetype pkcs12

Create certificate signing request:

> keytool -keystore __kafka.broker.jks__ -alias localhost -validity {validity} -genkey -keyalg RSA -destkeystoretype pkcs12 -ext SAN=DNS:{FQDN},IP:{IPADDRESS1}

__Notes__:
  - -ext option can be ommited.
  - disable hostname verification: set ssl.endpoint.identification.algorithm to an empty string

server.properties

listeners=PLAINTEXT://:9092,SSL://:9093
ssl.keystore.location=/opt/kafka/config/kafka01.keystore.jks
ssl.keystore.password=vertica
ssl.key.password=vertica
ssl.truststore.location=/opt/kafka/config/kafka.truststore.jks
ssl.truststore.password=vertica
ssl.enabled.protocols=TLSv1.2,TLSv1.1,TLSv1
ssl.client.auth=required



## Test


keytool -keystore client.keystore.jks -alias localhost -validity 365 -genkey -keyalg RSA -ext SAN=DNS:fqdn_of_client_system
keytool -keystore client.keystore.jks -alias localhost -certreq -file client.unsigned.cert
openssl x509 -req -CA ca.crt -CAkey ca.key -in client.unsigned.cert -out client.signed.cert \
        -days 365 -CAcreateserial 

keytool -keystore client.keystore.jks -alias CARoot -import -file ca.crt
keytool -keystore client.keystore.jks -alias localhost -import -file client.signed.cert


openssl s_client -debug -connect broker_host_name:9093 -tls1




