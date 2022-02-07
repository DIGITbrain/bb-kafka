#!/bin/bash

if [[ -z "${ZOOKEEPER_HOST}" ]]; then
  /home/kafka/bin/zookeeper-server-start.sh /home/kafka/config/zookeeper.properties &
else
  if [[ -z "${ZOOKEEPER_PORT}" ]]; then ZOOKEEPER_PORT="2181"; fi
  sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect='${ZOOKEEPER_HOST}':'${ZOOKEEPER_PORT}'/g' config/server.properties
  /home/kafka/bin/zookeeper-server-start.sh /home/kafka/config/zookeeper.properties &
fi

if [[ -z "${ADVERTISED_IP}" ]]; then ADVERTISED_IP="localhost"; fi
if [[ -z "${SSL_PORT}" ]]; then SSL_PORT="9093"; fi
echo "advertised.listeners=EXTERNAL://${ADVERTISED_IP}:${SSL_PORT},INTERNAL://:9092" >> config/server.properties

/home/kafka/bin/kafka-server-start.sh /home/kafka/config/server.properties &
wait -n
exit 0
