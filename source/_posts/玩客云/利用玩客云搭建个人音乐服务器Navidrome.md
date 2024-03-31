---
title: 利用玩客云搭建个人音乐服务器Navidrome
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-31 18:26:21
---

### 玩客云利用Navidrome搭建个人音乐服务器

**需求简介**：最近酷狗会员到期，发现年费涨价，舍不得钱，用闲着的玩客云搭建一个云服务听听歌。

#### 一、简介

​		**Navidrome** 是一开源的音乐服务器，可以用来自建云端音乐播放器，在网页听硬盘中存的歌曲，兼容 Subsonic、Aironic 播放器，支持跨平台，具体介绍见：https://www.appinn.com/navidrome/。

体验网站：https://demo.navidrome.org/   账户密码：demo/demo

​		使用前提：拥有公网ip或者ipv6+域名，

​		最终效果截图：

![image-20230402113309964](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230402113309964.png)



#### 二、搭建教程

**1、安装docker**



**2、拉镜像**，选择arm/v7架构，镜像地址：https://hub.docker.com/r/deluan/navidrome

```bash
docker pull deluan/navidrome:develop@sha256:d7610fc239c8e541db82d6bff59091d8f807310fd20a2cd96443ba421fbac588
```



**3、创建数据文件夹**

```bash
mkdir ~/app/music/music ~/app/music/data
```



**4、创建容器，启动容器**

```bash
# 镜像重命名
docker tag 镜像id 仓库名:tag
# 启动
docker run -d --name navidrome --restart=unless-stopped --user $(id -u):$(id -g) -v /root/mydisk/software/navidrome/music/music:/music -v /root/mydisk/software/navidrome/music/data:/data -p 4533:4533 -e ND_LOGLEVEL=info 镜像id
```

![image-20230402114739351](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230402114739351.png)



**5、设置**。在 ***~/app/music/music*** 路径下添加mp3音乐，浏览器输入***http://玩客云ip:4533/***，即可（访问不了，检查防火墙、端口、容器日志），支持中文，个人设置。

![image-20230402113309964](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230402113309964.png)

**6、跨平台**。安卓推荐：**Symfonium**，安装之后选择添加Subsonic源，填上ip、端口、用户名密码，直接add Server即可（安装包在文尾），免费的推荐**DSub**

<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/117f9a1cc7f8c78f3810d8d2f55356c.jpg" alt="117f9a1cc7f8c78f3810d8d2f55356c" style="zoom:50%;" />





附件：

Symfonium 安装包：链接：https://pan.baidu.com/s/15ZiTJWH51TZHoEaiJLP4sg?pwd=eqk3 

Substracks安卓安装包：https://pan.baidu.com/s/1rHv9vTa0ujndBgBnjoONxA?pwd=jd05 

DSub 安卓安装包： 链接：https://pan.baidu.com/s/1R5gIi8f1gpYKTSwR3KcPSQ?pwd=xt2g 
