#!/bin/bash
. ./system_init_functions.sh
newhostname=$1

#if [ ! -z $newhostname ];then
#    /bin/cp -f /etc/sysconfig/network /etc/sysconfig/network-bak
#    sed -i "s/HOSTNAME=.*/HOSTNAME=$newhostname/g" /etc/sysconfig/network && hostname $newhostname;echo $?
#    cat /etc/sysconfig/network
#    #rm -rf /etc/sysconfig/network-bak
#else

if [ ! -z $newhostname ];then
     #echo "$newhostname" > /etc/hostname
     hostnamectl set-hostname  $newhostname
     echo "127.0.0.1 $newhostname" >>/etc/hosts
 else
    echo "Usage: $0 Hostname"
fi
cat /etc/hosts