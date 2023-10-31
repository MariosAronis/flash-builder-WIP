#!/bin/bash

set -eux

BRANCH=$1
USERNAME=$2
VALUE=${USERNAME}-${BRANCH}

echo $VALUE
# VALUE=openvpn
UserInstance=`aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$VALUE" --output text \
    --query 'Reservations[*].Instances[*].{InstanceId:InstanceId}'
    # | jq '.[]'`
Length=`echo $UserInstance | grep -c '^[^#]'`

echo $UserInstance
echo $Length

if [[ $Length -eq 1 ]] ; then
    echo "Updating node"
elif [[ $Length -gt 1 ]] ; then
    echo "Multiple nodes, must kill all and restart"
else
    echo "Deploying new node for user"
fi