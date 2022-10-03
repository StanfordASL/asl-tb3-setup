#!/usr/bin/env bash

# install dependencies ########################################################
sudo apt update
sudo apt upgrade -y

all_pkgs=$(apt list 2>/dev/null | cut -d'/' -f1 | tail -n +1)
sanitize_pkgs() {
	pkgs="$@"
	local list=""
	for pkg in $pkgs; do
		if echo $all_pkgs | grep $pkg > /dev/null; then
			list="$list $pkg"
		fi
	done
	echo $list
}

sudo apt install -y $(sanitize_pkgs vim nano emacs git zsh lsb-core curl cmake htop \
  python3-empy \
	python3-dev liblz4-dev unzip libpcap-dev libtinyxml2-dev \
	libtinyxml-dev qt5-qmake qt5-default python3-pyqt5 pyqt5-dev \
	software-properties-common libboost-dev python3 python3-dev \
	python3-pip build-essential python3-serial libgazebo9-dev \
	libpoco-dev)

# remove previous ros installation ############################################
sudo apt purge -y ros-* 
sudo apt autoremove -y 
sudo rm -rf /etc/ros 
sudo rm -f /etc/apt/sources.list.d/ros-* 

# build new ros ###############################################################
pip3 install rosdep rospkg rosinstall_generator rosinstall vcstool \
	catkin_tools catkin_pkg 
export PATH="$PATH:$HOME/.local/bin"

cd /usr/lib/aarch64-linux-gnu
sudo ln -s libboost_python3.a libboost_python37.a 
sudo ln -s libboost_python3.so libboost_python37.so 

cd ~/ 
sudo $HOME/.local/bin/rosdep init 
$HOME/.local/bin/rosdep update 
cd ~ 
mkdir -p ros_catkin_ws/src 
cd ros_catkin_ws

catkin config --init -DCMAKE_BUILD_TYPE=Release \
	--blacklist rqt_rviz rviz_plugin_tutorials librviz_tutorial \
	--install
rosinstall_generator desktop_full --rosdistro noetic --deps --tar > \
	noetic-desktop-full.rosinstall
vcs import --input noetic-desktop-full.rosinstall ./src
export ROS_DISTRO="noetic"
export ROS_PYTHON_VERSION="3"

export DEBIAN_FRONTEND=noninteractive
sudo apt install -y tzdata
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata

sudo $HOME/.local/bin/rosdep install --from-paths src --ignore-src -y -r

catkin build


# install necessary ros packages ##############################################
source ~/ros_catkin_ws/install/setup.bash
cd
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src

git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone https://github.com/StanfordASL/asl_turtlebot.git
git clone https://github.com/StanfordASL/openslam_gmapping.git
git clone https://github.com/StanfordASL/velodyne.git
git clone https://github.com/ros-drivers/rosserial.git
git clone https://github.com/ros-drivers/usb_cam.git
git clone https://github.com/ros-perception/slam_gmapping.git

cd ~/catkin_ws
rm -rf devel build
catkin build
