#!/usr/bin/env bash

set -e

# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum makecache fast

VERSION="$1"
if [ -n "$VERSION" ] ; then
    yum -y install docker-ce-"${VERSION}.ce"
else
    yum -y install docker-ce
fi

innerip=$(ip a  |egrep 'eth0|ens32|ens33|eno1|eno2' |grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' |awk '{print $2}')
_bip_4=` echo $innerip|awk -F. '{print$4}'`
cat > /etc/docker/daemon.json << EOF
{
   "graph": "/data/docker",
   "storage-driver": "overlay2",
   "insecure-registries": ["registry.access.redhat.com","quay.io","harbor.od.com"],
   "registry-mirrors": ["https://jltw059v.mirror.aliyuncs.com"],
   "bip": "10.10.${_bip_4}.1/24",  
   "exec-opts": ["native.cgroupdriver=systemd"],
   "live-restore": true
}
EOF
./post_install_docker.sh

../utils/start_service.sh docker

docker version
