# Attaching a Volume

You can attach a volume as an NFS share to your cluster creating either
a new volume, or attaching an existing volume.

### Creating a New Volume

To create a new volume specify the volume name and volume size, either
on the command line with `--nfs-volume` and `--volume-size`, or in
[vars.yml][vars]. `--device-name` should be left as the default
(`/dev/mapper/osdataproc`). This will create a new encrypted OpenStack
volume, the password for which you set on first creation of a cluster.

For subsequent cluster creations you need only to specify the volume
name (or ID).

### Using an Existing Volume

You may also wish to attach an existing volume not created by
`osdataproc` to your cluster. To do this, specify the name of the volume
you wish to attach, as well as the device mountpoint name of the main
data partition. Again this can be on the command line with
`--nfs-volume` and `--device-name`, or in [vars.yml][vars].

For example, a simple existing volume might have its main partition on
`dev/vdb1`, or a volume created with [hgi-cloud][hgi-cloud] will have
its device mountpoint name at `/dev/mapper/hail-tmp_dir`.

### Destroying a Volume

To destroy volumes attached to the cluster use the `--destroy-volumes`
flag. Not specifying this will keep the data on the volume for when a
cluster is recreated.

### Troubleshooting

If you enter an incorrect password on cluster creation, the cluster will
not become fully configured. If the provisioning logs become stuck on
'Wait for device' this is a sign that the password is incorrect. You
can correct this by connecting to the master node and running:

```bash
sudo systemd-tty-ask-password-agent
```

...entering the correct password for your volume when prompted. The
provisioning will then continue automatically from where it was paused.

<!-- References -->
[hgi-cloud]: https://github.com/wtsi-hgi/hgi-cloud
[vars]:      vars.yml
