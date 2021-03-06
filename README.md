# osdataproc

osdataproc is a command-line tool for creating an OpenStack cluster with [Apache Spark](https://spark.apache.org/) and [Apache Hadoop](https://hadoop.apache.org/) configured. It comes with [JupyterLab](https://jupyter.org/) and [Hail](https://hail.is), a genomic data analysis library built on Spark installed, as well as [Netdata](https://github.com/netdata/netdata) for monitoring.

### Setup

1. Create a virtual environment, e.g. `python3 -m venv env`
2. Download [Terraform](https://terraform.io) and unzip it into a location on your path, e.g. into your venv. Make sure to download the appropriate version for your operating system and architecture. 
    ```bash
    wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip && unzip terraform_0.12.26_linux_amd64.zip -d env/bin/
    ```
3. Source the environment, clone this repository and install requirements into the virtual environment:
    ```bash
    source env/bin/activate
    git clone https://github.com/wtsi-ssg/osdataproc.git
    cd osdataproc
    pip install -e .
    ```
4. Make sure you have created an SSH keypair with `ssh-keygen` if you have not done so before. The default options are ok. Read the notes below if your private key has a passphrase.
5. Download your OpenStack project openrc.sh file. You can find the specific file for your project at Project > API Access, and then Download OpenStack RC File > OpenStack RC File (Identity API v3) in the top right.
6. Source your openrc file: `source <project-name>-openrc.sh`

You can then run the `osdataproc` command as shown below. `osdataproc --help`, or `osdataproc create --help` etc. will show all possible arguments. Once run, it will ask you for a password. This is for access to the web interfaces, including Jupyter Lab. It is also the password for an encrypted NFS volume (see [NFS.md](https://github.com/wtsi-ssg/osdataproc/blob/master/NFS.md). When you first access your cluster via a browser you will be asked for a username and password. Your username is your OpenStack username, and the password is the one configured at setup. 

### Example usage

```bash
osdataproc create [--num-workers] <Number of desired worker nodes> 
                  [--public-key] <Path to public key file>
                  [--flavor] <OpenStack flavor to use>
                  [--network-name] <OpenStack network to use>
                  [--image-name] <OpenStack image to use - Ubuntu images only>
                  [--nfs-volume] <Name/ID of volume to attach or create as NFS shared volume>
                  [--volume-size] <Size of OpenStack volume to create>
                  [--device-name] <Device mountpoint name of volume>
                  [--floating-ip] <OpenStack floating IP to associate to master node - 
                                   will automatically create one if not specified>
                  <cluster-name>

osdataproc destroy <cluster-name>
```
`osdataproc create` will output the public ip of your master node when the node has been created. You can connect to this with `ssh ubuntu@<spark_master_public_ip>`. It will take a few minutes for the configuration to complete.

From here you can access Jupyter Lab online at `<spark_master_public_ip>/jupyter`.

You can also view the:

Spark webUI at `<spark_master_public_ip>/spark`\
HDFS webUI at `<spark_master_public_ip>/hdfs`\
YARN webUI at `<spark_master_public_ip>/yarn`\
Spark History Server at `<spark_master_public_ip>/sparkhist`\
MapReduce History Server at `<spark_master_public_ip>/mapreduce`\
Netdata metrics at `<spark_master_public_ip>/netdata`

### Attaching a Volume

You can attach a volume as an NFS share to your cluster creating either a new volume, or attaching an existing volume. This will mount the volume on the `data` directory and mount the `data` directory of your master node to all of the worker nodes as a shared volume over NFS.

See [NFS.md](https://github.com/wtsi-ssg/osdataproc/blob/master/NFS.md) for details and creation options.

### Configuration Options

There is a [vars.yml](https://github.com/wtsi-ssg/osdataproc/blob/master/vars.yml) file where default options for creating the cluster can be saved, as well as Spark and Hadoop configuration items tuned. Additional packages and python modules to install on the cluster can also be specified.

### Troubleshooting Notes

*  If your private key has a passphrase, Ansible will not be able to connect to the created instances unless you add your key to ssh-agent. To use a passphrase you can type `eval $(ssh-agent)` and `ssh-add`, entering your private key passphrase when prompted. Then go on to create your cluster as above.
*  You can view Ansible logs at `osdataproc/state/<cluster-name>/ansible-master.log` to see the configuration state of your master.
*  You can check provisioning status of the worker nodes by copying your SSH keys to the master node and SSH'ing to one of the worker nodes using its private IP. The provisioning status is found at `/var/log/user_data.log` on each worker node.
*  osdataproc is configured to use Kryo serialization for use with Hail and up to 10x faster data serialization, although not all Serializable types are supported, and so it may be necessary to change `$SPARK_HOME/conf/spark-defaults.conf` by commenting out or removing the `spark.serializer` configuration option. This can also be removed by default in [vars.yml](https://github.com/wtsi-ssg/osdataproc/blob/master/vars.yml) when creating a cluster.
*  For Sanger users, check [here](https://metrics.internal.sanger.ac.uk/dashboard/db/fce-available-capacity?refresh=5m&orgId=1) for available FCE capacity before creating a cluster.

### Contributing and Editing

You can contribute by submitting pull requests to this repository. If you create a fork you will need to update the `REPO` and `BRANCH` variables in `terraform/user_data.sh.tpl` to the new repository location for the changes you make to be reflected in the created cluster.

#### TODO

*  Resize functionality (larger flavor/more nodes)
*  Support for other distributions
