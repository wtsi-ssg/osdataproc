from setuptools import setup

setup(
        name='osdataproc',
        version='0.1',
        py_modules=['osdataproc'],
        install_requires=['ansible==4.2.0', 'jmespath==0.9.4', 'python-openstackclient==5.2.0', 'openstacksdk==0.46.0'],
        entry_points='''
            [console_scripts]
            osdataproc=osdataproc:cli
        ''',
)
