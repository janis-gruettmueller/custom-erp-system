##########################################################
# File: build.sh                                         #
# Version: 1.0                                           #
# Author: Janis Grüttmüller on 19.02.2025                #
# Description: script to deploy the erp-system on a AWS  #
# EC2 Instance                                           #
#                                                        #
# change history:                                        #
# 19.02.2025 - initial version                           #
##########################################################

#!/bin/bash
set -e  # Exit if any command fails

# Configuration Variables
EC2_USER="ubuntu"
EC2_HOST="ec2-51-20-69-219.eu-north-1.compute.amazonaws.com"  # EC2 public IPv4 DNS
SSH_KEY="aws-ec2-connection-key-temp.pem"  # Temporary SSH key file
AWS_EC2_ACCESS_KEY="/Users/janisgruettmueller/java-workspace/erp-system-root/secrets/aws-ec2-connection-key.pem"
DOCKER_COMPOSE_FILE="docker-compose.yml"  # Docker Compose file name
INIT_SQL_FILE="/Users/janisgruettmueller/java-workspace/erp-system-root/database/init.sql"
ENV_FILE="/Users/janisgruettmueller/java-workspace/erp-system-root/.env"

# Step 1: Save GitHub Secret (SSH Key) to a File & Set Permissions
#echo $AWS_EC2_ACCESS_KEY > $SSH_KEY
cat "$AWS_EC2_ACCESS_KEY" > $SSH_KEY
chmod 600 $SSH_KEY  # Secure the key file

# Step 2: Copy docker-compose.yml to EC2 instance
echo "Copying docker-compose.yml to EC2 instance..."
scp -i $SSH_KEY -o StrictHostKeyChecking=no $DOCKER_COMPOSE_FILE $EC2_USER@$EC2_HOST:/home/ubuntu/
scp -i $SSH_KEY -o StrictHostKeyChecking=no $INIT_SQL_FILE $EC2_USER@$EC2_HOST:/home/ubuntu/
scp -i $SSH_KEY -o StrictHostKeyChecking=no $ENV_FILE $EC2_USER@$EC2_HOST:/home/ubuntu/

# Step 3: SSH into EC2 and deploy with docker-compose
echo "Connecting to EC2 instance and deploying with docker-compose..."
ssh -i $SSH_KEY -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST << EOF
  cd /home/ubuntu
  
  echo "Pulling latest Docker images..."
  docker-compose pull

  echo "Stopping old containers..."
  docker-compose down --remove-orphans  # Keeps named volumes intact

  echo "Starting new containers..."
  docker-compose up -d

  echo "Deployment completed!"
EOF

# Step 4: Cleanup SSH Key
rm -f $SSH_KEY

echo "Successfully Deployed!"