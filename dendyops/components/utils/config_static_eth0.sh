#!/usr/bin/env bash

set -e

_route=`route -n | awk '{ print$2 }' | grep -Eo '?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*'  | grep -v '0.0.0.0'`
IP=`ip addr show | grep -v 'docker0' | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
if [[ "$IP" = "" ]]; then
       echo "error ! $IP:ip =='  '   ,not found ip "
       exit 1
fi
if [[ "$_route" = "" ]]; then
       echo "error ! $_route:route =='  '   ,not found route "
       exit 1
fi
ConfigNetworkIp(){
	if [ -f  /etc/sysconfig/network-scripts/ifcfg-eth0 ] ; then
       sed -i "s/ONBOOT=yes/ONBOOT=no/" /etc/sysconfig/network-scripts/ifcfg-eth0
       mv /etc/sysconfig/network-scripts/ifcfg-eth0  /etc/sysconfig/network-scripts/ifcfg-eth0.$(date +%U%T)
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=$IP
GATEWAY=${_route}
NETMASK=255.255.255.0
DNS=8.8.8.8
DNS2=114.114.114.114
EOF
else
    echo  '/etc/sysconfig/network-scripts/ifcfg-eth0   not found'
   exit 1
fi
}
#if [ $1 -eq 0 ]
#	then
#	ConfigNetworkIp
#	/etc/init.d/network reload
#	sleep 1
#else
#	ConfigHosname
ConfigNetworkIp
#	hostname $hostNameTmp
#	echo "$ip $hostNameTmp" >> /etc/hosts
systemctl restart network.service
systemctl status network.service