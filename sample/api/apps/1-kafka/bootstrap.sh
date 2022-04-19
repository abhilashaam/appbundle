#!/bin/bash

#add strimzi repo, to move to harbor
helm repo add strimzi https://strimzi.io/charts/

#Deploy the Cluster Operator to manage your Kafka cluster
#helm install strimzi strimzi/strimzi-kafka-operator

#spin up 3 node kafka cluster
kubectl apply -f kafka-3-node.yaml
