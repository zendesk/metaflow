FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/dockerhub-images/golang:1.16-alpine AS goose
RUN go get -u github.com/pressly/goose/cmd/goose

FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/docker-images-base/python:3.7-focal
RUN apt update && apt install -y git && apt install -y postgresql && apt install -y gcc && apt install -y libpq-dev
RUN git clone https://github.com/Netflix/metaflow-service /repo

COPY src/write-creds.sh /repo/write-creds.sh
RUN pip install --editable /repo

