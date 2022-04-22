#!/bin/bash

## Install postgreSQL on appsdk namespace
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install postgresql bitnami/postgresql --values postgresql-values.yaml --namespace nginx-test --create-namespace

## Install pgadmin4
#helm repo add runix https://helm.runix.net
#helm repo update
#helm upgrade --install pgadmin runix/pgadmin4 --values pgadmin4-values.yaml -n appsdk

## Uninstall postgresql
# helm uninstall postgresql -n appsdk

## Uninstall pgadmin4
# helm uninstall pgadmin -n appsdk
