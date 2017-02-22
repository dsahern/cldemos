# Created by Topology-Converter v4.2.0
#    https://github.com/cumulusnetworks/topology_converter
#    using topology data from: /home/dsa/vagrant/2-tier-clos/topo.dot
#
#    NOTE: in order to use this Vagrantfile you will need:
#       -Vagrant(v1.8.1+) installed: http://www.vagrantup.com/downloads
#       -Cumulus Plugin for Vagrant installed: $ vagrant plugin install vagrant-cumulus
#       -the "helper_scripts" directory that comes packaged with topology-converter.py
#        -Libvirt Installed -- guide to come
#       -Vagrant-Libvirt Plugin installed: $ vagrant plugin install vagrant-libvirt
#       -Boxes which have been mutated to support Libvirt -- see guide below:
#            https://community.cumulusnetworks.com/cumulus/topics/converting-cumulus-vx-virtualbox-vagrant-box-gt-libvirt-vagrant-box
#       -Start with \"vagrant up --provider=libvirt --no-parallel\n")

# Check required plugins
REQUIRED_PLUGINS_LIBVIRT = %w(vagrant-libvirt vagrant-mutate)
exit unless REQUIRED_PLUGINS_LIBVIRT.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end

# Check required plugins
REQUIRED_PLUGINS = %w(vagrant-cumulus)
exit unless REQUIRED_PLUGINS.all? do |plugin|
  Vagrant.has_plugin?(plugin) || (
    puts "The #{plugin} plugin is required. Please install it with:"
    puts "$ vagrant plugin install #{plugin}"
    false
  )
end

