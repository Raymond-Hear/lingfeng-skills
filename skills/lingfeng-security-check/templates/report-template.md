# 检查报告模板

本文档提供了GitHub安全检查报告的标准模板。

## 完整报告模板

```markdown
# GitHub安全检查报告

**项目路径**: `[填写路径]`
**检查时间**: `[填写时间]`
**检查范围**: `[文件数量]` 个文件
**检查工具**: GitHub Security Check

---

## 1. 执行摘要

### 1.1 风险概览

| 风险等级 | 数量 | 占比 | 说明 |
|---------|------|------|------|
| 🔴🔴🔴 严重 | `[N]` | `[X]%` | 立即处理，可能导致严重后果 |
| 🔴🔴 高 | `[N]` | `[X]%` | 优先处理，重要安全问题 |
| 🟠 中高 | `[N]` | `[X]%` | 建议处理，中等风险 |
| 🟡 中 | `[N]` | `[X]%` | 注意处理，一般风险 |
| 🟢 低 | `[N]` | `[X]%` | 可选处理，轻微问题 |
| 🔵 配置 | `[N]` | `[X]%` | 配置优化建议 |

**总计**: `[总数量]` 个问题

### 1.2 关键发现

1. **[关键问题1]** - [简要描述]
   - 文件: `[文件路径]:[行号]`
   - 风险: 🔴🔴🔴 严重
   - 影响: [潜在影响说明]

2. **[关键问题2]** - [简要描述]
   - 文件: `[文件路径]:[行号]`
   - 风险: 🔴🔴 高
   - 影响: [潜在影响说明]

3. **[关键问题3]** - [简要描述]
   - 文件: `[文件路径]:[行号]`
   - 风险: 🟠 中高
   - 影响: [潜在影响说明]

### 1.3 处理优先级

**立即处理** (P0 - 今天):
- [ ] [处理事项1]
- [ ] [处理事项2]
- [ ] [处理事项3]

**本周处理** (P1 - P2):
- [ ] [处理事项4]
- [ ] [处理事项5]

**可选处理** (P3 - P4):
- [ ] [处理事项6]
- [ ] [处理事项7]

---

## 2. 风险汇总表

| ID | 优先级 | 文件 | 行号 | 问题类型 | 风险描述 | 建议 |
|----|--------|------|------|----------|----------|------|
| 1 | P0 | config.py | 15 | API密钥 | OpenAI密钥泄露 | 环境变量 |
| 2 | P0 | .env | 3 | 敏感文件 | 环境变量文件 | .gitignore |
| 3 | P1 | credentials.json | - | 凭证文件 | 多服务凭证 | 加密存储 |
| 4 | P2 | README.md | 12 | 内部信息 | 内部API地址 | 占位符 |
| 5 | P3 | config.py | 25 | 本地路径 | 用户路径暴露 | 替换路径 |

---

## 3. 详细问题清单

### 3.1 🔴🔴🔴 严重风险 (P0 - 立即处理)

#### 问题 #1: OpenAI API密钥泄露

**文件位置**: `config/config.py:15`

**代码上下文**:
```python
# 原始代码
OPENAI_API_KEY = "sk-abc123def456ghi789jkl012mno345pqr"
```

**风险评估**:
- **敏感程度**: 40/40 (生产环境、完全权限)
- **影响范围**: 30/30 (API费用损失、数据泄露)
- **可利用性**: 30/30 (直接可用于API调用)
- **综合评分**: 100/100

**潜在影响**:
- ⚠️ API费用可能被恶意使用
- ⚠️ 数据可能被未授权访问
- ⚠️ 服务可能被中断

**清理建议**:

**Step 1**: 撤销泄露的密钥
```
1. 访问 https://platform.openai.com/api-keys
2. 找到泄露的密钥: sk-abc1...
3. 点击 "Roll key" 生成新密钥
```

**Step 2**: 创建 .env 文件
```bash
cat > .env << 'EOF'
# OpenAI API配置
OPENAI_API_KEY=sk-your-new-key-here
EOF
```

**Step 3**: 更新代码
```python
# 修改后
import os
from dotenv import load_dotenv

