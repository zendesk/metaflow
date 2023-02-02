FROM python:3.7
ADD /vendor/netflix/Netflix/metaflow-service/services/__init__.py /root/services/
ADD /vendor/netflix/Netflix/metaflow-service/services/data /root/services/data
ADD /vendor/netflix/Netflix/metaflow-service/services/utils /root/services/utils
ADD /vendor/netflix/Netflix/metaflow-service/services/metadata_service /root/services/metadata_service
ADD /vendor/netflix/Netflix/metaflow-service/setup.py /root/
ADD /vendor/netflix/Netflix/metaflow-service/setup.cfg /root/
WORKDIR /root
RUN pip install --editable .
CMD metadata_service
