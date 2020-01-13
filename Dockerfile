FROM ubuntu:18.04

LABEL maintainer="Andrew McIsaac <am43@sanger.ac.uk"

RUN apt-get update \
    && apt-get install -y python3 python3-virtualenv wget unzip vim jmespath ssh-client software-properties-common \
    && wget https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip \
    && unzip terraform_0.12.17_linux_amd64.zip -d /opt/terraform \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt install -y ansible

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:/opt/terraform:$PATH"
ADD . /opt/osdataproc
RUN pip install -e /opt/osdataproc/
