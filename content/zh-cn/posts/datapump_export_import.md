---
title: "Oracle Data Pump 导出与导入脚本示例"
date: 2025-09-25
draft: false
tags: ["Oracle", "Data Pump", "expdp", "impdp", "数据库迁移"]
categories: ["数据库运维"]
---

本文提供一个基于 **Oracle Data Pump** 的导出与导入脚本示例，适用于多 Schema 数据迁移。  
通过参数文件方式管理配置，便于维护和复用。

## 脚本内容

以下脚本可保存为 `datapump_export_import.sh` 并执行：

```bash
#!/bin/bash
# Oracle Data Pump 导出与导入脚本示例
# 使用者需替换 USERID、SCHEMAS、DIRECTORY 等参数为实际环境

## 导出
cat > expdp.par << 'EOF'
USERID="用户名/密码@连接串"
SCHEMAS=SCHEMA1, SCHEMA2, SCHEMA3
DIRECTORY=DATA_PUMP_DIR   -- 使用者需替换为实际的 Oracle DIRECTORY 对象
DUMPFILE=exp_schemas_%U.dmp
LOGFILE=exp_schemas.log
PARALLEL=4
COMPRESSION=ALL
EXCLUDE=STATISTICS
REUSE_DUMPFILES=YES
EOF

expdp parfile=expdp.par
rm -rf expdp.par
echo 'export done'

## 导入
cat > impdp.par << 'EOF'
USERID="用户名/密码@连接串"
SCHEMAS=SCHEMA1, SCHEMA2, SCHEMA3
DIRECTORY=DATA_PUMP_DIR   -- 使用者需替换为实际的 Oracle DIRECTORY 对象
DUMPFILE=exp_schemas_%U.dmp
LOGFILE=imp_schemas.log
PARALLEL=4
TABLE_EXISTS_ACTION=REPLACE
EXCLUDE=STATISTICS
EOF

impdp parfile=impdp.par
rm -rf impdp.par
echo 'import done'
