FROM 713408432298.dkr.ecr.us-west-2.amazonaws.com/base/zendesk/docker-images-base/python:3.7-focal
RUN apt update && apt install -y git && apt install -y postgresql
RUN git clone https://github.com/Netflix/metaflow-service /metaflow-service
RUN mkdir /root/services
RUN mv /metaflow-service/services/__init__.py /root/services/
RUN mv /metaflow-service/services/data /root/services/data
RUN mv /metaflow-service/services/utils /root/services/utils
RUN mv /metaflow-service/services/metadata_service /root/services/metadata_service
RUN mv /metaflow-service/setup.py  /root/
WORKDIR /root
RUN pip install --editable /root
CMD metadata_service


