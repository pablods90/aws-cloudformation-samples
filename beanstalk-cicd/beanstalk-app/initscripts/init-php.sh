#!/bin/sh
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
echo $instance_id > ~/instance.txt

##
## Initialization finished! This line will pass
## control to the command specified in 'CMD'.
##
exec "$@"
