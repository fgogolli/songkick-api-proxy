# -*- mode: ruby -*-
# vi: set ft=ruby :

$provision = <<EOS

echo "Installing puppet..."
apt-get install -y puppet >/dev/null 2>&1

echo "Installing 'puppet/nginx' puppet module..."
puppet module install puppet-nginx >/dev/null 2>&1

echo "Installing 'fgogolli/songkick-api-proxy' puppet module..."
cp -R /tmp/songkick-api-proxy /etc/puppet/modules/ >/dev/null 2>&1

echo "Deploying the songkick-api-proxy..."
puppet apply /etc/puppet/modules/songkick-api-proxy/tests/init.pp >/dev/null 2>&1

# Because of a dependency issue within the upstream nginx module, two puppetruns are required.
puppet apply /etc/puppet/modules/songkick-api-proxy/tests/init.pp >/dev/null 2>&1

echo "The songkick-api-proxy has been deployed. Try connecting via:"
echo "http://songkick-api-proxy:8080/api/3.0/artists/{artist_id}/calendar.json?apikey={your_api_key}"
echo "http://songkick-api-proxy:8080/api/3.0/venues/{venue_id}/calendar.json?apikey={your_api_key}"

EOS

Vagrant.configure("2") do |config|
  config.vm.define "songkick-api-proxy" do |config|

    config.vm.box = "debian/jessie64"
    config.vm.hostname = "songkick-api-proxy"
    config.vm.network "private_network", ip: "192.168.1.5"
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.provision "copy-module", type: "file", source: "songkick-api-proxy", destination: "/tmp/"
    config.vm.provision "deploy-proxy", type: "shell", inline: $provision

  end
end
