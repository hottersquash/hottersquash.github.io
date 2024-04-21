---
title: 记一次mysql远程访问权限问题.md
date: 2024-04-21 16:32:32
categories:
  - 编程
  - 数据库
---



今天装mariadb，准备开ipv6远程访问mysql，按照网上教程用命令开启：

```mysql
grant all privileges on *.* to root@"%" identified by "password" with grant option;
FLUSH PRIVILEGES;
```



结果死活连不上，一直以为是**ipv6的问题**导致失败，于是修改配置文件**50-server.cnf**的bind-address为::

```bash
[mysqld]
bind-address = ::
```



重启mysql，结果还是连不上，最后无奈，把日志打开，发现一直报错

```bash
Access denied for user 'root'@'xxxxxxxx' (using password: YES)
```



登录mysql，查看用户表

```mysql
select host, password, user from mysql.user;
```



恍然大悟，是最开始的授权指令后面的**identified by "password"** 导致的root密码和root开始设置的密码混淆了

![image-20240421174724290](https://picture-byan.obs.cn-east-3.myhuaweicloud.com//imgs_byan/image-20240421174724290.png)



重新设置密码

```bash
set password for ipv6test@'%' = password('xxxxxxx')
```



最后成功解决!!!
