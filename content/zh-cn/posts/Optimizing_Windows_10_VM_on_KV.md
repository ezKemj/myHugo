---
title: "Optimizing Windows 10 VM on KVM"
slug: "optimizing-win10-vm-kvm"
date: 2025-11-05
draft: false
---

# Optimizing Windows 10 VM on KVM

## 🛠️ 操作步骤

### 1. 安装 VirtIO 驱动（必做）
- 下载 virtio-win 驱动 ISO  
- 在 virt-manager 或 virsh 配置里，给 Win10 VM 添加一个光驱，挂载该 ISO  
- 启动 Win10 VM → 打开 **设备管理器**：  
  - 磁盘控制器 → 更新驱动 → 浏览 → 指定 ISO 内 **viostor** 文件夹  
  - 网络控制器 → 更新驱动 → 指定 ISO 内 **NetKVM** 文件夹  
- 安装 **Balloon 驱动**（内存回收）和 **QEMU Guest Agent**（宿主机通信）  
- 显卡可选安装 **viogpu**，提供基础 2D 加速  

---

### 2. 宿主机侧优化
**CPU 绑定 (CPU pinning)**  
```bash
virsh list --all
virsh vcpupin <VM名称或ID> 0 2
```
建议 Win10 VM 固定 1–2 个核，避免和宿主机 GUI 抢核

HugePages 内存优化

bash
# 编辑配置
vim /etc/sysctl.conf
vm.nr_hugepages=1024
# 重启后在 VM XML 添加
<memoryBacking>
  <hugepages/>
</memoryBacking>
磁盘与网络设置

virt-manager → VM → 详情 → 磁盘 → 改为 VirtIO SCSI，缓存模式设为 none

网络接口改为 virtio，模式选择 桥接 (bridge) 或 macvtap

3. Win10 内部轻量化
关闭视觉特效 右键“此电脑” → 属性 → 高级系统设置 → 性能 → 设置 → 选择“调整为最佳性能”

卸载无用组件 设置 → 应用 → 卸载 3D Viewer、Mixed Reality、Xbox Game Bar

关闭后台服务 services.msc → 禁用 Windows Search、Superfetch (SysMain)、Windows Update (可设为手动)

禁用 3D 加速（仅需 2D 桌面时） virt-manager → 显示设备 → 取消勾选 “3D 加速”

📋 最佳实践总结
必做：virtio 驱动 + CPU pinning + HugePages

推荐：磁盘/网络改 virtio，缓存模式 none

可选：Win10 内部关闭特效和服务，减少资源占用
