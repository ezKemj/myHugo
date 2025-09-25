---
title: "批处理脚本示例：检测 Office 安装路径并调用 ospp.vbs"
date: 2025-09-25T16:10:00+08:00
draft: false
tags: ["Windows", "Batch", "Office", "脚本示例"]
categories: ["运维", "自动化"]
---

## 📌 简介
本文展示一个 **批处理脚本示例**，用于检测 Microsoft Office 的安装路径，并调用自带的 `ospp.vbs` 脚本执行操作。  
该示例仅用于学习 **批处理逻辑**（循环、条件判断、路径检测），不包含任何激活或破解内容。  

> ⚠️ **免责声明**：本文仅供学习 Windows 批处理脚本编写方法。请勿将此类脚本用于规避商业软件授权或其他违法用途，否则后果自负。

---

## 🛠 功能说明
1. 遍历常见的 Office 安装目录（x64 与 x86）。  
2. 检测不同版本的 Office（2010/2013/2016+）。  
3. 如果找到 `ospp.vbs`，则切换到对应目录并执行示例命令。  

---

## 💻 脚本代码

```bat
@echo off
title Office Script Example
echo Detecting Office version...

:: 定义可能的 Office 版本号
set "office_paths=16 15 14"
set "found=0"

:: 遍历 x64 和 x86 安装目录
for %%p in ("%ProgramFiles%" "%ProgramFiles(x86)%") do (
    for %%v in (%office_paths%) do (
        if exist "%%~p\Microsoft Office\Office%%v\ospp.vbs" (
            set "office_path=%%~p\Microsoft Office\Office%%v"
            set "office_version=%%v"
            set "found=1"
            goto :version_found
        )
    )
)

:version_found
if "%found%"=="0" (
    echo Office installation not found.
    goto :end
)

cd /d "%office_path%"

:: 示例：调用 ospp.vbs（此处仅演示，不包含激活命令）
cscript ospp.vbs /dstatus

echo Process completed
timeout /t 5

:end
