
docker pull grafana/grafana
mkdir -p /opt/grafana/data /opt/grafana/

docker run  \
-d \
-p 3000:3000 \
--name=grafana \
-v /opt/grafana/data:/var/lib/grafana \
grafana/grafana