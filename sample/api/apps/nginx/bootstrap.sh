#!/bin/bash

echo "Installing helm repo "
helm repo add bitnami https://charts.bitnami.com/bitnami
echo "creating namespace : nginx"
kubectl create namespace nginx-test
echo "install nginx"
helm upgrade --install nginx-test bitnami/nginx -n nginx-test
