# Spring Boot App

## 1. 简介

Environment for **Spring Boot** Appication

为运行 **Spring Boot** 应用而提供的环境

## 2. 特性

1. Ubuntu/Alpine
2. OpenJDK 8/17/21
3. TZ=Asia/Shanghai
4. C.UTF-8
5. curl和telnet
6. arthas(在/usr/local/arthas目录下)
7. 运行的jar包：/usr/local/myservice/myservice.jar

## 3. 编译并上传镜像

```sh
# JDK8
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:8 --build-arg VERSION=8 . --push
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:8-alpine --build-arg VERSION=8-alpine . --push
# JDK17
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:17 --build-arg VERSION=17 . --push
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:17-alpine --build-arg VERSION=17-alpine . --push
# JDK21
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:21 --build-arg VERSION=21 . --push
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:21-alpine --build-arg VERSION=21-alpine . --push
```

## 4. 单机

```sh
docker run -d --net=host --name 容器名称 --init -v /usr/local/外部程序所在目录:/usr/local/myservice --restart=always nnzbz/spring-boot-app
```

## 5. Swarm

- Docker Compose

```yaml{.line-numbers}
version: "3.9"
services:
  svr:
    image: nnzbz/spring-boot-app
    init: true
    environment:
      - PROG_ARGS=--spring.profiles.active=prod
      #- JAVA_OPTS=-Xms100M -Xmx100M
    volumes:
      # 初始化脚本
      - /usr/local/xxx-svr/init.sh:/usr/local/myservice/init.sh:z
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
