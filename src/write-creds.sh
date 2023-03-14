#!/bin/bash

username=$(cat /secrets/db_user)
password=$(cat /secrets/db_pass)

aws_credentials_file=/aws-config/credentials

cat >> "${aws_credentials_file}" <<- EOM
[default]
aws_access_key_id=$(cat /secrets/IAM_AWS_ACCESS_KEY_ID)
aws_secret_access_key=$(cat /secrets/IAM_AWS_SECRET_ACCESS_KEY)
aws_session_token=$(cat /secrets/IAM_AWS_SESSION_TOKEN)
EOM
