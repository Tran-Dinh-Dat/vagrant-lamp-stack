# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/ubuntu-22.04"

  # Create a private network, which allows host-only access to the machine using a specific IP.\
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "172.20.20.20"

  # Provider settings
  config.vm.provider "virtualbox" do |vb|
    vb.gui=true
    vb.memory="2048"
  end

  # Share an additional folder to the guest VM. The first argument is the path on the host to the actual folder.
  # The second argument is the path on the guest to mount the folder.
  config.vm.synced_folder "./", "/var/www/html", :mount_options => ["dmode=777", "fmode=666"]

  # Define the bootstrap file: A (shell) script that runs after first setup of your box (= provisioning)
  config.vm.provision :shell, path: "bootstrap.sh", privileged: false

end
