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
