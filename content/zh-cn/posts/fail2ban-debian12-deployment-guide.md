# Fail2ban 部署与配置指南（Debian 12 实践）

本文提供一份**可直接复制执行**的命令行脚本与配置示例，帮助你在 Debian 12 上快速部署并启用 Fail2ban。  
重点解决 Debian 12 默认无 `/var/log/auth.log` 的问题，推荐使用 **systemd backend**。

---

## 📝 背景说明

- Debian 12 默认不再生成 `/var/log/auth.log`，SSH 登录失败记录存放在 **systemd journal** 中。  
- Fail2ban 默认配置会报错，需要调整：  
  - 方法一：安装 `rsyslog` 生成传统日志文件  
  - 方法二（推荐）：让 Fail2ban 直接读取 systemd 日志  

---

## 🚀 安装与启用

```bash
sudo apt update
sudo apt install fail2ban -y
sudo systemctl enable --now fail2ban
```
⚙️ 配置 Fail2ban
编辑配置文件：

bash
sudo nano /etc/fail2ban/jail.d/defaults-debian.local
示例配置：

ini
[DEFAULT]
backend = systemd
allowipv6 = auto

[sshd]
enabled  = true
mode     = extra
maxretry = 5
bantime  = 3600
findtime = 600

[nginx-http-auth]
enabled  = true
port     = http,https
logpath  = /srv/nginx/logs/error.log
maxretry = 5
bantime  = 3600
findtime = 600

[nginx-botsearch]
enabled  = true
port     = http,https
logpath  = /srv/nginx/logs/access.log
maxretry = 3
bantime  = 86400

[nginx-limit-req]
enabled  = true
port     = http,https
logpath  = /srv/nginx/logs/error.log
maxretry = 10
bantime  = 3600
findtime = 600

[mysqld-auth]
enabled  = true
port     = 3308
filter   = mysqld-auth
logpath  = /srv/mysql/8.0/prod/logs/error.log
maxretry = 5
findtime = 600
bantime  = 3600
保存后重启：

bash
sudo systemctl restart fail2ban
sudo systemctl status fail2ban
🔧 常用管理命令
bash
# 启动 / 停止 / 重启
sudo systemctl start fail2ban
sudo systemctl stop fail2ban
sudo systemctl restart fail2ban

# 设置开机自启
sudo systemctl enable fail2ban

# 查看服务状态
sudo systemctl status fail2ban

# 查看总体状态（有哪些 jail 在运行）
sudo fail2ban-client status

# 查看某个 jail 的详细状态
sudo fail2ban-client status sshd
sudo fail2ban-client status nginx-botsearch

# 手动封禁 / 解封 IP
sudo fail2ban-client set sshd banip 1.2.3.4
sudo fail2ban-client set sshd unbanip 1.2.3.4

# 重新加载配置（不重启服务）
sudo fail2ban-client reload

# 测试日志文件是否能匹配过滤器
sudo fail2ban-regex /var/log/auth.log /etc/fail2ban/filter.d/sshd.conf

# 查看 Fail2ban 日志
tail -f /var/log/fail2ban.log

# 搜索封禁记录
grep "Ban" /var/log/fail2ban.log
📝 总结
✅ Debian 12 推荐使用 systemd backend，避免依赖传统日志文件

✅ 可针对 SSH、Nginx、MySQL 等服务单独配置 jail

✅ 提供常用管理命令，方便日常运维
