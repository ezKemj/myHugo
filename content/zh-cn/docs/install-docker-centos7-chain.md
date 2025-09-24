---
title: "CentOS 7 一键安装 Docker 并配置镜像加速"
date: 2025-09-24
draft: false
tags: ["Docker", "CentOS", "Shell", "镜像加速"]
categories: ["部署脚本"]
description: "适用于中国网络环境的 Docker 安装脚本。"
---

> 本脚本适用于 CentOS 7 环境，自动完成 Docker 安装及镜像加速配置。

## 📦 安装脚本内容

```bash
#!/bin/bash
# CentOS 7 一键安装 Docker 并配置镜像加速

set -e

# 颜色定义
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# 镜像加速地址（请替换为你的专属加速器）
DOCKER_MIRROR="https://your.mirror.address/"

echo -e "${YELLOW}[1/4] 更新系统包...${NC}"
yum clean all
yum makecache fast
yum update -y

echo -e "${YELLOW}[2/4] 安装 Docker CE（官方源）...${NC}"
# 安装必要工具
yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加 Docker 官方源（请根据实际情况替换）
yum-config-manager --add-repo https://your.repo.address/docker-ce.repo

# 安装最新版 Docker CE
yum makecache fast
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "${YELLOW}[3/4] 配置 Docker 镜像加速...${NC}"
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": [
     "${DOCKER_MIRROR}"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

echo -e "${YELLOW}[4/4] 启动 Docker 服务并设置开机自启...${NC}"
systemctl daemon-reload
systemctl enable docker
systemctl start docker

echo -e "${GREEN}Docker 安装与镜像加速配置完成！${NC}"
echo -e "${GREEN}Docker 版本：$(docker --version)${NC}"
