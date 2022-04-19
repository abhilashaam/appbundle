#!/bin/bash

#add confluent repo, to move to harbor
helm repo add confluentinc https://confluentinc.github.io/cp-helm-charts/
helm repo update

#Deploy the schema registry
#helm install confluentinc/cp-helm-charts --name my-confluent --version 0.6.0
#helm install --set cp-schema-registry.enabled=true,cp-kafka-rest.enabled=false,cp-kafka-connect.enabled=false confluentinc/cp-helm-charts
helm install assetmark-schema-registry -f values.yaml cp-schema-registry


echo "Deployment completed"