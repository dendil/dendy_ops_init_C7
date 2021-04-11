#!/bin/bash
. /etc/init.d/functions
function a_sub(){
                local ip=$1
                local passwd=$3
                local sshfile=$2
                expect /opt/dendyops/components/ssh/fenfa_clinet_sshkey.exp  $sshfile  $ip $passwd >/dev/null 2>&1
                if [ $? -eq 0 ]
                        then
                        action "$ip" /bin/true
                else
                        action "$ip" /bin/false
                        echo -e " \e[32;1mif  you  See let U try  ssh  it's ok  \e[0m "
                fi

}
if [   -z $1 ];then
    echo  "usage   $@  password "
    exit 1
fi
passwd=$2
sshfile=$1
hostfile=/opt/dendyops/components/salt_k8s/hosts.txt
if [ -f  $hostfile  ];then
    for i in  `cat  $hostfile |grep -v ^# |grep -v $HOSTNAME |awk '{print $3}'`
    do
        a_sub $i  $sshfile  $passwd
     done
fi
touch ~/.ssh/authorized_keys
if [ `grep "$(cat ~/.ssh/id_rsa.pub )" ~/.ssh/authorized_keys |wc -l ` -lt 1 ];then
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    
fi
action "$HOSTNAME" /bin/true