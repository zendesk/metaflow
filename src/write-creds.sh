#!/bin/bash

export MF_METADATA_DB_PSWD=$(cat /secrets/metadata-service-db-password)
metadata_service
