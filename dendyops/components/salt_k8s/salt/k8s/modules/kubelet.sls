# -*- coding: utf-8 -*-
#******************************************
# Author:       skymyyang
# Email:        yang-li@live.cn
# Organization: https://www.cnblogs.com/skymyyang/
# Description:  Kubernetes Node kubelet
#******************************************

{% set k8s_version = "k8s-v1.18.2" %}

include:
  - k8s.modules.cni
  - k8s.modules.docker

kubelet-workdir:
  file.directory:
    - name: /var/lib/kubelet
    - mode: 755
kubelet-service-d:
  file.directory:
    - name: /usr/lib/systemd/system/kubelet.service.d
    - mode: 755


#创建 kubelet bootstrap kubeconfig 文件
kubelet-bootstrap-kubeconfig:
  file.managed:
    - name: /etc/kubernetes/bootstrap-kubelet.conf
    - source: salt://k8s/files/cert/bootstrap-kubelet.conf
    - user: root
    - group: root
    - mode: 644

#拷贝CA证书
ca-pem-pki:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - name: /etc/kubernetes/pki/ca.pem
    - source: salt://k8s/files/cert/ca.pem
    - replace: False


ca-key-pem-pki:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - name: /etc/kubernetes/pki/ca-key.pem
    - source: salt://k8s/files/cert/ca-key.pem
    - replace: False

kubelet-bin:
  file.managed:
    - name: /usr/local/bin/kubelet
    - source: salt://k8s/files/{{ k8s_version }}/bin/kubelet
    - user: root
    - group: root
    - mode: 755
kubelet-kubeadm-conf:
  file.managed:
    - name: /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
    - source: salt://k8s/templates/kubelet/10-kubeadm.conf.template
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
        HOST_NAME: {{ pillar['HOST_NAME'] }}
kubelet-config-yaml:
  file.managed:
    - name: /var/lib/kubelet/config.yaml
    - source: salt://k8s/templates/kubelet/kubelet-conf.yml.template
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        CLUSTER_DNS_SVC_IP: {{ pillar['CLUSTER_DNS_SVC_IP'] }}
        CLUSTER_DNS_DOMAIN: {{ pillar['CLUSTER_DNS_DOMAIN'] }}
kubelet-service:
  file.managed:
    - name: /usr/lib/systemd/system/kubelet.service
    - source: salt://k8s/templates/kubelet/kubelet.service.template
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: systemctl daemon-reload
  service.running:
    - name: kubelet
    - enable: True
    - watch:
      - file: kubelet-kubeadm-conf
