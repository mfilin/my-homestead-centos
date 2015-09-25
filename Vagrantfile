Vagrant.configure(2) do |config|
    config.vm.box = "centos/7"
    config.vm.provision "file", source:"provision/templates/", destination: "/home/vagrant/provision/templates/"
    config.vm.provision "shell", path: "provision/provision.sh"
    config.vm.provision "shell", path: "provision/nodejs.sh", privileged: false
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vb.memory = "2048"
        vb.cpus = 2
    end
    config.vm.network :forwarded_port, guest: 80, host: 3000
    config.vm.network :private_network, ip: "192.168.33.77"
    config.vm.hostname = "www.example.local"
    config.hostsupdater.aliases = ["example.local"]
    config.vm.synced_folder "./code", "/home/vagrant/example", type: "nfs"
end
