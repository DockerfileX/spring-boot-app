# 基础镜像
FROM --platform=${TARGETPLATFORM} nnzbz/openjdk

# 作者及邮箱
# 镜像的作者和邮箱
LABEL maintainer="nnzbz@163.com"
# 镜像的版本
LABEL version="1.0.6"
# 镜像的描述
LABEL description="Environment for Spring Boot Appication\
为运行Spring Boot Application而提供的环境"

# 设置工作目录
ENV WORKDIR=/usr/local/myservice
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

# JAVA选项
ENV JAVA_OPTS=""
# 系统属性
ENV SYS_PROP=""
# 运行jar包的文件名
ENV MYSERVICE_FILE_NAME=myservice.jar

# 运行服务
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -cp . ${SYS_PROP} -Djava.security.egd=file:/dev/./urandom -XX:+UseG1GC -server -jar ${MYSERVICE_FILE_NAME} ${PROG_ARGS}"]
