---
title: "自动清理无效的 Windows 防火墙入站规则"
date: 2025-09-25T15:34:00+08:00
draft: false
tags: ["Windows", "PowerShell", "防火墙", "自动化", "脚本"]
categories: ["运维", "安全"]
---

## 📌 简介
本文分享一个 PowerShell 脚本，用于 **自动清理无效的 Windows 防火墙入站规则**。  
脚本会在执行前自动备份当前规则，并在日志中详细记录每一步操作，确保可追溯性和安全性。  

> ⚠️ 注意：日志中可能包含规则名称和程序路径。

---

## 🛠 功能说明
1. 自动生成带时间戳的防火墙规则备份文件和日志文件。  
2. 定义系统规则白名单，避免误删关键规则。  
3. 检测入站规则对应的程序路径是否存在。  
4. 删除无效规则（非系统、非手动创建）。  
5. 在日志末尾列出所有手动规则，方便人工检查。  

---

## 💻 脚本代码

```powershell
<#
.SYNOPSIS
自动清理无效的 Windows 防火墙入站规则，并备份当前规则和记录详细日志。
.NOTE
日志中会记录规则名称和程序路径。
#>

# 1. 生成带时间戳的备份文件和日志文件
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "C:\Path\To\Backup\firewall_backup_$timestamp.pol"
$logPath = "C:\Path\To\Logs\firewall_cleanup_$timestamp.log"

# 2. 备份当前防火墙规则
netsh advfirewall export $backupPath | Out-Null
Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 防火墙规则已备份到: $backupPath" | Tee-Object -FilePath $logPath -Append

# 3. 定义系统规则白名单（防止误删关键系统规则）
$systemRules = @("*Windows*", "*System*", "*svchost*", "*lsass*", "*wininit*")
$systemPaths = @("*\Windows\*", "*\Program Files\*", "*\Program Files (x86)\*")

# 4. 获取所有手动创建的规则（PersistentStore）
$manualRules = Get-NetFirewallRule | Where-Object { $_.PolicyStore -eq "PersistentStore" }

# 5. 清理无效规则（非系统+非手动）
$rules = Get-NetFirewallRule -Direction Inbound | Where-Object { $_.Enabled -eq 'True' }
foreach ($rule in $rules) {
    $program = ($rule | Get-NetFirewallApplicationFilter).Program
    if ($program -and (Test-Path $program) -eq $false) {
        # 检查是否为系统规则或手动规则
        $isSystemRule = $systemRules -contains $rule.Name -or 
                       ($program -and ($systemPaths | Where-Object { $program -like $_ }))
        $isManualRule = ($rule.PolicyStore -eq "PersistentStore")
        
        if (-not $isSystemRule -and -not $isManualRule) {
            $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 删除无效规则: $($rule.Name) (程序路径: $program)"
            Write-Output $logMessage | Tee-Object -FilePath $logPath -Append
            $rule | Remove-NetFirewallRule -Confirm:$false
        } elseif ($isSystemRule) {
            $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 跳过系统规则: $($rule.Name) (程序路径: $program)"
            Write-Output $logMessage | Tee-Object -FilePath $logPath -Append
        } elseif ($isManualRule) {
            $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 跳过手动规则: $($rule.Name) (程序路径: $program)"
            Write-Output $logMessage | Tee-Object -FilePath $logPath -Append
        }
    } else {
        $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 保留有效规则: $($rule.Name) (程序路径: $program)"
        Write-Output $logMessage | Tee-Object -FilePath $logPath -Append
    }
}

# 6. 在日志末尾列出所有手动规则
Write-Output "`n[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 当前所有手动规则列表：" | Tee-Object -FilePath $logPath -Append
$manualRules | ForEach-Object {
    $program = ($_ | Get-NetFirewallApplicationFilter).Program
    Write-Output " - 规则名称: $($_.Name), 程序路径: $program" | Tee-Object -FilePath $logPath -Append
}

Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] 清理完成！日志已保存到: $logPath" | Tee-Object -FilePath $logPath -Append
