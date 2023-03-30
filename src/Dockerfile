
FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/docker-images-base/python:3.7-focal
RUN apt-get update && \
    apt-get install -y git postgresql gcc libpq-dev wget curl

# Install Go
RUN wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
RUN touch /root/.bashrc
RUN echo "export PATH=$PATH:/root/go/bin" >> "/root/.bashrc"
RUN echo "export PATH=$PATH:/usr/local/go/bin" > "/root/.bashrc"
RUN PATH=$PATH:/usr/local/go/bin GO111MODULE=on go install -mod=mod github.com/pressly/goose/cmd/goose@latest


# Clone the metaflow-service repository
RUN git clone https://github.com/Netflix/metaflow-service /repo

# Copy script for injecting db creds and starting the metaflow_service
COPY src/write-creds.sh /repo/write-creds.sh

RUN pip install --editable /repo

