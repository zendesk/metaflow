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
Metaflow 2.7.22 executing HelloAWSFlow for user:jkirkwood
Validating your flow...
    The graph looks good!
Running pylint...
    Pylint is happy!
2023-02-15 14:28:16.303 Workflow starting (run-id 1676431694822152):
2023-02-15 14:28:16.406 [1676431694822152/start/1 (pid 28457)] Task is starting.
2023-02-15 14:28:17.749 [1676431694822152/start/1 (pid 28457)] HelloAWS is starting.
2023-02-15 14:28:17.749 [1676431694822152/start/1 (pid 28457)] 
2023-02-15 14:28:17.749 [1676431694822152/start/1 (pid 28457)] Using metadata provider: local@/Users/jkirkwood/Code/ml-training-pipelines
2023-02-15 14:28:18.776 [1676431694822152/start/1 (pid 28457)] 
2023-02-15 14:28:18.777 [1676431694822152/start/1 (pid 28457)] The start step is running locally. Next, the
2023-02-15 14:28:18.777 [1676431694822152/start/1 (pid 28457)] 'hello' step will run remotely on AWS batch.
2023-02-15 14:28:18.777 [1676431694822152/start/1 (pid 28457)] If you are running in the Netflix sandbox,
2023-02-15 14:28:18.777 [1676431694822152/start/1 (pid 28457)] it may take some time to acquire a compute resource.
2023-02-15 14:28:19.311 [1676431694822152/start/1 (pid 28457)] Task finished successfully.
2023-02-15 14:28:20.055 [1676431694822152/hello/2 (pid 28461)] Task is starting.
2023-02-15 14:28:21.766 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task is starting (status SUBMITTED)...
2023-02-15 14:28:24.859 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task is starting (status RUNNABLE)...
2023-02-15 14:28:28.148 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task is starting (status STARTING)...
2023-02-15 14:28:51.248 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task is starting (status RUNNING)...
2023-02-15 14:28:50.282 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Setting up task environment.
2023-02-15 14:28:59.849 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Downloading code package...
2023-02-15 14:29:00.546 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Code package downloaded.
2023-02-15 14:29:00.566 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task is starting.
2023-02-15 14:29:01.505 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Metaflow says: Hi from AWS!
2023-02-15 14:29:03.647 [1676431694822152/hello/2 (pid 28461)] [5202b3b9-f832-455d-9707-8917bb4a434d] Task finished with exit code 0.
2023-02-15 14:29:05.347 [1676431694822152/hello/2 (pid 28461)] Task finished successfully.
2023-02-15 14:29:05.756 [1676431694822152/end/3 (pid 28479)] Task is starting.
2023-02-15 14:29:07.310 [1676431694822152/end/3 (pid 28479)] HelloAWS is finished.
2023-02-15 14:29:08.849 [1676431694822152/end/3 (pid 28479)] Task finished successfully.
2023-02-15 14:29:09.099 Done!

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
