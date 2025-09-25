---
title: "CentOS 7 调整 LVM 分区：缩小 /home 并扩展 /root"
date: 2025-09-25T16:40:00+08:00
draft: false
tags: ["CentOS", "LVM", "XFS", "Linux", "磁盘管理"]
categories: ["运维", "系统管理"]
---

## 📌 简介
在 CentOS 7 的默认安装中，常常会出现 `/home` 分区过大而 `/` 分区空间不足的情况。
本文演示如何通过 **备份 → 删除 home → 重建 home → 扩展 root** 的方式重新分配磁盘空间。

> ⚠️ **注意**：此操作具有破坏性，必须提前做好完整备份。
> 本文中的卷组名、逻辑卷名、路径均为示例，请根据实际环境替换。

---

## 🛠 操作步骤

### 1. 查看磁盘使用情况
```bash
df -h
```
### 2. 备份 /home 数据
可以选择打包压缩或 rsync 增量备份：

```bash
# 打包压缩备份
sudo tar -czvf /tmp/home_backup.tar.gz /home

# 或使用 rsync 增量备份（需提前准备 /backup 目录）
sudo rsync -avh /home /backup/
```
### 3. 卸载并删除原有 /home 分区
```bash
sudo umount /home

# 删除 home 逻辑卷（请替换为实际路径）
sudo lvremove /dev/mapper/<vg_name>-home
```
### 4. 重新创建较小的 /home 分区
```bash
# 创建新的 home 分区（示例大小 10G，请根据需求调整）
sudo lvcreate -L 10G -n home <vg_name>

# 格式化为 XFS 文件系统
sudo mkfs.xfs /dev/mapper/<vg_name>-home

# 挂载到 /home
sudo mount /dev/mapper/<vg_name>-home /home
```
### 5. 恢复 /home 数据
```bash
# 从压缩包恢复
sudo tar -xzvf /tmp/home_backup.tar.gz -C /
```
### 6. 扩展 root 分区
将剩余的空闲空间分配给 root：

```bash
# 扩展 root 卷（请替换为实际路径）
sudo lvextend -l +100%FREE /dev/mapper/<vg_name>-root

# 调整 XFS 文件系统大小
sudo xfs_growfs /dev/mapper/<vg_name>-root
```
✅ 总结
本文演示了如何在 CentOS 7 上通过 LVM 调整分区，缩小 /home 并扩展 /root。

核心步骤：备份 → 删除 home → 重建 home → 恢复数据 → 扩展 root。

安全提醒：

一定要提前备份 /home 数据。

卷组名 <vg_name>、逻辑卷名 <vg_name>-home、<vg_name>-root 需根据实际情况替换。

操作完成后请再次检查数据完整性。
