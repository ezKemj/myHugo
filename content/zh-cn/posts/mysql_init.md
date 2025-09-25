---
title: "MySQL 初始化用户与数据库及防火墙配置"
date: 2025-09-25
draft: false
tags: ["MySQL", "数据库", "权限管理", "防火墙"]
categories: ["数据库运维"]
---

本文提供一个 MySQL 初始化脚本示例，涵盖用户创建、数据库创建、权限分配以及防火墙端口配置。  
请根据实际环境替换用户名、密码、数据库名和端口号。

## 脚本内容

以下脚本可保存为 `mysql_init.sh` 并执行：

```bash
#!/bin/bash
# MySQL 初始化用户、数据库及防火墙配置示例
# 使用者需替换用户名、密码、数据库名等为实际环境

mysql -u root -p <<'EOF'
-- 创建用户（如已存在请先删除）
CREATE USER 'your_user'@'%' IDENTIFIED BY 'your_password';

-- 更新用户密码
ALTER USER 'your_user'@'%' IDENTIFIED BY 'your_password';

-- 创建数据库（使用者需替换为实际数据库名）
CREATE DATABASE IF NOT EXISTS your_db1 CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS your_db2 CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- 授权用户访问数据库
GRANT ALL PRIVILEGES ON `your_db1`.* TO 'your_user'@'%';
GRANT ALL PRIVILEGES ON `your_db2`.* TO 'your_user'@'%';

-- 刷新权限
FLUSH PRIVILEGES;

-- 查看用户权限
SHOW GRANTS FOR 'your_user'@'%';

-- 查看数据库列表
SHOW DATABASES LIKE 'your_db%';
EOF

# 防火墙配置（使用者需替换端口号）
# 查看永久开放的端口
sudo firewall-cmd --permanent --list-ports

# 查看当前实时生效的开放端口
sudo firewall-cmd --zone=public --list-ports

# 开放防火墙端口
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload

# 移除防火墙端口
# sudo firewall-cmd --zone=public --remove-port=3306/tcp --permanent
# sudo firewall-cmd --reload
