import openstack as openstack_client
import os
import sys
import prettytable

def get_volume_id(volume):
    openstack = openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])

    volumes = [(v.id, v.name, v.status, v.size) for v in openstack.volume.volumes() if v.name == volume or v.id == volume]

    if len(volumes) == 0:
        sys.exit("No volume with name '" + volume + "' found, would you like to create one?")
    if len(volumes) > 1:
        pt = prettytable.PrettyTable(["Volume ID", "Name", "Status", "Size"])
        for row in range(len(volumes)):
            pt.add_row([col for col in volumes[row]])
        sys.exit("Multiple volumes with name '" + volume + "' found, please specify the ID of the desired volume.\n" + str(pt))

    return volumes[0][0] if volumes else None

#def get_volume_from_instance(instance_name):


def create_openstack_volume(volume_name, volume_size):
    openstack = openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])
    openstack.volume.create_volume(name=volume_name, size=volume_size)

def delete_openstack_volume(volume):
    openstack = openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])
    volume_id = get_volume_id(volume)
    openstack.volume.delete_volume(volume=volume_id)
