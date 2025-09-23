---
title: "CentOS 7 Docker 安装与镜像加速配置脚本"
date: 2025-09-23
tags: ["Docker", "CentOS", "运维脚本"]
categories: ["部署指南"]
draft: false
---


本文提供一个适用于 **CentOS 7** 的 Docker 安装与镜像加速配置脚本，帮助快速部署 Docker 环境，并优化镜像拉取速度。  
镜像加速地址需根据实际情况自行替换为可信来源。

## 📌 使用说明

- **适用环境**：CentOS 7.x，需 root 权限
- **风险提示**：
  - `yum update -y` 会升级所有系统包，可能影响现有服务
  - 镜像加速源应来自可信渠道（如官方或企业内部源）
- **执行方式**：
  1. 将脚本保存为 `install_docker.sh`
  2. 赋予执行权限：`chmod +x install_docker.sh`
  3. 执行：`./install_docker.sh`

## 🛠 脚本内容

```bash
#!/bin/bash
# Docker 安装与镜像加速配置脚本（CentOS 7版）
# 镜像加速地址需自行替换

set -e

    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    NC='\033[0m'

    # 镜像加速地址占位符，请替换为可信来源
DOCKER_MIRROR="https://your.mirror.address/"

echo -e "${YELLOW}[1/3] 更新系统包...${NC}"
yum update -y

echo -e "${YELLOW}[2/3] 安装 Docker...${NC}"
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
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

echo -e "${GREEN}Docker 安装与镜像加速配置完成！（CentOS 7）${NC}"
