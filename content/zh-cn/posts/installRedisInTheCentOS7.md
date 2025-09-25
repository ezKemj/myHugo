---
title: "在 CentOS 7 上安装与配置 Redis（含远程访问）"
date: 2025-09-25T16:30:00+08:00
draft: false
tags: ["CentOS", "Redis", "数据库", "Linux", "运维"]
categories: ["后端", "数据库"]
---

## 📌 简介
本文记录了在 **CentOS 7** 环境下安装 Redis、配置远程访问和防火墙规则的完整流程。
适合初学者快速搭建 Redis 服务，同时包含一些安全注意事项。

> ⚠️ **注意**：本文中的密码与 IP 地址均为示例，请务必替换为你自己的安全配置。生产环境中请避免直接使用 `bind *`，建议绑定内网 IP 并结合防火墙限制来源。

---

## 🛠 安装 Redis

首先添加必要的仓库并安装 Redis：

```bash
# 添加 EPEL 仓库
sudo yum install epel-release -y

# 添加 Remi 仓库
sudo yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y

# 启用 Remi 源
sudo yum-config-manager --enable remi

# 安装 Redis
sudo yum --enablerepo=remi install redis -y

# 验证安装
redis-server --version
```

⚙️ 配置 Redis 服务
启用并启动 Redis 服务：

```bash
sudo systemctl enable redis
sudo systemctl start redis
sudo systemctl status redis
```
查看 Redis 的 systemd 配置文件：

```bash
cat /usr/lib/systemd/system/redis.service
```
编辑 Redis 配置文件：

```bash
vi /etc/redis/redis.conf
```
需要修改的关键配置：

conf
# 允许远程访问（仅在受控环境下使用，生产环境建议绑定内网 IP）
bind *

# 设置访问密码（请替换为你自己的强密码）
requirepass your_strong_password
保存后重启 Redis：

```bash
sudo systemctl restart redis
sudo systemctl status redis
```
🔥 防火墙配置
开放 Redis 默认端口 6379：

```bash
sudo firewall-cmd --permanent --add-port=6379/tcp
sudo firewall-cmd --reload
```
🌐 远程连接测试
确认 Redis 是否在监听端口：

```bash
ss -tulnp | grep redis
```
使用 redis-cli 远程连接测试（请替换为你服务器的实际 IP 和密码）：

```bash
redis-cli -h <your_server_ip> -p 6379 -a "your_strong_password"
```
默认用户名为：

代码
default
✅ 总结
本文展示了如何在 CentOS 7 上安装 Redis 并配置远程访问。

关键步骤包括：添加仓库、安装 Redis、修改配置文件、设置密码、防火墙放行端口。

安全提醒：

不要在公网环境下直接使用 bind *。

一定要设置强密码，并结合防火墙限制来源 IP。

生产环境建议仅允许内网访问 Redis。

这样，你就可以在 CentOS 7 上快速部署一个可远程访问的 Redis 服务了 🚀。
