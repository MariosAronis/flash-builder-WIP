#!/bin/bash

set -ex

HOSTNAME="__HOSTNAME__"

# Install pkgs
apt-get update
apt-get install -y net-tools git
apt-get install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y
hostnamectl set-hostname $HOSTNAME
git clone https://github.com/MariosAronis/FlashNodes-WIP.git ~/Flashnodes

ansible-galaxy role install --roles-path=/home/ubuntu/Flashnodes/ansible gantsign.golang

ansible-playbook  /home/ubuntu/Flashnodes/ansible/provision-flashnode.yml --skip-tags remote