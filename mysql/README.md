# Kafka Broker and Kakfa Connect on Docker Compose
## Pre Requisite
### Create and prepare RDS MySQL Instance 
1. Refer https://github.com/debezium/debezium-examples/tree/main/tutorial
2. Create DB with parameter group as indicated in cft-rds-mysql.yaml.
3. Connect to DB and do following configuration
```shell
CREATE USER 'debezium'@'%' IDENTIFIED BY 'debezium'; 

GRANT REPLICATION SLAVE, SELECT, RELOAD, REPLICATION CLIENT, 
       LOCK TABLES, EXECUTE ON *.* TO 'debezium'@'%'; 
       
       FLUSH PRIVILEGES;
       
call mysql.rds_set_configuration('binlog retention hours', 168);
```
4. Create schema in the DB with [schema.sql](./schema.sql)

### Create and prepare Cloud9 IDE instance
1. Install Docker compose. 
```shell
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compos
docker-compose -version
```

## CDC as Json Data
1. Checkout the code on EC2/Cloud9.
```shell
git clone https://github.com/akshayar/kafka-connect-debezium.git
```
2. Bring up Kakfa and Kafka Connect by executing the commands below on a Cloud9 IDE or EC2. Ensure that Cloud9/EC2 can connect to the DB. 
```shell
cd kafka-connect-debezium/mysql
export DEBEZIUM_VERSION=1.8
docker-compose -f docker-compose-mysql.yaml up
```
3. Start MySQL connector. Before that command modify [register-mysql.json](./register-mysql.json) and update database.hostname, database.user etc. 
```shell
curl -X DELETE http://localhost:8083/connectors/rdsmysql-connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json
curl -X GET http://localhost:8083/connectors/rdsmysql-connector/status
```
4. Consume messages from a Debezium topic
```shell
docker-compose -f docker-compose-mysql.yaml exec kafka /kafka/bin/kafka-console-consumer.sh \
   --bootstrap-server kafka:9092 \
   --from-beginning \
   --property print.key=true \
   --topic rdsmysql.devmysql.artists
```   
5. Modify records in the database via MySQL client
6. Shut down the cluster
```shell
docker-compose -f docker-compose-mysql.yaml down
``` 

## CDC as Avro Data , confluent schema registry and S3 Sink Connector
1. Bring up Kakfa and Kafka Connect. The Kafka connect also needs S3 sink connector for which the Docker image needs to be built. 
```shell
cd kafka-connect-debezium/mysql
export DEBEZIUM_VERSION=1.8
docker-compose -f docker-compose-mysql-avro-connector.yaml up --build
```
2. Ensure that the EC2 instance on which the container runs has permission to write to the S3 bucket
3. Start MySQL source connector and S3 sink connector. Before that command modify [register-mysql-avro.json](./register-mysql-avro.json) and update database.hostname, database.user etc.
```shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql-avro.json
## For Parquet Sink data
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-s3-sink-connector-parquet.json
## Get status of connectors
curl -X GET http://localhost:8083/connectors/rdsmysql-s3-sink-connector-parquet/status
curl -X GET http://localhost:8083/connectors/rdsmysql-dev-connector-avro/status

## For Avro Sink Data
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-s3-sink-connector-avro.json
## Get status of connectors
curl -s -X GET http://localhost:8083/connectors/rdsmysql-s3-sink-connector-avro/status
```
4. Consume messages from a Debezium topic
```shell
docker-compose -f docker-compose-mysql-avro-connector.yaml exec schema-registry /usr/bin/kafka-avro-console-consumer \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --property schema.registry.url=http://schema-registry:8081 \
    --topic rdsmysql.devmysql.artists
```   
5. Modify records in the database via MySQL client
6. View files in S3.
```shell
export BUCKET_NAME=<BUCKET-NAME>
aws s3 ls  --recursive s3://${BUCKET_NAME}/debezium/sink/avro/rdsmysql/rdsmysql.devmysql.artists/
aws s3 ls  --recursive s3://${BUCKET_NAME}/debezium/sink/parquet/rdsmysql/rdsmysql.devmysql.artists/
```
7. Shut down the cluster
```shell
# Delete connectors
curl -X DELETE http://localhost:8083/connectors/rdsmysql-s3-sink-connector-parquet
curl -X DELETE http://localhost:8083/connectors/rdsmysql-s3-sink-connector-avro
curl -X DELETE http://localhost:8083/connectors/rdsmysql-dev-connector-avro
## Shut down cluster
docker-compose -f docker-compose-mysql-avro-connector.yaml down
``` 
## CDC as Avro Data , Apicurio schema registry and S3 Sink Connector
1. Bring up Kakfa and Kafka Connect. The Kafka connect also needs S3 sink connector for which the Docker image needs to be built.
```shell
cd kafka-connect-debezium/mysql
export DEBEZIUM_VERSION=1.8
docker-compose -f docker-compose-mysql-apicurio.yaml up --build
```
2. Ensure that the EC2 instance on which the container runs has permission to write to the S3 bucket
3. Start MySQL connector
```shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql-apicurio.json
# For Parquet Sink Data
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-s3-sink-connector-apicurio-parquet.json 
## Get status
curl -X GET http://localhost:8083/connectors/rdsmysql-dev-connector-apicurio-avro/status
curl -X GET http://localhost:8083/connectors/rdsmysql-s3-sink-connector-apicurio-parquet/status
# For Avro Sink Data
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-s3-sink-connector-apicurio-avro.json 
## Get status
curl -X GET http://localhost:8083/connectors/rdsmysql-s3-sink-connector-apicurio-avro/status
```
4. Consume messages from a Debezium topic
```shell
docker-compose -f docker-compose-mysql-apicurio.yaml exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic rdsmysqlapicurio.dev.artists

```   
5. Modify records in the database via MySQL client
6. View files in S3.
```shell
export BUCKET_NAME=<BUCKET-NAME>
aws s3 ls --recursive s3://$BUCKET_NAME/debezium/sink/apicurio-avro/rdsmysql/
aws s3 ls --recursive s3://$BUCKET_NAME/debezium/sink/apicurio-parquet/rdsmysql/

```
5. Shut down the cluster
```shell
# Delete connectors
curl -X DELETE http://localhost:8083/connectors/rdsmysql-dev-connector-apicurio-avro
curl -X DELETE http://localhost:8083/connectors/rdsmysql-s3-sink-connector-apicurio-parquet
curl -X DELETE http://localhost:8083/connectors/rdsmysql-s3-sink-connector-apicurio-avro
## Shut down cluster
docker-compose -f docker-compose-mysql-apicurio.yaml down
``` 
