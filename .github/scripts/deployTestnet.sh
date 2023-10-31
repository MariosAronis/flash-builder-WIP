#!/bin/bash

set -e

BRANCH=$1
USERNAME=$2
VALUE=${USERNAME}-${BRANCH}

UserInstance=`aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$VALUE" --output json \
    --query 'Reservations[*].Instances[*].{InstanceId:InstanceId}' \
    | jq '.[]'`

Length=`echo $UserInstance | jq '. | length'`

if [[ $Length -eq 1 ]] ; then
    InstaceId=`echo $UserInstance | jq -r '.[] | ."InstanceId"'`
    echo $InstanceId
    echo "Updating node"
elif [[ $Length -gt 1 ]] ; then
    ##TO DO
    echo "Multiple nodes, must kill all and restart"
else
    echo "Deploying new node for user"
fi