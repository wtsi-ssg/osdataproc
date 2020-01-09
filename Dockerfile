FROM ubuntu:18.04

LABEL maintainer="Andrew McIsaac <am43@sanger.ac.uk"

RUN apt-get update \
    && apt-get install -y python3 python3-virtualenv wget unzip vim \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://releases.hashicorp.com/terraform/0.12.17/terraform_0.12.17_linux_amd64.zip \
    && unzip terraform_0.12.17_linux_amd64.zip -d /opt/terraform

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:/opt/terraform:$PATH"
