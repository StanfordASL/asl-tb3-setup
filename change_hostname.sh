#!/bin/bash

read -p "Please enter the new hostname: " hostname

sudo hostname $hostname
sudo sed -i s/turtlebot/$hostname/g /etc/hostname
sudo sed -i s/turtlebot/$hostname/g /etc/hosts
sed -i s/turtlebot/$hostname/g .bashrc
cp .bashrc /home/aa274/.bashrc
sudo hostnamectl set-hostname $hostname
sudo rm /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
sudo reboot 0
