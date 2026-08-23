# 阶段4：清理指导和执行

## 目标
提供详细的清理步骤指导，帮助用户安全地修复发现的问题，确保项目可以安全地上传到GitHub。

## 清理流程概览

```
清理步骤流程
├── 第0步: 备份（重要！）
├── 第1步: 紧急风险处理（P0）
├── 第2步: 高风险处理（P1）
├── 第3步: 中等风险处理（P2/P3）
├── 第4步: 配置优化
└── 第5步: 最终验证
```

## 第0步：备份（非常重要！）

在开始任何清理之前，先备份项目。

```bash
# 方法1: 复制整个项目目录
cp -r myproject myproject.backup

# 方法2: 使用Git创建备份分支
git branch backup-before-cleanup
git push origin backup-before-cleanup

# 方法3: 打包备份
tar -czf project-backup-$(date +%Y%m%d).tar.gz myproject/

# 验证备份
ls -la myproject.backup/
# 或
git branch | grep backup
```

**为什么需要备份？**
- ⚠️ 清理过程中可能误删重要内容
- ⚠️ 替换环境变量后代码可能无法运行
- ⚠️ Git历史清理是不可逆的
- ✅ 有了备份可以随时恢复

---

## 第1步：紧急风险处理（P0 - 立即处理）

### 1.1 处理硬编码的API密钥

#### 问题示例
```python
# config.py
OPENAI_API_KEY = "sk-abc123def456ghi789"
```

#### 清理步骤

**Step 1: 撤销已泄露的密钥**
1. 登录OpenAI平台: https://platform.openai.com/api-keys
2. 找到泄露的密钥
3. 点击"Roll key"或"Delete"并创建新密钥

**Step 2: 创建 .env 文件**
```bash
# 创建 .env 文件（不要提交到Git）
cat > .env << 'EOF'
# OpenAI API配置
OPENAI_API_KEY=sk-your-new-key-here
EOF
```

**Step 3: 更新 .gitignore**
```bash
# 添加到 .gitignore
echo ".env" >> .gitignore
```

**Step 4: 修改代码**
```python
# 修改后的 config.py
import os
from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
```

**Step 5: 创建 .env.example**
```bash
cat > .env.example << 'EOF'
# OpenAI API配置
OPENAI_API_KEY=your_openai_api_key_here
EOF
```

**Step 6: 测试**
```bash
# 加载环境变量并测试
python -c "from dotenv import load_dotenv; import os; load_dotenv(); print(os.getenv('OPENAI_API_KEY'))"
```

**Step 7: 安装依赖**
```bash
# Python
pip install python-dotenv

# 添加到 requirements.txt
echo "python-dotenv>=1.0.0" >> requirements.txt
```

---

### 1.2 处理数据库密码

#### 问题示例
```python
# config.py
DATABASE_URL = "mongodb://admin:password123@localhost:27017/mydb"
```

#### 清理步骤

**Step 1: 修改数据库密码**
```bash
# MongoDB 示例
mongosh
> use admin
> db.changeUserPassword("admin", passwordPrompt())
# 输入新密码

# 或使用命令
> db.changeUserPassword("admin", "newStrongPassword123!")
```

**Step 2: 更新 .env**
```bash
cat >> .env << 'EOF'

# 数据库配置
DATABASE_URL=mongodb://admin:newStrongPassword123!@localhost:27017/mydb
EOF
```

**Step 3: 更新代码**
```python
# config.py
DATABASE_URL = os.getenv("DATABASE_URL")
```

**Step 4: 更新 .env.example**
```bash
cat >> .env.example << 'EOF'

# 数据库配置
DATABASE_URL=mongodb://username:password@localhost:27017/database
EOF
```

---

### 1.3 处理 .env 文件泄露

#### 问题
.env 文件被追踪或已提交到Git

#### 清理步骤

**Step 1: 从Git追踪中移除**
```bash
# 从追踪中移除（保留本地文件）
git rm --cached .env

# 如果文件不存在，先移除
git rm --cached .env 2>/dev/null || true
```

