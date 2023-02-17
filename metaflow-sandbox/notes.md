# Metaflow hello world notes

configure metaflow with

```
$> metaflow configure
```

see /helloaws for settings used in sandbox

Clues for what dynamoDB is used for!
```
Metaflow can schedule your flows on AWS Step Functions and trigger them at a specific cadence using Amazon EventBridge.
To support flows involving foreach steps, you would need access to AWS DynamoDB.
```

## Metaflow metadata service

for some reason the terraform minimal setup has networking issues for metadata service. It currently can not access the internet to get a docker hub or ecr image. It would be nice to test this here but since we most likely will not use fargate in production setup, I think its worth trying to get this working in staging in k8s.
