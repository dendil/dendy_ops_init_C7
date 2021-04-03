#!/bin/bash
. /etc/init.d/functions
function a_sub(){
                local ip=$1
                local passwd
                expect ./fenfa_clinet_sshkey.exp  ~/.ssh/id_rsa.pub  $ip $passwd >/dev/null 2>&1
                if [ $? -eq 0 ]
                        then
                        action "$ip" /bin/true
                else
                        action "$ip" /bin/false
                fi
}
if [  ! -z $1 ];then
    echo  "usage   $@  password "
    exit 1
fi
passwd=$1
hostfile=/opt/dendyops/components/salt_k8s/hosts.txt
if [ -f  $hostfile  ];then
    for i in  `cat  $hostfile |grep -v ^# |awk '{print $3}'`
    do
        a_sub $i $passwd
     done
fi
