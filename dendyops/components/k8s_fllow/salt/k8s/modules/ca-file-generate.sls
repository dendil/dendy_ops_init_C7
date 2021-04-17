# -*- coding: utf-8 -*-



#这里我们统一生成证书
#证书统一存放在/opt/kubernetes/pki 目录下
include:
  - k8s.modules.cfssl

#定义根证书配置文件
#CA 配置文件用于配置根证书的使用场景 (profile) 和具体参数 (usage，过期时间、服务端认证、客户端认证、加密等) #}
#定义目录/opt/kubernetes/sslcert,此处用于生成证书，
#定义目录/opt/kubernetes/pki  此处用于存放证书，k8s实际运行时所需证书
sslcert-config-dir:
  file.directory:
    - name: /opt/kubernetes/sslcert
    - makedirs: True
srv-salt-cert-dir:
  file.directory:
    - name: /opt/salt/k8s/files/cert
    - makedirs: True

ca-config-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/ca-config.json
    - source: salt://k8s/templates/ca/ca-config.json
    - user: root
    - group: root
    - mode: 644
ca-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/ca-csr.json
    - source: salt://k8s/templates/ca/ca-csr.json
    - user: root
    - group: root
    - mode: 644
#制作ca证书以及key
ca-pem-key-pki:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -initca ca-csr.json | cfssljson -bare ca && /bin/cp /opt/kubernetes/sslcert/ca.pem /opt/salt/k8s/files/cert/ca.pem && /bin/cp /opt/kubernetes/sslcert/ca-key.pem /opt/salt/k8s/files/cert/ca-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/ca-key.pem

#此时会生成ca.pem ca-key.pem ca.csr三个文件
#制作kubectl所需证书以及私钥   定义证书签名请求,以及生成证书
admin-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/admin-csr.json
    - source: salt://k8s/templates/ca/admin-csr.json.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=/opt/kubernetes/sslcert/ca.pem -ca-key=/opt/kubernetes/sslcert/ca-key.pem -config=/opt/kubernetes/sslcert/ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin && /bin/cp /opt/kubernetes/sslcert/admin.pem /opt/salt/k8s/files/cert/admin.pem && /bin/cp /opt/kubernetes/sslcert/admin-key.pem /opt/salt/k8s/files/cert/admin-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/admin-key.pem

#生成kubectl配置文件-这里将不再需要kubectl.sls文件
kubectl-admin-set-cluster:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-cluster kubernetes --certificate-authority=ca.pem --embed-certs=true --server={{ pillar['KUBE_APISERVER'] }} --kubeconfig=kubectl.kubeconfig

kubectl-admin-set-credentials:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-credentials kubernetes-admin --client-certificate=admin.pem --embed-certs=true --client-key=admin-key.pem --kubeconfig=kubectl.kubeconfig

kubectl-admin-set-context:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-context kubernetes-admin@kubernetes --cluster=kubernetes --user=kubernetes-admin --kubeconfig=kubectl.kubeconfig

kubectl-admin-use:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config use-context kubernetes-admin@kubernetes --kubeconfig=kubectl.kubeconfig && mkdir -p ~/.kube && /bin/cp /opt/kubernetes/sslcert/kubectl.kubeconfig ~/.kube/config

#生成kube-apiserver组件持有的服务端证书和私钥
# 由此根证书签发的证书有:
#kube-apiserver 组件持有的服务端证书,这里用的是同一个证书，kubeadm是基于同一个CA生成了两个证书
#/opt/kubernetes/pki/apiserver.crt--- 这里使用的apiserver-kubelet-client.pem
#/opt/kubernetes/pki/apiserver.key--- 这里使用的是apiserver-kubelet-client-key.pem
#kubelet 组件持有的客户端证书, 用作 kube-apiserver 主动向 kubelet 发起请求时的客户端认证
#/opt/kubernetes/pki/apiserver-kubelet-client.crt--- 这里使用的apiserver-kubelet-client.pem
#/opt/kubernetes/pki/apiserver-kubelet-client.key --- 这里使用的是apiserver-kubelet-client-key.pem
#这里跟kubeadm生成的证书是不一样的，  

