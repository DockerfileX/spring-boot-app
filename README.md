# Spring Boot App

## 1. 特性

1. CentOS 7
2. JDK 8
3. TZ=Asia/Shanghai
4. en_US.UTF-8
5. 运行的jar包：/usr/local/myservice/myservice.jar

## 2. 拉取与制作标签

1. pull

   在自动构建后，拉取下来

   ```sh
   docker pull nnzbz/spring-boot-app
   ```

2. tag(注意修改**xxx**为当前版本号)

   ```sh
   docker tag nnzbz/spring-boot-app:latest nnzbz/spring-boot-app:xxx
   ```

3. push(注意修改**xxx**为当前版本号)

   ```sh
   docker push nnzbz/spring-boot-app:xxx
   ```

## 3. 创建并运行容器

```sh
docker run -d --net=host --name 容器名称 -v /usr/local/外部程序所在目录:/usr/local/myservice --restart=always nnzbz/spring-boot-app
```
