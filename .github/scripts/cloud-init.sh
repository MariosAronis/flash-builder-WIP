#!/bin/bash

set -ex

HOSTNAME="__HOSTNAME__"

# Install pkgs
apt-get update
apt-get install -y net-tools git
apt-get install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y

# Set Hostname to Flashnode-Testnet-$GHUSERNAME-BRANCHNAME
hostnamectl set-hostname $HOSTNAME

# Clone the Infra repo and execute ansible on localhost
su -P ubuntu "git clone https://github.com/MariosAronis/FlashNodes-WIP.git $HOME/Flashnodes"
su -p ubuntu "ansible-galaxy role install --roles-path=$HOME/Flashnodes/ansible gantsign.golang"
su -p ubuntu "ansible-playbook $HOME/Flashnodes/ansible/provision-flashnode.yml --skip-tags remote"