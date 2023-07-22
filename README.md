# Spring Boot App

## 1. 简介

Environment for **Spring Boot** Appication

为运行 **Spring Boot** 应用而提供的环境

## 2. 特性

1. Alpine
2. OpenJDK 8
3. TZ=Asia/Shanghai
4. C.UTF-8
5. curl和telnet
6. arthas(在/usr/local/arthas目录下)
7. SkyWalking Agent(在/usr/local/skywalking/agent目录下)
8. 运行的jar包：/usr/local/myservice/myservice.jar

## 3. 编译并上传镜像

```sh
# JDK8
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:8 --build-arg VERSION=8 . --push
# latest
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:latest --build-arg VERSION=8 . --push
# JDK18
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:18 --build-arg VERSION=18 . --push
```

## 4. 单机

```sh
docker run -d --net=host --name 容器名称 --init -v /usr/local/外部程序所在目录:/usr/local/myservice --restart=always nnzbz/spring-boot-app
```

## 5. Swarm

- 初始化 `SkyWalking Agent` 插件的脚本

```sh
#!/bin/sh
#####################################################################################
# Docker容器启动时要运行的脚本 															#
#####################################################################################
# 添加插件
mv ${SKYWALKING_AGENT_DIR}/optional-plugins/apm-mybatis-3.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/plugins/
mv ${SKYWALKING_AGENT_DIR}/optional-plugins/apm-spring-webflux-5.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/plugins/
mv ${SKYWALKING_AGENT_DIR}/optional-plugins/apm-trace-ignore-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/plugins/
# 移除不用的插件
mv ${SKYWALKING_AGENT_DIR}/plugins/dubbo-3.x-conflict-patch-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
mv ${SKYWALKING_AGENT_DIR}/plugins/apm-dubbo-3.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
mv ${SKYWALKING_AGENT_DIR}/plugins/apm-springmvc-annotation-3.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
mv ${SKYWALKING_AGENT_DIR}/plugins/apm-springmvc-annotation-4.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
mv ${SKYWALKING_AGENT_DIR}/plugins/apm-springmvc-annotation-5.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
mv ${SKYWALKING_AGENT_DIR}/plugins/apm-mysql-6.x-plugin-${SKYWALKING_AGENT_VERSION}.jar ${SKYWALKING_AGENT_DIR}/optional-plugins/
```

- Docker Compose

```yaml{.line-numbers}
version: "3.9"
services:
  svr:
    image: nnzbz/spring-boot-app
    init: true
    environment:
      - PROG_ARGS=--spring.profiles.active=prod
      # 启用SkyWalking Agent
      - ENABLE_SKYWALKING_AGENT=true
      # Agent的项目名称
      - SW_AGENT_NAME=xxx-svr
      # SkyWalking OAP 服务器的地址
      - SW_AGENT_COLLECTOR_BACKEND_SERVICES=skywalking-oap:11800
      #- JAVA_OPTS=-Xms100M -Xmx100M
    volumes:
      # 初始化脚本
      - /usr/local/xxx-svr/init.sh:/usr/local/myservice/init.sh:z
      # SkyWalking Agent的配置文件
      - /usr/local/xxx-svr/config/apm-trace-ignore-plugin.config:/usr/local/skywalking/agent/config/apm-trace-ignore-plugin.config:z
      # 配置文件目录
      - /usr/local/xxx-svr/config/:/usr/local/myservice/config/:z
      # 运行的jar包
      - /usr/local/xxx-svr/xxx-svr-x.x.x.jar:/usr/local/myservice/myservice.jar:z
    deploy:
      placement:
        constraints:
          # 部署的节点指定是app角色的
          - node.labels.role==app
      # 默认副本数先设置为1，启动好后再用 scale 调整，以防第一次启动初始化时并发建表
      replicas: 1

networks:
  default:
    external: true
    name: rebue
```

- 部署

```sh
docker stack deploy -c /usr/local/xxx-svr/stack.yml xxx
```
