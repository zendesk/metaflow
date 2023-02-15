# Create aws run

Testing helloaws with
```
cat ~/.metaflowconfig/config.json
{
    "METAFLOW_BATCH_JOB_QUEUE": "arn:aws:batch:ap-southeast-2:794874039740:job-queue/metaflow-q1lkynmm",
    "METAFLOW_DATASTORE_SYSROOT_S3": "s3://metaflow-s3-q1lkynmm/metaflow-sandbox",
    "METAFLOW_DATATOOLS_SYSROOT_S3": "s3://metaflow-s3-q1lkynmm/metaflow-sandbox/data",
    "METAFLOW_DEFAULT_DATASTORE": "s3",
    "METAFLOW_ECS_S3_ACCESS_IAM_ROLE": "arn:aws:iam::794874039740:role/metaflow-batch_s3_task_role-q1lkynmm"
}%
```
deploy with
```
python helloaws.py run
```

View data with
```
$> python
>>> from metaflow import Flow, get_metadata, namespace
>>> namespace(None)
>>> run = Flow("HelloAWSFlow").latest_successful_run
>>> run
Run('HelloAWSFlow/1676431694822152')
>>> run.data
<MetaflowData: name, message>
>>> run.data.message
'Hi from AWS!'
```
