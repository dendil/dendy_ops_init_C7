#!/usr/bin/env bash

set -e

# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum makecache fast

install_path="$1"
if [ -n "${install_path}" ] ; then
  yum -y install docker-ce

  innerip=$(ip a  |egrep 'eth0|ens32|ens33|eno1|eno2' |grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' |awk '{print $2}')
  _bip_4=` echo $innerip|awk -F. '{print$4}'`
  mkdir -p /etc/docker
  cat > /etc/docker/daemon.json << EOF
{
   "data-root": "${install_path}/docker",
   "storage-driver": "overlay2",
   "insecure-registries": ["registry.access.redhat.com","quay.io"],
   "bip": "172.16.${_bip_4}.1/24",  
   "exec-opts": ["native.cgroupdriver=systemd"],
   "live-restore": true
}
EOF
mkdir ${install_path}/docker -p




else
    yum -y install docker-ce
fi


./post_install_docker.sh

../utils/start_service.sh docker

docker version