**Step 2: 确保在 .gitignore 中**
```bash
# 检查 .gitignore
grep -q "^\.env$" .gitignore || echo ".env" >> .gitignore
```

**Step 3: 提交更改**
```bash
git add .gitignore
git commit -m "Remove .env from git tracking"
```

**Step 4: 如果历史中有敏感信息，清理历史**
```bash
# 使用 BFG Repo-Cleaner（推荐）
# 安装: brew install bfg 或下载 jar

# 清理 .env 文件
bfg --delete-files .env

# 清理文件中的密码
bfg --replace-text passwords.txt

# passwords.txt 内容示例:
# *.env*->***REMOVED***
# password=***REMOVED***

# 清理后
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 强制推送（谨慎！）
git push origin --force --all
```

---

### 1.4 处理 credentials.json

#### 问题
```json
{
  "api_key": "sk-...",
  "secret": "...",
  "password": "..."
}
```

#### 清理步骤

**Step 1: 移动到安全位置**
```bash
# 移动到用户目录
mkdir -p ~/.credentials
mv credentials.json ~/.credentials/myproject-credentials.json
chmod 600 ~/.credentials/myproject-credentials.json
```

**Step 2: 更新代码**
```python
# config.py
import json
import os

CREDENTIALS_PATH = os.path.expanduser("~/.credentials/myproject-credentials.json")

with open(CREDENTIALS_PATH) as f:
    credentials = json.load(f)

api_key = credentials["api_key"]
```

**Step 3: 创建示例文件**
```bash
cat > credentials.example.json << 'EOF
{
  "api_key": "your_api_key_here",
  "secret": "your_secret_here",
  "password": "your_password_here"
}
EOF
```

**Step 4: 更新 .gitignore**
```bash
echo "credentials.json" >> .gitignore
echo "*.json" >> .gitignore  # 谨慎：根据实际情况
# 或更精确
echo "credentials/" >> .gitignore
```

---

## 第2步：高风险处理（P1）

### 2.1 处理 JWT Secret

#### 问题
```python
SECRET_KEY = "my-super-secret-key-12345"
```

#### 清理步骤

```bash
# 生成随机密钥
python -c "import secrets; print(secrets.token_urlsafe(32))"

# 输出示例: 8KqP9sR2mN5vX7wY...
```

```bash
# 添加到 .env
cat >> .env << 'EOF'

# JWT配置
SECRET_KEY=8KqP9sR2mN5vX7wY...
EOF
```

```python
# 更新代码
SECRET_KEY = os.getenv("SECRET_KEY")
```

---

### 2.2 处理 OAuth Token

#### 清理步骤

**Step 1: 撤销Token**
- OAuth提供者平台撤销Token
- 生成新Token

**Step 2: 环境变量**
```bash
cat >> .env << 'EOF'

# OAuth配置
OAUTH_TOKEN=your_new_token_here
OAUTH_CLIENT_SECRET=your_client_secret
EOF
```

---

## 第3步：中等风险处理（P2/P3）

### 3.1 清理本地路径

#### 问题示例

**Windows路径:**
```python
CONFIG_PATH = "C:\Users\YourName\\Documents\\config.json"
```

**Unix路径:**
```python
CONFIG_PATH = "/Users/john/Documents/config.json"
```

#### 清理方案

**方案1: 使用相对路径**
```python
# 推荐
CONFIG_PATH = "./config.json"
```

**方案2: 使用用户目录**
```python
import os

CONFIG_PATH = os.path.expanduser("~/Documents/config.json")
# 或
CONFIG_PATH = os.path.join(os.path.expanduser("~"), "Documents", "config.json")
```

**方案3: 使用环境变量**
```python
CONFIG_PATH = os.getenv("CONFIG_PATH", "./config.json")
```

**方案4: 使用跨平台路径**
```python
from pathlib import Path

CONFIG_PATH = Path.home() / "Documents" / "config.json"
```

---

### 3.2 清理个人信息

#### 问题示例

```markdown
# README.md
作者：张三
邮箱：zhangsan@example.com
电话：13800138000
```

#### 清理方案

**方案1: 完全移除**
```markdown
# README.md
- 作者：[你的名字]
```

