# osdataproc - Attaching a Volume

You can attach a volume as an NFS share to your cluster. This option, at present, will mount the `data` directory in the home directory of your master node to all of the slave nodes, and attach the volume by default to the device mountpoint on the master node.

If you already know the device mountpoint you can overwrite the `device_mountpoint` variable in `ansible/roles/spark_master/defaults/main.yml` to the mountpoint of your volume. By default this is set as /dev/vdb1, so will automatically mount a device found at this point to `/home/ubuntu/data`. The `nfs-kernel-server` service will be automatically started if a mountpoint is found, otherwise the service will need to be manually started for slave nodes to mount the master `data` directory.

If you do not know the mountpoint, to mount the data directory, identify the device you want to mount after creating the cluster, and then mount it on the `data` directory. E.g. `mount /dev/vdb1 /home/ubuntu/data`. Then start the `nfs-kernel-server` service with `sudo service nfs-kernel-server start`. If there is no partition on the device (e.g. it is a newly created volume), you will need to first create a partition as shown below.

If you have an encrypted LUKS volume you must first decrypt the volume before you mount it, using e.g. `cryptsetup`. For example, `sudo cryptsetup luksOpen /dev/vdb2 hail-tmp_dir`, then mount the device with `sudo mount /dev/mapper/hail-tmp_dir /home/ubuntu/data`.

### Creating a Partition

Follow the output below to create and format a partition on a new device.
```
$ sudo parted /dev/vdb
GNU Parted 3.2
Using /dev/vdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mklabel gpt
(parted) mkpart
Partition name?  []?
File system type?  [ext2]? ext4
Start? 0%
End? 100%
(parted) quit
$ sudo mkfs.ext4 /dev/vdb1
```