Vagrant.configure("2") do |config|
  wbid = 1469742492

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "init.yml"
  end

  config.vm.provider :libvirt do |domain|
    # increase nic adapter count to be greater than 8 for all VMs.
    domain.nic_adapter_count = 55
  end


  ##### DEFINE VM for spine-2 #####
  config.vm.define "spine-2" do |device|
    device.vm.hostname = "spine-2"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> leaf-1:swp2
      device.vm.network "private_network",
            :mac => "44383900001e",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9015',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8015',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> leaf-2:swp2
      device.vm.network "private_network",
            :mac => "443839000026",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9019',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8019',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> leaf-3:swp2
      device.vm.network "private_network",
            :mac => "44383900002c",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9022',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8022',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> leaf-4:swp2
      device.vm.network "private_network",
            :mac => "443839000004",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9002',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8002',
            :libvirt__iface_name => 'swp4',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1e swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:26 swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2c swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:04 swp4"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for spine-1 #####
  config.vm.define "spine-1" do |device|
    device.vm.hostname = "spine-1"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> leaf-1:swp1
      device.vm.network "private_network",
            :mac => "44383900002a",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9021',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8021',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> leaf-2:swp1
      device.vm.network "private_network",
            :mac => "443839000012",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9009',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8009',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> leaf-3:swp1
      device.vm.network "private_network",
            :mac => "443839000008",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9004',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8004',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> leaf-4:swp1
      device.vm.network "private_network",
            :mac => "443839000016",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9011',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8011',
            :libvirt__iface_name => 'swp4',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2a swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:12 swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:08 swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:16 swp4"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for leaf-1 #####
  config.vm.define "leaf-1" do |device|
    device.vm.hostname = "leaf-1"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> spine-1:swp1
      device.vm.network "private_network",
            :mac => "443839000029",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8021',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9021',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> spine-2:swp1
      device.vm.network "private_network",
            :mac => "44383900001d",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8015',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9015',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> host-11:eth1
      device.vm.network "private_network",
            :mac => "443839000019",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8013',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9013',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> host-12:eth1
      device.vm.network "private_network",
            :mac => "44383900000f",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8008',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9008',
            :libvirt__iface_name => 'swp4',
            auto_config: false
      # link for swp5 --> host-21:eth1
      device.vm.network "private_network",
            :mac => "443839000013",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8010',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9010',
            :libvirt__iface_name => 'swp5',
            auto_config: false
      # link for swp6 --> host-22:eth1
      device.vm.network "private_network",
            :mac => "44383900001b",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8014',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9014',
            :libvirt__iface_name => 'swp6',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:29 swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1d swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:19 swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0f swp4"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:13 swp5"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1b swp6"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for leaf-3 #####
  config.vm.define "leaf-3" do |device|
    device.vm.hostname = "leaf-3"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> spine-1:swp3
      device.vm.network "private_network",
            :mac => "443839000007",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8004',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9004',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> spine-2:swp3
      device.vm.network "private_network",
            :mac => "44383900002b",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8022',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9022',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> host-31:eth1
      device.vm.network "private_network",
            :mac => "443839000017",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8012',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9012',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> host-32:eth1
      device.vm.network "private_network",
            :mac => "44383900002f",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8024',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9024',
            :libvirt__iface_name => 'swp4',
            auto_config: false
      # link for swp5 --> host-41:eth1
      device.vm.network "private_network",
            :mac => "443839000009",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8005',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9005',
            :libvirt__iface_name => 'swp5',
            auto_config: false
      # link for swp6 --> host-42:eth1
      device.vm.network "private_network",
            :mac => "44383900002d",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8023',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9023',
            :libvirt__iface_name => 'swp6',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:07 swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2b swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:17 swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2f swp4"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:09 swp5"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2d swp6"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for leaf-2 #####
  config.vm.define "leaf-2" do |device|
    device.vm.hostname = "leaf-2"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> spine-1:swp2
      device.vm.network "private_network",
            :mac => "443839000011",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8009',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9009',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> spine-2:swp2
      device.vm.network "private_network",
            :mac => "443839000025",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8019',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9019',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> host-11:eth2
      device.vm.network "private_network",
            :mac => "443839000005",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8003',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9003',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> host-12:eth2
      device.vm.network "private_network",
            :mac => "44383900000b",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8006',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9006',
            :libvirt__iface_name => 'swp4',
            auto_config: false
      # link for swp5 --> host-21:eth2
      device.vm.network "private_network",
            :mac => "443839000027",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8020',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9020',
            :libvirt__iface_name => 'swp5',
            auto_config: false
      # link for swp6 --> host-22:eth2
      device.vm.network "private_network",
            :mac => "44383900000d",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8007',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9007',
            :libvirt__iface_name => 'swp6',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:11 swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:25 swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:05 swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0b swp4"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:27 swp5"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0d swp6"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for leaf-4 #####
  config.vm.define "leaf-4" do |device|
    device.vm.hostname = "leaf-4"
    device.vm.box = "CumulusCommunity/cumulus-vx"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for swp1 --> spine-1:swp4
      device.vm.network "private_network",
            :mac => "443839000015",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8011',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9011',
            :libvirt__iface_name => 'swp1',
            auto_config: false
      # link for swp2 --> spine-2:swp4
      device.vm.network "private_network",
            :mac => "443839000003",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8002',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9002',
            :libvirt__iface_name => 'swp2',
            auto_config: false
      # link for swp3 --> host-31:eth2
      device.vm.network "private_network",
            :mac => "44383900001f",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8016',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9016',
            :libvirt__iface_name => 'swp3',
            auto_config: false
      # link for swp4 --> host-32:eth2
      device.vm.network "private_network",
            :mac => "443839000001",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8001',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9001',
            :libvirt__iface_name => 'swp4',
            auto_config: false
      # link for swp5 --> host-41:eth2
      device.vm.network "private_network",
            :mac => "443839000023",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8018',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9018',
            :libvirt__iface_name => 'swp5',
            auto_config: false
      # link for swp6 --> host-42:eth2
      device.vm.network "private_network",
            :mac => "443839000021",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '8017',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '9017',
            :libvirt__iface_name => 'swp6',
            auto_config: false


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:15 swp1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:03 swp2"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1f swp3"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:01 swp4"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:23 swp5"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:21 swp6"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_switch.sh"
  end

  ##### DEFINE VM for host-12 #####
  config.vm.define "host-12" do |device|
    device.vm.hostname = "host-12"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-1:swp4
      device.vm.network "private_network",
            :mac => "443839000010",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9008',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8008',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-2:swp4
      device.vm.network "private_network",
            :mac => "44383900000c",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9006',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8006',
            :libvirt__iface_name => 'eth2',
            auto_config: false



    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"


    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:10 eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0c eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-11 #####
  config.vm.define "host-11" do |device|
    device.vm.hostname = "host-11"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-1:swp3
      device.vm.network "private_network",
            :mac => "44383900001a",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9013',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8013',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-2:swp3
      device.vm.network "private_network",
            :mac => "443839000006",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9003',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8003',
            :libvirt__iface_name => 'eth2',
            auto_config: false

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1a eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:06 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

      device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-22 #####
  config.vm.define "host-22" do |device|
    device.vm.hostname = "host-22"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-1:swp6
      device.vm.network "private_network",
            :mac => "44383900001c",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9014',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8014',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-2:swp6
      device.vm.network "private_network",
            :mac => "44383900000e",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9007',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8007',
            :libvirt__iface_name => 'eth2',
            auto_config: false


    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:1c eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0e eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"

    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-21 #####
  config.vm.define "host-21" do |device|
    device.vm.hostname = "host-21"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-1:swp5
      device.vm.network "private_network",
            :mac => "443839000014",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9010',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8010',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-2:swp5
      device.vm.network "private_network",
            :mac => "443839000028",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9020',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8020',
            :libvirt__iface_name => 'eth2',
            auto_config: false


    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:14 eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:28 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-21 #####
  config.vm.define "host-21" do |device|
    device.vm.hostname = "host-21"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-1:swp5
      device.vm.network "private_network",
            :mac => "443839000014",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9010',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8010',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-2:swp5
      device.vm.network "private_network",
            :mac => "443839000028",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9020',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8020',
            :libvirt__iface_name => 'eth2',
            auto_config: false


    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:14 eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:28 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-31 #####
  config.vm.define "host-31" do |device|
    device.vm.hostname = "host-31"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-3:swp3
      device.vm.network "private_network",
            :mac => "443839000018",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9012',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8012',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-4:swp3
      device.vm.network "private_network",
            :mac => "443839000020",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9016',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8016',
            :libvirt__iface_name => 'eth2',
            auto_config: false

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:18 eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:20 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-32 #####
  config.vm.define "host-32" do |device|
    device.vm.hostname = "host-32"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-3:swp4
      device.vm.network "private_network",
            :mac => "443839000030",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9024',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8024',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-4:swp4
      device.vm.network "private_network",
            :mac => "443839000002",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9001',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8001',
            :libvirt__iface_name => 'eth2',
            auto_config: false

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:30 eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:02 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-41 #####
  config.vm.define "host-41" do |device|
    device.vm.hostname = "host-41"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-3:swp5
      device.vm.network "private_network",
            :mac => "44383900000a",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9005',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8005',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-4:swp5
      device.vm.network "private_network",
            :mac => "443839000024",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9018',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8018',
            :libvirt__iface_name => 'eth2',
            auto_config: false

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:0a eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:24 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end

  ##### DEFINE VM for host-42 #####
  config.vm.define "host-42" do |device|
    device.vm.hostname = "host-42"
    device.vm.box = "yk0/ubuntu-xenial"
    
    # disabling sync folder support on all VMs
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder '.', '/vagrant', disabled: true
    device.vm.provider :libvirt do |v|
      v.memory = 1024
    end

    # NETWORK INTERFACES
      # link for eth1 --> leaf-3:swp6
      device.vm.network "private_network",
            :mac => "44383900002e",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9023',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8023',
            :libvirt__iface_name => 'eth1',
            auto_config: false
      # link for eth2 --> leaf-4:swp6
      device.vm.network "private_network",
            :mac => "443839000022",
            :libvirt__tunnel_type => 'udp',
            :libvirt__tunnel_local_ip => '127.0.0.1',
            :libvirt__tunnel_local_port => '9017',
            :libvirt__tunnel_ip => '127.0.0.1',
            :libvirt__tunnel_port => '8017',
            :libvirt__iface_name => 'eth2',
            auto_config: false

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(grep -q 'mesg n' /root/.profile && sed -i '/mesg n/d' /root/.profile && echo 'Ignore the previous error, fixing this now...') || exit 0;"

    # Install Rules for the interface re-map
      device.vm.provision "file", source: "./helper_scripts/apply_udev.py", destination: "/home/vagrant/apply_udev.py"
      device.vm.provision :shell , inline: "chmod 755 /home/vagrant/apply_udev.py"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:2e eth1"
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -a 44:38:39:00:00:22 eth2"

      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -vm "
      device.vm.provision :shell , inline: "/home/vagrant/apply_udev.py -s"
 
    device.vm.provision :shell , path: "./helper_scripts/config_server.sh"
  end
end
