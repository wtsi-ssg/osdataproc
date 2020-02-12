# osdataproc

osdataproc is a command-line tool for creating an OpenStack cluster with [Apache Spark](https://spark.apache.org/) and [Apache Hadoop](https://hadoop.apache.org/) configured. It comes with [JupyterLab](https://jupyter.org/) and [Hail](https://hail.is), a genomic data analysis library built on Spark installed, as well as [Netdata](https://github.com/netdata/netdata) for monitoring.

### Setup

1. Create a virtual environment, e.g. `python3 -m venv env`
2. Download Terraform and unzip it into a location on your path, e.g. into your venv: 
    ```bash
    wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip && unzip terraform_0.12.20_linux_amd64.zip -d env/bin/
    ```
3. Source the environment, clone this repository and install requirements into the virtual environment:
    ```bash
    source env/bin/activate
    git clone https://gitlab.internal.sanger.ac.uk/am43/osdataproc.git
    cd osdataproc/ && pip install -e .
    ```
4. Make sure you have created an SSH keypair with `ssh-keygen` if you have not done so before. The default options are ok. Read the notes below if your private key has a passphrase.
5. Download your OpenStack project openrc.sh file into your $HOME directory on the spark-runner server. You can find the specific file for your project at Project > API Access, and then Download OpenStack RC File > OpenStack RC File (Identity API v3) in the top right.
6. Source your openrc file: `source <project-name>-openrc.sh`

You can then run the `osdataproc` command as shown below. `osdataproc --help`, or `osdataproc create --help` etc. will show all possible arguments.

### Example usage

```bash
osdataproc create [--num-slaves] <number of desired slave nodes> 
                  [--flavor] <OpenStack flavor to use>
                  --public-key <path to public key file>
                  [--network-name] <OpenStack network to use>
                  [--image-name] <OpenStack image to use - Ubuntu images only>
                  [--nfs-volume] <OpenStack volume to attach as NFS shared volume>
                  <cluster-name>

osdataproc destroy <cluster-name>
```
`osdataproc create` will output the public ip of your master node when the node has been created. You can connect to this with `ssh ubuntu@<spark_master_public_ip>`. It will take a few minutes for the configuration to complete.

You can configure defaults for the optional arguments in the `terraform/variables.tf` file.

From here you can access Jupyter Lab online at `<spark_master_public_ip>:8888` (the default password is "jupyter"). This can be changed by running `jupyter notebook password` from the master shell and entering your new password, then restarting the server with `sudo service jupyter-lab restart`).

View the Spark webUI at `<spark_master_public_ip>:8080`\
View the HDFS webUI at `<spark_master_public_ip>:9870`\
View the YARN webUI at `<spark_master_public_ip>:8088`\
View the Spark History Server at `<spark_master_public_ip>:18080`\
View the MapReduce History Server at `<spark_master_public_ip>:19888`\
View Netdata at `<spark_master_public_ip>:19999`

### Attaching a Volume

You can attach a volume as an NFS share to your cluster. This option, at present, will mount the `data` directory in the home directory of your master node to all of the slave nodes, and attach the volume by default to `/dev/vdb` on the master node.
To mount the data directory, identify the device you want to mount, and then mount it on the `data` directory. E.g. `mount /dev/vdb1 /home/ubuntu/data`.

You must then restart the nfs-kernel-server service to pick up these changes (`service nfs-kernel-server restart`), and reboot the slave nodes to pick up the new filesystem changes. `osdataproc reboot <cluster-name>` from the same location you provisioned the cluster will reboot all slave nodes of the specified cluster.

### Troubleshooting Notes

*  If your private key has a passphrase, Ansible will not be able to connect to the created instances unless you add your key to ssh-agent. To use a passphrase you can type `eval $(ssh-agent)` and `ssh-add`, entering your private key passphrase when prompted. Then go on to create your cluster as above.
*  You can view Ansible logs at osdataproc/state/\<cluster-name\>/ansible-master.log to see the configuration state of your master.
*  You can check provisioning status of the slave nodes by copying your SSH keys to the master node and SSH'ing to one of the slave nodes using its private IP (found at `terraform/outputs.json`). The provisioning status is found at `/var/log/user_data.log` on each slave node.
*  For Sanger users, check [here](https://metrics.internal.sanger.ac.uk/dashboard/db/fce-available-capacity?refresh=5m&orgId=1) for available FCE capacity before creating a cluster.
