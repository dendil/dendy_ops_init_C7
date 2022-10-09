# a

```bash
if [ command  -v docker ];then
docker pull prom/prometheus
mkdir -p /opt/prometheus  /opt/prometheus/data
cp /opt/dendyops/components/prometheus/prometheus.yml  /opt/prometheus/

docker0_ip=`ip a |grep docker0 |grep inet|awk '{print$2}'|awk -F\/ '{print$1}'`
sed -i "s/127.0.0.1/${docker0_ip}/" /opt/prometheus/prometheus.yml

docker run -d \
 --name prometheus \
 -p 9090:9090 \
 --restart=always \
 -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
 -v /etc/localtime:/etc/localtime:ro \
 -v /opt/prometheus/data:/prometheus \
 prom/prometheus

else
    echo 'command docker not  exist!!!'
fi




```