#!/bin/bash

REPO="git@gitlab.internal.sanger.ac.uk:am43/osdataproc.git"

ssh-keyscan gitlab.internal.sanger.ac.uk >> /root/.ssh/known_hosts
chmod 0400 /root/.ssh/known_hosts

apt update -y
apt install git -y
pip install ansible
/usr/local/bin/ansible-pull ansible/main.yml -C dev -U $REPO -fi localhost, --full --purge
