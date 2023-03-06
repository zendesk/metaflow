FROM python:3.7
WORKDIR /build
RUN ls
ADD /metaflow-service/services/__init__.py /root/services/
ADD /metaflow-service/services/data /root/services/data
ADD /metaflow-service/services/utils /root/services/utils
ADD /metaflow-service/services/metadata_service /root/services/metadata_service
ADD /metaflow-service/setup.py /metaflow-service/setup.cfg /root/
WORKDIR /root
RUN pip install --editable .
CMD metadata_service
