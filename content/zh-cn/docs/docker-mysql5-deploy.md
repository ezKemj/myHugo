---
title: "Debian 12 使用 Docker 部署 MySQL 5.7"
date: 2025-09-24
draft: false
tags: ["MySQL", "Docker", "Debian", "数据库部署"]
categories: ["部署脚本"]
description: "在 Debian 12 上通过 Docker 快速部署 MySQL 5.7 的完整脚本示例，包含配置文件、管理脚本和远程用户创建。"
---

> 本脚本适用于 Debian 12 环境，自动完成 MySQL 5.7 的 Docker 部署与基础配置。

## 📦 部署脚本内容

```bash
#!/bin/bash
# MySQL 5.7 Docker 部署脚本
# 适用于 Debian 12

set -e

# 颜色定义
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 配置变量（请根据需要修改）
MYSQL_ROOT_PASSWORD="<YOUR_ROOT_PASSWORD>"
MYSQL_DATA_DIR="<YOUR_DATA_DIR>"
MYSQL_CONTAINER_NAME="mysql5"
MYSQL_PORT="3305"

echo -e "${YELLOW}[1/4] 拉取 MySQL 5.7 镜像...${NC}"
docker pull mysql:5.7

echo -e "${YELLOW}[2/4] 创建数据与配置目录...${NC}"
mkdir -p ${MYSQL_DATA_DIR}
mkdir -p /etc/mysql5-docker
cat > /etc/mysql5-docker/my.cnf << 'MYSQL_EOF'
[mysqld]
innodb_buffer_pool_size = 256M
innodb_log_file_size = 128M
max_connections = 50
key_buffer_size = 16M
thread_cache_size = 8

character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

skip-name-resolve
lower_case_table_names = 1
MYSQL_EOF

echo -e "${YELLOW}[3/4] 停止并删除旧容器（如有）...${NC}"
docker stop ${MYSQL_CONTAINER_NAME} 2>/dev/null || true
docker rm ${MYSQL_CONTAINER_NAME} 2>/dev/null || true
rm -rf ${MYSQL_DATA_DIR}/*

echo -e "${YELLOW}[4/4] 运行 MySQL 容器...${NC}"
docker run -d \
  --name ${MYSQL_CONTAINER_NAME} \
  --restart always \
  -p ${MYSQL_PORT}:3306 \
  -v ${MYSQL_DATA_DIR}:/var/lib/mysql \
  -v /etc/mysql5-docker/my.cnf:/etc/mysql/conf.d/my.cnf \
  -e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
  <YOUR_DOCKER_REGISTRY>/mysql:5.7

echo -e "${YELLOW}等待 MySQL 启动...${NC}"
sleep 15

if docker ps | grep -q ${MYSQL_CONTAINER_NAME}; then
    echo -e "${GREEN}MySQL 5.7 部署成功！${NC}"
    echo -e "${GREEN}容器名称: ${MYSQL_CONTAINER_NAME}${NC}"
    echo -e "${GREEN}端口: ${MYSQL_PORT}${NC}"
    echo -e "${GREEN}数据目录: ${MYSQL_DATA_DIR}${NC}"
    echo -e "${GREEN}配置文件: /etc/mysql5-docker/my.cnf${NC}"
    echo -e "${GREEN}Root 密码: ${MYSQL_ROOT_PASSWORD}${NC}"

    # 创建管理脚本
    cat > /usr/local/bin/mysql5-docker << 'SCRIPT_EOF'
#!/bin/bash
case "$1" in
    start) docker start mysql5 ;;
    stop) docker stop mysql5 ;;
    restart) docker restart mysql5 ;;
    status) docker ps -a | grep mysql5 ;;
    logs) docker logs -f mysql5 ;;
    shell) docker exec -it mysql5 bash ;;
    mysql) docker exec -it mysql5 mysql -u root -p ;;
    *) echo "用法: $0 {start|stop|restart|status|logs|shell|mysql}"; exit 1 ;;
esac
SCRIPT_EOF
    chmod +x /usr/local/bin/mysql5-docker
    echo -e "${GREEN}管理命令已创建: mysql5-docker {start|stop|restart|status|logs|shell|mysql}${NC}"

    # 创建远程用户（可选）
    echo -e "${YELLOW}创建远程用户 admin...（可选）${NC}"
    docker exec -i ${MYSQL_CONTAINER_NAME} mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<SQL
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY '<YOUR_ADMIN_PASSWORD>';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL
    echo -e "${GREEN}远程用户 admin 创建完成！${NC}"
else
    echo -e "${RED}MySQL 部署失败，请检查日志：${NC}"
    docker logs ${MYSQL_CONTAINER_NAME}
    exit 1
fi
