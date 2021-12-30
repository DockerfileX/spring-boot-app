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
6. arthas(在/usr/local目录下)
7. 运行的jar包：/usr/local/myservice/myservice.jar

## 3. 编译并上传镜像

```sh
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:1.0.8 . --push
# latest
docker buildx build --platform linux/arm64,linux/amd64 -t nnzbz/spring-boot-app:latest . --push
```

## 4. 单机

```sh
docker run -d --net=host --name 容器名称 --init -v /usr/local/外部程序所在目录:/usr/local/myservice --restart=always nnzbz/spring-boot-app
```

## 5. Swarm

```yaml{.line-numbers}
version: "3.9"
services:
  xxx-svr:
    image: nnzbz/spring-boot-app
    init: true
    environment:
      - PROG_ARGS=--spring.profiles.active=prod
      #- JAVA_OPTS=-Xms100M -Xmx100M
    volumes:
      # 配置文件目录
      - /usr/local/xxx-svr/config/:/usr/local/myservice/config/:z
      - /usr/local/xxx-svr/xxx-svr-x.x.x.jar:/usr/local/myservice/myservice.jar:z
    deploy:
      # 默认副本数先设置为1，启动好后再用 scale 调整，以防第一次启动初始化时并发建表
      replicas: 1

networks:
  default:
    external: true
    name: rebue
```
