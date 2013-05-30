#!/bin/bash

# setup_passwordless_ssh.sh
#
# Script creates user buildmeister and then
# dumps buildmeister@pep public key for both 'buildmeister' and 'ciq'.

BUILDMEISTER_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqVtjrIarqj3bnoNpYAT5ynm3FaFrpSCMl2YJracuzuIGt3schEgW7lKKxK3ht2cKMXlxFUn6YukLtrKhru12f2ba7YjslnOe3r30LGM1F/MHVJp0E/gauTRDzXLNY1mP8oCIHzDcrzDSQZjcRHDTeeL5Uktcrb9c+/oi6r0cAkrc4er9+4JRyIMal95c4nF35d7JrpYDUK/RUK1JAS7Tu4cWcbKaoGcYZueK2iJl2ZNjjbabzYY2CBcs8AzQK9po5zqNYGXhO8MqAse+bkNM9iBVeg+A6xksSYtM2LrpeGsGqf47Q8HlISBnEzxY3uyw334eHM6B1opUNGF9IXkCEQ== buildmeister@pep"

# Check to see if script is running as root
if [ $UID -ne 0 ]; then
    echo "$0 must be run as root WITH root environment variable. Please 'sudo -i' first!"
    exit 1
fi

echo "*** Configuring for Hudson access..."

# 0 if user doesn't exist, 1 otherwise
buildmeister_name="buildmeister"
buildmeister_group="buildmeister"
NAME_EXIST=$(grep -c $buildmeister_name /etc/passwd)
if [ $NAME_EXIST -eq 0 ]; then
	echo "*** Creating the group $buildmeister_group"
	/usr/sbin/groupadd $buildmeister_group

	echo "*** Adding user $buildmeister_name to $buildmeister_group..."
	/usr/sbin/useradd -g $buildmeister_group $buildmeister_name
fi

# Create .ssh and authorized keys for user 'buildmeister'
echo "*** Adding buildmeister@pep key for user buildmeister..."
BUILDMEISTER_SSH_DIR=/home/buildmeister/.ssh
BUILDMEISTER_AUTH_KEYS=$BUILDMEISTER_SSH_DIR/authorized_keys
mkdir -p $BUILDMEISTER_SSH_DIR
chmod 0700 $BUILDMEISTER_SSH_DIR
# Dump the key into authorized_keys if it isn't there already.
KEY_EXIST=$(grep -c "buildmeister@pep" $BUILDMEISTER_AUTH_KEYS)
if [ $KEY_EXIST -eq 0 ]; then
	echo "$BUILDMEISTER_PUBLIC_KEY" >> $BUILDMEISTER_AUTH_KEYS
fi
chmod 0600 $BUILDMEISTER_AUTH_KEYS

# Now make the whole .ssh directory owned by buildmeister
chown -R $buildmeister_name:$buildmeister_group $BUILDMEISTER_SSH_DIR

# Create .ssh and authorized keys for user 'ciq'
echo "*** Adding buildmeister@pep key for user ciq..."
CIQ_SSH_DIR=/home/ciq/.ssh
CIQ_AUTH_KEYS=$CIQ_SSH_DIR/authorized_keys
mkdir -p $CIQ_SSH_DIR
chmod 0700 $CIQ_SSH_DIR
# Dump the key into authorized_keys if it isn't there already.
KEY_EXIST=$(grep -c "buildmeister@pep" $CIQ_AUTH_KEYS)
if [ $KEY_EXIST -eq 0 ]; then
	echo "$BUILDMEISTER_PUBLIC_KEY" >> $CIQ_AUTH_KEYS
fi
chmod 0600 $CIQ_AUTH_KEYS

# Now make the whole .ssh directory owned by buildmeister
chown -R ciq:ciq $CIQ_SSH_DIR

echo "*** Done."