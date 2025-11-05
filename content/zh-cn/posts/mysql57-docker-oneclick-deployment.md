# MySQL 5.7 Docker 部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 MySQL 5.7 的 Docker 部署。  
脚本内容涵盖：目录初始化、自定义配置、权限设置与容器启动。

---

## 📝 配置说明（简要）

### 基础信息
- `--name mysql57-prod`：容器名称  
- `--restart unless-stopped`：开机自启，除非手动停止  
- `-p 3309:3306`：宿主机 3309 端口映射到容器 3306  

### 数据目录与配置
- `/srv/mysql/5.7/prod/data`：数据目录  
- `/srv/mysql/5.7/prod/conf`：自定义配置目录  
- `/srv/mysql/5.7/prod/logs`：日志目录  

### 初始化参数
- `MYSQL_ROOT_PASSWORD`：root 用户密码  
- `MYSQL_DATABASE`：初始化数据库  
- `MYSQL_USER` / `MYSQL_PASSWORD`：初始化普通用户  

### 自定义配置（custom.cnf）
- 内存与连接数限制：`innodb_buffer_pool_size`、`max_connections` 等  
- 字符集与排序规则：`utf8mb4` / `utf8mb4_unicode_ci`  
- 网络与兼容性：`skip-name-resolve`、`lower_case_table_names=1`  

---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

# === 1. 创建目录 ===
mkdir -p /srv/mysql/5.7/prod/{data,conf,logs}

# === 2. 写自定义配置 ===
cat > /srv/mysql/5.7/prod/conf/custom.cnf <<'EOF'
[mysqld]
# 内存与连接数限制
innodb_buffer_pool_size = 256M
innodb_log_file_size = 128M
innodb_log_files_in_group = 2
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

# === 3. 设置目录权限 ===
chown -R 999:999 /srv/mysql/5.7/prod/{data,logs}

# === 4. 启动容器 ===
docker run -d \
  --name mysql57-prod \
  --restart unless-stopped \
  -p 3309:3306 \
  -v /srv/mysql/5.7/prod/data:/var/lib/mysql \
  -v /srv/mysql/5.7/prod/conf:/etc/mysql/conf.d \
  -v /srv/mysql/5.7/prod/logs:/var/log/mysql \
  -e MYSQL_ROOT_PASSWORD="PleaseEnterStrongPassw0rd!" \
  -e MYSQL_DATABASE=myapp \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  mysql:5.7

echo "✅ MySQL 5.7 已启动完成"
echo "👉 Run 'docker ps | grep mysql57-prod' to verify the container status."
echo "👉 Run 'docker exec -it mysql57-prod mysql -uroot -p' to connect."
