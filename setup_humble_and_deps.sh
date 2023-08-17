#!/usr/bin/env bash

# install micromamba
"${SHELL}" <(curl -L micro.mamba.pm/install.sh) < /dev/null

# install robostack
micromamba create -n ros_env -c conda-forge -c robostack-staging ros-humble-ros-base -y
micromamba activate ros_env
micromamba install -c conda-forge rosdep compilers cmake pkg-config make ninja colcon-common-extensions -y

# pull sources to build
mkdir -p ~/ros2_ws/src && cd ~/ros2_ws/src
git clone -b ros2-devel https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b ros2-devel https://github.com/ROBOTIS-GIT/hls_lfcd_lds_driver.git
git clone -b ros2-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone -b ros2-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone https://github.com/StanfordASL/tb3-driver.git

# pull pre-built rosdep packages
rosdep init
rosdep update
rosdep install --from-paths ~/ros2_ws/src --skip-keys "nav2_bringup rviz2 cartographer_ros" -i -r -y

# build driver
cd ~/ros2_ws
colcon build --packages-up-to tb3-driver

# source setup scripts
echo "source \$HOME/ros2_ws/install/setup.bash" >> $CONDA_PREFIX/etc/conda/activate.d/ros-humble-ros-workspace_activate.sh

# re-activate
micromamba deactivate
micromamba activate ros_env
