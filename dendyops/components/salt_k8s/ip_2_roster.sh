#!/bin/bash
# Sample salt-ssh config file
#web1:
#  host: 192.168.42.1 # The IP addr or DNS hostname
#  user: fred         # Remote executions will be executed as user fred
#  passwd: foobarbaz  # The password to use for login, if omitted, keys are used
#  sudo: True         # Whether to sudo to root, not enabled by default
#web2:
#  host: 192.168.42.2
#  [第一次执行的时候，有的机器可能会提醒输入ssh初次登录询问yes/no，
#  如果要去掉这个yes/no的询问环节，只需要修改本机的/etc/ssh/ssh_config
#  文件中的"# StrictHostKeyChecking ask" 为 "StrictHostKeyChecking no"，然后重启sshd服务即可]
#  sed -i 's/\#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g'  /etc/ssh/ssh_config
hostfile=/opt/dendyops/components/salt_k8s/hosts.txt
for Name in `/usr/bin/cat $hostfile |grep -v ^# | awk '{print $2}'`
do
	Roster_hostname=`/usr/bin/cat $hostfile  |grep -v ^#|grep   $Name | awk '{print $3}'`
	Roster_ip=`/usr/bin/cat $hostfile |grep -v ^# |grep   $Name | awk '{print $1}'`
	#Roster_passwd=`/usr/bin/cat $hostfile  |grep -v ^#|grep   $Name | awk '{print $8}'`
	Roster_user="root"
	Roster_port="22"
echo "${Roster_hostname}:">>roster
echo "  host: ${Roster_ip}">>roster
echo "  user: ${Roster_user}">>roster
echo "  priv: /root/.ssh/id_rsa">>roster
echo "  port: ${Roster_port}">>roster
done
#if [ `/usr/bin/cat  /etc/ssh/ssh_config  |grep "StrictHostKeyChecking no" |wc -l` -eq 0 ];then
#	sed -i 's/\#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g'  /etc/ssh/ssh_config
#fi
#systemctl restart sshd