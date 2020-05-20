import openstack as openstack_client
import os
import sys

def get_volume_id(volume):
    openstack = openstack_client.connect(auth_url=os.environ['OS_AUTH_URL'],
                                       project_name=os.environ['OS_PROJECT_NAME'],
                                       username=os.environ['OS_USERNAME'],
                                       password=os.environ['OS_PASSWORD'],
                                       region_name=os.environ['OS_REGION_NAME'])

    volume_ids = [(v.id, v.name, v.status, v.size) for v in openstack.volume.volumes() if v.name == volume or v.id == volume]

    if len(volume_ids) == 0:
        sys.exit("No volume with name '" + volume + "' found, would you like to create one?")
    if len(volume_ids) > 1:
        sys.exit("Multiple volumes with name '" + volume + "' found, please specify the id of the desired volume." + \
                "\nVolumes found were:\n" + \
                "\n".join("| ID: %s | Name: %s | Status: %-9s | Size: %-2i |" % tup for tup in volume_ids))

    return volume_ids[0][0] if volume_ids else None

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
