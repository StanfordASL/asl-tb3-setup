#!/usr/bin/env bash

# TF; see https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html
sudo apt-get -y update
sudo apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran

sudo apt-get -y install python3-pip
sudo pip3 install -U pip testresources setuptools==49.6.0

sudo pip3 install -U --no-deps numpy==1.19.4 future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 protobuf pybind11 cython pkgconfig packaging
sudo env H5PY_SETUP_REQUIRES=0 pip3 install -U h5py==3.1.0

sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v461 tensorflow

# PyTorch; see https://docs.nvidia.com/deeplearning/frameworks/install-pytorch-jetson-platform/index.html
sudo apt-get -y install autoconf bc build-essential g++-8 gcc-8 clang-8 lld-8 gettext-base gfortran-8 iputils-ping libbz2-dev libc++-dev libcgal-dev libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev liblzma-dev libncurses5-dev libncursesw5-dev libpng-dev libreadline-dev libssl-dev libsqlite3-dev libxml2-dev libxslt-dev locales moreutils openssl python-openssl rsync scons python3-pip libopenblas-dev

sudo pip3 install -U expecttest xmlrunner hypothesis aiohttp pyyaml scipy==1.5.3 ninja cython typing_extensions protobuf
export LD_LIBRARY_PATH=/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH
sudo pip3 install https://developer.download.nvidia.com/compute/redist/jp/v461/pytorch/torch-1.11.0a0+17540c5+nv22.01-cp36-cp36m-linux_aarch64.whl
