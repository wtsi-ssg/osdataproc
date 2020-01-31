#!/bin/bash -eux

exec >> /var/log/user_data.log 2>&1

REPO=https://gitlab.internal.sanger.ac.uk/am43/osdataproc.git

echo ${spark_master_private_ip} spark-master >> /etc/hosts

pip install ansible
ansible-pull ansible/main.yml -C ansipull -U $REPO -fi localhost -e 'ansible_python_interpreter=/usr/bin/python3' -e --skip-tags=master
