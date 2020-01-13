import argparse
import subprocess
import os
import sys

def create(args):
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = get_args(args, 'apply')
    subprocess.run([f'{osdataproc_home}/run', 'init'])
    subprocess.run(run_args)

def destroy(args):
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = get_args(args, 'destroy')
    subprocess.run(run_args)

def update(args):
    osdataproc_home = os.path.dirname(os.path.realpath(__file__))
    run_args = get_args(args, 'update')
    subprocess.run(run_args)
    subprocess.run([f'{osdataproc_home}/run', 'ansible_slaves'])

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

    group = parser_create.add_mutually_exclusive_group(required=True)

    parser_create.add_argument('cluster-name', help='name of the cluster to create')
    parser_create.add_argument('-n', '--num-workers', default='2', type=int, help='number of worker nodes')
    parser_create.add_argument('-f', '--flavor', help='OpenStack flavor to use')
    group.add_argument('-k', '--keypair', help='OpenStack keypair to use')
    group.add_argument('-i', '--identity-file', help='path to public key file')
    parser_create.set_defaults(func=create)


    parser_destroy = subparsers.add_parser('destroy', help='destroy a Spark cluster')
    parser_destroy.add_argument('cluster-name', help='name of the cluster to destroy')
    parser_destroy.set_defaults(func=destroy)


    parser_update = subparsers.add_parser('update', help='resize a Spark cluster')
    parser_update.add_argument('cluster-name', help='name of the cluster to resize')
    parser_update.add_argument('-n', '--num-workers', type=int, help='number of worker nodes')
    parser_update.set_defaults(func=update)

    args = parser.parse_args()
    args.func(args)
