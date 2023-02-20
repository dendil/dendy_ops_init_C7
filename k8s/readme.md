# 机器准备
```bash
192.168.30.96 szmz30-96.host.com #worker
192.168.30.94 szmz30-94.host.com #master
192.168.30.93 szmz30-93.host.com #master
192.168.30.200 szmz30-200.host.com #LB
```



# 添加新节点&新的控制节点
```bash
kubeadm token create --print-join-command
# 运行节点直接加入
kubeadm join 192.168.30.200:6443 --token 6iddz3.dx8dyl73bpgdl0ak --discovery-token-ca-cert-hash sha256:90e24c1b4a42b199cff275179aac655bb51214f5182b489bdab4d23b3ce05544
# 控制节点加入 需要生产证书认证
kubeadm init phase upload-certs --upload-certs
kubeadm join 192.168.30.200:6443 \
    --token 6iddz3.dx8dyl73bpgdl0ak \
    --discovery-token-ca-cert-hash  \
    sha256:90e24c1b4a42b199cff275179aac655bb51214f5182b489bdab4d23b3ce05544 \
    --control-plane \
    --certificate-key \
    0e982e5e92b001943bba8ea0dd748ea4af9046d31e799dabcf0f566903ef5c55
#     ↑ 由 kubeadm init phase upload-certs --upload-certs 生成
```