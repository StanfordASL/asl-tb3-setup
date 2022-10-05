## Setting up a new TurtleBot3 from the [AA274](https://asl.stanford.edu/aa274a) system image:
1. Host machine setup:
    - Install [Ubuntu 18.04](https://releases.ubuntu.com/18.04/)
    - Install [NVIDIA SDK Manager](https://developer.nvidia.com/nvidia-sdk-manager)
    - Follow the first 7 steps at [kdb373] with Target Hardware Jetson TX2 and JetPack Version 4.6.2
    - Download, unpack, and install the corresponding Board Support Package (see the Orbitty Carrier [downloads page](https://connecttech.com/product/orbitty-carrier-for-nvidia-jetson-tx2-tx1/)):

        ```
        cd ~/nvidia/nvidia_sdk/JetPack_4.6.2_Linux_JETSON_TX2_TARGETS/Linux_For_Tegra
        wget https://connecttech.com/ftp/Drivers/CTI-L4T-TX2-32.7.2-V001.tgz
        tar -xzf CTI-L4T-TX2-32.7.2-V001.tgz
        cd CTI-L4T
        sudo ./install.sh
        cd ..
        ```
    - Download the AA274 system image from the [Releases](https://github.com/schmrlng/turtlebot3_setup/releases) page and overwrite the default system image:
        ```
        wget https://github.com/schmrlng/turtlebot3_setup/releases/download/202209/aa274.img
        sudo cp aa274.img bootloader/system.img
        ```
    - Your working directory (check with `pwd`) should be `~/nvidia/nvidia_sdk/JetPack_4.6.2_Linux_JETSON_TX2_TARGETS/Linux_For_Tegra` at this point, which will be assumed for all steps below.
2. Connect the Jetson TX2 to power and to the host machine via the micro USB port. All other connections may be removed for easier access to the carrier board RECOVERY and RESET buttons.
3. With the TX2 powered on, hold down the RECOVERY button and tap the RESET button to boot the TX2 into recovery mode.
![tb3_tx2_reset_recovery](https://user-images.githubusercontent.com/4130030/193955389-d0d68cb3-29ac-4d21-8450-1148f5311f5b.jpg)
4. On the host machine, run
    ```
    sudo ./flash.sh -r cti/tx2/orbitty/base mmcblk0p1
    ```
   to flash the AA274 system image onto the TX2.
5. Connect a monitor (HDMI) and mouse/keyboard (USB3) to the TX2 and RESET the board. Once it boots up, log in to the existing `aa274` account (password: `aa274`) and use the GUI to connect to WiFi. After connecting, go to "Edit Connections..." under the networking menu (alternatively "Network Connections" from applications/search) and edit the WiFi connection so that "General -> All users may connect to this network" is checked; this last step ensures that the robot will connect to WiFi on startup.
6. Now connect the TX2 to (i) the Velodyne (Ethernet, not micro USB -- we no longer need the adapter), (ii) the TB3 OpenCR board (USB3), and (iii) the Logitech C270 camera (USB3), and power cycle the robot.
7. Log into the TX2 from the host machine (`ssh aa274@turtlebot.local`) and run
    ```
    cd turtlebot3_setup
    git pull
    ./setup_velodyne_network.sh
    ./flash_opencr_noetic.sh  # NOTE: this command sometimes needs to be run twice (check output for errors)
    ./change_hostname.sh
    ```
   where for the last command enter the name (converted to all lowercase) printed on the label on the Velodyne.
8. After a short wait (the TX2 is rebooting), you should now be able to log into the robot using its new/unique name (`ssh aa274@$NAME.local`). On the robot, update the [`asl_turtlebot`](https://github.com/StanfordASL/asl_turtlebot) package to make sure it's running the latest version:
    ```
    cd ~/catkin_ws/src/asl_turtlebot
    git pull
    ```
9. The robot should now be ready to go! Test it by running (on the robot):
    ```
    roslaunch asl_turtlebot systems_test.launch
    ```
   and on the host machine (after editing/`source`-ing [`rostb3.sh`](https://github.com/StanfordASL/asl_turtlebot/blob/master/rostb3.sh)):
    ```
    roslaunch asl_turtlebot systems_test_host.launch
    ```

## Creating the AA274 system image (for reference; in most cases you should not need to do this!):
1. Complete the ["Host machine setup"](#setting-up-a-new-turtlebot3-from-the-aa274-system-image) instructions above.
2. Connect the Jetson TX2 to power and to the host machine via the micro USB port. All other connections may be removed for easier access to the carrier board RECOVERY and RESET buttons.
3. With the TX2 powered on, hold down the RECOVERY button and press the RESET button to boot the TX2 into recovery mode.
4. Install the vanilla OS/BSP by running (on the host machine):
    ```
    sudo ./cti-flash.sh
    ```
   (pick options "3. Orbitty" and "1. TX2").
5. Connect a monitor (HDMI) and mouse/keyboard (USB3) to the TX2 and RESET the board. Once it boots up, follow the GUI prompts for initial OS setup, making sure to:
    - Connect to WiFi
    - Computer's name: `turtlebot`
    - Username/password: `aa274`/`aa274`
    - Performance mode: MAXN
6. Once you hit a login screen, do not proceed (i.e., do not login and update software packages, etc.). Instead, proceed with [kdb374] to install all Jetson SDK components.
7. Reset/power cycle the TX2 and perform these actions on the device (perhaps connecting from the host machine with `ssh aa274@turtlebot.local`, now that the TX2 WiFi is set up):
    ```
    sudo apt update
    sudo apt upgrade
    git clone https://github.com/schmrlng/turtlebot3_setup.git
    cd turtlebot3_setup
    ./build_noetic_and_deps.sh
    ./install_ml_frameworks.sh
    cp .bashrc ~/.bashrc
    sudo reboot 0
    ```
8. Connect the TX2 to the host machine (micro USB) and RESET it into RECOVERY mode. Create the system image by running (on the host machine):
    ```
    sudo ./flash.sh -r -k APP -G aa274.img jetson-tx2 mmcblk0p1
    ```
   The image will be saved to `./aa274.img` (which, if you've been following the instructions above, should correspond to the full path `~/nvidia/nvidia_sdk/JetPack_4.6.2_Linux_JETSON_TX2_TARGETS/Linux_For_Tegra/aa274.img`).

## References
1. [Connect Tech kdb373: CTI-L4T Board Support Package Installation for NVIDIA JetPack with Connect Tech Jetson™ Carriers](https://connecttech.com/resource-center/kdb373/)
2. [Connect Tech kdb374: Installing Jetpack SDK Components alongside the CTI-L4T BSP](https://connecttech.com/resource-center/kdb374/)
3. [Connect Tech kdb378: Cloning Jetson™ Modules with Connect Tech Board Support Package](https://connecttech.com/resource-center/kdb-378-cloning-jetson-modules-with-connect-tech-board-support-package/)
4. [BOARD SUPPORT PACKAGE For Connect Tech NVIDIA Jetson TX2 Carriers: TX2-32.7.2 V001 
](https://connecttech.com/ftp/Drivers/L4T-Release-Notes/Jetson-TX2/TX2-32.7.2.pdf)
5. [ROBOTIS TurtleBot3 OpenCR Setup](https://emanual.robotis.com/docs/en/platform/turtlebot3/opencr_setup/)

[kdb373]: https://connecttech.com/resource-center/kdb373/
[kdb374]: https://connecttech.com/resource-center/kdb374/
[kdb378]: https://connecttech.com/resource-center/kdb-378-cloning-jetson-modules-with-connect-tech-board-support-package/
