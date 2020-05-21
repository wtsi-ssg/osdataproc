import openstack as openstack_client
import os
import sys
import prettytable

def connect_to_openstack():
    '''Return an object of type openstack.connection.Connection with configuration options sourced from the environment.'''
    return openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])

def get_volume_id(volume, to_create):
    '''Return volume ID of an OpenStack volume with name volume. Exit if multiple volumes with same name exist, or if no volumes exist of the specified name.'''
    openstack = connect_to_openstack()

    volumes = [(v.id, v.name, v.status, v.size) for v in openstack.volume.volumes() if v.name == volume or v.id == volume]

    if len(volumes) > 1:
        pt = prettytable.PrettyTable(["Volume ID", "Name", "Status", "Size"])
        for row in range(len(volumes)):
            pt.add_row([col for col in volumes[row]])
        sys.exit("Multiple volumes with name '" + volume + "' found, please specify the ID of the desired volume.\n" + str(pt))
    if not to_create:
        if len(volumes) == 0:
            sys.exit("No volume with name '" + volume +"' found, please check that a volume with that name exists, or create a new volume by including '--volume-size' with your desired volume size in GiB.")
    return volumes[0][0] if volumes else None

def get_attached_volumes(instance):
    '''Return list of volumes attached to instance.'''
    openstack = connect_to_openstack()
    
    server_id = openstack.get_server_id(instance)
    return [a.id for a in openstack.compute.volume_attachments(server_id)] if server_id else None

def create_volume(volume_name, volume_size):
    '''Create an OpenStack volume called volume_name of size volume_size, and return its ID.'''
    openstack = connect_to_openstack()

    volume = openstack.volume.create_volume(name=volume_name, size=volume_size)
    if volume:
        print("Volume created with name '" + volume_name + "' and size " + volume_size + "GiB.")
    return volume.id

def destroy_volumes(volumes):
    '''Destroy a list of Openstack volumes.'''
    openstack = connect_to_openstack()

    for v in volumes:
        openstack.volume.delete_volume(v)
