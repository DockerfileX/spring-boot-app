# Spring Boot App

## 1. 简介

Environment for **Spring Boot** Appication

为运行 **Spring Boot** 应用而提供的环境

## 2. 特性

1. Alpine
2. OpenJDK 8
3. TZ=Asia/Shanghai
4. C.UTF-8
5. 运行的jar包：/usr/local/myservice/myservice.jar

## 3. 编译

```sh
docker build -t nnzbz/spring-boot-app:1.0.6 .
# latest
docker tag nnzbz/spring-boot-app:1.0.6 nnzbz/spring-boot-app:latest
```

## 3. 上传镜像

```sh
docker push nnzbz/spring-boot-app:1.0.6
docker push nnzbz/spring-boot-app:latest
```

## 4. 创建并运行容器

```sh
docker run -d --net=host --name 容器名称 -v /usr/local/外部程序所在目录:/usr/local/myservice --restart=always nnzbz/spring-boot-app
```
