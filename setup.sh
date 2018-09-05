#!/bin/bash

if [[ "x$1" == "x-h" || "x$1" == "x--help" ]]; then
    echo "setup.sh [DIST HOST_EXEC]"
    echo "  DIST: [fedora|suse] ... Define what distribution will be used for the client"
    echo "  HOST_PREP: [true|false] ... Define if the playbook to prepare the host will run or not"
    echo ""
    exit 0
fi


DIST=${1-"fedora"}
HOST_PREP=${2-"true"}

if [ "$HOST_PREP" == "true" ]; then
    echo "1. Preparing host..."
    ansible-playbook -i "localhost," -c local "./provision/prepare-host.yml"

    if [ $? -ne 0 ]; then
        echo "Unable to provision host machine!"
        exit 1
    fi
else
    echo "1. Skipping host preparation..."
fi

echo "2. Bringing up guests..."
# Windows machines sometimes timeout when starting up in parallel
# so we start them first in sequence.

DIST="$DIST" vagrant up ad

if [ $? -ne 0 ]; then
    echo "Unable to bring ad up!"
    exit 1
fi

DIST="$DIST" vagrant up ad-child

if [ $? -ne 0 ]; then
    echo "Unable to bring ad-child up!"
    exit 1
fi

DIST="$DIST" vagrant up

if [ $? -ne 0 ]; then
    echo "Unable to bring guests up!"
    exit 1
fi

echo "3. Provisioning guests..."
./provision.sh "$DIST"

if [ $? -ne 0 ]; then
    echo "Unable to provision guests!"
    exit 1
fi

echo "Guest machines are ready."
echo "Use 'vagrant ssh client' to ssh into client machine."

exit 0