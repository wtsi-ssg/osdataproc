import argparse
import subprocess
import os
import sys

def create(args):
    act(args, 'apply')

def destroy(args):
    act(args, 'destroy')

def update(args):
    act(args, 'update')

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
    for val in vars(args):
        run_args.append(str(vars(args)[val]))
    return run_args

def cli():
    '''osdataproc'''
    parser = argparse.ArgumentParser(description='CLI tool to manage a Spark cluster')
    subparsers = parser.add_subparsers()

    parser_create = subparsers.add_parser('create', help='create a Spark cluster')

    parser_create.add_argument('cluster-name', help='name of the cluster to create')
    parser_create.add_argument('-n', '--num-slaves', default='2', type=int, help='number of slave nodes')
    parser_create.add_argument('-f', '--flavor', default='m1.medium', help='OpenStack flavor to use')
    parser_create.add_argument('-p', '--public-key', help='path to public key file', required=True)
    parser_create.add_argument('--network-name', default='cloudforms_network', help='OpenStack network to use')
    parser_create.add_argument('--image-name', default='bionic-server', help='OpenStack image to use - Ubuntu only')
    parser_create.add_argument('-v', '--nfs-volume', help='ID of an nfs volume to attach to the cluster')
    parser_create.set_defaults(func=create)


    parser_destroy = subparsers.add_parser('destroy', help='destroy a Spark cluster')
    parser_destroy.add_argument('cluster-name', help='name of the cluster to destroy')
    parser_destroy.set_defaults(func=destroy)

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    cli()
