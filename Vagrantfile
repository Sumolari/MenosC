# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #config.vm.box = "parallels/ubuntu-13.10"
  config.vm.box = "parallels/ubuntu-14.04"
  #config.vm.box = "parallels/centos-6.5"

  config.vm.synced_folder "./LAB", "/LAB"

  config.vm.provider "parallels" do |vb|
    vb.memory = 512
    vb.cpus = 1
    vb.update_guest_tools = true
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end

  config.vm.provision "shell",
    inline: "sudo apt-get update && sudo apt-get -q -y install flex bison lib32z1"

  #config.vm.provision "shell",
  #  inline: "yum -y update && yum -y install flex bison lib32z1"

end
