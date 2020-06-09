# osdataproc - Attaching a Volume

You can attach a volume as an NFS share to your cluster creating either a new volume, or attaching an existing volume.

### Creating a new volume

To create a new volume specify the volume name and volume size, either on the command line with `--nfs-volume` and `--volume-size`, or in [vars.yml]('https://github.com/wtsi-ssg/osdataproc/blob/master/vars.yml'). This will create a new encrypted OpenStack volume, the password for which you set on first creation of a cluster.

For subsequent cluster creations you need only to specify the volume name (or ID).

### Using an existing volume

You may also wish to attach an existing volume to your cluster. To do this specify the name of the volume you wish to attach, as well as the device mountpoint name of the main data partition. Again this can be on the command line with `--nfs-volume` and `--device-name`, or in [vars.yml]('https://github.com/wtsi-ssg/osdataproc/blob/master/vars.yml'). For example, a simple existing volume might have its main partition on `dev/vdb1`, or a volume created with [hgi-cloud]('https://github.com/wtsi-hgi/hgi-cloud.git`) will have its device mountpoint name at `/dev/mapper/hail-tmp_dir`.

### Destroying a volume

To destroy volumes attached to the cluster use the `--destroy-volumes` flag. Not specifying this will keep the data on the volume for when a cluster is recreated.

### Troubleshooting

If you enter an incorrect password on cluster creation the cluster will not become fully configured. If the provisioning logs become stuck on 'Wait for device' this is a sign that the password is incorrect. You can correct this by connecting to the master node and running `sudo systemd-tty-ask-password-agent`, entering the correct password for your volume when prompted.

Check the progress of your cluster provisioning from your home computer in the `state/<cluster-name>/ansible-master.log` file.
