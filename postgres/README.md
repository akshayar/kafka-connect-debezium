```
export DEBEZIUM_VERSION=2.0
docker-compose -f docker-compose-pg-confluent-schema.yaml up
```
```
curl -i -X POST -H "Accept:application/json"     -H  "Content-Type:application/json"     http://localhost:8083/connectors/ -d @postgres.json 
```

```
["inventory-connector-pg",{"server":"pgdev"}]
{
  "last_snapshot_record": true,
  "lsn": 63552100632,
  "txId": 1618,
  "ts_usec": 1666267991774697,
  "snapshot": true
}

["inventory-connector-pg",{"server":"pgdev"}]
{
  "transaction_id": null,
  "lsn_proc": 63619219552,
  "lsn_commit": 63619219552,
  "lsn": 63619219552,
  "txId": 1650,
  "ts_usec": 1666268220374889
}
["inventory-connector-pg",{"server":"pgdev"}]
{
  "transaction_id": null,
  "lsn_proc": 63619244840,
  "lsn_commit": 63619244840,
  "lsn": 63619244840,
  "txId": 1667,
  "ts_usec": 1666268242685027
}
["inventory-connector-pg-dr2",{"server":"pgdev"}]
{
  "transaction_id": null,
  "lsn_proc": 63954767208,
  "lsn_commit": 63954767208,
  "lsn": 63954767208,
  "txId": 1681,
  "ts_usec": 1666269647736549
}

["inventory-connector-pg-dr3",{"server":"pgdevdr2"}]

["inventory-connector-pg-dr3",{"server":"pgdevdr2"}] 	
{
  "transaction_id": null,
  "lsn_proc": 65364052864,
  "lsn_commit": 65364052808,
  "lsn": 65364052864,
  "txId": 1735,
  "ts_usec": 1666345651445283
}

["inventory-connector-pg-dr4",{"server":"pgdevdr2"}] 	
{
  "transaction_id": null,
  "lsn_proc": 65364052864,
  "lsn_commit": 65364052808,
  "lsn": 65364052864,
  "txId": 1735,
  "ts_usec": 1666345651445283
}

["inventory-connector-pg-dr4",{"server":"pgdevdr2"}]
{
  "transaction_id": null,
  "lsn_proc": 65431153824,
  "lsn_commit": 65431153768,
  "lsn": 65431153824,
  "txId": 1745,
  "ts_usec": 1666346001605705
}

["inventory-connector-pg-dr5",{"server":"pgdevdr2"}]
{
  "transaction_id": null,
  "lsn_proc": 65431153824,
  "lsn_commit": 65431153768,
  "lsn": 65431153824,
  "txId": 1745,
  "ts_usec": 1666346001605705
}


["inventory-connector-pg-dr4",{"server":"pgdevdr2"}]
{
  "transaction_id": null,
  "lsn_proc": 65565373160,
  "lsn_commit": 65565370848,
  "lsn": 65565373160,
  "txId": 1764,
  "ts_usec": 1666346464663614
}


["inventory-connector-pg-dr5",{"server":"pgdevdr2"}]
{
  "transaction_id": null,
  "lsn_proc": 65565373160,
  "lsn_commit": 65565370848,
  "lsn": 65565373160,
  "txId": 1764,
  "ts_usec": 1666346464663614
}
```
