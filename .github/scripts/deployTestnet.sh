#!/bin/bash

set -ex

BRANCH=$1
USERNAME=$2

AMI="ami-0a588942e90cfecc9"
SG="sg-06d9f0fd0b749c6ee"
SUBNET=subnet-0160d2ef49ea42ecc
VPC="vpc-09831d1e37a601415"
VALUE="Flashnode-Testnet-${USERNAME}-${BRANCH}"

get_instance_id () {
InstanceID=`aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$VALUE" \
            "Name=instance-state-name,Values=running" \
  --output json --query 'Reservations[*].Instances[*].{InstanceId:InstanceId}' | jq -r '.[] | .[] | ."InstanceId"'`   
echo $InstanceID 
}

get_instance_az () {
AZ=`aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$VALUE" \
            "Name=instance-state-name,Values=running" \
  --output json \
  --query 'Reservations[*].Instances[*].Placement[].AvailabilityZone' | jq -r '.[]'`
echo $AZ
}

create_ebs_volume () {
aws ec2 create-volume \
  --availability-zone $AZ \
  --size 500 \
  --volume-type "gp2" \
  --tag-specification "ResourceType=volume,Tags=[{Key=Name,Value="$VALUE"}]" 
}

get_volume_id () {
VOLUMEID=`aws ec2 describe-volumes \
  --filters "Name=tag:Name,Values=$VALUE" \
  --output json --query 'Volumes[*].VolumeId[]' | jq -r .[]`

echo $VOLUMEID
}

attach_ebs_volume () {
aws ec2 attach-volume \
  --device "/dev/sdf" \
  --instance-id $InstanceID \
  --volume-id $VolumeID
}

create_instance () {
aws ec2 run-instances \
  --user-data "file://.github/scripts/cloud-init.sh" \
  --image-id $AMI \
  --count 1 \
  --instance-type t3.2xlarge \
  --key-name mariosee \
  --security-group-ids $SG \
  --subnet-id $SUBNET \
  --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":20,\"DeleteOnTermination\":true}}]" \
  --instance-initiated-shutdown-behavior terminate \
  --tag-specification "ResourceType=instance,Tags=[{Key=Name,Value="$VALUE"},{Key=Branch,Value="$BRANCH"}]" \
  --metadata-options "InstanceMetadataTags=enabled"   
}

delete_instance () {
pass
}

UserInstance=`aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$VALUE" \
              "Name=instance-state-name,Values=running" \
    --output json \
    --query 'Reservations[*].Instances[*].{InstanceId:InstanceId}' \
    | jq '.[]'`

Length=`echo $UserInstance | jq '. | length'`

if [[ $Length -eq 1 ]] ; then
    InstaceId=`echo $UserInstance | jq -r '.[] | ."InstanceId"'`
    echo $InstanceId
    echo "Updating node"
elif [[ $Length -gt 1 ]] ; then
    ##TO DO
    echo "Multiple nodes, must kill all and deploy a fresh one...proceeding!"
else
    echo "Deploying new node for user"
    create_instance
    sleep 20
    AZ=`get_instance_az`
    
    create_ebs_volume
    InstanceID=`get_instance_id`
    VolumeID=`get_volume_id`
    attach_ebs_volume
fi