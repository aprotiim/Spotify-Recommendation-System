#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 613539139859.dkr.ecr.us-east-2.amazonaws.com

echo "Pulling Docker image..."
docker pull 613539139859.dkr.ecr.us-east-2.amazonaws.com/spotify-hybrid-recsys:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=hybrid-recsys)" ]; then
    echo "Stopping existing container..."
    docker stop hybrid-recsys
fi

if [ "$(docker ps -aq -f name=hybrid-recsys)" ]; then
    echo "Removing existing container..."
    docker rm hybrid-recsys
fi

echo "Starting new container..."
docker run -d -p 80:8000 --name hybrid-recsys 613539139859.dkr.ecr.us-east-2.amazonaws.com/spotify-hybrid-recsys:latest

echo "Container started successfully."