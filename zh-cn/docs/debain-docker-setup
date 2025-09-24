---
title: "Debian 12 一键安装 Docker 并配置镜像加速"
date: 2025-09-24
draft: false
tags: ["Docker", "Debian", "Shell", "镜像加速"]
categories: ["部署脚本"]
description: "适用于 Debian 12 的 Docker 安装与镜像加速脚本。"
---

> 本脚本适用于 Debian 12 环境，自动完成 Docker 安装及镜像加速配置。

## 📦 安装脚本内容

```bash
#!/bin/bash
# Docker 安装与镜像加速配置脚本
# 适用于 Debian 12

set -e

# 颜色定义
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# 镜像加速地址（请替换为你的专属加速器）
DOCKER_MIRROR="https://your.mirror.address/"

echo -e "${YELLOW}[1/3] 更新系统包...${NC}"
apt-get update -y

echo -e "${YELLOW}[2/3] 安装 Docker...${NC}"
apt-get install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 添加 Docker 官方源（视网络情况替换）
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable --now docker

echo -e "${YELLOW}[3/3] 配置 Docker 镜像加速...${NC}"
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

systemctl daemon-reload
systemctl restart docker

echo -e "${GREEN}Docker 安装与镜像加速配置完成！${NC}"
