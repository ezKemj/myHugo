---
title: "CentOS 7 更换 YUM 镜像源并更新系统"
date: 2025-09-25
draft: false
tags: ["CentOS", "YUM", "Linux", "系统优化"]
categories: ["系统运维"]
---

在国内环境下，使用默认的 CentOS 官方仓库可能会遇到速度较慢的问题。  
本文提供一个脚本，帮助你快速切换到新的镜像源，并完成系统更新。  

## 脚本内容

以下脚本可保存为 `update_yum_repo.sh` 并执行：

```bash
#!/bin/bash
# 更新 CentOS 7 YUM 仓库配置并切换到新的镜像源

# 1. 备份原有仓库配置
sudo mkdir -p /etc/yum.repos.d/backup
sudo mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/

# 2. 下载新的仓库配置文件
# 使用者需根据实际情况替换资源路径
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -o /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo

# 3. 清理缓存并重建
sudo yum clean all
sudo yum makecache

# 4. 更新系统
sudo yum update -y
