# PostgreSQL 16 Docker 部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 PostgreSQL 16 的 Docker 部署。
同时附带常见问题排查，确保新手也能顺利完成。

# 📝 配置说明（简要）
## 基础信息

--name postgres16：容器名称

--restart=unless-stopped：开机自启，除非手动停止

--shm-size=128m：共享内存大小，避免大查询报错

## 数据库初始化

POSTGRES_USER=admin / POSTGRES_PASSWORD=...：初始化超级用户

POSTGRES_DB=appdb：初始化数据库

POSTGRES_INITDB_ARGS="--encoding=UTF8 --locale=C.UTF-8"：设置编码和 locale

PGDATA=/var/lib/postgresql/data/pgdata：数据目录位置

## 时区与本地化

TZ=Asia/Shanghai：容器时区

-c timezone / -c log_timezone / -c datestyle：数据库时区和日期格式

## 存储挂载

/srv/postgres16/data：数据目录

/srv/postgres16/logs：日志目录

/srv/postgres16/backup：备份目录

## 性能参数（适合小内存机器）

shared_buffers=64MB、work_mem=2MB、max_connections=50 等：内存和连接数优化

checkpoint_completion_target、wal_buffers、max_wal_size：WAL 日志调优

random_page_cost、effective_io_concurrency：I/O 优化

## 日志配置

logging_collector=on：启用日志收集

log_directory、log_filename：日志目录和文件名

log_rotation_age=1d、log_rotation_size=100MB：日志轮转策略

log_min_duration_statement=1000：记录超过 1 秒的慢查询
---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

# === 1. 清理旧容器和目录 ===
docker stop postgres16 2>/dev/null || true
docker rm -f postgres16 2>/dev/null || true

sudo rm -rf /srv/postgres16/data/*
sudo rm -rf /srv/postgres16/logs/*
sudo rm -rf /srv/postgres16/backup/*

# === 2. 创建目录并设置权限 ===
sudo mkdir -p /srv/postgres16/{data,logs,backup,init}
sudo chown -R 999:999 /srv/postgres16/{data,logs}

# === 3. 启动容器 ===
docker run -d \
  --name postgres16 \
  --restart=unless-stopped \
  --shm-size=128m \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD='PleaseEnterStrongPassw0rd!' \
  -e POSTGRES_DB=appdb \
  -e POSTGRES_INITDB_ARGS="--encoding=UTF8 --locale=C.UTF-8" \
  -e TZ=Asia/Shanghai \
  -e PGDATA=/var/lib/postgresql/data/pgdata \
  -v /srv/postgres16/data:/var/lib/postgresql/data \
  -v /srv/postgres16/logs:/var/lib/postgresql/logs \
  -v /srv/postgres16/backup:/backup \
  -p 5432:5432 \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  postgres:16-bookworm \
  -c shared_buffers=64MB \
  -c effective_cache_size=256MB \
  -c work_mem=2MB \
  -c maintenance_work_mem=32MB \
  -c max_connections=50 \
  -c timezone='Asia/Shanghai' \
  -c log_timezone='Asia/Shanghai' \
  -c datestyle='iso, ymd' \
  -c default_text_search_config='pg_catalog.simple' \
  -c checkpoint_completion_target=0.9 \
  -c wal_buffers=8MB \
  -c max_wal_size=512MB \
  -c min_wal_size=128MB \
  -c random_page_cost=1.1 \
  -c effective_io_concurrency=200 \
  -c logging_collector=on \
  -c log_directory='/var/lib/postgresql/logs' \
  -c log_filename='postgresql-%Y-%m-%d.log' \
  -c log_rotation_age=1d \
  -c log_rotation_size=100MB \
  -c log_min_duration_statement=1000

echo "✅ PostgreSQL 16 已启动完成"
echo "🎉 PostgreSQL 16 has been deployed and started successfully!"
echo "👉 Run 'docker ps | grep postgres16' to verify the container status."
echo "👉 Run 'docker exec -it postgres16 psql -U admin -d appdb -c \"SELECT version();\"' to test the database connection."

```
