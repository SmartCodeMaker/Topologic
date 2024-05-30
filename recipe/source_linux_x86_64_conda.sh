#!/bin/bash
set -e

# Determine Python version. Corresponding conda_env_topologic_py*.yml
# must exist.
PYTHONVER=312
if [ ! -z "$1" ]; then PYTHONVER=$1; fi
set --

# Obtain project root/top directory and stay in it.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/..
TOP_DIR=$(pwd)

# Install and activate Miniconda.
if [ ! -d "$HOME/miniconda" ]; then
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
fi
source ~/miniconda/bin/activate

# Make sure Miniconda environment is created.
if conda info --envs | grep -q topologic_py${PYTHONVER}; then
  echo "Well done, conda environment already created."
else
  conda env create -f conda_env_topologic_py${PYTHONVER}.yml
fi

# Activate Miniconda environment.
conda activate topologic_py${PYTHONVER}
python --version

# Build source package.
mkdir -p BUILD
cd BUILD
cmake -DBUILD_VERSION=${TOPOLOGIC_VERSION} ../
make package_source

echo "Source code has been prepared successfully."
