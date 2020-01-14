# osdataproc

1. Download your OpenStack openrc.sh file into your ${HOME} directory.
2. `mkdir ${HOME}/state` - will store the state of the cluster on the host.
3. `sudo docker run -it -v ${HOME}:/root -v ${HOME}/state:/opt/osdataproc/terraform/terraform.tfstate.d andrewmcisaac/osdataproc`
4. `source openrc.sh`
5. `osdataproc create -n 4 -f m1.medium -i ${HOME}/.ssh/id_rsa.pub spark`

Example usage:

osdataproc create --num-workers 8 --flavor m1.small --keypair am43-spark sparkcluster

osdataproc destroy sparkcluster

osdataproc update --num-workers 32 sparkcluster
