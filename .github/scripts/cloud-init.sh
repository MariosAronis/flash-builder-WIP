#!/bin/bash

set -ex

# Install pkgs
apt-get update
apt-get install -y net-tools git
apt-get install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y

ansible-galaxy role install gantsign.golang