#!/bin/bash

SSH_CREDENTIALS="/Users/eroman/.ssh/silvercity.pem"

DB_SERVER="10.0.1.173"
APP_SERVER="10.0.1.94"
BRIDGE_SERVER="ciq.pacific-dev.com"

# Set-up the tunnel to the MySQL DB.
ssh -i ${SSH_CREDENTIALS} -f -v -L 3306:${DB_SERVER}:3306 -N ec2-user@${BRIDGE_SERVER}

# Set-up the tunnel to Cassandra.
ssh -i ${SSH_CREDENTIALS} -f -v -L 9160:${DB_SERVER}:9160 -N ec2-user@${BRIDGE_SERVER}

# Set-up the tunnel to GreenDB
ssh -i ${SSH_CREDENTIALS} -f -v -L 10000:${APP_SERVER}:10000 -N ec2-user@${BRIDGE_SERVER}

# Set-up the tunnel to RabbitMQ (AMQP).
ssh -i ${SSH_CREDENTIALS} -f -v -L 5672:${APP_SERVER}:5672 -N ec2-user@${BRIDGE_SERVER}

# Set-up the tunnel to memcached.
ssh -i ${SSH_CREDENTIALS} -f -v -L 11211:${APP_SERVER}:11211 -N ec2-user@${BRIDGE_SERVER} 