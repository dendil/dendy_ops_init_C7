FROM app.lianziyou.tech:5000/public/amazoncorretto:11
ENV TZ=Asia/Shanghai
# ENV JAVA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ADD ./target/ygt-biz-1.0-SNAPSHOT.jar /app.jar
ENV JAVA_OPTS=$JAVA_OPTS
ENV ENV_OPTS=$ENV_OPTS
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Duser.timezone=Asia/Shanghai -Dfile.encoding=utf8 -Djava.security.egd=file:/dev/./urandom -jar /app.jar $ENV_OPTS" ]
