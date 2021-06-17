#!/bin/bash
docker-compose -f ./single-node-kafka-docker-compose.yml build
docker-compose -f ./single-node-kafka-docker-compose.yml up -d
# docker-compose -f ./single-node-kafka-docker-compose.yml down
                     s
# docker-compose -f ./multi-node-kafka-docker-compose.yml up -d
# docker-compose -f ./multi-node-kafka-docker-compose.yml down
