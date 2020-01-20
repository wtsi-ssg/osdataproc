# osdataproc

osdataproc is a command-line tool for creating an OpenStack cluster with [Apache Spark](https://spark.apache.org/) and [Apache Hadoop](https://hadoop.apache.org/) configured. It also comes with [JupyterLab](https://jupyter.org/) installed.

### Setup

1. You first need to connect to the spark-runner server at `<username>@172.27.84.230`, signing in with your LDAP (Sanger) password.
2. Download your OpenStack project openrc.sh file into your $HOME directory on the spark-runner server. You can find the specific file for your project on eta at Project > API Access, and Download OpenStack RC File > OpenStack RC File (Identity API v3) in the top right.
3. Configure your SSH keys, either by copying pre-existing keys to the server, or creating a new keypair.
    * Copy your SSH key to the spark-runner server, e.g.: `scp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa <username>@172.27.84.230:.ssh/`. Read the notes below if your private key has a passphrase. OR:
    * Create a new keypair with `ssh-keygen`. The default options are ok. If you choose this option you will only be able to access the created cluster from the spark-runner server, and not your home directory.
4. `docker run -it -v $HOME:/root -v $HOME/state:/opt/osdataproc/terraform/terraform.tfstate.d andrewmcisaac/osdataproc`
5. Source your openrc file. For the ssg-isg project, this is `source ssg-isg-openrc.sh`

You can then run the `osdataproc` command as shown below. `osdataproc --help`, or `osdataproc create --help` etc. will show possible arguments.

### Example usage

`osdataproc create --num-slaves 4 --flavor m1.medium -i ~/.ssh/id_rsa.pub  sparkcluster`

`osdataproc destroy sparkcluster`

`osdataproc create` will output the public ip (172.x.x.x) of your master node when finished. You can connect to this with `ssh ubuntu@172.x.x.x` from the spark-runner server. It will take a few minutes for the configuration to complete.

From here you can access Jupyter Lab online at <spark_master_public_ip>:8888 (the default password is "jupyter". This can be changed if you desire by running `jupyter notebook password` and entering your new password, then restarting the server with `sudo systemctl restart jupyter-lab.service`).
You can view the HDFS webUI at <spark_master_public_ip>:9870, and Spark webUI at <spark_master_public_ip>:8080.

### Notes

*  If your private key has a passphrase, Ansible will not be able to connect to the created instances unless you add your key to ssh-agent from within the container. It is recommended to use a passphraseless private key, but to use a passphrase you can type `eval $(ssh-agent)` and `ssh-add`, entering your private key passphrase when prompted. Then go on to create your cluster as above.
*  Ansible runs in the Docker container, so do not prematurely close the container, or the instances will not be correctly configured - you can detach it with `Ctrl` + `P` + `Q`, and then reattach with `docker attach <container_id>` (container_id is found with `docker container ls`). Re-run your create command to finish an incomplete configuration.
*  You can view Ansible logs at $HOME/state/\<cluster-name\>/ansible-{master,slaves}.log to see the provisioning state of your instances.
