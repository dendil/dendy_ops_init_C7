#!/bin/bash
. /etc/init.d/functions
Comman=`echo "$2"|awk '{print $1}'`
Command=`which $Comman`
Options=`echo "$*"|awk -F"$Comman" '{print $2}'`
a_sub() {
#       ip=`echo $i|awk -F@ '{print $1}'`
#       echo "start ${ip}-${Command}--------------------------"
        ssh -p 22 root@$i $Command $Options
#       echo "end   ${ip}-${Command}--------------------------"
                if [ $? -eq 0 ]
                        then
                        action "$i" /bin/true
                else
                        action "$i" /bin/false
                fi
}
hostfile=$1
if [ -f  $hostfile  ];then
tmp_fifofile="/tmp/$.fifo"
mkfifo $tmp_fifofile      # 新建一个fifo类型的文件
exec 6<>$tmp_fifofile      # 将fd6指向fifo类型
/bin/rm $tmp_fifofile
thread=20 # 此处定义线程数
for ((a=0;a<$thread;a++));do
echo
done >&6 # 事实上就是在fd6中放置了$thread个回车符
for i in `cat  $hostfile|grep -v ^#|awk '{print $3}'`
do # 50次循环，可以理解为50个主机，或其他
read -u6
{
 a_sub
 echo   >&6 # 当进程结束以后，再向fd6中加上一个回车符，即补上了read -u6减去的那个
} &

done
wait # 等待所有的后台子进程结束
exec 6>&- # 关闭df6
exit 0
fi