---
title: 利用Cloudflare+Nginx实现ipv4访问纯ipv6的各种服务
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-31 18:26:20
---

### 利用**Cloudflare** + **Nginx** + **ddns-go** 实现**ipv4**访问纯**ipv6**的服务器

**前提条件：ipv6 + 域名**

####  一、需求描述

​	在公司（ipv4环境）想访问的家里的玩客云（ipv6环境）的笔记和音乐服务

#### 二、实现原理：

​	(这里用aab.cn域名举例，假设服务器提供两种服务：note笔记服务(端口9000)、music音乐服务(端口4533))

1. Cloudflare提供免费dns解析和代理功能，代理功能相当于一台同时具有ipv4/ipv6的服务器帮你做中继转发。
2. ddns-go用来做域名和ipv6地址绑定上报
3. 用不同子域名来区分各种服务： note.aab.cn对应note服务，music.aab.cn对应music服务
4. Cloudflare将访问aab.cn请求都打到服务器同一个端口8880上，服务器上用nginx统一监听该端口，根据子域名转发到匹配的服务端口。

![image-20230507101642706](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507101642706.png)

#### 三、实现步骤

**注意：1、 所有Cloudflare的操作不会立刻生效，都需要等一段时间！！！**

​			**2、Chrome没有Edge表现好，如果Chrome一直转圈圈，可以换Edge试试**



**具体步骤**

1、注册Cloudflare，绑定域名，到**域名提供商网站**上去修改dns server（比如我的是阿里云，去阿里云域名管理里面修改即可）

参考：https://www.kuajingyuan.com/set-cloudflare-as-dns-server

![image-20230507102318419](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507102318419.png)



2、获取**授权令牌**，安装**ddns-go**，设置ddns-go的域名记录上报，这里的子域名可以随便写（一个服务对应一个子域名），只要后面步骤nginx的配置文件能对应上就行。

具体步骤参考：https://zhuanlan.zhihu.com/p/581967733

![image-20230507103204003](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507103204003.png)



3、等待域名上报生效，ddns-go配置成功后，应该会出现如下记录，然后逐个**点亮**那个云朵，开启代理功能。

![image-20230507103344763](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507103344763.png)



4、设置回溯端口，统一将请求转发到服务器的同一个端口上

![image-20230507103652619](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507103652619.png)



点击创建规则，点击保存，等待规则生效，现在完成了代理服务器的设置。规则如下图：

![image-20230507103741356](https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20230507103741356.png)

5、服务器开放防火墙8880端口，然后配置并重启nginx，配置中的子域名要和第2步中的上报域名一致，然后server中服务端口自定义即可。下面贴出nginx.conf配置：

```conf
events {
        worker_connections 768;
        # multi_accept on;
}

http {
        server_names_hash_bucket_size 64;
        client_max_body_size 0;
        server {
                listen       [::]:8880 ;
                server_name  note.hottersquash.top;
                location / {
                        proxy_pass      http://localhost:9001;
                }
        }

        server {
                listen       [::]:8880 ;
                server_name  docker.hottersquash.top;
                location / {
                        proxy_pass      http://localhost:9000;
                }
        }


        server {
                listen       [::]:8880 ;
                server_name  nav.hottersquash.top;
                location / {
                        proxy_pass      http://localhost:4533;
                }
        }

        server {
                listen       [::]:8880 ;
                server_name  ql.hottersquash.top;
                location / {
                        proxy_pass      http://localhost:5600;
                }
        }

        server {
                listen       [::]:8880 ;
                server_name  hottersquash.top;
                location / {
                        proxy_pass      http://localhost:8081;
                }
        }

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        }
```



6、如果一切顺利，现在即可实现外网访问。



#### 四、问题

1、Cloudflare的**速度着实很慢**，所以只适合及时性不太高的任务。

2、如果想某个服务直接通过ipv6访问，不走代理，可以在步骤中的第3步不点亮那个云朵即可（我这边的ssh服务就不想走代理，所以没有点亮）。



本文参考文章：[NAS那些事儿 篇一：纯IPV4访问纯IPV6且内网穿透](https://post.smzdm.com/p/awxlgpvk/)