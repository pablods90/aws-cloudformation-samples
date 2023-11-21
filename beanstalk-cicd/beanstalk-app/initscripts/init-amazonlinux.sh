#!/bin/env bash
##
## Startup and initialization script. This script
## will run before calling the command specified
## in 'CMD'.
##
set -e

##
## Perform any required initialization (create
## directories, export variables, etc)
##

###
# Get instnace ID
###
export instance_id=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)

# Verification
echo $instance_id >> ~/instance.txt

# Install AWS CLI
yum update -y && yum install -y awscli

####
# Retrieve secrets
####
# - Just set the names of the secrets that need to be retrieved (using the names you configured in SSM)
# - If not used... leave the variable undeclared
#declare -a secrets=("SSM_PARAMETER_NAME_1"
#                    "SSM_PARAMETER_NAME_2"
#)
if [ -z ${secrets+x} ]; then

  echo "secrets is unset! Not retrieving secrets ..."

else

  echo "secrets is set!"

  # Get the current region
  the_region=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

  # Get the keys and export them as variables
  for param in "${secrets[@]}"; do

      p=$(aws --region=$the_region secretsmanager get-secret-value --secret-id $param --query "SecretString" --output text)

      export $param="$p"

  done

fi

# Verification
env >> ~/env.txt

##
## Initialization finished! This line will pass
## control to the command specified in 'CMD'.
##
exec "$@"
