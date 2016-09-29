2 spine, 4 leaf, 8 host simulation used for demo at netdev 1.2, October 2016.

    http://netdevconf.org/1.2/session.html?david-ahern

This demo shows how to use VRF and routing on the host (quagga/bgp) with
with docker-based containers. Spine and leaf nodes are running Cumulus
Linux 3.1; the hosts are running Ubuntu 16.04 with the v4.4 kernel.

Vagrant
-------
Topology orchestration is done with Vagrant.

topo.dot contains the wiring diagram. The initial vagrant file was
generated from it using the topology converter:

	https://github.com/CumulusNetworks/topology_converter

topo.out is the output file from running that command on the topo.dot file.

The vagrant helper script enable Management VRF on all switches. For the
host nodes the helper script is used to work around limitations with the
iproute2 version in Ubuntu 16.04 (table id to vrf name), add the cumulus
user, to install lldpd and perf on all nodes and a few workaround using
the vagrant box image for Ubuntu 16.04.


Ansible
-------
Ansible is used to configure the nodes.

Docker is installed on the host nodes to run containers. There are 2
networking options: bridge or veth. The option to configure a host
node is specified by adding -e 'net=<value>' arg:

    ansible-playbook configure.yml -e "net=bridge" -l host-11
    ansible-playbook configure.yml -e "net=veth"   -l host-12


Helper script
-------------
run-host-cmd is a wrapper around the ansible command to run commands on
the host nodes -- either the host os or inside a docker container.


Command Sequence
----------------
# bring up nodes
vagrant up --no-parallel 2>&1 | tee vagrant-up.log

# configure spine and leaf nodes
ansible-playbook configure.yml -l spine-*
ansible-playbook configure.yml -l leaf-*

# configure odd hosts to use bridges for container networking
ansible-playbook configure.yml -e "net=bridge" -l host-[1-4]1

# configure even hosts use veth and /32 for container networking
ansible-playbook configure.yml -e "net=veth" -l host-[1-4]2

# Start containers on hosts as desired
#
# e.g., create the first set of containers on all hosts that
#       are connected to VRF red
./run-host-cmd -v red -n 1

# start second set
./run-host-cmd -v red -n 2

# similarly for VRF blue
./run-host-cmd -v blue -n 1
./run-host-cmd -v blue -n 2


Container Addresses
-------------------
172.16.(HOSTID + VRF).CONID

HOSTID: 11, 12, 21, 22, 31, 32, 41, 42
   VRF: 100 = red, 200 = blue
 CONID: 1, 2

Container names in docker are deb-${vrf}-${conid}


Host-Leaf Addresses
-------------------
Host-Leaf IP address assignments since VRF in Ubuntu 16.04, 4.4 kernel,
does not handle IPv6 linklocal address. These addresses are only used
for quagga.

10.1.1.0/28  = leaf-1 to host-11 up to 8 VRFs
10.1.1.16/28 = leaf-1 to host-12 up to 8 VRFs

      leaf-1     host-11    
red  10.1.1.0   10.1.1.1  /31
blue 10.1.1.2   10.1.1.3  /31
                 host-12    
red  10.1.1.16  10.1.1.17  /31
blue 10.1.1.18  10.1.1.19  /31
                 host-21    
red  10.1.1.32  10.1.1.33  /31
blue 10.1.1.34  10.1.1.35  /31
                 host-22    
red  10.1.1.48  10.1.1.49  /31
blue 10.1.1.50  10.1.1.51  /31

... remainder of 10.1.1.0/24 for adding more hosts to leaf


10.1.2.0/28 = leaf-2 to host-11 up to 8 VRFs

      leaf-2     host-11    
red  10.1.2.0   10.1.2.1  /31
blue 10.1.2.2   10.1.2.3  /31
                 host-12    
red  10.1.2.16  10.1.2.17  /31
blue 10.1.2.18  10.1.2.19  /31
                 host-21    
red  10.1.2.32  10.1.2.33  /31
blue 10.1.2.34  10.1.2.35  /31
                 host-22    
red  10.1.2.48  10.1.2.49  /31
blue 10.1.2.50  10.1.2.51  /31

... remainder of 10.1.2.0/24 for adding more hosts to leaf


Generically:
- for leaf-N, VRF-M 10.1.N.X/31

- last octet:
     0-15 = host 1 connected to leaf N
    16-31 = host 2 connected to leaf N
    32-47 = host 3 connected to leaf N
    48-63 = host 4 connected to leaf N
    ...

- per VRF: leaf: (vrf_id-1)*2   host: (vrf_id-1)*2 + 1
    vrf1 (red) :  leaf: 0  host: 1
    vrf2 (blue):  leaf: 2  host: 3
    vrf3       :  leaf: 4  host: 5
    ...
    --> up to 8 VRFs per leaf
