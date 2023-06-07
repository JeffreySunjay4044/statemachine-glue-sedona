#!/bin/bash

# Initialize the project and create the necessary files
python -m venv venv
source venv/bin/activate

# Build and package your package
python -m pip install --upgrade setuptools wheel
python setup.py sdist bdist_wheel

# Publish the package to PyPI
python -m pip install --upgrade twine
twine upload dist/*


