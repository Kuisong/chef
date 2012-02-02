#!/bin/bash -ex
CHEF_SERVER_URL=https://api.opscode.com/organizations/polyforms
CHEF_RUN_LIST="role[jenkins]"

wget -q -O - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
sudo aptitude update
sudo aptitude upgrade -y
echo "chef chef/chef_server_url string $CHEF_SERVER_URL" | sudo debconf-set-selections && sudo apt-get install chef -y

sudo wget -O /etc/chef/validation.pem https://raw.github.com/Kuisong/chef/master/certificates/polyforms-validator.pem
sudo sh -c 'echo validation_client_name \"polyforms-validator\" >> /etc/chef/client.rb'

echo "{\"run_list\": [ \"$CHEF_RUN_LIST\" ]}" | sudo tee /etc/chef/run_list.json
sudo sh -c 'echo json_attribs \"/etc/chef/run_list.json\" >> /etc/chef/client.rb'

sudo service chef-client restart
