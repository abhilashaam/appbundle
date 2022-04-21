#!/bin/bash

if [ $# -eq 0 ]
then
echo " please pass the environment argument and namespace as below"
echo " sh bootstrap.sh <environment> <namespace>"
exit 1
fi
env=$1
ns=$2

kubectl create namespace $ns
kubectl config set-context $(kubectl config current-context) --namespace=$ns

kubectl apply -f deploy/rbac.yaml

kubectl apply -f deploy/operator.yaml

kubectl create -f deploy/secrets.yaml

kubectl apply -f deploy/cr.yaml


ret_code=$?

#eventual consistency wait
sleep 5

if [ $ret_code -ne 0 ]
then
echo " MongoDB installation failed!!.."
exit $ret_code 
fi


kubectl get all


