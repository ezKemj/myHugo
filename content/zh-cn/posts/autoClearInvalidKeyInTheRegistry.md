---
title: "批处理脚本示例：自动清理注册表中的无效键值"
date: 2025-09-25T16:00:00+08:00
draft: false
tags: ["Windows", "Batch", "注册表", "自动化"]
categories: ["运维", "系统优化"]
---

## 📌 简介
本文分享一个 **Windows 批处理脚本**，用于自动清理注册表中无效的键值。  
脚本会遍历指定的注册表路径，查找并删除包含特定关键字的项。  

> ⚠️ **免责声明**：本文仅供学习 Windows 注册表操作与批处理脚本编写方法。请勿将此类脚本用于规避商业软件授权或其他违法用途，否则后果自负。

---

## 🛠 功能说明
1. 遍历指定的注册表路径（示例中为 `HKEY_CURRENT_USER\Software\Classes\CLSID`）。  
2. 查找包含指定关键字的子项。  
3. 删除匹配的注册表项，并输出日志。  

---

## 💻 脚本代码

```bat
@echo off
setlocal enabledelayedexpansion

:: 定义关键字
set dn=Info
set dn2=ShellFolder
set rp=HKEY_CURRENT_USER\Software\Classes\CLSID

echo 开始扫描注册表...

for /f "tokens=*" %%a in ('reg query "%rp%"') do (
  echo 正在检查: %%a

  for /f "tokens=*" %%l in ('reg query "%%a" /f "%dn%" /s /e ^| findstr /i "%dn%"') do (
    echo 删除匹配项: %%a
    reg delete %%a /f
  )

  for /f "tokens=*" %%l in ('reg query "%%a" /f "%dn2%" /s /e ^| findstr /i "%dn2%"') do (
    echo 删除匹配项: %%a
    reg delete %%a /f
  )
)

echo 清理完成！
pause
exit
