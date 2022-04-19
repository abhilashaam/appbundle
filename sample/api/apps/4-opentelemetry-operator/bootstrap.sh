#!/bin/bash

#install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.1 \
  # --set installCRDs=true

#install Opentelemetry-operator
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
kubectl apply -f opentelemetry-collector-instance.yaml

#install Jaeger Operator
kubectl create namespace observability
kubectl create -n observability -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.29.1/jaeger-operator.yaml
kubectl apply -f jaeger-instance.yaml

#Check if the otel-collector and jaeger-query service has been created
kubectl get svc --all-namespaces

#Now, setup a port forward to the jaeger-query service
kubectl port-forward service/jaeger-query -n observability 8080:16686 &

#install fission
export FISSION_NAMESPACE=fission
helm install --namespace $FISSION_NAMESPACE \
  fission fission-charts/fission-all \
  --set openTelemetry.otlpCollectorEndpoint="otel-collector.opentelemetry-operator-system.svc:4317" \
  --set openTelemetry.otlpInsecure=true \
  --set openTelemetry.tracesSampler="parentbased_traceidratio" \
  --set openTelemetry.tracesSamplingRate="1"

#test application traces
# create an environment
fission env create --name nodejs --image fission/node-env

# get hello world function
curl https://raw.githubusercontent.com/fission/examples/master/nodejs/hello.js > hello.js

# register the function with Fission
fission function create --name hello --env nodejs --code hello.js

# run the function
fission function test --name hello
hello, world!