load_dotenv()
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
```

**Step 4**: 更新 .gitignore
```bash
echo ".env" >> .gitignore
```

**Step 5**: 创建 .env.example
```bash
cat > .env.example << 'EOF'
# OpenAI API配置
OPENAI_API_KEY=your_openai_api_key_here
EOF
```

**验证**:
```bash
# 测试环境变量
python -c "from dotenv import load_dotenv; import os; load_dotenv(); print(os.getenv('OPENAI_API_KEY'))"
```

---

#### 问题 #2: 环境变量文件暴露

**文件位置**: `.env`

**文件内容**:
```bash
DATABASE_URL=mongodb://admin:password123@localhost:27017/mydb
AWS_SECRET_KEY=aws_secret_key_here
JWT_SECRET=my-super-secret-key
```

**风险评估**:
- **敏感程度**: 40/40 (多服务凭证)
- **影响范围**: 30/30 (数据库完全暴露)
- **可利用性**: 30/30 (直接使用)
- **综合评分**: 100/100

**清理建议**:

**Step 1**: 立即修改数据库密码
```bash
mongosh
> use admin
> db.changeUserPassword("admin", passwordPrompt())
```

**Step 2**: 从Git追踪中移除
```bash
git rm --cached .env
git add .gitignore
git commit -m "Remove .env from tracking"
```

**Step 3**: 撤销AWS密钥
```
访问AWS IAM控制台，撤销并重新创建密钥
```

---

### 3.2 🔴🔴 高风险 (P1 - 优先处理)

#### 问题 #3: JWT Secret硬编码

**文件位置**: `config.py:30`

**代码上下文**:
```python
SECRET_KEY = "my-super-secret-key-12345"
```

**清理建议**:
```python
SECRET_KEY = os.getenv("SECRET_KEY")
```

---

### 3.3 🟠 中高风险 (P2 - 计划处理)

#### 问题 #4: 内部API地址

**文件位置**: `README.md:12`

**内容**:
```markdown
请访问 https://api.internal.company.com 获取API文档
```

**清理建议**:
```markdown
请访问 https://api.example.com 获取API文档
或: 请联系项目维护者获取API地址
```

---

### 3.4 🟡 中低风险 (P3/P4 - 择机/可选处理)

#### 问题 #5: 本地路径暴露

**文件位置**: `config.py:25`

**代码上下文**:
```python
CONFIG_PATH = "C:\Users\YourName\\Documents\\config.json"
```

**清理建议**:
```python
CONFIG_PATH = os.path.expanduser("~/Documents/config.json")
```

#### 问题 #6: 个人邮箱

**文件位置**: `README.md:8`

**内容**:
```markdown
作者：张三 <zhangsan@example.com>
```

**清理建议**:
```markdown
作者：[Your Name]
或通过 GitHub Issues 联系
```

---

## 4. 逐文件清理建议

### 文件1: `config/config.py`

**发现问题**:
- Line 15: API密钥硬编码
- Line 25: 本地路径暴露
- Line 30: JWT Secret硬编码

**完整对比**:
```diff
 import os
+from dotenv import load_dotenv
+
+load_dotenv()

-# API配置
-OPENAI_API_KEY = "sk-abc123def456ghi789"
-DATABASE_URL = "mongodb://localhost:27017/mydb"
-SECRET_KEY = "my-super-secret-key-12345"
-
-# 文件路径
-CONFIG_PATH = "C:\Users\YourName\\Documents\\config.json"
+# API配置
+OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
+DATABASE_URL = os.getenv("DATABASE_URL", "mongodb://localhost:27017/mydb")
+SECRET_KEY = os.getenv("SECRET_KEY")
+
+# 文件路径
+CONFIG_PATH = os.path.expanduser("~/Documents/config.json")
```

---

### 文件2: `.gitignore`

**当前状态**: 需要创建

**建议内容**:
```gitignore
# 环境变量
.env
.env.local
.env.*.local

# 凭证文件
*.key
*.pem
credentials.json
secrets.yml

# Python
__pycache__/
*.py[cod]
*.so

# IDE
.vscode/
.idea/
*.swp

# 系统文件
.DS_Store
Thumbs.db

# 日志
*.log
logs/
```

---

### 文件3: `.env.example`

**需要创建**:

```bash
# API配置
OPENAI_API_KEY=your_openai_api_key_here

# 数据库配置
DATABASE_URL=mongodb://localhost:27017/mydb
DB_USER=your_db_user
DB_PASSWORD=your_db_password

# JWT配置
SECRET_KEY=your_secret_key_here

# 第三方服务
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

---

## 5. .gitignore 配置建议

### 5.1 完整的 .gitignore 内容

[参考 templates/check-dimensions.md 中的完整内容]

### 5.2 验证命令

```bash
# 检查文件是否被忽略
git check-ignore -v .env

# 查看所有被忽略的文件
git ls-files --others --ignored --exclude-standard

# 检查即将提交的文件
git status
```

---

## 6. 环境变量设置建议

### 6.1 创建 .env 文件

```bash
# 复制模板
cp .env.example .env

# 编辑实际值
nano .env
```

### 6.2 代码中读取

#### Python
```python
from dotenv import load_dotenv
import os

load_dotenv()

api_key = os.getenv("OPENAI_API_KEY")
```

#### Node.js
```javascript
require('dotenv').config();

const apiKey = process.env.OPENAI_API_KEY;
```

### 6.3 安装依赖

```bash
# Python
pip install python-dotenv
echo "python-dotenv>=1.0.0" >> requirements.txt

# Node.js
npm install dotenv
```

---

## 7. 上传前确认清单

### 🔴 严重风险 - 必须全部完成

- [ ] **所有API密钥已撤销或替换为环境变量**
  - [ ] OpenAI API密钥
  - [ ] 数据库密码
  - [ ] 第三方服务密钥
  - [ ] OAuth Token