**方案2: 使用占位符**
```markdown
# README.md
作者：[Your Name]
联系方式：通过 GitHub Issues 联系
```

**方案3: 使用公开渠道**
```markdown
# README.md
作者：Zhang San
GitHub: @zhangsan
```

---

### 3.3 清理内部地址

#### 问题示例

```javascript
const API_URL = "https://api.internal.company.com";
const WEBHOOK_URL = "https://webhook.internal.company.com/hooks/abc123";
```

#### 清理方案

**方案1: 环境变量**
```javascript
const API_URL = process.env.API_URL || "https://api.example.com";
```

**方案2: 配置文件**
```javascript
// config/development.json
{
  "apiUrl": "https://api.internal.company.com"
}

// config/production.json
{
  "apiUrl": "https://api.example.com"
}
```

**方案3: 文档说明**
```markdown
请设置环境变量:
export API_URL=https://your-actual-api-url.com
```

---

## 第4步：配置优化

### 4.1 创建/更新 .gitignore

```bash
cat > .gitignore << 'EOF'
# ================================
# 环境变量和密钥（最重要！）
# ================================
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
*.key
*.pem
*.cert
*.crt
credentials.json
cred.json
secrets.yml
secrets.yaml
secret.txt
secrets.baseline

# ================================
# Python
# ================================
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.coverage
htmlcov/

# ================================
# Node.js
# ================================
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
package-lock.json
.yarn-integrity

# ================================
# IDE和编辑器
# ================================
.vscode/
.idea/
*.swp
*.swo
*~
.project
.classpath
.settings/
*.sublime-project
*.sublime-workspace

# ================================
# 系统文件
# ================================
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
desktop.ini

# ================================
# 日志和临时文件
# ================================
*.log
logs/
tmp/
temp/
*.tmp
*.cache

# ================================
# 数据库
# ================================
*.sql
*.sqlite
*.sqlite3
*.db

# ================================
# 其他
# ================================
coverage/
.nyc_output/
.cache/
EOF
```

### 4.2 验证 .gitignore

```bash
# 测试特定文件
git check-ignore -v .env

# 查看所有被忽略的文件
git ls-files --others --ignored --exclude-standard

# 状态检查
git status
```

### 4.3 如果文件已被追踪

```bash
# 从追踪中移除（保留本地）
git rm --cached -r .

# 重新添加（会遵循 .gitignore）
git add .

# 提交
git commit -m "Update .gitignore and remove tracked files"
```

---

## 第5步：最终验证

### 5.1 全面扫描检查

```bash
# 搜索可能的敏感信息
grep -r "api_key\|API_KEY\|secret\|password\|token" --include="*.py" --include="*.js" --include="*.json" --include="*.yml" --exclude-dir=node_modules --exclude-dir=__pycache__ .

# 检查是否有本地路径
grep -r "C:\\Users\\\|/Users/\|/home/" --include="*.py" --include="*.js" --include="*.md" .

# 检查即将提交的文件
git diff --cached --name-only
```

### 5.2 使用专业工具

**TruffleHog**
```bash
# 安装
pip install truffleHog

# 扫描
trufflehog --regex --entropy=False /path/to/project
```

**Git-secrets**
```bash
# 扫描历史
git secrets --scan-history

# 扫描当前
git secrets --scan
```

**Detect-secrets**
```bash
# 安装
pip install detect-secrets

# 扫描
detect-secrets scan > .secrets.baseline

# 审查
detect-secrets audit .secrets.baseline
```

### 5.3 最终检查清单

```bash
#!/bin/bash
# final-check.sh

echo "=== 最终安全检查 ==="

# 1. 检查是否有 .env 文件被追踪
if git ls-files | grep -q "^\.env$"; then
    echo "❌ 错误: .env 文件被Git追踪"
    exit 1
else
    echo "✅ .env 文件未被追踪"
fi

# 2. 检查 .gitignore 是否存在
if [ -f .gitignore ]; then
    echo "✅ .gitignore 存在"
else
    echo "⚠️  警告: .gitignore 不存在"
fi

# 3. 搜索敏感关键词
if git grep -qi "password\|secret\|api_key" --and --not "example"; then
    echo "⚠️  警告: 发现可能的敏感信息"
    git grep -ni "password\|secret\|api_key"
else
    echo "✅ 未发现明显的敏感信息"
fi

# 4. 检查大文件
large_files=$(find . -type f -size +50M -not -path "./.git/*" -not -path "./node_modules/*")
if [ -n "$large_files" ]; then
    echo "⚠️  警告: 发现大文件:"
    echo "$large_files"
else
    echo "✅ 无大文件"
fi

echo "=== 检查完成 ==="
```

