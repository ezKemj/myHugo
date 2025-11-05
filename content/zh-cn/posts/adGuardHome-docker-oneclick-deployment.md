# AdGuard Home Docker 部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 AdGuard Home 的 Docker 部署。  
AdGuard Home 是一款全功能的网络广告与跟踪拦截 DNS 服务器。

---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

docker run -d \
  --name adguardhome \
  --restart unless-stopped \
  -v /srv/adguard/work:/opt/adguardhome/work \
  -v /srv/adguard/conf:/opt/adguardhome/conf \
  -p 53:53/tcp -p 53:53/udp \
  -p 3000:3000/tcp \
  -p 80:80/tcp \
  -p 443:443/tcp -p 443:443/udp \
  -p 853:853/tcp \
  adguard/adguardhome:latest

echo "✅ AdGuard Home 已启动完成"
echo "👉 Web 管理界面：http://<服务器IP>:3000"
```
📝 配置说明
数据目录：/srv/adguard/work、/srv/adguard/conf

端口映射：

53 (DNS)

3000 (初始 Web 管理界面)

80/443 (HTTP/HTTPS)

853 (DNS-over-TLS)
