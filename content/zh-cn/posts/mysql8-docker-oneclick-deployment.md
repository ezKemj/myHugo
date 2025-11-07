# MySQL 8.0 Docker 部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 MySQL 8.0 的 Docker 部署。
脚本内容涵盖：目录初始化、自定义配置、权限设置与容器启动。

---

## 📝 配置说明（简要）

### 基础信息
- `--name mysql8-prod`：容器名称
- `--restart unless-stopped`：开机自启，除非手动停止
- `-p 3308:3306`：宿主机 3308 端口映射到容器 3306

### 数据目录与配置
- `/srv/mysql/8.0/prod/data`：数据目录
- `/srv/mysql/8.0/prod/conf`：自定义配置目录
- `/srv/mysql/8.0/prod/logs`：日志目录

### 初始化参数
- `MYSQL_ROOT_PASSWORD`：root 用户密码
- `custom.cnf`：只覆盖必要参数（内存限制、字符集、日志路径等）

---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

# === 1. 停止并删除容器 ===
docker stop mysql8-prod
docker rm -f mysql8-prod

# === 2. 删除挂载的数据、配置和日志目录 ===
rm -rf /srv/mysql/8.0/*

cat > /srv/mysql/8.0/prod/conf/custom.cnf <<'EOF'
[mysqld]
# 内存与连接数限制
innodb_buffer_pool_size = 256M
innodb_redo_log_capacity = 134217728
max_connections = 50
key_buffer_size = 16M
thread_cache_size = 8

# 字符集与排序规则
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

# 网络与兼容性
skip-name-resolve
lower_case_table_names = 1

EOF

# === 4. 启动容器 ===
docker run -d \
  --name mysql8-prod \
  --restart unless-stopped \
  -p 3308:3306 \
  -v /srv/mysql/8.0/prod/data:/var/lib/mysql \
  -v /srv/mysql/8.0/prod/conf:/etc/mysql/conf.d \
  -e MYSQL_ROOT_PASSWORD="PleaseEnterStrongPassw0rd!" \
  mysql:8
```
