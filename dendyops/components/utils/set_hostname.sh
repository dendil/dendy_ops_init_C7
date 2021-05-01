#!/usr/bin/env bash

set -e

IP=`ip addr show | grep -Ev  'docker0|veth|br*:' | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
if [[ "$IP" = "" ]]; then
        IP=`wget -qO- -t1 -T2 ipv4.icanhazip.com`
fi
##### hosts        同步hosts 文件 主机名#############################

function hosts_hostname(){
    local hostfile=$1
    if [ `grep $IP $hostfile  |wc -l` -eq 1  ];then
        New_hostname=`grep $IP $hostfile |awk '{print $3}'`
        hostnamectl set-hostname --static $New_hostname
        echo " New hostname ==>  $New_hostname ...........ok!"
    else
        los=`grep $IP $hostfile`
        echo "not found hostname ,found $los"
    fi
}
hostfile=$1
if [ -f  $hostfile  ];then
hosts_hostname  $hostfile
fi