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


## Minimal terraform resources

Names for resources appended with the random string. An example config file is also created.
```
random_string.suffix
local_file.metaflow_config
data.aws_availability_zones.available
```

IAM components. These will need to be checked through, and usable by the pipeline deploy role, ie teams in service catalog and spinnaker
S3 KMS should be removed, s3 will use self-service to create the bucket and manage access.
```
module.metaflow.data.aws_caller_identity.current
module.metaflow.data.aws_iam_policy_document.allow_sagemaker
module.metaflow.data.aws_iam_policy_document.batch_s3_task_role_assume_role
module.metaflow.data.aws_iam_policy_document.cloudwatch
module.metaflow.data.aws_iam_policy_document.custom_s3_batch
module.metaflow.data.aws_iam_policy_document.custom_s3_list_batch
module.metaflow.data.aws_iam_policy_document.deny_presigned_batch
module.metaflow.data.aws_iam_policy_document.dynamodb
module.metaflow.data.aws_iam_policy_document.iam_pass_role
module.metaflow.data.aws_iam_policy_document.s3_kms
module.metaflow.data.aws_region.current
module.metaflow.aws_iam_role.batch_s3_task_role
module.metaflow.aws_iam_role_policy.grant_allow_sagemaker
module.metaflow.aws_iam_role_policy.grant_cloudwatch
module.metaflow.aws_iam_role_policy.grant_custom_s3_batch
module.metaflow.aws_iam_role_policy.grant_custom_s3_list_batch
module.metaflow.aws_iam_role_policy.grant_deny_presigned_batch
module.metaflow.aws_iam_role_policy.grant_iam_pass_role
module.metaflow.aws_iam_role_policy.grant_s3_kms
```

```
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.batch_execution_role_assume_role
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.custom_access_policy
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.ec2_custom_policies
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.ecs_execution_role_assume_role
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.ecs_instance_role_assume_role
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.ecs_task_execution_policy
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.iam_custom_policies
module.metaflow.module.metaflow-computation.data.aws_iam_policy_document.iam_pass_role
module.metaflow.module.metaflow-computation.aws_iam_instance_profile.ecs_instance_role
module.metaflow.module.metaflow-computation.aws_iam_role.batch_execution_role
module.metaflow.module.metaflow-computation.aws_iam_role.ecs_execution_role
module.metaflow.module.metaflow-computation.aws_iam_role.ecs_instance_role
module.metaflow.module.metaflow-computation.aws_iam_role_policy.grant_custom_access_policy
module.metaflow.module.metaflow-computation.aws_iam_role_policy.grant_ec2_custom_policies
module.metaflow.module.metaflow-computation.aws_iam_role_policy.grant_ecs_access
module.metaflow.module.metaflow-computation.aws_iam_role_policy.grant_iam_custom_policies
module.metaflow.module.metaflow-computation.aws_iam_role_policy.grant_iam_pass_role
module.metaflow.module.metaflow-computation.aws_iam_role_policy_attachment.ecs_instance_role
```

Step functions will be created by the pipeline deployer, this has not been tested in Sandbox
```
module.metaflow.module.metaflow-step-functions.data.aws_region.current
module.metaflow.module.metaflow-step-functions.data.aws_caller_identity.current
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.eventbridge_assume_role_policy
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.eventbridge_step_functions_policy
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_assume_role_policy
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_batch_policy
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_cloudwatch
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_dynamodb
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_eventbridge
module.metaflow.module.metaflow-step-functions.data.aws_iam_policy_document.step_functions_s3
```

Database and S3 will be required in Prod but should be created with self-service storage, not terraform
```
module.metaflow.module.metaflow-datastore.aws_db_instance.this[0]
module.metaflow.module.metaflow-datastore.aws_db_subnet_group.this
module.metaflow.module.metaflow-datastore.aws_security_group.rds_security_group
module.metaflow.module.metaflow-datastore.aws_kms_key.rds
module.metaflow.module.metaflow-datastore.aws_kms_key.s3
module.metaflow.module.metaflow-datastore.aws_s3_bucket.this
module.metaflow.module.metaflow-datastore.aws_s3_bucket_public_access_block.this
module.metaflow.module.metaflow-datastore.random_password.this
module.metaflow.module.metaflow-datastore.random_pet.final_snapshot_id
```

