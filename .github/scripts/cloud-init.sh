#!/bin/bash

set -ex

HOSTNAME="__HOSTNAME__"

# Install pkgs
apt-get update
apt-get install -y net-tools git
apt-get install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y
# ansible-galaxy role install gantsign.golang

# Set Hostname to Flashnode-Testnet-$GHUSERNAME-BRANCHNAME
hostnamectl set-hostname $HOSTNAME

# Clone the Flashnodes repo
su -P ubuntu -c "git clone https://github.com/MariosAronis/FlashNodes-WIP.git /home/ubuntu/Flashnodes"
#Install gantsign.golang role
su -p ubuntu -c "ansible-galaxy role install --roles-path=/home/ubuntu/Flashnodes/ansible gantsign.golang"
# su -p ubuntu -c "ansible-galaxy role install gantsign.golang"
# su -p ubuntu -c "
ansible-playbook /home/ubuntu/Flashnodes/ansible/provision-flashnode.yml --skip-tags remote