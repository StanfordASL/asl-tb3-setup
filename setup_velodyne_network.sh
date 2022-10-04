#!/usr/bin/env bash

# Generate udev rules file
ADAPTOR_VENDOR=00:04:4b
RULES_LOCATION=/etc/udev/rules.d/70-persistent-net.rules

RULES_TEMPLATE=$(cat <<EOF
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
  ATTR{address}=="%MAC_ADDR%", ATTR{type}=="1", NAME="velodyne0"
EOF
)

REGEXP="$ADAPTOR_VENDOR(:[0-9a-fA-F]{2}){3}"
VELODYNE_ADAPTOR_MAC=$(ifconfig | grep -Eo -m 1 $REGEXP)
if [ -z "$VELODYNE_ADAPTOR_MAC" ]
then
  echo "No matching mac address found with prefix $ADAPTOR_VENDOR"
else
  echo "$RULES_TEMPLATE" | sed -e "s/%MAC_ADDR%/$VELODYNE_ADAPTOR_MAC/g" | sudo tee $RULES_LOCATION > /dev/null
  echo "Saved udev rules file to $RULES_LOCATION"
fi

# Overwrite network interfaces file
INTERFACES_LOCATION=/etc/network/interfaces
INTERFACES_DOC=$(cat <<EOF
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto velodyne0
iface velodyne0 inet static
address 192.168.3.102
netmask 255.255.255.255
up route add 192.168.1.201 velodyne0
EOF
)

echo "$INTERFACES_DOC" | sudo tee $INTERFACES_LOCATION > /dev/null
echo "Added velodyn0 network interface at $INTERFACES_LOCATION"

# Add user to dialout group
sudo usermod -a -G dialout $USER
