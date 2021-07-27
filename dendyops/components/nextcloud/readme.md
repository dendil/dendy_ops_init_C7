# mysql安装


docker run --name=nextcloud_db -e MYSQL_ROOT_PASSWORD=123456 -d -p 3306:3306 --restart=always mysql:5


docker exec -it nextcloud_db mysql -u root -p
CREATE DATABASE nextcloud;
GRANT ALL ON *.* TO 'root'@'%';
flush privileges;
exit;




docker run -itd --restart always --name=nextcloud --link nextcloud_db:db -p 5580:6880 -v /data/docker/nextcloud:/var/www/html docker.io/nextcloud:latest

docker run -i -t -d -p 6880:6880 --restart=always -v /data/docker/onlyoffice/log:/var/log/onlyoffice -v /data/docker/onlyoffice/data:/var/www/onlyoffice/Data -v /data/docker/onlyoffice/lib:/var/lib/onlyoffice -v /data/docker/onlyoffice/db:/var/lib/postgresql  onlyoffice/documentserver