- [ ] **所有敏感文件已处理**
  - [ ] .env 文件已添加到 .gitignore
  - [ ] credentials.json 已删除或加密
  - [ ] *.key, *.pem 文件已删除或加密

- [ ] **Git历史已清理**（如果之前提交过敏感信息）
  - [ ] 使用 git-filter-repo 清理
  - [ ] 或使用 BFG Repo-Cleaner
  - [ ] 强制推送（谨慎操作）

### 🟡 中等风险 - 建议完成

- [ ] **个人信息已清理**
  - [ ] 邮箱地址已删除或替换
  - [ ] 电话号码已删除
  - [ ] 家庭地址已删除

- [ ] **本地路径已清理**
  - [ ] Windows路径已替换（C:\Users\...）
  - [ ] Unix路径已替换（/Users/..., /home/...）
  - [ ] 数据库连接字符串已修改

### 🔵 配置优化 - 建议完成

- [ ] **.gitignore 已配置**
  - [ ] .env 及变体已忽略
  - [ ] 処证文件已忽略
  - [ ] 日志文件已忽略
  - [ ] 依赖目录已忽略
  - [ ] 编辑器配置已忽略
  - [ ] 系统文件已忽略

- [ ] **.env.example 已创建**
  - [ ] 包含所有需要的环境变量
  - [ ] 使用占位符而非真实值
  - [ ] 包含注释说明

- [ ] **依赖已安装**
  - [ ] python-dotenv (Python)
  - [ ] dotenv (Node.js)

### 📋 最终检查

```bash
# 1. 检查将要提交的文件
git status

# 2. 查看差异
git diff

# 3. 搜索可能的敏感信息
git grep -i "password\|secret\|key\|token"

# 4. 检查 .gitignore 是否生效
git check-ignore -v .env

# 5. 确认没有敏感文件被追踪
git ls-files | grep -E "\.env$|credentials|secret|\.key$"
```

### ✅ 所有检查通过后

```bash
# 添加文件
git add .

# 提交
git commit -m "Initial commit"

# 推送到GitHub
git push origin main
```

---

## 8. 后续建议

### 8.1 自动化安全检查

安装和配置 git-secrets:
```bash
# 安装
brew install git-secrets

# 配置
git secrets --install
git secrets --add 'password\s*=\s*".+?"'
git secrets --add 'api_key\s*=\s*".+?"'

# 扫描历史
git secrets --scan-history
```

### 8.2 Pre-commit Hook

创建 `.git/hooks/pre-commit`:
```bash
#!/bin/sh
if git diff --cached --name-only | xargs grep -l "password\|secret\|api_key"; then
    echo "⚠️  警告：检测到可能的敏感信息！"
    exit 1
fi
```

使其可执行:
```bash
chmod +x .git/hooks/pre-commit
```

### 8.3 定期审计

- 每月检查一次依赖更新
- 每季度审计一次提交历史
- 定期检查已泄露的密钥是否有异常使用
- 关注安全公告和漏洞信息

---

## 附录

### A. 常用命令

```bash
# 搜索敏感信息
grep -r "password\|secret\|api_key" --include="*.py" --include="*.js"

# 检查大文件
find . -type f -size +50M -not -path "./.git/*"

# 从Git追踪中移除
git rm --cached filename

# 清理Git历史
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch filename" \
  --prune-empty --tag-name-filter cat -- --all
```

### B. 参考资源

- [Git Secrets](https://github.com/awslabs/git-secrets)
- [Detect Secrets](https://github.com/Yelp/detect-secrets)
- [TruffleHog](https://github.com/trufflesecurity/trufflehog)
- [GitHub Security Best Practices](https://docs.github.com/en/security)

---

**报告生成时间**: `[时间]`
**检查工具版本**: `[版本]`
**下次检查建议**: 上传任何代码前
```

## 简化版报告模板

```markdown
# GitHub安全检查报告（简化版）

**项目**: `[路径]`
**检查时间**: `[时间]`

## 风险统计

- 🔴🔴🔴 严重: `[N]` 个
- 🔴🔴 高: `[N]` 个
- 🟠 中高: `[N]` 个
- 🟡 中: `[N]` 个
- 🟢 低: `[N]` 个

## 关键问题

1. **[问题1]** - `[文件:行号]`
   - 风险: [等级]
   - 建议: [简要建议]

2. **[问题2]** - `[文件:行号]`
   - 风险: [等级]
   - 建议: [简要建议]

## 立即处理

- [ ] [处理事项1]
- [ ] [处理事项2]
- [ ] [处理事项3]

## .gitignore 建议

```gitignore
[建议的.gitignore内容]
```

## 环境变量建议

```bash
[建议的环境变量设置]
```

## 确认清单

- [ ] 所有API密钥已处理
- [ ] 敏感文件已添加到.gitignore
- [ ] 个人信息已清理
- [ ] 本地路径已替换
```
