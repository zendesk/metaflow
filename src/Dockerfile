FROM golang:1.16.3 AS goose
RUN go get -u github.com/pressly/goose/cmd/goose


FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/docker-images-base/python:3.7-focal
RUN apt update && apt install -y git && apt install -y postgresql && apt install -y gcc && apt install -y libpq-dev
RUN git clone https://github.com/Netflix/metaflow-service /repo

RUN mkdir /metadata-service/services
RUN mkdir /migration-service/services

RUN mv /repo/services/__init__.py /metadata-service/services/
RUN mv /repo/services/data /metadata-service/services/data
RUN mv /repo/services/utils /metadata-service/services/utils
RUN mv /repo/services/metadata_service /metadata-service/services/metadata_service
RUN mv /repo/setup.py  /metadata-service/setup.py

COPY src/write-creds.sh /metadata-service/write-creds.sh

WORKDIR /metadata-service
RUN pip install --editable /metadata-service

COPY --from=goose /go/bin/goose /usr/local/bin/

RUN mv /repo/__init__.py /migration-service/services/__init__.py
RUN mv /repo/utils /migration-service/service/utils
RUN mv /repo/migration_service /migration-service/services/migration_service
RUN mv /repo/setup.py setup.cfg /migration-service

WORKDIR /migration-service
RUN pip install --editable /migration-service