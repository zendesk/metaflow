#!/bin/bash

export MF_METADATA_DB_PSWD=$(cat /secrets/metadata-service-db-password)
cd /metadata-service && metadata_service