kube-api-server-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/kubernetes-csr.json
    - source: salt://k8s/templates/ca/kubernetes-csr.json.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        MASTER_IP_M1: {{ pillar['MASTER_IP_M1'] }}
        MASTER_IP_M2: {{ pillar['MASTER_IP_M2'] }}
        MASTER_IP_M3: {{ pillar['MASTER_IP_M3'] }}
        MASTER_H1: {{ pillar['MASTER_H1'] }}
        MASTER_H2: {{ pillar['MASTER_H2'] }}
        MASTER_H3: {{ pillar['MASTER_H3'] }}
        KUBE_APISERVER_DNS_NAME: {{ pillar['KUBE_APISERVER_DNS_NAME'] }}
        CLUSTER_KUBERNETES_SVC_IP: {{ pillar['CLUSTER_KUBERNETES_SVC_IP'] }}
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare apiserver-kubelet-client && /bin/cp /opt/kubernetes/sslcert/apiserver-kubelet-client.pem /opt/salt/k8s/files/cert/apiserver-kubelet-client.pem && /bin/cp /opt/kubernetes/sslcert/apiserver-kubelet-client-key.pem /opt/salt/k8s/files/cert/apiserver-kubelet-client-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/apiserver-kubelet-client-key.pem





#创建metrics-server使用的证书和私钥
front-proxy-client-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/front-proxy-client-csr.json
    - source: salt://k8s/templates/ca/front-proxy-client-csr.json.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes front-proxy-client-csr.json | cfssljson -bare front-proxy-client && /bin/cp /opt/kubernetes/sslcert/front-proxy-client.pem /opt/salt/k8s/files/cert/front-proxy-client.pem && /bin/cp /opt/kubernetes/sslcert/front-proxy-client-key.pem /opt/salt/k8s/files/cert/front-proxy-client-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/front-proxy-client-key.pem



#创建 kube-controller-manager 证书和私钥
kube-controller-manager-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/kube-controller-manager-csr.json
    - source: salt://k8s/templates/ca/kube-controller-manager-csr.json.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        MASTER_IP_M1: {{ pillar['MASTER_IP_M1'] }}
        MASTER_IP_M2: {{ pillar['MASTER_IP_M2'] }}
        MASTER_IP_M3: {{ pillar['MASTER_IP_M3'] }}
        MASTER_H1: {{ pillar['MASTER_H1'] }}
        MASTER_H2: {{ pillar['MASTER_H2'] }}
        MASTER_H3: {{ pillar['MASTER_H3'] }}
        KUBE_APISERVER_DNS_NAME: {{ pillar['KUBE_APISERVER_DNS_NAME'] }}
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager && /bin/cp /opt/kubernetes/sslcert/kube-controller-manager.pem /opt/salt/k8s/files/cert/kube-controller-manager.pem && /bin/cp /opt/kubernetes/sslcert/kube-controller-manager-key.pem /opt/salt/k8s/files/cert/kube-controller-manager-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/kube-controller-manager-key.pem




#创建和分发 kube-controller-manager的kubeconfig 文件;kube-controller-manager 使用 kubeconfig 文件访问 apiserver，
#该文件提供了 apiserver 地址、嵌入的 CA 证书和 kube-controller-manager 证书等信息
kube-controller-manager-set-cluster:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-cluster kubernetes --certificate-authority=ca.pem --embed-certs=true --server={{ pillar['KUBE_APISERVER'] }} --kubeconfig=kube-controller-manager.kubeconfig

kubectl-controller-manager-set-credentials:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-credentials system:kube-controller-manager --client-certificate=kube-controller-manager.pem --embed-certs=true --client-key=kube-controller-manager-key.pem --kubeconfig=kube-controller-manager.kubeconfig

kubectl-controller-manager-set-context:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-context system:kube-controller-manager@kubernetes --cluster=kubernetes --user=system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig

kubectl-controller-manager-use:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config use-context system:kube-controller-manager@kubernetes --kubeconfig=kube-controller-manager.kubeconfig
  file.copy:
    - user: root
    - group: root
    - mode: 644
    - name: /opt/salt/k8s/files/cert/controller-manager.conf
    - source: /opt/kubernetes/sslcert/kube-controller-manager.kubeconfig
    - force: True

