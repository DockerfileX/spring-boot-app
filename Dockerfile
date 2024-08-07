ARG VERSION

# 基础镜像
FROM --platform=${TARGETPLATFORM} nnzbz/temurinx:${VERSION}

# 如果这里不重复定义参数，后面会取不到参数的值
ARG VERSION

# 作者及邮箱
# 镜像的作者和邮箱
LABEL maintainer="nnzbz@163.com"
# 镜像的版本
LABEL version=${VERSION}
# 镜像的描述
LABEL description="Environment for Spring Boot Appication\
    为运行Spring Boot Application而提供的环境"

# 设置工作目录
ENV WORKDIR=/usr/local/myservice
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

# Java选项
ENV JAVA_OPTS=""
# 运行jar包的文件名
ENV MYSERVICE_FILE_NAME=myservice.jar

RUN touch init.sh
RUN echo '#!/bin/sh' >> entrypoint.sh
RUN echo 'set +e' >> entrypoint.sh
RUN echo 'sh ./init.sh' >> entrypoint.sh
RUN echo 'CMD="java ${JAVA_OPTS} -jar ${MYSERVICE_FILE_NAME} ${PROG_ARGS}"' >> entrypoint.sh
RUN echo 'echo $CMD' >> entrypoint.sh
RUN echo 'exec $CMD' >> entrypoint.sh

RUN chmod +x ./init.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["sh", "./entrypoint.sh"]
