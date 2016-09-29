#!/bin/bash

echo "#################################"
echo "  Running Switch Post Config"
echo "#################################"
sudo su

# enable management VRF
cat > /etc/network/interfaces <<EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*.intf

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
    vrf mgmt

auto mgmt
iface mgmt
    address 127.0.0.1/8
    vrf-table 1111
    mtu 1500
EOF

# nothing to do

echo "#################################"
echo "   Finished"
echo "#################################"

(
setsid shutdown -r
)&

exit 0