---

## 特殊场景处理

### 场景1：已推送到公开仓库

```bash
# 紧急处理流程

# 1. 立即撤销所有泄露的凭证
# - 登录各服务提供商
# - 撤销/删除所有泄露的密钥

# 2. 清理Git历史
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# 3. 清理引用
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 4. 强制推送（谨慎！）
git push origin --force --all
git push origin --force --tags

# 5. 通知所有协作者
echo "请所有协作者重新克隆仓库！"
echo "git clone --recursive https://github.com/user/repo.git"
```

### 场景2：多分支仓库

```bash
# 清理所有分支
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# 推送所有分支
git push origin --force --all
```

### 场景3：子模块

```bash
# 检查子模块
git submodule status

# 递归检查
find . -type d -name ".git" | while read dir; do
    echo "检查: $dir"
    # 对每个子模块运行检查
done
```

---

## 完整清理脚本示例

```bash
#!/bin/bash
# cleanup.sh - 一键清理脚本

set -e  # 遇到错误立即退出

echo "=== 开始安全清理 ==="

# 备份
echo "1. 创建备份..."
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r . "$BACKUP_DIR/"
echo "   备份创建在: $BACKUP_DIR"

# 清理 .env
echo "2. 处理 .env 文件..."
if [ -f .env ]; then
    if git ls-files | grep -q "^\.env$"; then
        git rm --cached .env
        echo "   从Git追踪中移除 .env"
    fi
fi

# 确保 .env 在 .gitignore 中
if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo ".env" >> .gitignore
    echo "   添加 .env 到 .gitignore"
fi

# 提交更改
echo "3. 提交更改..."
git add .gitignore
git commit -m "Security: Remove sensitive files from tracking"

echo "=== 清理完成 ==="
echo "请手动检查以下内容："
echo "  1. 代码中是否有硬编码的密钥"
echo "  2. credentials.json 等凭证文件"
echo "  3. 本地路径需要替换"
echo "  4. 个人信息需要清理"
```

---

## 验证命令汇总

```bash
# 1. 检查文件状态
git status

# 2. 查看即将提交的内容
git diff --cached

# 3. 搜索敏感信息
git grep -i "password\|secret\|key\|token"

# 4. 检查忽略文件
git check-ignore -v .env

# 5. 查看所有被追踪的文件
git ls-files

# 6. 查看文件大小
find . -type f -exec ls -lh {} \; | awk '{print $5, $9}' | sort -rh | head -20
```

---

## 最终输出示例

```
═══════════════════════════════════════════════════════════
  ✅ 清理指导完成
═══════════════════════════════════════════════════════════

已完成的清理:
✅ P0 严重风险: 3个问题已处理
✅ P1 高风险: 2个问题已处理
✅ P2 中高风险: 1个问题已处理
✅ P3 中等风险: 5个问题已处理

创建的文件:
📄 .gitignore (已更新)
📄 .env.example (已创建)
📄 requirements.txt (已更新)

下一步:
1. 运行最终验证: bash final-check.sh
2. 测试代码是否正常运行
3. 确认无误后上传到GitHub

═══════════════════════════════════════════════════════════
```

---

## 注意事项

- ⚠️ 清理前务必备份
- ⚠️ 撤销密钥后代码可能需要更新
- ⚠️ 环境变量修改后需要测试
- ⚠️ Git历史清理是不可逆的
- ⚠️ 强制推送会影响其他协作者
- ✅ 清理后完整测试代码
- ✅ 通知团队成员重新克隆
- ✅ 定期进行安全审计
