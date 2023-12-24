#!/bin/bash

## Installing dependecies   
yum install -y zip unzip wget curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
echo "export PATH=$PATH:/usr/local/bin/" >> /root/.bashrc

# Adding cluster name in ecs config
echo ECS_CLUSTER=${project_name}-${environment}-ecs >> /etc/ecs/ecs.config