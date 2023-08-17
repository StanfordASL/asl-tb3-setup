# TurtleBot3 Setup for Stanford AA174 / AA274

## Upgrade From Existing ROS1 Image

1. Log into the TX2 from a host machine, replacing `<name>` with the actual robot name labeled on the LiDAR.
    ```bash
    ssh aa274@<name>.local  # e.g. ssh aa274@curly.local
    ```
2. Update the `turtlebot3_setup` repo
    ```bash
    cd ~/turtlebot3_setup && git pull
    ```
3. Flash OpenCR with ROS2 compatible firmware
    ```bash
    ./flash_opencr_humble.sh
    ```
    **Note**: check output for any errors, this command might need to be run twice.
4. Install ROS2 humble and drivers
    ```bash
    ./setup_humble_and_deps.sh
    ```
5. Setup `ROS_DOMAIN_ID`: different robot should have different domain IDs.
    ```bash
    ./change_ros2_domain.sh  # enter the desirable domain ID when prompted
    ```

## Flashing (TODO)

Re-flashing is not needed, but for reference, see [legacy instructions](LEGACY.md).
