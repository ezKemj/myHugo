## Disclaimer / 免责声明

This project and all related documentation are provided **for educational and research purposes only**.  
They are intended to demonstrate Docker deployment practices and system configuration examples.  

- The author does **not** encourage, endorse, or promote any use of the software or configurations that may violate local laws or regulations.  
- Users are solely responsible for ensuring that their usage complies with all applicable laws, policies, and service agreements in their jurisdiction.  
- The author assumes **no liability** for any misuse, damages, or legal consequences arising from the use of this content.  

本项目及相关文档仅用于 **学习和研究目的**，旨在演示 Docker 部署与系统配置示例。  

- 作者不鼓励、不支持、也不推广任何可能违反当地法律法规的用途。  
- 使用者需自行确保其使用行为符合所在地区的法律、政策及服务条款。  
- 因使用本内容而产生的任何误用、损害或法律后果，作者概不负责。
- 
---

```markdown
# V2RayA Docker 部署最佳实践 - 一键脚本版

本文提供一份**可直接复制执行**的命令行脚本，帮助你快速完成 V2RayA 的 Docker 部署。  
V2RayA 是一个基于 Web 的 V2Ray/Xray 管理面板。

---

## 🚀 一键部署脚本

```bash
#!/bin/bash
set -e

docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/xray \
  -e V2RAYA_NFTABLES_SUPPORT=off \
  -e IPTABLES_MODE=legacy \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya

echo "✅ V2RayA 已启动完成"
echo "👉 Web 管理界面：http://<服务器IP>:2017"
```
📝 配置说明
运行模式：--network=host，直接使用宿主机网络

权限：--privileged，需要访问内核网络模块

环境变量：

V2RAYA_LOG_FILE：日志路径

V2RAYA_V2RAY_BIN：Xray 二进制路径

IPTABLES_MODE=legacy：兼容 iptables 模式

挂载目录：

/etc/v2raya：配置文件

/lib/modules：内核模块只读挂载
