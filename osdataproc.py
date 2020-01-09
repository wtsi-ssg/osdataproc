import argparse
import subprocess

def create(args):
    run_args = get_args(args, 'apply')
    subprocess.run(['./run', 'init'])
    subprocess.run(run_args)
    subprocess.Popen(['./run', 'ansible_master'])
    subprocess.Popen(['./run', 'ansible_slaves'])

def destroy(args):
    run_args = get_args(args, 'destroy')
    subprocess.run(run_args)

def update(args):
    run_args = get_args(args, 'update')
    subprocess.run(run_args)
    subprocess.run(['./run', 'ansible_slaves'])

def get_args(args, command):
    run_args = ['./run', command]
    for val in vars(args):
        run_args.append(str(vars(args)[val]))
    return run_args

def cli():
    '''Example script'''
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
