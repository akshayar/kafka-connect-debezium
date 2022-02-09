```shell
aws dms create-endpoint --endpoint-identifier s3-target-parque --engine-name s3 --endpoint-type target --s3-settings '{"ServiceAccessRoleArn": <IAM role ARN for S3 endpoint>, "BucketName": "akshaya-firehose-test", "DataFormat": "parquet"}'
```
