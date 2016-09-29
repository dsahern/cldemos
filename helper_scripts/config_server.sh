#!/bin/bash

#This file is transferred to a Debian/Ubuntu Host and executed to re-map interfaces
#Extra config COULD be added here but I would recommend against that to keep this file standard.
echo "#################################"
echo "  Running Server Post Config"
echo "#################################"
sudo su


#Replace existing network interfaces file
cat > /etc/network/interfaces <<EOF
source /etc/network/interfaces.d/*.intf

auto lo
iface lo inet loopback

auto vagrant
iface vagrant inet dhcp
EOF

# workaround for ifupdown2
mkdir -p /etc/iproute2/rt_tables.d

cat >> /etc/iproute2/rt_tables <<EOF
1001    red
1002    blue
EOF

# fix default target -- multi-user, not graphical
systemctl set-default multi-user.target

# easy console access
systemctl enable serial-getty@ttyS0
systemctl start serial-getty@ttyS0
sed 's/root:!/root:/' -i /etc/shadow
sed 's/ quiet splash / console=ttyS0 /' -i.bak /boot/grub/grub.cfg

# add cumulus user
useradd cumulus
CUMULUS_HASH=`python -c 'import crypt; print(crypt.crypt("CumulusLinux!", "\$6\$saltsalt\$").replace("/","\\/"))'`
sed "s/cumulus:!/cumulus:$CUMULUS_HASH/" -i /etc/shadow
mkdir /home/cumulus/
sed "s/PasswordAuthentication no/PasswordAuthentication yes/" -i /etc/ssh/sshd_config
chsh -s /bin/bash cumulus

echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
mkdir /home/cumulus/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/cumulus/.ssh/authorized_keys
chmod 700 -R /home/cumulus
chown cumulus:cumulus -R /home/cumulus

# Other stuff
sudo apt-get update -qy
sudo apt-get install lldpd linux-tools-$(uname -r) -qy

echo "#################################"
echo "   Finished"
echo "#################################"

(
setsid shutdown -r
)&

exit 0
