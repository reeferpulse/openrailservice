#!/bin/bash
set -e

[[ -z ${STAGE}  ]]  && read -p 'Select environment: ' stage && export STAGE=${stage} 

app_name=$(cat package.json | jq -r .name)

[[ "$STAGE" == "dev" ]]   && export AWS_ACCOUNT_ID=145116315369
[[ "$STAGE" == "prod" ]] && export AWS_ACCOUNT_ID=019031175166

export app_name=${app_name} 
export TF_WORKSPACE=${STAGE}
export TF_VAR_stage=${STAGE} 
export AWS_REGION="eu-west-3"
export lambda_image_name=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${STAGE}-${app_name}:docker_image
