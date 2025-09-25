---
title: "在 CentOS 7 上安装 MySQL 5.7"
date: 2025-09-25
draft: false
tags: ["MySQL", "CentOS", "数据库", "安装指南"]
categories: ["数据库部署"]
---

本文记录了在 **CentOS 7** 上安装 **MySQL 5.7** 的完整步骤，并提供了可直接运行的脚本。  
请根据实际环境替换文中标注的路径或参数。

## 安装脚本

以下脚本可保存为 `install_mysql57.sh` 并执行：

```bash
#!/bin/bash
# 在 CentOS 7 上安装 MySQL 5.7

# 1. 下载 RPM 仓库配置
# 使用者可根据需要替换本地保存路径
sudo curl -f -s -S -L -o /tmp/mysql57-community-release-el7-11.noarch.rpm \
  https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

# 2. 安装 RPM 仓库
sudo yum localinstall /tmp/mysql57-community-release-el7-11.noarch.rpm -y

# 3. 安装 MySQL 官方公钥
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# 4. 检查仓库是否启用
sudo yum repolist all | grep mysql

# 5. 安装 MySQL 服务器
sudo yum install mysql-community-server -y

# 6. 启动服务
sudo systemctl start mysqld

# 7. 设置开机自启
sudo systemctl enable mysqld

# 8. 获取临时密码
# 使用者需确认日志路径是否一致
sudo grep 'temporary password' /var/log/mysqld.log

# 9. 执行安全配置
sudo mysql_secure_installation
