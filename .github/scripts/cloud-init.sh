#!/bin/bash

set -ex

# Install pkgs
sudo apt-get update
sudo apt get install -y net-tools git
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

ansible-galaxy role install gantsign.golang