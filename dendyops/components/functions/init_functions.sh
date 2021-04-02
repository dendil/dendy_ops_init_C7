#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

. /etc/init.d/functions
######################################################################
#锁文件
LOCK_FILE="auto_install.lock"
LOCK_DIR="/var/lock/auto_install"
#日志文件
LOG_DIR="/var/log"
# 判断是否可以上网####################################################
function test_ping(){
    if [ ! -f /etc/selinux/_test_ping ];then
        ping -c 2 baidu.com >/dev/null
        if [ $? -eq 0 ];then
            Msg "test_ping() networking  is ok!"
            echo  "1" >/etc/selinux/_test_ping
        else
            Msg "test_ping() networking  not  configured- exiting"
            shell_unlock
            exit 1
        fi
    else
        Msg "test_ping() networking  is ok!"
    fi
}
function get_base_path(){
 #获取相对路径/get path
 SOURCE="$0"
 while [ -h "$SOURCE"  ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /*  ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
 done
 DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd  )"
 Msg "$DIR"
}

# Lock################################################################
function shell_lock(){
    check_folder ${LOCK_DIR}  >/dev/null 2>&1
    touch ${LOCK_DIR}/${LOCK_FILE}
}
# 查看是否上锁########################################################
function check_lock(){
    if [ -f "${LOCK_DIR}/${LOCK_FILE}" ];then
        echo " error !  this scripts is  running"
        kill -9 $ROTATE_PID
        exit 1
    fi
}
# unlock##############################################################
function  shell_unlock(){
    rm -f ${LOCK_DIR}/${LOCK_FILE}
    echo '' >> /dev/null
}
# 记录日志############################################################
function log(){
    datetime=`date +"%F %H:%M:%S"`
    message=$1
    if [ -z "$2" ];then
        loglevel="INFO"
    else
        loglevel=$2
    fi
    outdir="${LOG_DIR}"
    if [ ! -d "$outdir" ]; then
        mkdir "$outdir"
    fi
    logname="${LOG_FILE}"
    echo "$datetime [$0] [$(pwd)][$loglevel] :: $message" | tee -a "$outdir/$logname"
}
function log_error(){
        log "$1" "ERROR"
}
function log_info(){
        log "$1" "INFO"
}
function lv_se(){
    local F1=$1
    echo "\[\e[32;1m\]$F1\[\e[0m\]"
}
function Msg(){
    if [ $? -eq 0 ];then
        log_info "$1"
    else
        log_error "$1"
    fi
}
function bin_grep(){
    local string1=$1
    local string2=$2
    if [ "`/bin/grep "/${string1}"  ${string2} |wc -l`" -eq 0 ];then
        echo " ${string2} "  >> ${string2}
    fi
}# 获取系统信息
function check_sys(){
    #是否 为红帽系linux 
    Software_Path="/software"
    #缺省值为空
    # Install time state
    StartDate=''
    #############
    StartDateSecond=''
    # Current folder
    # 现在的目录路径
    cur_dir=`pwd`
    # CPU Number
    # CPU核数 4
    Cpunum=`cat /proc/cpuinfo | grep 'processor' | wc -l`
    [[ ! -f /etc/redhat-release ]] && Msg 'Error: This script not support your OS, please change to CentOS/RedHat/Fedora and retry!' && exit 1
    #CPU型号 速率 Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz
    cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    #CPU核数 4 
    cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    #CPU 赫兹  2400.042
    freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    #物理内存  7901MB
    tram=$( free -m | awk '/Mem/ {print $2}' )
    #虚拟内存  3999MB
    swap=$( free -m | awk '/Swap/ {print $2}' )
    #启动时间 14days, 19:17:55
    up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
    #系统版本 CentOS 6.9
    opsy=$( awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release )
    #   系统位数 x86_64
    arch=$( uname -m )
    #系统位数  64
    lbit=$( getconf LONG_BIT )
    #系统主机名  cobbler6-9.24k.com
    host=$( hostname )
    #内核版本 2.6.32-696.el6.x86_64
    kern=$( uname -r )
    #物理内存 加 虚拟内存 总大小 7902 + 4999 = 13G
    RamSum=`expr $tram + $swap`
    if [ $RamSum -lt 480 ]; then
        log_error "Error: Not enough memory to install LAMP. The system needs memory: ${tram}MB*RAM + ${swap}MB*Swap > 480MB"
        exit 1
    fi
}

function pre_installation_settings(){
    check_sys()
    StartDate=$(date);
    #开始秒数
    StartDateSecond=$(date +%s);
    Msg "Start time: ${StartDate}"; 
    Msg "time sync completed "
    Msg ""
    Msg "#############################################################"
    Msg "#  Auto Install Script for CentOS / RedHat / Fedora     "
    Msg "#  Intro: http://caojie.top "
    Msg "#  Author: dendi                        "
    Msg "#############################################################"
    Msg ""
    # Display System information
    # 显示系统信息
    Msg "System information is below"
    Msg ""
    Msg "CPU model            : $cname"
    Msg "Number of cores      : $cores"
    Msg "CPU frequency        : $freq MHz"
    Msg "Total amount of ram  : $tram MB"
    Msg "Total amount of swap : $swap MB"
    Msg "System uptime        : $up"
    Msg "OS                   : $opsy"
    Msg "Arch                 : $arch ($lbit Bit)"
    Msg "Kernel               : $kern"
    Msg "公网/waiwang address : $IP"
    Msg "eth0 address         : $IP"
    Msg "#############################################################"
    Msg " "
    Msg "wait ... to start...or Press Ctrl+C to cancel"
    #char=`get_char`
    #Remove Packages
}
# Make sure only root can run our script
# # 判断是否为root用户执行该脚本
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       log_error "Error:This script must be run as root!" 1>&2
       kill -9 $ROTATE_PID
       exit 1
    fi
}
# check file md5#检查两个文件是否内容一致
function md5sum_check(){
    local Frist=$1
    local Sencond=$2
    local Mrist=$(/usr/bin/md5sum $1|awk '{print $1}')
    local Srist=$(/usr/bin/md5sum $2|awk '{print $1}')
    if [ $Mrist == $Srist ];then 
	   return 0
    else 
	   return 1
    fi
}
# check soft download or un tar
function check_soft(){
    local file=$1
    local soft=`cat ${DIR}/$(basename $0) |grep $file|grep '#'|awk -F"#" '{print $2}'`
    if [ ! -d "${Tar_Path}/$file" ];then
        log_error "${Tar_Path}/$file not  found!!!........."
        check_folder ${Software_Path}
        cd ${Software_Path}
        download_file $soft
        untar_file $soft
    else
        log_info "${Tar_Path}/$file  [found]"
    fi
}
# 解压文件到指定的目录
function untar_file(){
    local UNtarfile=$1
        tar xf ${UNtarfile} -C  ${Tar_Path}/ >/dev/null 2>&1
        if [ "$?" -eq 0 ] ;then
            Msg "tar  ${UNtarfile} -C ${Tar_Path}/  ........."
        else
            Msg "tar  ${UNtarfile} -C ${Tar_Path}/ error !!!!!"
        fi
}
# 检查目录是否存在，不存在就创建
function check_folder(){
    local folder=$1
    if [ ! -d $folder ] ;then 
        mkdir -p $folder
        Msg "$folder had been make"
    else
        log_info "$folder Already exists "
    fi
}
# 检查 链接文件是否存在
function check_link(){
    local Link_file1=$1
    local Link_file2=$2
    if [ ! -L "${Link_file2}" ] ;then
        ln -s  ${Link_file1}  ${Link_file2}
    fi
}
# 检查对比文件内容是否一致
function check_file(){
    local Test_file_dow=$1
    local Test_file_local=$2
    if [ -f "${Test_file_local}" ];then
        md5sum_check  ${Test_file_dow}  ${Test_file_local}
        if [ ! $? -eq 0 ];then
            mv ${Test_file_local}{,.bak.$(date +%F)}
            mv ${Test_file_dow}  ${Test_file_local}
        fi
    else
        mv ${Test_file_dow}  ${Test_file_local}
    fi
}
function getIP(){
    IP=`ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^127\.|^255\." | head -n 1`
    if [[ "$IP" = "" ]]; then
        IP=`wget -qO- -t1 -T2 ipv4.icanhazip.com`
    fi
}
# is 64bit or not
# # 判断是否为 64位
function is_64bit(){
    if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
        return 0
    else
        return 1
    fi        
}
# Get version
# # 取 精确 linux 版本 6.9
function getversion(){
    if [[ -s /etc/redhat-release ]];then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else    
        grep -oE  "[0-9.]+" /etc/issue
    fi    
}
# CentOS version
function centosversion(){
    local code=$1
    local version="`getversion`"
    #取 version 小数点之前的数  6.9 → 6
    local main_ver=${version%%.*}
    if [ $main_ver == $code ];then
        return 0
    else
        return 1
    fi        
}