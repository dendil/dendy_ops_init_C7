#!/usr/bin/env bash

set -e

# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi


# Download and install
MAJOR_VERSION="$1"
if [ ! -n "${VERSION}" ]; then
    MAJOR_VERSION="1.8"
fi

MINOR_VERSION="$2"
if [ ! -n "${MINOR_VERSION}" ]; then
    MINOR_VERSION="0"
fi

HTTP_PORT="$3"
if [ ! -n "${HTTP_PORT}" ]; then
    HTTP_PORT="80"
fi
HOST_NAME="$4"
if [ ! -n "${HOST_NAME}" ]; then
    HOST_NAME="harbor.od.com"
fi
HARBOR_PASS="$5"
if [ ! -n "${HARBOR_PASS}" ]; then
    HARBOR_PASS="harbor.od.com"
fi

VERSION="${MAJOR_VERSION}.${MINOR_VERSION}"
RELEASE_PATH="release-${MAJOR_VERSION}.0"
mkdir -p /opt/src
cd /opt/src
HARBOR_PACKAGE="harbor-offline-installer-v${VERSION}.tgz"
if [ ! -f "${HARBOR_PACKAGE}" ];then
wget https://storage.googleapis.com/harbor-releases/${RELEASE_PATH}/${HARBOR_PACKAGE}
fi
tar xvf ${HARBOR_PACKAGE}
mv harbor /opt/harbor-v${VERSION}
ln -s /opt/harbor-v${VERSION} /opt/harbor
mkdir -p /data/harbor/logs

/opt/dendyops/components/utils/replace_in_file.sh /opt/harbor/harbor.yml "hostname: reg.mydomain.com" "hostname: ${HOST_NAME}"
/opt/dendyops/components/utils/replace_in_file.sh /opt/harbor/harbor.yml "port: 80" "port: ${HTTP_PORT}"
/opt/dendyops/components/utils/replace_in_file.sh /opt/harbor/harbor.yml "data_volume: \/data" "data_volume: \/data\/harbor"
/opt/dendyops/components/utils/replace_in_file.sh /opt/harbor/harbor.yml "location: \/var\/log\/harbor" "location: \/data\/harbor\/logs"
/opt/dendyops/components/utils/replace_in_file.sh /opt/harbor/harbor.yml "harbor_admin_password: Harbor12345" "harbor_admin_password: ${HARBOR_PASS}"

if [ ! -h /usr/bin/docker-compose ] ;then
 /opt/dendyops/components/docker-compose/install_docker_compose.sh
fi

cd /opt/harbor && sudo ./install.sh

echo "Harbor URL: http://${HOST_NAME}:${HTTP_PORT} ,data_volume: /data/harbor,location: /data/harbor/logs,harbor_admin_password: ${HARBOR_PASS}"

# Harbor will be auto restarted by docker-compose when reboot server
# So don't need add Harbor into `systemd` service