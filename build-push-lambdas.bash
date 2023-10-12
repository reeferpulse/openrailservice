#!/bin/bash
set -e
. ./set_env.sh
aws --region ${AWS_REGION} ecr get-login-password | docker login --password-stdin --username AWS ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker build -f "Dockerfile" -t ${lambda_image_name} .
docker push "${lambda_image_name}"