AWS Batch setup, we will need to test this is ok to use this terraform version in Prod.
```
module.metaflow.module.metaflow-computation.data.aws_region.current
module.metaflow.module.metaflow-computation.data.aws_ssm_parameter.ecs_optimized_cpu_ami
module.metaflow.module.metaflow-computation.aws_batch_compute_environment.this
module.metaflow.module.metaflow-computation.aws_batch_job_queue.this
module.metaflow.module.metaflow-computation.aws_launch_template.cpu[0]
module.metaflow.module.metaflow-computation.aws_security_group.this
```

Metadata service did not work in Sandbox, this needs to be tested from scratch within staging. Planning to run the container in k8s.
```
module.metaflow.module.metaflow-metadata-service.data.aws_caller_identity.current
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.custom_s3_batch
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.deny_presigned_batch
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.lambda_ecs_execute_role
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.lambda_ecs_task_execute_policy_cloudwatch
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.lambda_ecs_task_execute_policy_vpc
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.metadata_svc_ecs_task_assume_role
module.metaflow.module.metaflow-metadata-service.data.aws_iam_policy_document.s3_kms
module.metaflow.module.metaflow-metadata-service.aws_iam_role.lambda_ecs_execute_role
module.metaflow.module.metaflow-metadata-service.aws_iam_role.metadata_svc_ecs_task_role
module.metaflow.module.metaflow-metadata-service.aws_iam_role_policy.grant_custom_s3_batch
module.metaflow.module.metaflow-metadata-service.aws_iam_role_policy.grant_deny_presigned_batch
module.metaflow.module.metaflow-metadata-service.aws_iam_role_policy.grant_lambda_ecs_cloudwatch
module.metaflow.module.metaflow-metadata-service.aws_iam_role_policy.grant_lambda_ecs_vpc
module.metaflow.module.metaflow-metadata-service.aws_iam_role_policy.grant_s3_kms
module.metaflow.module.metaflow-metadata-service.data.archive_file.db_migrate_lambda
module.metaflow.module.metaflow-metadata-service.data.aws_region.current
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_api_key.this[0]
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_deployment.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_integration.db
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_integration.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_integration_response.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_method.db
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_method.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_method_response.db
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_method_response.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_resource.db
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_resource.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_rest_api.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_stage.this
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_usage_plan.this[0]
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_usage_plan_key.this[0]
module.metaflow.module.metaflow-metadata-service.aws_api_gateway_vpc_link.this
module.metaflow.module.metaflow-metadata-service.aws_cloudwatch_log_group.this
module.metaflow.module.metaflow-metadata-service.aws_ecs_cluster.this
module.metaflow.module.metaflow-metadata-service.aws_ecs_service.this
module.metaflow.module.metaflow-metadata-service.aws_ecs_task_definition.this
module.metaflow.module.metaflow-metadata-service.local_file.db_migrate_lambda
module.metaflow.module.metaflow-metadata-service.aws_lambda_function.db_migrate_lambda
module.metaflow.module.metaflow-metadata-service.aws_lb.this
module.metaflow.module.metaflow-metadata-service.aws_lb_listener.db_migrate
module.metaflow.module.metaflow-metadata-service.aws_lb_listener.this
module.metaflow.module.metaflow-metadata-service.aws_lb_target_group.db_migrate
module.metaflow.module.metaflow-metadata-service.aws_lb_target_group.this
module.metaflow.module.metaflow-metadata-service.aws_security_group.metadata_service_security_group
```

Network pieces that we shouldn't need in Prod
```
module.vpc.aws_eip.nat[0]
module.vpc.aws_internet_gateway.this[0]
module.vpc.aws_nat_gateway.this[0]
module.vpc.aws_route.private_nat_gateway[0]
module.vpc.aws_route.public_internet_gateway[0]
module.vpc.aws_route_table.private[0]
module.vpc.aws_route_table.public[0]
module.vpc.aws_route_table_association.private[0]
module.vpc.aws_route_table_association.private[1]
module.vpc.aws_route_table_association.private[2]
module.vpc.aws_route_table_association.public[0]
module.vpc.aws_route_table_association.public[1]
module.vpc.aws_route_table_association.public[2]
module.vpc.aws_subnet.private[0]
module.vpc.aws_subnet.private[1]
module.vpc.aws_subnet.private[2]
module.vpc.aws_subnet.public[0]
module.vpc.aws_subnet.public[1]
module.vpc.aws_subnet.public[2]
module.vpc.aws_vpc.this[0]
```
