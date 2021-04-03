#!/bin/bash
hostfile=/opt/components/salt_k8s/host.txt
if [ -f /opt/hosts ];then
    mv  /opt/hosts{,.bak.$RANDOM}
fi
touch /opt/hosts

head  -n 2 /etc/hosts >/opt/hosts

cat $hostfile  | grep -v ^# |awk -F' ' '{print $1"."$3}'|awk -F. '{print $1"."$2"."$3"."$4" "$5" "$5"."$6"."$7"" }' >>/opt/hosts