#创建 kube-scheduler 证书和私钥
kube-scheduler-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/kube-scheduler-csr.json
    - source: salt://k8s/templates/ca/kube-scheduler-csr.json.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        MASTER_IP_M1: {{ pillar['MASTER_IP_M1'] }}
        MASTER_IP_M2: {{ pillar['MASTER_IP_M2'] }}
        MASTER_IP_M3: {{ pillar['MASTER_IP_M3'] }}
        MASTER_H1: {{ pillar['MASTER_H1'] }}
        MASTER_H2: {{ pillar['MASTER_H2'] }}
        MASTER_H3: {{ pillar['MASTER_H3'] }}
        KUBE_APISERVER_DNS_NAME: {{ pillar['KUBE_APISERVER_DNS_NAME'] }}
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-scheduler-csr.json | cfssljson -bare kube-scheduler && /bin/cp /opt/kubernetes/sslcert/kube-scheduler.pem /opt/salt/k8s/files/cert/kube-scheduler.pem && /bin/cp /opt/kubernetes/sslcert/kube-scheduler-key.pem /opt/salt/k8s/files/cert/kube-scheduler-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/kube-scheduler-key.pem


#创建和分发 kube-scheduler的kubeconfig 文件;kube-scheduler 使用 kubeconfig 文件访问 apiserver，
#该文件提供了 apiserver 地址、嵌入的 CA 证书和 kube-scheduler 证书
kube-scheduler-set-cluster:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-cluster kubernetes --certificate-authority=/opt/kubernetes/sslcert/ca.pem --embed-certs=true --server={{ pillar['KUBE_APISERVER'] }} --kubeconfig=kube-scheduler.kubeconfig

kubectl-scheduler-credentials:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-credentials system:kube-scheduler --client-certificate=/opt/kubernetes/sslcert/kube-scheduler.pem --embed-certs=true --client-key=/opt/kubernetes/sslcert/kube-scheduler-key.pem --kubeconfig=kube-scheduler.kubeconfig

kubectl-scheduler-context:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-context system:kube-scheduler@kubernetes --cluster=kubernetes --user=system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig

kubectl-scheduler-use:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config use-context system:kube-scheduler@kubernetes --kubeconfig=kube-scheduler.kubeconfig
  file.copy:
    - user: root
    - group: root
    - mode: 644
    - name: /opt/salt/k8s/files/cert/scheduler.conf
    - source: /opt/kubernetes/sslcert/kube-scheduler.kubeconfig
    - force: True


#创建 kube-proxy 证书
kube-proxy-csr-json:
  file.managed:
    - name: /opt/kubernetes/sslcert/kube-proxy-csr.json
    - source: salt://k8s/templates/ca/kube-proxy-csr.json.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy && /bin/cp /opt/kubernetes/sslcert/kube-proxy.pem /opt/salt/k8s/files/cert/kube-proxy.pem && /bin/cp /opt/kubernetes/sslcert/kube-proxy-key.pem /opt/salt/k8s/files/cert/kube-proxy-key.pem
    - unless: test -f /opt/salt/k8s/files/cert/kube-proxy-key.pem



#创建和分发 kube-proxy 的kubeconfig 文件
kubeproxy-set-cluster:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-cluster kubernetes --certificate-authority=/opt/kubernetes/sslcert/ca.pem --embed-certs=true --server={{ pillar['KUBE_APISERVER'] }}  --kubeconfig=kube-proxy.kubeconfig

kubeproxy-set-credentials:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-credentials kube-proxy --client-certificate=/opt/kubernetes/sslcert/kube-proxy.pem --client-key=/opt/kubernetes/sslcert/kube-proxy-key.pem --embed-certs=true --kubeconfig=kube-proxy.kubeconfig

kubeproxy-set-context:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config set-context default --cluster=kubernetes --user=kube-proxy --kubeconfig=kube-proxy.kubeconfig

kubeproxy-use:
  cmd.run:
    - name: cd /opt/kubernetes/sslcert && kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
  file.copy:
    - user: root
    - group: root
    - mode: 644
    - name: /opt/salt/k8s/files/cert/proxy.config
    - source: /opt/kubernetes/sslcert/kube-proxy.kubeconfig
    - force: True



