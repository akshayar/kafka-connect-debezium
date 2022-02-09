# Kafka Broker and Kakfa Connect on Docker Compose
## Pre Requisite
1. Refer https://github.com/debezium/debezium-examples/tree/main/tutorial

## CDC as Json Data
1. Bring up Kakfa ,  Kafka Connect and Mongo DB
```shell
export DEBEZIUM_VERSION=1.8
docker-compose -f docker-compose-mongodb.yaml  up
```
2. Initialize MongoDB replica set and insert some test data
```
docker-compose -f docker-compose-mongodb.yaml exec mongodb bash -c '/usr/local/bin/init-inventory.sh'
```
3. Start MongoDB connector
```shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mongodb.json
```
4. Consume messages from a Debezium topic
```shell
docker-compose -f docker-compose-mongodb.yaml exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic dbserver1.inventory.customers
```   
5. Modify records in the database via MySQL client
```shell
mongo -u debezium -p dbz --authenticationDatabase admin ec2-13-233-122-162.ap-south-1.compute.amazonaws.com:27017/inventory
db.customers.updateOne({ _id: 1001 },{ $set: { first_name: "Modified Sally6"}})
```
6. Shut down the cluster
```shell
docker-compose -f docker-compose-mongodb.yaml down
``` 

## CDC as Avro Data , confluent schema registry
1. Bring up Kakfa ,  Kafka Connect and Mongo DB
```shell
export DEBEZIUM_VERSION=1.8
docker-compose -f docker-compose-mongodb-avro-connector.yaml up
```
2. Initialize MongoDB replica set and insert some test data
```
docker-compose -f docker-compose-mongodb-avro-connector.yaml exec mongodb bash -c '/usr/local/bin/init-inventory.sh'
```
3. Start MongoDB connector
```shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mongodb-avro.json
```
4. Consume messages from a Debezium topic
```shell
docker-compose -f docker-compose-mongodb-avro-connector.yaml exec schema-registry /usr/bin/kafka-avro-console-consumer     --bootstrap-server kafka:9092     --from-beginning     --property print.key=true     --property schema.registry.url=http://schema-registry:8081     --topic dbserver6.inventory.customers
```   
5. Modify records in the database via MySQL client
```shell
mongo -u debezium -p dbz --authenticationDatabase admin ec2-13-233-122-162.ap-south-1.compute.amazonaws.com:27017/inventory
db.customers.updateOne({ _id: 1001 },{ $set: { first_name: "Modified Sally6"}})
```
6. Shut down the cluster
```shell
docker-compose -f docker-compose-mongodb-avro-connector.yaml
``` 
