# 基础镜像
FROM --platform=${TARGETPLATFORM} nnzbz/openjdk

# 作者及邮箱
# 镜像的作者和邮箱
LABEL maintainer="nnzbz@163.com"
# 镜像的版本
LABEL version="1.0.9"
# 镜像的描述
LABEL description="Environment for Spring Boot Appication\
    为运行Spring Boot Application而提供的环境"

# 设置工作目录
ENV WORKDIR=/usr/local/myservice
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

# Java选项
ENV JAVA_OPTS=""
# Java Agent
ENV JAVA_AGENT=""
# 系统属性
ENV SYS_PROP=""
# 运行jar包的文件名
ENV MYSERVICE_FILE_NAME=myservice.jar

RUN touch init.sh
RUN echo '#!/bin/sh' >> entrypoint.sh
RUN echo 'set +e' >> entrypoint.sh
RUN echo 'if [ ${ENABLE_SKYWALKING_AGENT:false} ];then' >> entrypoint.sh
RUN echo '    export JAVA_AGENT=-javaagent:${SKYWALKING_AGENT_DIR}/skywalking-agent.jar' >> entrypoint.sh
RUN echo 'fi' >> entrypoint.sh
RUN echo 'sh ./init.sh' >> entrypoint.sh
RUN echo 'CMD="java ${JAVA_OPTS} -cp . ${SYS_PROP} -Djava.security.egd=file:/dev/./urandom -XX:+UseG1GC -server ${JAVA_AGENT} -jar ${WORKDIR}/${MYSERVICE_FILE_NAME} ${PROG_ARGS}"' >> entrypoint.sh
RUN echo 'echo $CMD' >> entrypoint.sh
RUN echo '$CMD' >> entrypoint.sh

RUN chmod +x ./init.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]
