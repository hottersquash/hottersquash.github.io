---
title: hexo部署脚本
date: 2024-03-31 17:23:38
categories:
  - 编程
tags:
  - 创建文章
---



hexo 部署脚本（同步代码到master）

```bash
#! /bin/bash

hexo clean && hexo generate
echo "生成html文件成功!"

if [[ "$1" == "preview" ]];then
	hexo server
	echo "----------------------------------------"
	exit 0
fi

hexo clean && hexo g -d
echo "部署成功!"

git checkout main 
git add . 
git commit -am ${0}
git push origin main
echo "git同步成功!"

```

