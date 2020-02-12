from setuptools import setup

setup(
        name='osdataproc',
        version='0.1',
        py_modules=['osdataproc'],
        install_requires=['ansible==2.9.4', 'jmespath==0.9.4', 'python-novaclient==16.0.0'],
        entry_points='''
            [console_scripts]
            osdataproc=osdataproc:cli
        ''',
)
