# 常用公共 DNS 提供商清单（IPv4 / IPv6 / DoH / DoT）

本文整理了国外常用的公共 DNS 提供商，涵盖 IPv4、IPv6、DoH（DNS over HTTPS）、DoT（DNS over TLS）等接入方式，方便在不同场景下快速查阅和配置。

---

## 🌐 IPv4 DNS

### Cloudflare DNS
- 标准：`1.1.1.1` / `1.0.0.1`  
- 仅阻止恶意软件：`1.1.1.2` / `1.0.0.2`  
- 阻止恶意软件和成人内容：`1.1.1.3` / `1.0.0.3`  

### Quad9 DNS
- 标准：`9.9.9.9` / `149.112.112.112`  
- 不安全（无过滤）：`9.9.9.10` / `149.112.112.10`  
- ECS 支持：`9.9.9.11` / `149.112.112.11`  

### OpenDNS (Cisco)
- 标准：`208.67.222.222` / `208.67.220.220`  
- FamilyShield（成人内容过滤）：`208.67.222.123` / `208.67.220.123`  
- Sandbox（无过滤）：`208.67.222.2` / `208.67.220.2`  

### Comodo Secure DNS
- `8.26.56.26` / `8.20.247.20`  

### Yandex DNS (俄罗斯)
- Basic（无过滤）：`77.88.8.8` / `77.88.8.1`  
- Safe（安全过滤）：`77.88.8.88` / `77.88.8.2`  
- 家庭（成人内容过滤）：`77.88.8.3` / `77.88.8.7`  

### Quad101 (台湾学术网络)
- `101.101.101.101` / `101.102.103.104`  

---

## 🌐 IPv6 DNS

### Cloudflare DNS
- 标准：`2606:4700:4700::1111` / `2606:4700:4700::1001`  
- 仅阻止恶意软件：`2606:4700:4700::1112` / `2606:4700:4700::1002`  
- 阻止恶意软件和成人内容：`2606:4700:4700::1113` / `2606:4700:4700::1003`  

### Quad9 DNS
- 标准：`2620:fe::fe` / `2620:fe::9`  
- 不安全（无过滤）：`2620:fe::10` / `2620:fe::fe:10`  
- ECS 支持：`2620:fe::11` / `2620:fe::fe:11`  

### OpenDNS (Cisco)
- 标准：`2620:119:35::35` / `2620:119:53::53`  
- Sandbox（无过滤）：`2620:0:ccc::2` / `2620:0:ccd::2`  

### Yandex DNS (俄罗斯)
- Basic（无过滤）：`2a02:6b8::feed:0ff` / `2a02:6b8:0:1::feed:0ff`  
- Safe（安全过滤）：`2a02:6b8::feed:bad` / `2a02:6b8:0:1::feed:bad`  
- 家庭（成人内容过滤）：`2a02:6b8::feed:a11` / `2a02:6b8:0:1::feed:a11`  

### Quad101 (台湾学术网络)
- `2001:de4::101` / `2001:de4::102`  

---

## 🔒 DoH（DNS over HTTPS）

### Cloudflare DNS
- 标准：https://dns.cloudflare.com/dns-query  
- 仅阻止恶意软件：https://security.cloudflare-dns.com/dns-query  
- 阻止恶意软件和成人内容：https://family.cloudflare-dns.com/dns-query  

### Quad9 DNS
- 标准：https://dns.quad9.net/dns-query  
- 不安全（无过滤）：https://dns10.quad9.net/dns-query  
- ECS 支持：https://dns11.quad9.net/dns-query  

### OpenDNS (Cisco)
- 标准：https://doh.opendns.com/dns-query  
- FamilyShield：https://doh.familyshield.opendns.com/dns-query  
- Sandbox：https://doh.sandbox.opendns.com/dns-query  

### Yandex DNS (俄罗斯)
- Basic：https://common.dot.dns.yandex.net/dns-query  
- Safe：https://safe.dot.dns.yandex.net/dns-query  
- 家庭：https://family.dot.dns.yandex.net/dns-query  

### IIJ.JP DNS (日本)
- https://public.dns.iij.jp/dns-query  

---

## 🔒 DoT（DNS over TLS）

### Cloudflare DNS
- 标准：`tls://one.one.one.one`  
- 仅阻止恶意软件：`tls://security.cloudflare-dns.com`  
- 阻止恶意软件和成人内容：`tls://family.cloudflare-dns.com`  

### Quad9 DNS
- 标准：`tls://dns.quad9.net`  
- 不安全（无过滤）：`tls://dns10.quad9.net`  
- ECS 支持：`tls://dns11.quad9.net`  

### OpenDNS (Cisco)
- 标准：`tls://dns.opendns.com`  
- FamilyShield：`tls://familyshield.opendns.com`  
- Sandbox：`tls://sandbox.opendns.com`  

### Yandex DNS (俄罗斯)
- Basic：`tls://common.dot.dns.yandex.net`  
- Safe：`tls://safe.dot.dns.yandex.net`  
- 家庭：`tls://family.dot.dns.yandex.net`  

### IIJ.JP DNS (日本)
- `tls://public.dns.iij.jp`  

### Quad101 (台湾学术网络)
- `tls://101.101.101.101`  

---

## ⚠️ 免责声明

- 本文仅为 **学习与研究** 整理的公共 DNS 信息，旨在方便快速查阅。  
- 不保证所有服务在任何地区均可用，亦不保证其长期稳定性。  
- 使用者需自行确保其行为符合所在地区的法律法规与网络政策。  
- 作者不对因使用本文信息而产生的任何后果承担责任。  

---

