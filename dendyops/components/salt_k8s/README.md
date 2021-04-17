# Salt-ssh自动化部署Kubernetes

k8s_15  https://pan.baidu.com/s/1-ZxmZ0LFrGQJVPXQLu1apQ
服务器节点(如需要请自行修改)
``` 
cat /opt/dendyops/components/salt_k8s/hosts.txt
#     ip           mac                   hostname       k8s-role        etcd-role 
192.168.1.7  	00:0c:29:36:5e:b0	node3.caojie.top         node            no
192.168.1.8	    00:0c:29:e8:9f:cc	admin1.caojie.top         master             node3
192.168.1.9	    00:0c:29:67:7a:09	node1.caojie.top         node             no
192.168.1.11	00:0c:29:0f:44:8d	master1.caojie.top         master          node1
192.168.1.13	00:0c:29:0d:43:83	master2.caojie.top         master           node2
192.168.1.234	00:0c:29:f5:0f:67	node2.caojie.top         node             no
```
# Salt SSH管理的机器以及角色分配
k8s-role: 用来设置K8S的角色
etcd-role: 用来设置etcd的角色，如果只需要部署一个etcd，只需要在一台机器上设置即可
etcd-name: 如果对一台机器设置了etcd-role就必须设置etcd-name
worker-role: 所有节点均为worker节点
ca-file-role: 定义c8-node1为证书生成节点
kubelet-bootstrap-role: 在c8-node1上生成kubelet-bootstrap的kubeconfig配置文件，然后再拷贝至各个节点
kubelet-role: 所有的节点都需要安装kubelet
calico-role: 在c8-node1的管理节点上安装并配置calico网络
# 设置部署节点到其它所有节点的SSH免密码登录（包括本机）
管理机（以下不做标记皆为admin 管理机）
```bash 
# 安装dendyops
cd /tmp && git clone https://github.com/dendil/dendy_ops_init_C7.git &&cd dendy_ops_init_C7 &&find . -name '*.sh' -exec chmod u+x {} \; &&bash init.sh update
#hosts文件生成
/opt/dendyops/components/utils/make_hosts.sh /opt/dendyops/components/salt_k8s/hosts.txt
mv /etc/hosts{,.bak.$RANDOM} 
cp /opt/hosts /etc/
# 设置主机名
/opt/dendyops/components/utils/set_hostname.sh
# 生成密钥
/opt/dendyops/components/ssh/ssh_key_gen.sh
# 分发密钥
/opt/dendyops/components/ssh/fenfa_clinet_ssk.sh ~/.ssh/id_rsa.pub 123456 /opt/dendyops/components/salt_k8s/hosts.txt
#测试
/opt/dendyops/components/ssh/fenfa_clinet_ssk_test.sh /opt/dendyops/components/salt_k8s/hosts.txt hostname
#初始化子节点
/opt/dendyops/components/ssh/fenfa_client_file.sh    /opt/dendyops/components/salt_k8s/hosts.txt /tmp/dendy_ops_init_C7 /tmp/
/opt/dendyops/components/ssh/fenfa_clinet_ssk_test.sh  /opt/dendyops/components/salt_k8s/hosts.txt 'bash /tmp/dendy_ops_init_C7/init.sh update'

#/opt/dendyops/components/ssh/fenfa_clinet_ssk.sh /etc/salt/pki/master/ssh/salt-ssh.rsa.pub 123456
#安装saltstack salt-ssh
/opt/dendyops/components/saltstack/install_salt_master.sh  



# 生成 roster
/opt/dendyops/components/salt_k8s/ip_2_roster.sh /opt/dendyops/components/salt_k8s/hosts.txt
mv /etc/salt/roster{,.bak}
 cp /opt/roster  /etc/salt/
 #分发hosts
#/opt/dendyops/components/ssh/fenfa_client_file.sh   /opt/hosts  /etc/hosts
 salt-ssh  '*' cp.get_file /opt/hosts /etc/hosts
 salt-ssh  '*' cmd.run 'cat /etc/hosts'
 #同步主机名
#/opt/dendyops/components/ssh/fenfa_client_file.sh    /opt/dendyops/components/utils/set_hostname.sh  /tmp 
#/opt/dendyops/components/ssh/fenfa_clinet_ssk_test.sh 'bash /tmp/set_hostname.sh'
 salt-ssh  '*' cp.get_file  /opt/dendyops/components/utils/set_hostname.sh  /tmp
 salt-ssh  '*' cmd.run   'bash /tmp/set_hostname.sh'
 salt-ssh  '*' cmd.run   'hostname'


#安装dendyops
#salt-ssh  '*' cmd.run 'ls /tmp/'
 #如果有 则删掉
#salt-ssh  '*' cmd.run 'rm -fr  /tmp/dendy_ops_init_C7'
#同步内核文件
salt-ssh  '*' cp.get_file /opt/dendyops/components/salt_k8s/sysctl.conf  /etc/sysctl.conf
salt-ssh  '*' cmd.run   'sysctl -p'
#iptables透明网桥的实现
# NOTE: kube-proxy 要求 NODE 节点操作系统中要具备 /sys/module/br_netfilter 文件，而且还要设置 bridge-nf-call-iptables=1，如果不满足要求，那么 kube-proxy 只是将检查信息记录到日志中，kube-proxy 仍然会正常运行，但是这样通过 Kube-proxy 设置的某些 iptables 规则就不会工作。# 如果看到
#    sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory
#    sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
#    sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-arptables: No such file or directory
salt-ssh  '*' cmd.run 'modprobe br_netfilter'
salt-ssh  '*' cmd.run   'sysctl -p'

mv /etc/salt/master{,.bak}
cp      /opt/dendyops/components/salt_k8s/master   /etc/salt/
cp     -a /opt/dendyops/components/salt_k8s/pillar /opt/
cp     -a /opt/dendyops/components/salt_k8s/salt  /opt/

cd /opt/salt/k8s/
# 下载并放入k8s_15  https://pan.baidu.com/s/1-ZxmZ0LFrGQJVPXQLu1apQ

mkdir /opt/salt/k8s/files -p
cd /opt/salt/k8s/files 
mkdir cfssl 
cd cfssl 
wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64

wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64

wget https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl-certinfo_1.4.1_linux_amd64
cd ..


wget https://github.com/coreos/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz

tar xf etcd-v3.4.9-linux-amd64.tar.gz
mkdir cni-plugins-linux-amd64-v0.8.6
cd cni-plugins-linux-amd64-v0.8.6
wget  https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz
tar xf cni-plugins-linux-amd64-v0.8.6.tgz

cd ..
wget https://storage.googleapis.com/kubernetes-release/release/v1.18.2/kubernetes-server-linux-amd64.tar.gz 
# 虚拟机快照

salt-ssh '*' test.ping
salt-ssh  '*' state.sls k8s.baseset
salt-ssh -L 'master1.caojie.top,master2.caojie.top,admin1.caojie.top' state.sls k8s.etcd
etcdctl endpoint status --cluster -w table
salt-ssh  'admin1*' state.sls k8s.modules.ca-file-generate
salt-ssh -L 'master1.caojie.top,master2.caojie.top,admin1.caojie.top' state.sls k8s.master
salt-ssh -L 'admin1.caojie.top' state.sls k8s.modules.kubelet-bootstrap-kubeconfig
salt-ssh '*' state.sls k8s.node
salt-ssh  'admin1*' state.sls k8s.modules.calico
```

## Install Git

```bash
yum install git -y
git --version
cd /tmp
```

## Clone 

Run below commands on an empty directory:
```bash
git clone https://github.com/dendil/dendy_ops_init_C7.git
cd dendy_ops_init_C7
find . -name '*.sh' -exec chmod u+x {} \;
```



## Init centos7
```bash
sudo su
bash  init.sh
```
初始化项目

 - 关闭selinux
 - 关闭防火墙
 - 安装本插件
 - 添加sudo用户
 - 更改sshd配置
 - 扩大文件描述符
 - 同步时间并启动时间同步服务chrony
 - 配置国内阿里yum源 epel
 - 安装工具　 lrzsz dos2unix ntp gcc bc rsync chrony vim wget bash-completion lrzsz nmap nc tree htop iftop net-tools python3  yum-utils curl bind-utils unzip mtr

