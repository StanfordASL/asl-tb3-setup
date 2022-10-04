#!/usr/bin/env bash

set -xe
cd /tmp

sudo dpkg --add-architecture armhf
sudo apt-get update
sudo apt-get install -y libc6:armhf

export OPENCR_PORT=/dev/ttyACM0
export OPENCR_MODEL=burger_noetic
rm -rf ./opencr_update.tar.bz2

wget https://github.com/ROBOTIS-GIT/OpenCR-Binaries/raw/master/turtlebot3/ROS1/latest/opencr_update.tar.bz2 
tar -xvf opencr_update.tar.bz2 

cd ./opencr_update
sudo ./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr
