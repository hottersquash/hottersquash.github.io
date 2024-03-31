---
title: 玩客云编译comfast-cf-811ac-armhfv7版本驱动实现wifi上网
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-31 18:26:22
---


玩客云下编译comfast cf-811ac驱动实现wifi上网

<!-- more -->

环境：

<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221207140823565.png" alt="image-20221207140823565" style="zoom: 80%;" />



1、克隆源码，安装编译环境

```bash
# 克隆项目
git clone https://github.com/brektrou/rtl8821CU.git
# 安装编译环境
sudo apt install gcc g++ build-essential git dkms
```

参考文章: 

[Linux安装comfast 811AC usb网卡驱动]: https://blog.csdn.net/mzjmzjmzjmzj/article/details/104725817	"Linux安装comfast 811AC usb网卡驱动"



2、安装linux-header文件

header文件地址: https://pan.baidu.com/s/1X-HmzyQHKUpe1-ZivJ_gjg?pwd=760r 

```bash
```bash 
# 安装头文件,安装完成 /usr/src会出现linux-headers-5.9.0-rc7-aml-s812文件夹
dpkg -i linux-headers-current-aml-s812_20.11_armhf.deb
# 创建文件夹
mkdir -p /lib/modules/5.9.0-rc7-aml-s812/kernel
# 复制文件到指定目录
cp -r /usr/src/linux-headers-5.9.0-rc7-aml-s812/* /lib/modules/5.9.0-rc7-aml-s812/kernel/
```

参考链接：

[armbian版本5.9.0-rc7-aml-s812安装后，安装其他软件提示要内核头文件]: https://www.right.com.cn/FORUM/thread-6311941-1-1.html
[玩客云Armbian_20.11_Aml-s812_5.9.0-支持USB-WIFI最终完美版.img.xz]: https://www.right.com.cn/forum/forum.php?mod=viewthread&amp;tid=4103842&amp;page=1#pid11108017



3、解决兼容性问题

```bash
sudo cp /lib/modules/5.9.0-rc7-aml-s812/build/arch/arm/Makefile /lib/modules/5.9.0-rc7-aml-s812/build/arch/arm/Makefile.0957

sudo sed -i 's/-msoft-float//' /lib/modules/5.9.0-rc7-aml-s812/build/arch/arm/Makefile

sudo ln -s /lib/modules/5.9.0-rc7-aml-s812/build/arch/arm /lib/modules/5.9.0-rc7-aml-s812/build/arch/armv7l
```

参考链接：

https://github.com/brektrou/rtl8821CU

https://github.com/fastoe/RTL8811CU_for_Raspbian



4、编译

```bash
cd rtl8821CU-master
vim Makefile 
# 修改编译文件中两个参数如下：
# CONFIG_PLATFORM_I386_PC=n
# CONFIG_PLATFORM_ARM_RPI=y
# wq保存，之后开始编译
sudo make
# 等待结束之后即可编译完成
sudo make install
# 重启机器
sudo reboot

# 检查是否安装成功，若出现8821cu.ko文件即表示安装完成
ls /lib/modules/$(uname -r)/kernel/drivers/net/wireless/realtek/rtl8821cu
```

参考链接：同1



5、设置静态ip和启动wifi

```bash
打开armbian的图形化设置，先指定静态wifi的静态ip，然后拔掉网线，重启网络服务即可
armbian-config

# 重启网络服务
/etc/init.d/networking restart
```

参考链接：https://blog.csdn.net/weixin_39988888/article/details/112128801

<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221210145929563.png" alt="image-20221210145929563" style="zoom: 80%;" />



<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221210150156172.png" alt="image-20221210150156172" style="zoom:80%;" />



<img src="https://picture-byan.obs.cn-east-3.myhuaweicloud.com/imgs_byan/image-20221210150328040.png" alt="image-20221210150328040" style="zoom:80%;" />
