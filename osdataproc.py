import argparse
import subprocess
import os
import sys
import openstack as openstack_client

def create(args):
    args.nfs_volume = get_volume_id(args.nfs_volume)
    act(args, 'apply')

def destroy(args):
    act(args, 'destroy')

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

def get_volume_id(volume):
    openstack = openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])

    volume_ids = [(v.id, v.name, v.status, v.size) for v in openstack.volume.volumes() if v.name == volume or v.id == volume]

    if len(volume_ids) == 0:
        sys.exit("No volume with name '" + volume +"' found, please check that a volume with that name exists.")
    if len(volume_ids) > 1:
        sys.exit("Multiple volumes with name '" + volume + "' found, please specify the id of the desired volume." + \
                "\nVolumes found were:\n" + \
                "\n".join("| ID: %s | Name: %s | Status: %-9s | Size: %-2i |" % tup for tup in volume_ids))

    return volume_ids[0][0] if volume_ids else None


def get_args(args, command):
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = [f'{osdataproc_home}/run', command]
    for key in vars(args):
        run_args.append(str(vars(args)[key]))
    return run_args

def cli():
    '''osdataproc'''
    parser = argparse.ArgumentParser(description='CLI tool to manage a Spark and Hadoop cluster')
    subparsers = parser.add_subparsers()

    parser_create = subparsers.add_parser('create', help='create a Spark cluster')

    parser_create.add_argument('cluster-name', help='name of the cluster to create')
    parser_create.add_argument('-n', '--num-slaves', type=int, help='number of slave nodes')
    parser_create.add_argument('-p', '--public-key', help='path to public key file', required=True)
    parser_create.add_argument('-f', '--flavor', help='OpenStack flavor to use')
    parser_create.add_argument('--network-name', help='OpenStack network to use')
    parser_create.add_argument('-i', '--image-name', help='OpenStack image to use - Ubuntu only')
    parser_create.add_argument('-v', '--nfs-volume', help='Name or ID of an nfs volume to attach to the cluster') 
    parser_create.add_argument('--floating-ip', help='OpenStack floating IP to associate to the master node - will automatically create one if not specified')
    parser_create.set_defaults(func=create)


    parser_destroy = subparsers.add_parser('destroy', help='destroy a Spark cluster')
    parser_destroy.add_argument('cluster-name', help='name of the cluster to destroy')
    parser_destroy.set_defaults(func=destroy)

    parser_reboot = subparsers.add_parser('reboot', help='reboot all slave nodes of a cluster, e.g. to pick up mount point changes')
    parser_reboot.add_argument('cluster-name', help='name of the cluster to reboot')
    parser_reboot.set_defaults(func=reboot)

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    cli()
