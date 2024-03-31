---
title: 利用玩客云搭建个人博客hexo
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-31 18:26:21
---


利用玩客云搭建个人博客hexo

<!-- more -->

#### 1、玩客云刷好Armbian5.9系统，最终效果如下图：

<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207140823565.png" alt="image-20221207140823565" style="zoom: 80%;" />



#### 2、安装nodejs，hexo

```bash
# 注意安装armv7版本的node 
下载地址：https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-armv7l.tar.xz
```

其他步骤参考：

[Linux云服务器下Hexo部署及使用]: https://blog.csdn.net/weixin_43538830/article/details/109691629

#### 3、修改_config.yml文件部署到git上

```bash
# 这里只截取关键配置，其他例如git的ssh访问自行百度
deploy:
	type: git
	repo: git@github.com:hottersquash/hottersquash.github.io.git
	branch: main
```

#### 4、最终效果图

![image-20221209145815566](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221209145815566.png)

