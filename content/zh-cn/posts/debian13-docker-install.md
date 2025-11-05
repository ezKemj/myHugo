---
title: "Debian 13 Production Docker Installation Script"
slug: "debian13-docker-install"
date: 2025-11-05
draft: false
---

# Debian 13 (Trixie) 生产环境 Docker 官方安装脚本

仅安装 **Docker Engine**，不包含额外配置。  

## 📜 安装脚本

```bash
#!/bin/bash
# Debian 13 (Trixie) 生产环境 Docker 官方安装脚本
# 仅安装 Docker Engine，不包含额外配置

set -e

echo "[1/6] 卸载可能的旧包..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
  apt-get remove -y $pkg || true
done

echo "[2/6] 安装依赖..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

echo "[3/6] 添加 Docker 官方 GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "[4/6] 添加 Docker 官方 apt 仓库..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y

echo "[5/6] 安装 Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[6/6] 启动并设置开机自启..."
systemctl enable docker
systemctl start docker

echo "✅ Docker 安装完成，验证运行 hello-world..."
docker run --rm hello-world || true

echo "🎉 Docker 已成功安装并运行！"
```
✅ 使用说明
适用于 Debian 13 (Trixie)

默认安装 Docker Engine + Buildx + Compose 插件

不包含额外配置（如用户组、镜像加速器等），可根据需要自行添加
