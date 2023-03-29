
FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/docker-images-base/python:3.7-focal
RUN tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
RUN go get -u github.com/pressly/goose/cmd/goose
RUN apt update && apt install -y git && apt install -y postgresql && apt install -y gcc && apt install -y libpq-dev
RUN git clone https://github.com/Netflix/metaflow-service /repo

COPY src/write-creds.sh /repo/write-creds.sh
RUN pip install --editable /repo

