#!/bin/bash
. /etc/init.d/functions
function a_sub(){
                local ip=$1
                local passwd=$2
                expect /opt/dendyops/components/ssh/fenfa_clinet_sshkey.exp  ~/.ssh/id_rsa.pub  $ip $passwd >/dev/null 2>&1
                if [ $? -eq 0 ]
                        then
                        action "$ip" /bin/true
                else
                        action "$ip" /bin/false
                        echo " \[\e[32;1m\]if  you  See let U try  ssh  it's ok  \[\e[0m\] "
                fi

}
if [   -z $1 ];then
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
