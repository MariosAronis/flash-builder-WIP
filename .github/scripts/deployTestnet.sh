#!/bin/bash

set -eux

BRANCH=$1
USERNAME=$2
VALUE=${USERNAME}-${BRANCH}

echo $VALUE

UserInstance=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$VALUE" --output json --query 'Reservations[*].Instances[*].{InstanceId:InstanceId,Tags:Tags}' | jq '.[]'`
Length=`echo $UserInstance | jq '. | length'`
echo $UserInstance
echo $Length

if (( $Length == 1 )) ; then
    echo "Uodating node"
elif (( $Length > 1 )) ; then
    echo "Multiple nodes, must kill all and restart"
else
    echo "Deploying new node for user"
fi