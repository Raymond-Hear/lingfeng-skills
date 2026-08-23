# GitHub Security Check

<div align="center">

**GitHub上传前的全面安全检查**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange.svg)](https://claude.ai/claude-code)
[![Security](https://img.shields.io/badge/Security-Security%20Check-green.svg)]()

</div>

---

## 📖 简介

**GitHub Security Check** 是一个 Claude Code Skill，专门帮助你在将代码上传到 GitHub 之前进行全面的安全检查，避免泄露敏感信息、隐私数据或商业机密。

### ✨ 主要功能

- 🔍 **6维度扫描** - 全方位检查敏感信息
- 🎯 **风险评估** - 智能评估风险等级（P0-P4）
- 📊 **详细报告** - 生成完整的安全检查报告
- 🛠️ **清理指导** - 提供具体的清理步骤
- 📋 **确认清单** - 上传前的最终确认
- ⚙️ **配置建议** - .gitignore 和环境变量设置

---

## 🎯 检查维度

| 维度 | 检查内容 | 风险等级 |
|------|----------|----------|
| 🔑 **凭证和密钥** | API密钥、密码、Token、私钥 | 🔴🔴🔴 严重 |
| 👤 **个人信息** | 姓名、邮箱、电话、地址 | 🟡 中 |
| 📂 **本地路径** | 绝对路径、本地IP | 🟡 中 |
| 📄 **敏感文件** | .env、credentials、日志 | 🔴🔴🔴 严重 |
| 🏢 **商业敏感** | 内部地址、未公开信息 | 🟠 中高 |
| ⚙️ **Git配置** | .gitignore、历史记录 | 🔵 中 |

---

## 🚀 快速开始

### 安装步骤

#### 方式 1: 自动安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/Raymond-Hear/github-security-check.git

# 复制到 Claude Code skills 目录
# Windows
xcopy /E /I github-security-check "%USERPROFILE%\.claude\skills\github-security-check"

# macOS/Linux
cp -r github-security-check ~/.claude/skills/
```

#### 方式 2: 手动安装

1. **下载文件**
   - 下载整个仓库的 ZIP 文件，或使用 `git clone`

2. **创建目标目录**
   ```bash
   # Windows
   mkdir %USERPROFILE%\.claude\skills\github-security-check

   # macOS/Linux
   mkdir -p ~/.claude/skills/github-security-check
   ```

3. **复制文件**
   - 将所有文件复制到 `~/.claude/skills/github-security-check/` 目录

4. **重启 Claude Code**
   - 完全关闭 Claude Code
   - 重新启动应用

---

## 📖 使用方法

### 基本使用

1. **启动 Claude Code**

2. **调用 Skill**
   ```
   /github-security-check
   ```

3. **输入项目路径**
   ```
   请检查 D:\MyProject 的安全问题
   ```

4. **获取检查报告**
   - 自动扫描 6 个维度
   - 生成详细的风险评估
   - 提供清理建议和步骤

### 使用示例

#### 示例 1: 快速检查
```
请检查 ./my-project 的安全问题
```

#### 示例 2: 完整检查
```
我要把 D:\Claude Code\MyProject 上传到GitHub，请进行全面安全检查
```

#### 示例 3: 针对性检查
```
请检查 D:\MyProject 中是否有：
- API密钥和密码
- 本地路径（C:\Users\...）
- 个人信息
```

---

## 📂 项目结构

```
github-security-check/
├── SKILL.md                           # Skill 主配置文件
├── stages/                            # 工作流阶段
│   ├── 01-scan-sensitive.md          # 阶段1: 扫描敏感信息
│   ├── 02-assess-risks.md            # 阶段2: 评估风险等级
│   ├── 03-generate-report.md         # 阶段3: 生成检查报告
│   └── 04-cleanup-guide.md           # 阶段4: 清理指导
├── templates/                         # 可复用模板
│   ├── check-dimensions.md           # 检查维度定义
│   ├── report-template.md            # 报告模板
│   └── risk-levels.md                # 风险等级定义
├── examples/                          # 使用示例
│   └── sample-reports.md             # 示例报告
└── README.md                          # 本文档
```

---

## 🛡️ 安全检查流程

### 阶段 1: 扫描敏感信息

扫描以下内容：
- 🔑 API密钥、密码、Token
- 👤 个人信息（邮箱、电话等）
- 📂 本地路径和IP地址
- 📄 敏感文件（.env、credentials等）
- 🏢 商业敏感信息
- ⚙️ Git配置问题

### 阶段 2: 评估风险等级

根据以下标准评估：
- **敏感程度**（40分）- 信息的重要性
- **影响范围**（30分）- 泄露的后果
- **可利用性**（30分）- 被利用的难度

**风险等级**:
- 🔴🔴🔴 **严重**（90-100分）- 立即处理（P0）
- 🔴🔴 **高**（70-89分）- 优先处理（P1）
- 🟠 **中高**（50-69分）- 计划处理（P2）
- 🟡 **中**（30-49分）- 择机处理（P3）
- 🟢 **低**（10-29分）- 可选处理（P4）

### 阶段 3: 生成检查报告

提供详细的报告：
- 📊 执行摘要
- 📋 风险汇总表
- 📝 逐文件清理建议
- 🔧 环境变量设置
- ✔️ 上传前确认清单

### 阶段 4: 清理指导

提供具体的清理步骤：
- 撤销泄露的密钥
- 创建 .env 文件
- 更新 .gitignore
- 清理 Git 历史
- 验证清理结果

---

## 📝 输出内容

检查完成后，你将获得：

### 1. 风险汇总表

| 优先级 | 文件 | 行号 | 问题类型 | 建议 |
|--------|------|------|----------|------|
| P0 | config.py | 15 | API密钥 | 环境变量 |

### 2. 详细问题清单

每个问题的：
- 具体位置
- 代码上下文
- 风险评估
- 清理步骤
- 验证方法

### 3. .gitignore 配置

完整的 `.gitignore` 文件内容，包含：
- 环境变量文件
- 凭证文件
- IDE配置
- 系统文件
- 日志文件

### 4. 环境变量设置

- `.env.example` 模板
- 环境变量读取代码
- 依赖安装命令

### 5. 上传前确认清单

- [ ] 所有API密钥已处理
- [ ] 敏感文件已添加到.gitignore
- [ ] 个人信息已清理
- [ ] 本地路径已替换
- [ ] 最终验证完成

---

## 💡 典型使用场景

### 场景 1: Python项目

**检查内容**:
```python
# config.py
OPENAI_API_KEY = "sk-..."  # ❌ 硬编码密钥
DATABASE_URL = "mongodb://user:pass@..."  # ❌ 硬编码密码
CONFIG_PATH = "C:\\Users\\YourName\\..."  # ❌ 本地路径
```

**清理后**:
```python
import os
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")  # ✅ 环境变量
DATABASE_URL = os.getenv("DATABASE_URL")  # ✅ 环境变量
CONFIG_PATH = os.path.expanduser("~/config")  # ✅ 用户目录
```

### 场景 2: Node.js项目

**检查内容**:
```javascript
// config.js
const apiKey = "sk-...";  // ❌ 硬编码
const dbUrl = "postgres://user:pass@...";  // ❌ 硬编码
```

**清理后**:
```javascript
const apiKey = process.env.API_KEY;  // ✅ 环境变量
const dbUrl = process.env.DATABASE_URL;  # ✅ 环境变量
```

### 场景 3: 已公开的敏感信息

**紧急处理步骤**:
1. ⚡ 立即撤销所有泄露的凭证
2. 📧 通知所有团队成员
3. 🔧 清理Git历史
4. 🚀 强制推送更新
5. ✅ 验证清理结果

---

## 🎨 特色功能

### 智能风险评估

不是所有的"敏感信息"都是真正危险的：

| 发现内容 | 风险等级 | 说明 |
|---------|----------|------|
| `API_KEY=your_key_here` | 🟢 低 | 占位符，安全 |
| `API_KEY=sk-abc123...` | 🔴🔴🔴 严重 | 真实密钥，危险 |
| `C:\Users\{username}` | 🟢 低 | 通用占位符 |
| `C:\Users\YourName` | 🟡 中 | 具体用户名 |

### 上下文感知

区分代码中的内容和文档中的示例：
- 代码中的密钥 → 高风险
- 文档中的示例 → 低风险（如果是占位符）

### 具体操作指导

不只是发现问题，还提供：
- ✅ 具体的清理命令
- ✅ 代码修改示例
- ✅ 验证测试方法

---

## 🔧 高级功能

### Git历史清理

对于已经提交的敏感信息：

```bash
# 使用 BFG Repo-Cleaner
bfg --delete-files .env
bfg --replace-text passwords.txt

# 清理引用
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 强制推送（谨慎！）
git push origin --force --all
```

### 自动化安全检查

配置 pre-commit hook：

```bash
#!/bin/sh
if git diff --cached --name-only | xargs grep -l "password\|secret\|api_key"; then
    echo "⚠️  检测到可能的敏感信息！"
    exit 1
fi
```

### 定期审计

- 每月检查依赖更新
- 每季度审计提交历史
- 定期检查异常使用
- 关注安全公告

---

## 🤝 贡献

欢迎贡献！你可以：

1. **报告问题** - [提交 Issue](https://github.com/Raymond-Hear/github-security-check/issues)
2. **提出建议** - [提交 Feature Request](https://github.com/Raymond-Hear/github-security-check/issues)
3. **提交代码** - Fork 项目，创建 Pull Request

---

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

---

## 🙏 致谢

- 感谢 Claude Code 团队提供的 Skill 系统
- 感谢所有安全工具和最佳实践的贡献者

---

## 📞 联系方式

- **GitHub**: [Raymond-Hear](https://github.com/Raymond-Hear)
- **Issue**: [提交问题](https://github.com/Raymond-Hear/github-security-check/issues)

---

## ⚠️ 免责声明

本工具仅提供辅助检查建议，不能替代专业的安全审计。上传到GitHub前，请务必：
- ✅ 人工审查检查结果
- ✅ 验证所有清理步骤
- ✅ 测试代码是否正常运行
- ✅ 确认没有遗漏的敏感信息

---

## 🌟 Star History

如果这个项目对你有帮助，请给它一个 ⭐ Star！

---

<div align="center">

**🔒 保护你的代码，从安全检查开始**

[⬆ 返回顶部](#github-security-check)

</div>
