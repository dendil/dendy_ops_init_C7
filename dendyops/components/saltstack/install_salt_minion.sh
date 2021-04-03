#!/usr/bin/env bash

set -e

# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi






curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P -x python3
#../utils/start_service.sh salt-master
