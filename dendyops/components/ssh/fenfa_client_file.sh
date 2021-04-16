#!/bin/bash
. /etc/init.d/functions
if [ $# -ne 3 ]
	then
	echo "$0 file dir"
	exit 1
fi
filename=`basename $2`

hostfile=$1
if [ -f  $hostfile  ];then
for i in  `cat  $hostfile|grep -v ^# |grep -v $HOSTNAME |awk '{print $3}'`
do
	#ip=`echo $i|awk -F@ '{print $1}'`
	ip=$i
	rsync -avzP $2 -e 'ssh -t -p 22 ' root@$ip:$3
	#ssh -t -p 22 root@$ip sudo rsync ~/$filename $2
	if [ $? -eq 0 ]
		then
		action "$ip" /bin/true
	else
		action  "$ip" /bin/false
	fi
done
fi
