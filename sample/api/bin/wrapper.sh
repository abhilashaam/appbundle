#!/bin/bash
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
cd /opt/api/apps/3-postgresql
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
mongodb_parse () {
cd /opt/api/apps/7-mongodb
./bootstrap.sh dev mongodb-test >/tmp/$dte-temp.txt 2>/tmp/$dte-error.txt
input="/tmp/$dte-temp.txt"
 message1=`cat $input |grep -i "perconaservermongodbs.psmdb.percona.com"`
 echo notice1:$message1
 message2=`cat $input |grep -i "perconaservermongodbbackups.psmdb.percona.com"`
 echo notice2:$message2 
 message3=`cat $input |grep -i "perconaservermongodbrestores.psmdb.percona.com"`
 echo notice3:$message3
 message4=`cat $input |grep -i "role.rbac.authorization.k8s.io/percona-server-mongodb-operator"`
 echo notice4:$message4
 message5=`cat $input |grep -i "serviceaccount/percona-server-mongodb-operator"`
 echo notice5:$message5
 message6=`cat $input |grep -i "service-account-percona-server-mongodb-operator"`
 echo notice6:$message6
 message7=`cat $input |grep -i "percona-server-mongodb-operator"`
 echo notice7:$message7
 message8=`cat $input |grep -i "amewm30-mongodb"`
 echo notice8:$message8
 #kubectl get Kafka > /tmp/$dte-kafka.txt
 #name=`awk 'NR==2 {print $1}' /tmp/$dte-kafka.txt`
 #echo Name:$name
 #rep=`awk 'NR==2 {print $2}' /tmp/$dte-kafka.txt`
 #echo Kafka Replicas:$rep
 #rm /tmp/$dte-kafka.txt
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
    #cleanup
    ;;
  kafka|-k)
    kafka_parse |jc --kv -p
    #cleanup
    ;;
  postgres|-n)
    postgres_parse |jc --kv -p
    #cleanup
    ;; 
  mongodb|-n)
    mongodb_parse |jc --kv -p
    #cleanup
    ;;	
  list|-l)
    helm list -o json --all-namespaces 
    ;;
  help|-h)
    echo "available commands :" 
    echo "  list : list of installed apps" 
    echo "  nginx : to install nginx" 
    echo "  kakfa : to install kafka"
    echo "  postgres : to install postgres"
    echo "  mongodb : to install mongodb" 
    ;;
  *)
    echo "error:no parameter given to wrapper parser use -h for help" |jc --kv -p
    ;;
esac
