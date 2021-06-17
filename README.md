## Deployment type

Docker-comopose

## Image

Based on Wurstmeister [1], but Zookeeper replaced by the one shipped with Kafka.

__Note:__ image build is required, see: [docker/build.sh](docker/build.sh)


## Licence

Apache License 2.0

## Version

2.7.0

## Description

Apache Kafka is an open-source distributed event streaming platform.


# Deployment

## 1 broker, 1 zookeeper

See: [docker-compose/single-node-kafka-docker-compose.yml](docker-compose/single-node-kafka-docker-compose.yml).

- in docker subdirectory build base docker image: lpds/kafka:2.7.0 
 
```
cd docker
docker build -t lpds/kafka:2.7.0 .
cd ..
```

- in docker-compose subdirectory edit .env file to set the public IP address of the broker: PUBLIC_IP=xxx.xxx.xxx.xxx
- build docker-compose
- run docker-compose

```
cd docker-compose
docker-compose -f ./single-node-kafka-docker-compose.yml build
docker-compose -f ./single-node-kafka-docker-compose.yml up -d
# docker-compose -f ./single-node-kafka-docker-compose.yml down
```

For configuration details see: [8].

## 5 brokers, 1 zookeeper

See: [docker-compose/five-node-kafka-docker-compose.yml](docker-compose/five-node-kafka-docker-compose.yml).

- in docker subdirectory build base docker image: lpds/kafka:2.7.0 
 
```
cd docker
docker build -t lpds/kafka:2.7.0 .
```

- in docker-compose subdirectory edit .env file to set the public IP address of the broker: PUBLIC_IP=xxx.xxx.xxx.xxx
- build docker-compose
- run docker-compose

```
cd docker-compose
docker-compose -f ./five-node-kafka-docker-compose.yml build
docker-compose -f ./five-node-kafka-docker-compose.yml up -d
# docker-compose -f ./five-node-kafka-docker-compose.yml down
```

For configuration details see: [8].

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


# References

[1] https://github.com/wurstmeister/kafka-docker.git

[2] https://github.com/wurstmeister/zookeeper-docker

[3] https://hub.docker.com/r/wurstmeister/zookeeper

[4] https://github.com/wurstmeister/kafka-docker

[5] https://hub.docker.com/r/wurstmeister/kafka

[6] https://github.com/wurstmeister/docker-base

[7] https://hub.docker.com/r/wurstmeister/base

[8] https://rmoff.net/2018/08/02/kafka-listeners-explained/


