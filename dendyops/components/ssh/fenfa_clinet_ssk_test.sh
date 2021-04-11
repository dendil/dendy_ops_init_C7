#!/bin/bash
. /etc/init.d/functions
function a_sub(){
                local ip=$1
                ssh    $ip -t 'hostname' 
                if [ $? -eq 0 ]
                        then
                        action "$ip" /bin/true
                else
                        action "$ip" /bin/false
                        echo -e " \e[32;1mif  you  See let U try  ssh  it's ok  \e[0m "
                fi

}

hostfile=/opt/dendyops/components/salt_k8s/hosts.txt
if [ -f  $hostfile  ];then
    for i in  `cat  $hostfile |grep -v ^#  |awk '{print $3}'`
    do
        a_sub $i  
     done
fi
