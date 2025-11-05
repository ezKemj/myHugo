# 国内常用公共 DNS 提供商清单（IPv4 / IPv6 / DoH / DoT）

本文整理了国内常用的公共 DNS 提供商，涵盖 IPv4、IPv6、DoH（DNS over HTTPS）、DoT（DNS over TLS）等接入方式，方便在不同场景下快速查阅和配置。

---

## 🌐 IPv4 DNS

### 阿里 AliDNS
- `223.5.5.5`
- `223.6.6.6`

### 腾讯 DNSPod
- `119.29.29.29`
- `182.254.116.116` （备用）

### 114DNS
- Normal：`114.114.114.114` / `114.114.115.115`  
- Safe：`114.114.114.119` / `114.114.115.119`  
- 家庭：`114.114.114.110` / `114.114.115.110`  

### 360 Secure DNS
- `101.226.4.6`
- `218.30.118.6`
- `123.125.81.6`
- `140.207.198.6`

### 百度 Baidu DNS
- `180.76.76.76`

### 字节跳动 ByteDance DNS
- `180.184.1.1`
- `180.184.2.2`

### 运营商（联通大连示例）
- `202.96.69.38`

---

## 🌐 IPv6 DNS

### 阿里 AliDNS
- `2400:3200::1`
- `2400:3200:baba::1`

### 腾讯 DNSPod
- `2402:4e00::`

### 工信部 CFIEC
- `240C::6666`
- `240C::6644`

---

## 🔒 DoH（DNS over HTTPS）

### 阿里 AliDNS
- `https://dns.alidns.com/dns-query`

### 腾讯 DNSPod
- `https://dns.pub/dns-query`  
- `https://sm2.doh.pub/dns-query`

### 360 Secure DNS
- `https://doh.360.cn/dns-query`

### 工信部 CFIEC
- `https://dns.cfiec.net/dns-query`

---

## 🔒 DoT（DNS over TLS）

### 阿里 AliDNS
- `tls://dns.alidns.com`

### 腾讯 DNSPod
- `tls://dot.pub`

### 360 Secure DNS
- `tls://dot.360.cn`

### 工信部 CFIEC
- `tls://dns.cfiec.net`

---

## ⚠️ 免责声明

- 本文仅为 **学习与研究** 整理的公共 DNS 信息，旨在方便快速查阅。  
- 不保证所有服务在任何地区均可用，亦不保证其长期稳定性。  
- 使用者需自行确保其行为符合所在地区的法律法规与网络政策。  
- 作者不对因使用本文信息而产生的任何后果承担责任。  

---
