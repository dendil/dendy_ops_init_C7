swapoff -a
cat /etc/fstab
modprobe br_netfilter
echo -e 'net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1' > /etc/sysctl.d/k8s.conf
sysctl --system
modprobe -- ip_vs;modprobe -- ip_vs_rr;modprobe -- ip_vs_wrr;modprobe -- ip_vs_sh;modprobe -- nf_conntrack_ipv4
cut -f1 -d ' '  /proc/modules | grep -e ip_vs -e nf_conntrack_ipv4
yum install -y ipset ipvsadm >> /dev/null

yum list|egrep 'ipset|ipvsadm' 

cat > containerd.service  << EOF
 # 修改containerd模块启动脚本，让其先加载ipvs模块，这种方式是我测试多次后发现比较有效的
#   Copyright 2018-2020 Docker Inc.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStartPre=-/sbin/modprobe ip_vs
ExecStartPre=-/sbin/modprobe ip_vs_rr
ExecStartPre=-/sbin/modprobe ip_vs_wrr
ExecStartPre=-/sbin/modprobe ip_vs_sh
ExecStartPre=-/sbin/modprobe nf_conntrack_ipv4
ExecStart=/usr/bin/containerd
KillMode=process
Delegate=yes
LimitNOFILE=1048576
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF
cat containerd.service
cp containerd.service /usr/lib/systemd/system/containerd.service
/opt/dendyops/components/docker/install_docker_ce.sh
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://repo.huaweicloud.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://repo.huaweicloud.com/kubernetes/yum/doc/yum-key.gpg https://repo.huaweicloud.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubeadm kubelet kubectl
systemctl enable --now kubelet


