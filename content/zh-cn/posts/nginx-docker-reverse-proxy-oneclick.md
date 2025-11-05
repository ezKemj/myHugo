# Nginx Docker 反向代理部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 Nginx 反向代理的 Docker 部署。  
脚本内容涵盖：目录初始化、权限设置、安全参数、容器运行与示例配置。

---

## 📝 配置说明（简要）

### 目录与权限
- `/srv/nginx/conf`：Nginx 配置文件（只读，root:root）  
- `/srv/nginx/certs`：证书目录（只读，root:root）  
- `/srv/nginx/cache`、`/srv/nginx/run`、`/srv/nginx/logs`：运行时目录（UID 101 可写）  
- `/srv/nginx/html`：静态文件目录（只读）  

### 安全参数
- `--pids-limit=200`：限制进程数  
- `--memory=256m`：限制内存  
- `--security-opt no-new-privileges`：禁止提权  
- `--read-only`：容器根文件系统只读  
- `--cap-drop ALL`：移除所有 Linux capabilities  

### 配置文件示例
- 限流与连接数限制：`limit_req_zone`、`limit_conn_zone`  
- 安全头部：`X-Frame-Options`、`Content-Security-Policy` 等  
- 反向代理：Prowlarr、Radarr、qBittorrent、Jellyfin  
- WebSocket 支持：Jellyfin 视频流  

---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

# === 1. 创建目录 ===
mkdir -p /srv/nginx/{conf,certs,cache,run,logs}

# === 2. 设置权限 ===
chown -R 101:101 /srv/nginx/{cache,run,logs}
chown -R root:root /srv/nginx/conf
chown -R root:root /srv/nginx/certs

# === 3. 启动容器 ===
docker run -d \
  --name nginx-proxy \
  --restart unless-stopped \
  --pids-limit=200 \
  --memory=256m \
  -p 80:80 \
  -p 443:443 \
  --security-opt no-new-privileges \
  --read-only \
  --cap-drop ALL \
  -v /srv/nginx/conf:/etc/nginx/conf.d:ro \
  -v /srv/nginx/certs:/etc/nginx/certs:ro \
  -v /srv/nginx/cache:/var/cache/nginx \
  -v /srv/nginx/run:/var/run \
  -v /srv/nginx/logs:/var/log/nginx \
  -v /srv/nginx/html:/usr/share/nginx/html:ro \
  -e NGINX_ENTRYPOINT_QUIET_LOGS=1 \
  nginx:stable-alpine

echo "✅ Nginx 反向代理已启动完成"
```

🔧 常用操作
# 拷贝默认静态目录
docker cp nginx-proxy:/usr/share/nginx/html /srv/nginx/html

# 无中断重载配置
docker exec -it nginx-proxy nginx -s reload

# 将代理容器加入指定网络
docker network connect media nginx-proxy

# 日志排查
docker logs nginx-proxy
docker exec -it nginx-proxy nginx -t
📄 示例配置文件 /srv/nginx/conf/myapp.conf
nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;
limit_conn_zone $binary_remote_addr zone=addr:10m;
limit_conn addr 20;

server {
    listen 80;
    server_name yourdomain.com;

    server_tokens off;

    # 安全头部
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy strict-origin-when-cross-origin;
    add_header Content-Security-Policy "default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline';";
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=()";
    add_header X-Permitted-Cross-Domain-Policies "none";

    # 静态首页
    location / {
        limit_req zone=one burst=20 nodelay;
        root /usr/share/nginx/html;
        index index.html;
    }

    # 代理示例：Prowlarr
    location /prowlarr/ {
        proxy_pass http://prowlarr:9696/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 代理 Radarr
    location /radarr/ {
        proxy_pass http://radarr:7878/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 代理 qBittorrent
    location /qbittorrent/ {
        proxy_pass http://qbittorrent:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # 代理 Jellyfin
    location /jellyfin/ {
        proxy_pass http://jellyfin:8096/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket 支持
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # 避免视频流缓存
        proxy_buffering off;
    }

    # 如果未来要启用 HTTPS，可以取消下面的注释
    # return 301 https://$host$request_uri;
}
