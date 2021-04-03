#!/usr/bin/env bash

set -e

IP=`ip addr show | grep -v 'docker0' | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
if [[ "$IP" = "" ]]; then
        IP=`wget -qO- -t1 -T2 ipv4.icanhazip.com`
fi
##### hosts        同步hosts 文件 主机名#############################
function hosts_hostname(){
    local New_hostname=$1
    if [ `grep "$IP_addr $New_hostname" /etc/hosts |wc -l` -lt 1  ];then
        echo "$IP_addr $New_hostname"  >> /etc/hosts
    fi
    hostnamectl set-hostname --static $New_hostname
    Msg " New hostname ==>  $New_hostname ...........ok!"
}
hosts_hostname $1