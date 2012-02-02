#!/bin/bash -ex
wget -q -O - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
sudo aptitude update
sudo aptitude upgrade -y
echo "chef chef/chef_server_url string https://api.opscode.com/organizations/polyforms" | sudo debconf-set-selections && sudo apt-get install chef -y

sudo wget -O /etc/chef/validation.pem https://raw.github.com/Kuisong/chef/master/certificates/polyforms-validator.pem
sudo sh -c 'echo validation_client_name \"polyforms-validator\" >> /etc/chef/client.rb'

echo "{\"run_list\": [ \"role[jenkins]\" ]}" | sudo tee /etc/chef/run_list.json
sudo sh -c 'echo json_attribs \"/etc/chef/run_list.json\" >> /etc/chef/client.rb'

sudo service chef-client restart