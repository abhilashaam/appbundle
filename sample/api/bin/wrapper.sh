#!/bin/bash

#Purpose : Wrapper script to run bootstrap.sh
#          Ensures the command is run and parse the results in JSON
# Author : Gagan Mandava, 04-02-2022


dte=`date +%m%s`
export KUBECONFIG=/opt/api/conf/aks.dev.config
chmod 400 /opt/api/conf/aks.dev.config

nginx_parse () {
cd /opt/api/apps/nginx
./bootstrap.sh >/tmp/$dte-temp.txt 2>/tmp/$dte-error.txt
input="/tmp/$dte-temp.txt"

 while read -r line
 do
        echo $line |grep -m1 -w -i "^NAME:"
        echo $line |grep -m1 -w -i "LAST DEPLOYED:"
        echo $line |grep -m1 -w -i "NAMESPACE:"
        echo $line |grep -m1 -w -i "STATUS:"
        echo $line |grep -m1 -w -i "CHART NAME:"
        echo $line |grep -m1 -w -i "CHART VERSION:"
        echo $line |grep -m1 -w -i "APP VERSION:"
  done < $input

input="/tmp/$dte-error.txt"
 while read -r line
 do
    result=`echo $line |grep -i error`
    echo error/warnings:$result
 done < $input
}

postgres_parse () {
cd /opt/api/apps/nginx
./bootstrap.sh >/tmp/$dte-temp.txt 2>/tmp/$dte-error.txt
input="/tmp/$dte-temp.txt"

 while read -r line
 do
        echo $line |grep -m1 -w -i "^NAME:"
        echo $line |grep -m1 -w -i "LAST DEPLOYED:"
        echo $line |grep -m1 -w -i "NAMESPACE:"
        echo $line |grep -m1 -w -i "STATUS:"
        echo $line |grep -m1 -w -i "CHART NAME:"
        echo $line |grep -m1 -w -i "CHART VERSION:"
        echo $line |grep -m1 -w -i "APP VERSION:"
  done < $input

input="/tmp/$dte-error.txt"
 while read -r line
 do
    result=`echo $line |grep -i error`
    echo error/warnings:$result
 done < $input
}


kafka_parse () {
cd /opt/api/apps/1-kafka
 ./bootstrap.sh >/tmp/$dte-temp.txt 2>/tmp/$dte-error.txt
input="/tmp/$dte-temp.txt"

 message1=`cat $input |grep -i "skipping"`
 echo notice1:$message1
 message2=`cat $input |grep -i "assetmark-kafka-cluster"`
 echo notice2:$message2
 kubectl get Kafka > /tmp/$dte-kafka.txt
 name=`awk 'NR==2 {print $1}' /tmp/$dte-kafka.txt`
 echo Name:$name
 rep=`awk 'NR==2 {print $2}' /tmp/$dte-kafka.txt`
 echo Kafka Replicas:$rep
 rm /tmp/$dte-kafka.txt

input="/tmp/$dte-error.txt"
 while read -r line
 do
    result=`echo $line |grep -i error`
 done < $input
 echo error/warnings:$result

}

cleanup () {
  rm /tmp/$dte-temp.txt
  rm /tmp/$dte-error.txt
}

## Main ##

varx=$1

case $varx in

  nginx|-n)
    nginx_parse |jc --kv -p 
    cleanup
    ;;

  kafka|-k)
    kafka_parse |jc --kv -p
    cleanup
    ;;
  
  list|-l)
    helm list -o json --all-namespaces 
    ;;
  
  help|-h)
    echo "available commands :" 
    echo "  list : list of installed apps" 
    echo "  nginx : to install nginx" 
    echo "  kakfa : to install kafka" 
    ;;

  *)
    echo "error:no parameter given to wrapper parser use -h for help" |jc --kv -p
    ;;
esac
