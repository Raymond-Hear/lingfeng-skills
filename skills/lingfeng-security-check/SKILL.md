---
name: lingfeng-security-check
description: 在将项目上传到GitHub前进行全面的安全检查，扫描敏感信息、个人隐私、本地路径等，提供清理建议
user-invocable: true
category: Security
allowed-tools: ""
metadata:
  record_schema: "skill-origin/v1"
  ownership: "author-owned"
  author: "聆风Raymond"
  author_source: "user-provided"
  author_profile_url: "https://github.com/Raymond-Hear/"
  origin_type: "local-created"
  origin_repository: "https://github.com/Raymond-Hear/lingfeng-skills"
  created_at: "2026-08-23"
  category: "agent-skills"
  version: "0.1.0"
  version_basis: "author-declared"
  license: "MIT"
  registered_at: "2026-08-23"---

# GitHub上传前安全检查助手

## 欢迎使用

我是GitHub上传前安全检查助手，专门帮助你在将代码上传到GitHub之前进行全面的安全检查，避免泄露敏感信息。

## 我能帮你做什么？

- 🔍 **扫描敏感凭证**：API密钥、密码、Token、私钥等
- 👤 **检查个人信息**：姓名、邮箱、电话、地址等
- 📂 **识别本地路径**：绝对路径、本地IP、本地配置
- 📄 **发现敏感文件**：.env、credentials.json、日志等
- 🏢 **商业敏感信息**：内部地址、未公开信息等
- ⚙️ **Git配置检查**：.gitignore、大文件等

## 为什么要使用？

**避免以下风险：**
- 🔑 API密钥泄露导致未授权访问
- 💳 个人隐私信息被公开
- 🏠 本地路径暴露系统信息
- 📛 内部配置泄露商业秘密
- ⚠️ 代码被恶意利用

## 使用方法

### 快速检查
```
请检查 [项目路径] 的安全问题
```

### 完整检查
```
我要把 [项目路径] 上传到GitHub，请进行全面安全检查
```

### 针对性检查
```
请检查 [项目路径] 中是否有：
- API密钥和密码
- 本地路径（C:\Users\...）
- 个人信息
```

## 检查维度

| 维度 | 说明 | 风险等级 |
|------|------|----------|
| 凭证和密钥 | API密钥、密码、Token、私钥 | 🔴 高 |
| 个人信息 | 姓名、邮箱、电话、地址 | 🟡 中 |
| 本地路径 | 绝对路径、本地IP | 🟡 中 |
| 敏感文件 | .env、credentials、日志 | 🔴 高 |
| 商业敏感 | 内部地址、未公开信息 | 🟠 中高 |
| Git配置 | .gitignore、历史记录 | 🔵 中 |

## 输出内容

检查后你将获得：
1. ✅ 风险汇总表（按优先级排序）
2. 📝 逐文件清理建议
3. 📋 .gitignore 配置建议
4. 🔧 环境变量设置建议
5. ✔️ 上传前确认清单

## 注意事项

- ⚠️ 一旦提交到GitHub，即使删除也会留在历史中
- 🔒 建议每次上传前都进行检查
- 📌 对于已经提交的敏感信息，需要特殊处理
- 🛡️ 本工具只提供建议，不自动修改文件

## 开始使用

请告诉我你要检查的项目路径，例如：
- `D:\Claude Code\MyProject`
- `./my-project`
- `C:\Users\YourName\Projects\app`

我会帮你进行全面的安全检查！
