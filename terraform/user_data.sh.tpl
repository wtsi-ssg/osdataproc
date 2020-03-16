#!/bin/bash -eux

exec >> /var/log/user_data.log 2>&1

# Re-run user_data on reboot
rm /var/lib/cloud/instance/sem/config_scripts_user

REPO=https://github.com/wtsi-ssg/osdataproc.git
BRANCH=master
FOLDER=/tmp/osdataproc

if [ ! -d $FOLDER ] ; then
    git clone -b $BRANCH $REPO $FOLDER
fi

echo ${spark_master_private_ip} spark-master >> /etc/hosts

apt update
apt install software-properties-common -y
apt-add-repository --yes --update ppa:ansible/ansible

# Force non-interactive install: https://bugs.launchpad.net/ubuntu/+source/ansible/+bug/1833013
UCF_FORCE_CONFOLD=1 DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -qq -y install ansible

ansible-playbook /tmp/osdataproc/ansible/main.yml -i localhost -e ansible_python_interpreter=/usr/bin/python3 -e spark_master_private_ip=${spark_master_private_ip} -e netdata_api_key=${netdata_api_key} -e nfs_volume_id=${nfs_volume_id} --skip-tags=master

