import argparse
import subprocess
import os
import sys
import volumes
import yaml

def create(args):
    if args['nfs_volume'] is not None and args['volume_size'] is None:
        # find ID of specified volume
        args['nfs_volume'] = volumes.get_volume_id(args['nfs_volume'], to_create=False)
    elif args['nfs_volume'] is not None and args['volume_size'] is not None:
        # create a volume and return its ID if unique name
        if volumes.get_volume_id(args['nfs_volume'], to_create=True) is None:
            args['nfs_volume'] = volumes.create_volume(args['nfs_volume'], args['volume_size'])
        else:
            sys.exit("Please use a unique volume name.")
    act(args, 'apply')

def destroy(args):
    volumes_to_destroy = volumes.get_attached_volumes(
            os.environ['OS_USERNAME'] + "-" + args['cluster-name'] +  "-master")
    act(args, 'destroy')
    if args['destroy-volumes'] and volumes_to_destroy is not None:
        # destroy volumes attached to instance
        volumes.destroy_volumes(volumes_to_destroy)

def update(args):
    act(args, 'update')

def reboot(args):
    act(args, 'reboot')

def act(args, command):
    if "OS_USERNAME" not in os.environ:
        sys.exit("openrc.sh must be sourced")
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = get_args(args, command)
    subprocess.run([f'{osdataproc_home}/run', 'init'])
    subprocess.run(run_args)

def get_args(args, command):
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = [f'{osdataproc_home}/run', command]
    for key in args:
        run_args.append(str(args[key]))
    return run_args

def cli():
    '''osdataproc'''
    parser = argparse.ArgumentParser(description='CLI tool to manage a Spark and Hadoop cluster')
    subparsers = parser.add_subparsers()

    parser_create = subparsers.add_parser('create', help='create a Spark cluster')

    parser_create.add_argument('cluster-name', help='name of the cluster to create')
    parser_create.add_argument('-n', '--num-slaves', type=int, help='number of slave nodes')
    parser_create.add_argument('-p', '--public-key', help='path to public key file')
    parser_create.add_argument('-f', '--flavor', help='OpenStack flavor to use')
    parser_create.add_argument('--network-name', help='OpenStack network to use')
    parser_create.add_argument('-i', '--image-name', help='OpenStack image to use - Ubuntu only')
    parser_create.add_argument('-v', '--nfs-volume', help='Name or ID of an nfs volume to attach to the cluster') 
    parser_create.add_argument('-s', '--volume-size', help='Size of OpenStack volume to create')
    parser_create.add_argument('-d', '--device-name', help='Device mountpoint name of volume - see NFS.md')
    parser_create.add_argument('--floating-ip', help='OpenStack floating IP to associate to the master node - will automatically create one if not specified')
    parser_create.set_defaults(func=create)


    parser_destroy = subparsers.add_parser('destroy', help='destroy a Spark cluster')
    parser_destroy.add_argument('cluster-name', help='name of the cluster to destroy')
    parser_destroy.add_argument('-d', '--destroy-volumes', dest='destroy-volumes', action='store_true', help='also destroy volumes attached to cluster')
    parser_destroy.set_defaults(func=destroy)

    parser_reboot = subparsers.add_parser('reboot', help='reboot all slave nodes of a cluster, e.g. to pick up mount point changes')
    parser_reboot.add_argument('cluster-name', help='name of the cluster to reboot')
    parser_reboot.set_defaults(func=reboot)

    args = parser.parse_args()

    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    with open(f'{osdataproc_home}/vars.yml', 'r') as stream:
        defaults = yaml.safe_load(stream)
    defaults['osdataproc'].update({k: v for k, v in vars(args).items() if v is not None})

    args.func(defaults['osdataproc'])

if __name__ == "__main__":
    cli()
