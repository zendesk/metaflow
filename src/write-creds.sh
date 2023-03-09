#!/bin/bash

username=$(cat /secrets/MYSQL_mlflow_USERNAME)
password=$(cat /secrets/MYSQL_mlflow_PASSWORD)
database_name=$(cat /config/foundation/DATASTORE_AURORACLUSTER_mlflow_DATABASE_NAME)

echo -e "[client]\nuser=${username}\npassword=${password}\n\ndatabase=${database_name}" > /mysql-config/my.cnf


aws_credentials_file=/aws-config/credentials

cat >> "${aws_credentials_file}" <<- EOM
[default]
aws_access_key_id=$(cat /secrets/IAM_AWS_ACCESS_KEY_ID)
aws_secret_access_key=$(cat /secrets/IAM_AWS_SECRET_ACCESS_KEY)
aws_session_token=$(cat /secrets/IAM_AWS_SESSION_TOKEN)
EOM
