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
su -P ubuntu -c "git clone https://github.com/MariosAronis/FlashNodes-WIP.git /home/ubuntu/Flashnodes"
su -p ubuntu -c "ansible-galaxy role install --roles-path=/home/ubuntu/Flashnodes/ansible gantsign.golang"
su -p ubuntu -c "ansible-playbook /home/ubuntu/Flashnodes/ansible/provision-flashnode.yml --skip-tags remote"