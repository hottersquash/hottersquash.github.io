---
title: BaiduPCS-Go更新脚本
author: hottersquash
tags:
  - 玩客云
  - 刷机
categories:
  - 编程
date: 2024-03-31 18:29:38
---
### BaiduPCS-Go更新脚本

git链接：https://github.com/qjfoidnh/BaiduPCS-Go

更新脚本

```bash

#! /bin/bash

# 本地保存路径
LOCAL_MUSIC_ROOT_PATH="/root/mydisk/software/navidrome/music/music"
# 远程路径
REMOTE_MUSIC_ROOT_PATH="/apps/music"
# 程序所在路径
EXEC_FILE_PATH="/root/mydisk/software/baiduPCS/BaiduPCS-Go"

# 遍历队列
array[0]="different $REMOTE_MUSIC_ROOT_PATH $LOCAL_MUSIC_ROOT_PATH"
index=0

# BFS获取差异文件数组
function different(){
	# 本地根目录
	NOW_LOCAL_PATH=${2}
	cd ${NOW_LOCAL_PATH}
	# 本地文件列表
	NOW_LOCAL_ARRAY=(`ls -l | awk '{print $9}'`)

	# 远程根目录
	NOW_REMOTE_PATH=${1}
	${EXEC_FILE_PATH} cd ${NOW_REMOTE_PATH}
	# 远程文件列表
	NOW_REMOTE_ARRAY=(`${EXEC_FILE_PATH} ls -l | awk '{print $9}'`)

	# 下载
	for var in ${NOW_REMOTE_ARRAY[*]}:
	do
		# 远程文件路径
		NOW_REMOTE_FILE=${NOW_REMOTE_PATH}"/"${var}
		# 本地文件路径
		NOW_LOCAL_FILE=${NOW_LOCAL_PATH}"/"${file}
		echo "${NOW_REMOTE_FILE}"

		# 是文件夹
		if [ -d ${NOW_REMOTE_FILE} ]; then
  			# 本地存在，加入队列
      if [ -d ${NOW_LOCAL_FILE} ]; then
        array[${#array[@]}]="diff ${NOW_REMOTE_FILE} ${NOW_LOCAL_FILE}"
			else # 本地不存在直接开始下载
				${EXEC_FILE_PATH} d ${NOW_REMOTE_FILE} --saveto ${NOW_LOCAL_PATH}
			fi
  		# 文件
  	else
  			# 本地不存在
  			if [ ! -f ${NOW_LOCAL_FILE} ]; then
				${EXEC_FILE_PATH} d ${NOW_REMOTE_FILE} --saveto ${NOW_LOCAL_PATH}
			  fi
  	fi
	done


	# 上传
	for var in ${NOW_LOCAL_ARRAY[*]}:
	do
		# 远程文件路径
		NOW_REMOTE_FILE=${NOW_REMOTE_PATH}"/"${var}
		# 本地文件路径
		NOW_LOCAL_FILE=${NOW_LOCAL_PATH}"/"${file}
		echo "${NOW_REMOTE_FILE}"

		# 是文件夹
		if [ -d ${NOW_LOCAL_FILE} ]; then
  		# 云端不存在
      if [ ! -d ${NOW_REMOTE_FILE} ]; then
        # 直接开始上传
				${EXEC_FILE_PATH} u ${NOW_LOCAL_FILE}
			fi
  		# 文件
    else
      # 云端不存在
      if [ ! -f ${NOW_REMOTE_FILE} ]; then
				${EXEC_FILE_PATH} u ${NOW_LOCAL_FILE}
      fi
    fi
	done
}

# 开始遍历
while ((index<${#array[*]}))
do
	# 从命令列表中取出命令
  command=${array[${index}]}
  let index+=1
	echo "当前执行命令："${command}
  # 执行命令
	eval ${command}
done



```

