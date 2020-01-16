# osdataproc

### Setup

1. You first need to connect to the spark-runner server at `<username>@172.27.84.230`
2. Download your OpenStack openrc.sh file into your $HOME directory on the spark-runner server. You can find the specific file for your project on eta at Project > API Access, and Download OpenStack RC File > OpenStack RC File (Identity API v3) in the top right.
3. Copy your SSH keys to the spark-runner server, e.g.: `scp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa am43@172.27.84.230:.ssh/`
4. `docker run -it -v $HOME:/root -v $HOME/state:/opt/osdataproc/terraform/terraform.tfstate.d andrewmcisaac/osdataproc`
5. `source openrc.sh`

You can then run the osdataproc command as shown below. `osdataproc --help`, or `osdataproc create --help` etc. will show possible arguments.

### Example usage

`osdataproc create -n 4 -i ~/.ssh/id_rsa.pub --flavor m1.medium sparkcluster`

`osdataproc destroy sparkcluster`

`osdataproc update -n 16 sparkcluster`


### Note

Ansible runs in the Docker container, so do not prematurely close the container, or the instances will not be correctly configured - you can detach it with `Ctrl` + `P` + `Q`, and then reattach with `docker attach <container_id>` (container_id is found with `docker container ls`).

