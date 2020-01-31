from setuptools import setup

setup(
        name='osdataproc',
        version='0.1',
        py_modules=['osdataproc'],
        install_requires=['ansible', 'jmespath'],
        entry_points='''
            [console_scripts]
            osdataproc=osdataproc:cli
        ''',
)
