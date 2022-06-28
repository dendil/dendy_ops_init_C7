
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       log_error "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}
rootness
# 复制pubkey 进入 目录执行
if [ -f /root/.ssh/authorized_keys ];then
    echo "# new  keys $date"  >> ~/.ssh/authorized_keys
    for i in `ls /opt/dendyops/components/juna/pubkey/*.pub` ; do
        echo "# $i " >> /root/.ssh/authorized_keys ;
        cat $i >> /root/.ssh/authorized_keys  ;
        echo >> /root/.ssh/authorized_keys  ;
        done
fi

