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

```yaml
version: "3.9"
services:
  rac-svr:
    image: nnzbz/spring-boot-app
    init: true
    environment:
      - PROG_ARGS=--spring.profiles.active=prod
      #- JAVA_OPTS=-Xms100M -Xmx100M
    volumes:
      # 配置文件目录
      - /usr/local/rac-svr/config/:/usr/local/myservice/config/
      - /usr/local/rac-svr/rac-svr-1.2.4.jar:/usr/local/myservice/myservice.jar
    deploy:
      replicas: 3

networks:
  default:
    external: true
    name: rebue
```
