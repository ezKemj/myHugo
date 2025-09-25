---
title: "Debian 13 部署 JDK8 + Tomcat + LibreOffice 环境"
date: 2025-09-25
draft: false
tags: ["Debian", "Tomcat", "LibreOffice", "JDK8", "部署"]
categories: ["系统运维"]
---

本文提供一个完整的部署脚本，涵盖 **Debian 13** 环境下 JDK8、Tomcat、LibreOffice 的安装与配置。  
请根据实际环境替换脚本中的资源路径和版本号。

## 脚本内容

以下脚本可保存为 `deploy_tomcat_libreoffice.sh` 并执行：

```bash
#!/bin/bash
set -e

echo "=== 切换到镜像源（Debian 13 Trixie + sid for JDK8） ==="
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie main contrib non-free non-free-firmware
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ trixie-updates main contrib non-free non-free-firmware
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security trixie-security main contrib non-free non-free-firmware
# sid 源仅用于 JDK8
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ sid main contrib non-free non-free-firmware
EOF

apt update && apt upgrade -y

echo "=== 安装 OpenJDK 8（headless） ==="
apt install -y openjdk-8-jdk-headless wget curl apt-file
apt-file update

echo "=== 移除 sid 源，防止后续升级拉取不稳定包 ==="
grep -v "sid" /etc/apt/sources.list > /etc/apt/sources.list.tmp && mv /etc/apt/sources.list.tmp /etc/apt/sources.list
apt update

echo "=== 安装 Tomcat（需替换版本号和安装包路径） ==="
TOMCAT_VERSION=9.0.108
mkdir -p /opt/tomcat
# 使用者需替换 /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz 为实际下载路径
cp /tmp/apache-tomcat-${TOMCAT_VERSION}.tar.gz /tmp/tomcat.tar.gz
tar -xvf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1

groupadd -f tomcat
id -u tomcat &>/dev/null || useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
chown -R tomcat:tomcat /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="JAVA_OPTS=-Xms256m -Xmx512m -XX:MaxMetaspaceSize=512m -Xss256k -XX:MaxDirectMemorySize=64m -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=always
LimitNOFILE=4096
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now tomcat

echo "=== 安装 LibreOffice（需替换版本号和安装包路径） ==="
LIBO_VER=7.6.7.2
cd /tmp
# 使用者需替换 LibreOffice_${LIBO_VER}_Linux_x86-64_deb.tar.gz 为实际下载路径
tar -xvf LibreOffice_${LIBO_VER}_Linux_x86-64_deb.tar.gz
dpkg -i LibreOffice_${LIBO_VER}_Linux_x86-64_deb/DEBS/*.deb || true

echo "=== 安装 LibreOffice SDK（需替换安装包路径） ==="
tar -xvf LibreOffice_${LIBO_VER}_Linux_x86-64_deb_sdk.tar.gz
dpkg -i LibreOffice_${LIBO_VER}_Linux_x86-64_deb_sdk/DEBS/*.deb || true

echo "=== 检查并安装 LibreOffice 缺失依赖 ==="
LIBO_BINARIES=(
    /opt/libreoffice7.6/program/soffice
    /opt/libreoffice7.6/program/soffice.bin
    /opt/libreoffice7.6/program/unopkg
)

MISSING_LIBS_ALL=""
for bin in "${LIBO_BINARIES[@]}"; do
    if [ -x "$bin" ]; then
        MISSING_LIBS=$(ldd "$bin" | awk '/not found/ {print $1}' | sort -u)
        [ -n "$MISSING_LIBS" ] && MISSING_LIBS_ALL="$MISSING_LIBS_ALL $MISSING_LIBS"
    fi
done

if [ -n "$MISSING_LIBS_ALL" ]; then
    for lib in $(echo "$MISSING_LIBS_ALL" | tr ' ' '\n' | sort -u); do
        PKG=$(apt-file search -x "$lib" | awk -F: '{print $1}' | sort -u | head -n1)
        [ -n "$PKG" ] && apt install -y "$PKG"
    done
fi

echo "=== 安装中文字体 ==="
apt install -y fonts-wqy-zenhei fonts-wqy-microhei

echo "=== 配置 LibreOffice 转换脚本 ==="
cat > /usr/local/bin/convert_to_pdf.sh <<'EOF'
#!/bin/bash
INPUT_FILE="$1"
OUTPUT_DIR="$2"
if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_DIR" ]; then
  echo "用法: convert_to_pdf.sh <输入文件> <输出目录>"
  exit 1
fi
/opt/libreoffice7.6/program/soffice --headless --convert-to pdf "$INPUT_FILE" --outdir "$OUTPUT_DIR"
EOF
chmod +x /usr/local/bin/convert_to_pdf.sh

echo "=== 修正 Tomcat 下载目录权限 ==="
mkdir -p /opt/tomcat/webapps/ROOT/download/crfa
chown -R tomcat:tomcat /opt/tomcat/webapps/ROOT/download
chmod 755 /opt/tomcat/webapps/ROOT/download

echo "=== 配置中文本地化 ==="
sed -i 's/^# *\(zh_CN.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen
update-locale LANG=zh_CN.UTF-8 LANGUAGE=zh_CN:zh LC_ALL=zh_CN.UTF-8

echo "=== 部署完成 ==="
