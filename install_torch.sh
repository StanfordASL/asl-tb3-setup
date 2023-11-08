#!/usr/bin/env bash

# Install GDown
micromamba run -n ros_env pip3 install gdown

# Download and Install Pytorch and Torchvision Wheels
cd ~/Downloads/
micromamba run -n ros_env gdown 1qvKOf-OUMb_PRdlBqvQpoN1YQ7JT7Vd7
micromamba run -n ros_env gdown 145kaX38HEUHIXC4r1JjythiJis9jZizp
micromamba run -n ros_env pip3 install torch-1.10.0-cp310-cp310-linux_aarch64.whl 
micromamba run -n ros_env pip3 install torchvision-0.11.0a0-cp310-cp310-linux_aarch64.whl

# Pull and Install tb3-driver new deps
cd ~/ros2_ws/src/asl-tb3-driver
git pull
micromamba run -n ros_env rosdep update
micromamba run -n ros_env rosdep install --from-path . -i -y

# Colcon Build
cd ~/ros2_ws
micromamba run -n ros_env colcon build --packages-up-to asl_tb3_driver
