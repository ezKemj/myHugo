---
title: "在 Debian/Ubuntu 中配置静态 IP 地址"
date: 2025-09-25T16:50:00+08:00
draft: false
tags: ["Linux", "网络配置", "Debian", "Ubuntu", "静态IP"]
categories: ["运维", "系统管理"]
---

## 📌 简介
在服务器或虚拟机环境中，常常需要为网卡配置静态 IP 地址，以便固定访问。  
本文演示如何在 **Debian/Ubuntu 系统** 中通过修改 `/etc/network/interfaces` 文件来配置静态 IP。  

> ⚠️ **注意**：本文示例中的 IP 地址、网关、DNS 仅为演示，请根据实际网络环境替换。  
> 修改网络配置可能导致远程连接中断，建议在本地或有控制台的情况下操作。

---

## 🛠 操作步骤

### 1. 查看当前网络接口
```bash
ip addr
```
找到你要配置的网卡名称（示例为 ens32）。

2. 备份原始配置文件
```bash
sudo cp /etc/network/interfaces /etc/network/interfaces.bak
```
3. 编辑网络配置文件
```bash
sudo nano /etc/network/interfaces
```
添加或修改如下内容（请根据实际情况替换 IP、网关、DNS）：

conf
auto ens32
iface ens32 inet static
    address <your_static_ip>       # 例如 192.168.139.200
    netmask <your_netmask>         # 例如 255.255.255.0
    gateway <your_gateway>         # 例如 192.168.139.1
    dns-nameservers <dns_servers>  # 例如 8.8.8.8 8.8.4.4
4. 重启网络服务
```bash
sudo systemctl restart networking
```
5. 验证配置是否生效
```bash
ip addr show ens32
```
6. 测试网络连通性
```bash
ping -c 4 baidu.com
```
如果能正常返回结果，说明静态 IP 配置成功。

✅ 总结
本文演示了如何在 Debian/Ubuntu 系统中配置静态 IP。

核心步骤：备份配置 → 编辑 /etc/network/interfaces → 重启网络服务 → 验证与测试。

提醒：

IP、网关、DNS 请根据实际环境替换。

如果系统使用 netplan 或 NetworkManager，配置方式会有所不同。

这样，你就能在服务器或虚拟机中成功配置静态 IP 地址 🚀。
