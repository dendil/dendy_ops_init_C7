# Salt-ssh自动化部署Kubernetes

服务器节点(如需要请自行修改)
``` 
cat /opt/dendyops/components/salt_k8s/hosts.txt
192.168.1.10  00:50:56:35:1e:c7  prometheus1.caojie.top
192.168.1.11  00:50:56:33:44:e7  node1.caojie.top
192.168.1.12  00:50:56:34:0a:c7  node2.caojie.top
192.168.1.13  00:50:56:2e:34:67  node3.caojie.top
192.168.1.229 00:15:5d:ff:01:04  master1.caojie.top
192.168.1.228 00:15:5d:ff:01:03  master2.caojie.top
192.168.1.5   00:50:56:2f:95:77  admin.caojie.top
```

# 设置部署节点到其它所有节点的SSH免密码登录（包括本机）
管理机（以下不做标记皆为admin 管理机）
```bash 
#hosts文件生成
/opt/dendyops/components/utils/make_hosts.sh
mv /etc/hosts{,.bak.$RANDOM} 
cp /opt/hosts /etc/
# 生成密钥
/opt/dendyops/components/ssh/ssh_key_gen.sh
# 分发密钥
/opt/dendyops/components/ssh/fenfa_clinet_ssk.sh 123456


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

