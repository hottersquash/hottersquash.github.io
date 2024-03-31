---
title: 利用玩客云部署leanote打造个人笔记系统
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-3118:26:22
---


玩客云部署leanote打造个人笔记系统

<!-- more -->

1、玩客云刷好Armbian5.9系统，具体刷法参考下方链接 

[玩客云刷机教程]: https://www.bilibili.com/video/BV1rF411V7Lt/?share_source=copy_web&amp;vd_source=c816ac75903f257baf237ee7014ef127	"玩客云 免拆/拆机刷armbian +内网穿透ssh远程登录 +自动挂载硬盘 作为linux主机/服务器"

最终效果如下图：

<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207140823565.png" alt="image-20221207140823565" style="zoom: 80%;" />



2、安装docker

```bash
# 更新软件包信息
apt update
# 安装docker
apt install docker -y
# 查看docker版本,显示版本信息即为安装成功
docker -v
```

![image-20221207142231066](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207142231066.png)

3、利用docker安装arm32版的mongo，并配置相关volume

```bash
# 拉取mongo镜像
docker pull apcheamitru/arm32v7-mongo
# 创建mongo数据卷对应的物理文件夹，等会和容器做映射
mkdir  -p $HOME/mongo/data/db $HOME/mongo/data/configdb  $HOME/mongo/data/log 
# 查看镜像
docker images
```

![image-20221207145725209](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207145725209.png)

4、下载lenanote的arm版本

官方github地址：

http://sourceforge.net/projects/leanote-bin/files/2.6.1/leanote-linux-arm-v2.6.1.bin.tar.gz

度盘地址:

https://pan.baidu.com/s/1HqO7776w2dygQgsr5B35Rg?pwd=zfc0 



5、将mongo初始化文件cp到上面的volume目录

```bash
# 解压文件
tar -xvf leanote-linux-arm-v2.6.1.bin.tar.gz
# 复制mongo初始化文件到第3步创建的文件夹中 
cp -r ./leanote/mongodb_backup/* $HOME/mongo/data/db/
```



6、启动mongo容器

```bash
# 启动容器
docker run -itd --name mongo --restart=always --privileged -p 27017:27017 -v $HOME/mongo/data/db:/data/db -v $HOME/mongo/data/configdb:/data/configdb -v $HOME/mongo/data/log:/data/log apcheamitru/arm32v7-mongo:latest

# 参数说明
-p 端口映射，格式：物理机端口:容器端口
-v 挂载数据卷，格式：物理机文件夹:容器文件夹
--restart=always 挂掉自动重启
--privileged 使容器拥有真正的root权限

# 查看容器
docker ps
```

![image-20221207145825277](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207145825277.png)



7、进入容器，执行初始化脚本

```bash
# 进入容器
docker exec -it mongo bash

# 找到挂载数据卷目录
cd /data/db

# 导入数据
mongorestore -h localhost -d leanote --dir leanote_install_data
# 导出命令，备份的时候用
# mongodump -h localhost -d leanote -o <dir> 

# 退出容器
exit
```



8、运行leanote

```bash
# 运行
sh leanote/bin/run.sh
# 访问测试，默认是9000端口，具体配置见conf/app.conf
http://ip:9000/
```

![image-20221207145224124](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207145224124.png)



