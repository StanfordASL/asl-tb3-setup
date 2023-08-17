#!/usr/bin/env bash

read -p "Enter ROS2 Domain ID: " DOMAIN_ID
echo "export ROS_DOMAIN_ID=$DOMAIN_ID" > $MAMBA_ROOT_PREFIX/envs/ros_env/etc/conda/activate.d/domain.sh
echo "unset ROS_DOMAIN_ID" > $MAMBA_ROOT_PREFIX/envs/ros_env/etc/conda/deactivate.d/domain.sh
