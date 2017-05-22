# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  # You can re-run this on an already provisioned machine with "vagrant reload --provision". This will shutdown your machine!!!
  # this is not recommended, since you have to be sure that every action in the script is idempotent
  config.vm.provision "shell" do |s|
    s.path = 'provision.sh'
    s.args = [
      "#{ENV['git_name']}",
      "#{ENV['git_email']}",
      "#{ENV['proxy_ip']}",
      "#{ENV['proxy_port']}",
      "#{ENV['ssh_config']}",
    ]
  end

  config.vm.box = "bento/centos-7.2"
  config.vm.hostname = "bogdan-test"

  ###################
  # Pord forwarding #
  ###################
  # "vagrant reload" to update the port forwards
  # WARNING!!! it will shutdown your machine
  # example port forward:
  #config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

  # In case you want to use virtualbox shared folders
config.vm.synced_folder "C:/KERMIT/bogdan-test", "/home/bogdan-test",
owner: "root", group: "root", mount_options: ["dmode=775,fmode=664"], create: true, type: "virtualbox"

end
