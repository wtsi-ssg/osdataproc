#!/bin/sh
exec >> /var/log/user_data.log 2>&1
touch /home/ubuntu/test.txt

REPO="https://gitlab.internal.sanger.ac.uk/am43/osdataproc.git"

ssh-keyscan gitlab.internal.sanger.ac.uk >> /home/ubuntu/.ssh/known_hosts
chmod 0400 /home/ubuntu/.ssh/known_hosts

sudo apt update -y
sudo apt-get install git -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install ansible -y
/usr/bin/ansible-pull ansible/main.yml -C dev -U $REPO -fi localhost --skip-tags=hosts
