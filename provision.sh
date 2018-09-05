SSH_ARGS="-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s"
INVENTORY="./.vagrant/provisioners/ansible/inventory"
PLAYBOOKS="./provision/prepare-guests.yml"

if [[ "x$1" == "x-h" || "x$1" == "x--help" ]]; then
    echo "provision.sh [DIST LIMIT SKIP_PACKAGES PLAYBOOKS DIST]"
    echo "  DIST: [fedora|suse] ... Define what distribution will be used for the client"
    echo "  LIMIT: [all|list of host] ... limit which hosts should be provisioned"
    echo "  SKIP_PACKAGES: [true|false] ... skip package installation"
    echo "  PLAYBOOKS: [playbook paths] ... playbooks to run"
    echo ""
    exit 0
fi
DIST=${1-"fedora"}
LIMIT=${2-all}
SKIP_PACKAGES=${3-true}
PLAYBOOKS=${4-$PLAYBOOKS}

echo "Linux distro used for the client: $DIST"

run-playbook() {
    local PLAYBOOK=$1
    
    echo "Executing playbook $PLAYBOOK"

    ANSIBLE_HOST_KEY_CHECKING="false" ANSIBLE_SSH_ARGS="$SSH_ARGS" \
    ansible-playbook -v                                               \
      --limit "$LIMIT"                                             \
      --extra-vars="skip_packages=$SKIP_PACKAGES dist=$DIST"                  \
      --inventory-file="$INVENTORY"                                \
      $PLAYBOOK
}

for PLAYBOOK in $PLAYBOOKS
do
    run-playbook $PLAYBOOK
    
    if [ $? -ne 0 ]; then
        echo "Unable to provision guests!"
        exit 1
    fi
done

exit 0
