#!/usr/bin/env bash

# First stop kafka. The order is important. Kafka needs zk to be up in order to stop gracefully.
for i in $(seq 1 3); do
   vagrant ssh broker$i -c "/vagrant/scripts/stop-kafka.sh"
done

# Letting kafka stop
sleep 8

for i in $(seq 1 3); do
   vagrant ssh broker$i -c "/vagrant/scripts/stop-zk.sh"
done

for i in $(seq 1 3); do
   res_zk=$(vagrant ssh broker$i -c "jps" | grep -i quorumpeermain)
   res_kafka=$(vagrant ssh broker$i -c "jps" | grep -i kafka)

   if [ "x$res_zk" = "x" ]; then
      echo "zk stopped on $i"
   else
      echo "zk not stopped"
   fi

   if [ "x$res_kafka" = "x" ]; then
      echo "kafka stopped on $i"
   else 
      echo "kafka not stopped"
   fi
done
