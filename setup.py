#!/usr/bin/env python

# setup script for nmrglue

from setuptools import setup
from codecs import open
from os import path, walk

here = path.abspath(path.dirname(__file__))

# get long description from README
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='nmrglue',
    use_scm_version=True,
    description='A module for working with NMR data in Python',
    long_description=long_description,
    url='http://www.nmrglue.com',
    author='Jonathan J. Helmus',
    author_email='jjhelmus@gmail.com',
    license='New BSD License',
    classifiers=[
        'Intended Audience :: Science/Research',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Topic :: Scientific/Engineering',
        'Operating System :: MacOS :: MacOS X',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX :: Linux'],
    setup_requires=['setuptools_scm'],
    install_requires=['numpy', 'scipy'],
    extras_require={
        "docs": ["sphinx", "sphinx_rtd_theme", "numpydoc"]
    },
    tests_require=["pytest"],
    packages=[
        'nmrglue',
        'nmrglue.analysis',
        'nmrglue.analysis.tests',
        'nmrglue.fileio',
        'nmrglue.fileio.tests',
        'nmrglue.process',
        'nmrglue.process.nmrtxt',
        'nmrglue.util'],
    include_package_data=True,
)
