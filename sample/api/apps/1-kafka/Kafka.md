git # Kafka v0.1
@author Ajai Joy
## _Kafka configuration_

The Apache Kafka® broker configuration parameters are organized by broker side configuration, producer tuning and consumer tuning. Many of these dictate durability and fault tolerance and idempotency.


## Broker Configuration

    config:
      auto.create.topics.enable: "true"
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      default.replication.factor: 3
      # When a producer sets acks to "all" (or "-1"), min.insync.replicas specifies the minimum number of replicas that
      #  must acknowledge a write for the write to be considered successful.
      min.insync.replicas: 2
      inter.broker.protocol.version: "3.1"
      
# Producer side tuning
      acks: all
      enable.idempotence: true
      linger.ms: 100
      batch.size: 10

# Consumer side tuning
      heartbeat.interval.ms: 3000
      enable.auto.commit: false




