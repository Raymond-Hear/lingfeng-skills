# GitHub安全检查示例报告

本文档包含了不同场景下的安全检查报告示例。

## 示例1：Python项目安全检查

### 项目信息
- **项目路径**: `D:\MyProjects\python-api`
- **项目类型**: Python FastAPI 项目
- **文件数量**: 45个文件

### 检查结果

```
═══════════════════════════════════════════════════════════
  GitHub安全检查报告
═══════════════════════════════════════════════════════════

项目: D:\MyProjects\python-api
检查时间: 2026-02-11 14:30:00
扫描文件: 45个

───────────────────────────────────────────────────────────

📊 风险概览
───────────────────────────────────────────────────────────
🔴🔴🔴 严重: 2个 (4%)
🔴🔴 高: 1个 (2%)
🟠 中高: 2个 (4%)
🟡 中: 5个 (10%)
🟢 低: 3个 (6%)
🔵 配置: 2个 (4%)

总计: 15个问题

───────────────────────────────────────────────────────────

🔴🔴🔴 严重风险 (P0)
───────────────────────────────────────────────────────────

1. [API密钥] config/settings.py:18
   类型: OpenAI API密钥
   内容: OPENAI_API_KEY = "sk-abc123..."
   影响: API费用损失、数据泄露
   建议: 立即撤销密钥，使用环境变量

   清理步骤:
   1. 访问 https://platform.openai.com/api-keys
   2. 撤销密钥 sk-abc123...
   3. 创建 .env 文件
   4. 添加到 .gitignore
   5. 更新代码使用 os.getenv()

2. [数据库密码] config/database.py:12
   类型: MongoDB密码
   内容: MONGO_PASSWORD = "admin123"
   影响: 数据库完全暴露
   建议: 立即修改密码，使用环境变量

   清理步骤:
   1. 修改数据库密码
   2. 创建 .env 文件
   3. 添加到 .gitignore

───────────────────────────────────────────────────────────

🔴🔴 高风险 (P1)
───────────────────────────────────────────────────────────

1. [JWT密钥] config/auth.py:8
   类型: JWT Secret硬编码
   内容: SECRET_KEY = "my-secret-key-123"
   影响: 可伪造Token
   建议: 使用环境变量

───────────────────────────────────────────────────────────

🟠 中高风险 (P2)
───────────────────────────────────────────────────────────

1. [内部地址] README.md:25
   类型: 内部API文档地址
   内容: https://api.internal.company.com/docs
   建议: 使用占位符

2. [凭证文件] secrets/aws.json
   类型: AWS凭证文件
   建议: 加密存储或移除

───────────────────────────────────────────────────────────

🟡 中等风险 (P3)
───────────────────────────────────────────────────────────

1. [本地路径] config/settings.py:45
   类型: Windows用户路径
   内容: C:\Users\YourName\Documents\config.json
   建议: 替换为 ~/Documents/config.json

2. [个人信息] README.md:5
   类型: 邮箱地址
   内容: 作者邮箱: john@example.com
   建议: 删除或使用占位符

3-5. [其他问题]...

───────────────────────────────────────────────────────────

🔵 配置问题
───────────────────────────────────────────────────────────

1. [.gitignore] .gitignore 缺失
   影响: 敏感文件可能被提交
   建议: 创建 .gitignore 并添加规则

2. [大文件] data/large-dataset.csv
   大小: 125MB
   建议: 使用 Git LFS 或移除

───────────────────────────────────────────────────────────

✅ 检查完成

处理优先级:
立即 (P0): 撤销API密钥、修改数据库密码
本周 (P1): 处理JWT密钥
本月 (P2): 清理内部地址
可选 (P3): 清理个人信息
═══════════════════════════════════════════════════════════
```

### 清理前后对比

#### config/settings.py

```diff
 import os
+from dotenv import load_dotenv
+
+load_dotenv()

# API配置
-OPENAI_API_KEY = "sk-abc123def456ghi789"
-DATABASE_URL = "mongodb://admin:admin123@localhost:27017/mydb"
-SECRET_KEY = "my-secret-key-123"
+OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
+DATABASE_URL = os.getenv("DATABASE_URL", "mongodb://localhost:27017/mydb")
+SECRET_KEY = os.getenv("SECRET_KEY")

# 文件路径
-CONFIG_PATH = "C:\Users\YourName\\Documents\\config.json"
+CONFIG_PATH = os.path.expanduser("~/Documents/config.json")
```

#### README.md

```diff
-**作者**: John Smith <john@example.com>
+**作者**: [Your Name]
-**API文档**: https://api.internal.company.com/docs
+**API文档**: https://api.example.com/docs
```

---

## 示例2：Node.js项目安全检查

### 项目信息
- **项目路径**: `/home/john/projects/nodejs-app`
- **项目类型**: Node.js Express 项目
- **文件数量**: 38个文件

### 检查结果

```
═══════════════════════════════════════════════════════════
  GitHub安全检查报告
═══════════════════════════════════════════════════════════

项目: /home/john/projects/nodejs-app
检查时间: 2026-02-11 15:45:00
扫描文件: 38个

───────────────────────────────────────────────────────────

📊 风险概览
───────────────────────────────────────────────────────────
🔴🔴🔴 严重: 1个 (3%)
🟠 中高: 1个 (3%)
🟡 中: 3个 (8%)
🔵 配置: 3个 (8%)

总计: 8个问题

───────────────────────────────────────────────────────────

🔴🔴🔴 严重风险
───────────────────────────────────────────────────────────

1. [.env文件] .env
   问题: 环境变量文件存在且被Git追踪
   内容包含:
   - DATABASE_URL=postgresql://user:pass@localhost/db
   - STRIPE_SECRET_KEY=sk_test_...
   - JWT_SECRET=secret123

   紧急处理:
   1. git rm --cached .env
   2. echo ".env" >> .gitignore
   3. 修改所有泄露的密码和密钥
   4. git add .gitignore
   5. git commit -m "Remove .env from tracking"

───────────────────────────────────────────────────────────

🟠 中高风险
───────────────────────────────────────────────────────────

1. [凭证文件] config/service-account.json
   类型: Google Service Account凭证
   建议: 移到安全位置，加密存储

───────────────────────────────────────────────────────────

🟡 中等风险
───────────────────────────────────────────────────────────

1. [本地路径] src/config.js:15
   类型: Unix用户路径
   内容: /home/john/projects/config.json
   建议: 使用相对路径或 process.env.HOME

2. [硬编码端口] server.js:10
   内容: const PORT = 3000;
   建议: 使用 process.env.PORT || 3000

3. [个人信息] package.json:8
   内容: "author": "John Doe <john@example.com>"
   建议: 移除邮箱

───────────────────────────────────────────────────────────

🔵 配置问题
───────────────────────────────────────────────────────────

1. [.gitignore] 缺少 node_modules/
2. [.gitignore] 缺少 .env
3. [依赖] package-lock.json 被追踪

建议的 .gitignore:
node_modules/
.env
.env.local
dist/
*.log
```

---

## 示例3：已公开仓库的紧急处理

### 场景描述
用户发现已经推送到GitHub的仓库中包含敏感信息。

### 紧急处理步骤

```
═══════════════════════════════════════════════════════════
  🚨 紧急安全事件处理
═══════════════════════════════════════════════════════════

发现时间: 2026-02-11 16:00
仓库: https://github.com/user/repo
状态: 已公开，包含敏感信息

───────────────────────────────────────────────────────────

⚡ 立即行动 (5分钟内)
───────────────────────────────────────────────────────────

1. 🔑 撤销所有泄露的凭证
   ✅ OpenAI API密钥 - 已撤销
   ✅ 数据库密码 - 已修改
   ✅ AWS访问密钥 - 已撤销
   ✅ Stripe密钥 - 已撤销

2. 📧 通知团队成员
   ✅ 发送通知: "紧急：仓库包含敏感信息，请重新克隆"
   ✅ 要求所有人重新克隆仓库

3. 🔄 检查异常使用
   ✅ 检查OpenAI API使用记录
   ✅ 检查数据库访问日志
   ✅ 检查AWS CloudTrail日志

───────────────────────────────────────────────────────────

🔧 清理Git历史 (10分钟内)
───────────────────────────────────────────────────────────

使用 BFG Repo-Cleaner:

# 1. 安装 BFG
brew install bfg

# 2. 创建密码文件
cat > passwords.txt << EOF
*.env*-->***REMOVED***
password-->***REMOVED***
secret-->***REMOVED***
api_key-->***REMOVED***
EOF

# 3. 清理文件
bfg --delete-files .env
bfg --delete-files credentials.json
bfg --replace-text passwords.txt

# 4. 清理引用
cd repo
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 5. 强制推送
git push origin --force --all
git push origin --force --tags

⚠️ 警告: 强制推送会影响其他协作者！

───────────────────────────────────────────────────────────

✅ 验证清理 (清理后)
───────────────────────────────────────────────────────────

1. 检查历史是否干净
git log --all --full-history -- ".env"

2. 检查是否还有敏感信息
git log -p --all -S "sk-" --source --all

3. 重新克隆验证
git clone https://github.com/user/repo.git repo-verify
cd repo-verify
grep -r "password\|secret\|api_key" .

───────────────────────────────────────────────────────────

📋 预防措施
───────────────────────────────────────────────────────────

1. 安装 git-secrets
brew install git-secrets
git secrets --install
git secrets --register-aws
git secrets --add 'password\s*=\s*".+?"'

2. 配置 pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
if git diff --cached --name-only | xargs grep -l "password\|secret\|api_key"; then
    echo "⚠️  检测到可能的敏感信息！"
    exit 1
fi
EOF
chmod +x .git/hooks/pre-commit

3. 使用 pre-commit 框架
pip install pre-commit
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
EOF
pre-commit install

═══════════════════════════════════════════════════════════
  ✅ 紧急处理完成
═══════════════════════════════════════════════════════════

完成时间: 2026-02-11 16:25
耗时: 25分钟

后续:
- 持续监控账户活动
- 每24小时检查一次，持续一周
- 通知所有相关方
```

---

## 示例4：清理前后完整对比

### 清理前

```python
# config.py
import pymongo

# API配置
OPENAI_API_KEY = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234yz"
DATABASE_URL = "mongodb://admin:Admin123!@localhost:27017/myapp"
JWT_SECRET = "my-super-secret-jwt-key-12345"

# 文件路径
CONFIG_FILE = "C:\Users\YourName\\Documents\\myapp\\config.json"
LOG_PATH = "C:\Users\YourName\\Documents\\myapp\\logs\\app.log"

# AWS配置
AWS_ACCESS_KEY = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

```markdown
# README.md

# My Application

作者：张三
邮箱：zhangsan@example.com
电话：13800138000

## API文档

内部文档: https://api.internal.company.com/docs

## 数据库

生产数据库: mongodb://admin:Admin123!@prod.internal.company.com:27017
```

```
# .env (被Git追踪)
OPENAI_API_KEY=sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234yz
DATABASE_URL=mongodb://admin:Admin123!@localhost:27017/myapp
JWT_SECRET=my-super-secret-jwt-key-12345
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### 清理后

```python
# config.py
import os
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()

# API配置
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
DATABASE_URL = os.getenv("DATABASE_URL", "mongodb://localhost:27017/myapp")
JWT_SECRET = os.getenv("JWT_SECRET")

# 文件路径（使用跨平台方式）
CONFIG_DIR = Path.home() / "Documents" / "myapp"
CONFIG_FILE = str(CONFIG_DIR / "config.json")
LOG_PATH = str(CONFIG_DIR / "logs" / "app.log")

# AWS配置
AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
```

```markdown
# README.md

# My Application

作者：[Your Name]

## API文档

[API文档](https://api.example.com/docs)

## 配置

请参考 [配置指南](docs/CONFIGURATION.md) 了解如何设置环境变量。
```

```
# .env.example (可以提交到Git)
# OpenAI API配置
OPENAI_API_KEY=your_openai_api_key_here

# 数据库配置
DATABASE_URL=mongodb://username:password@localhost:27017/database

# JWT配置
JWT_SECRET=your_jwt_secret_here

# AWS配置
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
```

```
# .env (不提交到Git)
# 实际的配置值
OPENAI_API_KEY=sk-proj-new-key-here
DATABASE_URL=mongodb://admin:NewSecurePassword!@localhost:27017/myapp
JWT_SECRET=generated-secure-random-key
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
```

```gitignore
# .gitignore
# 环境变量
.env
.env.local
.env.*.local

# Python
__pycache__/
*.py[cod]
*.so

# IDE
.vscode/
.idea/

# 日志
*.log
logs/

# 系统
.DS_Store
Thumbs.db
```

---

## 示例5：最终验证脚本

```bash
#!/bin/bash
# final-verification.sh - 最终验证脚本

echo "=== GitHub上传前最终验证 ==="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查计数
errors=0
warnings=0

# 1. 检查.env是否被追踪
echo "1. 检查.env文件..."
if git ls-files | grep -q "^\.env$"; then
    echo -e "${RED}❌ 错误: .env 文件被Git追踪${NC}"
    errors=$((errors + 1))
else
    echo -e "${GREEN}✅ .env 文件未被追踪${NC}"
fi

# 2. 检查.gitignore
echo ""
echo "2. 检查.gitignore..."
if [ ! -f .gitignore ]; then
    echo -e "${YELLOW}⚠️  警告: .gitignore 不存在${NC}"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ .gitignore 存在${NC}"

    # 检查关键规则
    required_rules=(".env" "*.key" "credentials.json" "*.log")
    for rule in "${required_rules[@]}"; do
        if ! grep -q "^$rule" .gitignore; then
            echo -e "${YELLOW}⚠️  .gitignore 缺少规则: $rule${NC}"
            warnings=$((warnings + 1))
        fi
    done
fi

# 3. 搜索敏感关键词
echo ""
echo "3. 搜索敏感信息..."
sensitive_patterns=("password.*=" "secret.*=" "api_key.*=" "OPENAI_API_KEY")
found=0
for pattern in "${sensitive_patterns[@]}"; do
    if git grep -qi "$pattern" --and --not "example" --and --not "your_" 2>/dev/null; then
        echo -e "${RED}❌ 发现可能的敏感信息: $pattern${NC}"
        git grep -ni "$pattern" --and --not "example" --and --not "your_"
        found=1
    fi
done

if [ $found -eq 0 ]; then
    echo -e "${GREEN}✅ 未发现明显的敏感信息${NC}"
else
    errors=$((errors + found))
fi

# 4. 检查大文件
echo ""
echo "4. 检查大文件..."
large_files=$(find . -type f -size +50M -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./__pycache__/*")
if [ -n "$large_files" ]; then
    echo -e "${YELLOW}⚠️  发现大文件:${NC}"
    echo "$large_files"
    warnings=$((warnings + 1))
else
    echo -e "${GREEN}✅ 无大文件（>50MB）${NC}"
fi

# 5. 检查即将提交的文件
echo ""
echo "5. 检查暂存区..."
staged_files=$(git diff --cached --name-only)
if [ -n "$staged_files" ]; then
    echo -e "${GREEN}暂存的文件:${NC}"
    echo "$staged_files"
else
    echo -e "${YELLOW}没有暂存的文件${NC}"
fi

# 总结
echo ""
echo "═══════════════════════════════════════════════════"
if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
    echo -e "${GREEN}✅ 所有检查通过！可以安全上传到GitHub${NC}"
    exit 0
elif [ $errors -eq 0 ]; then
    echo -e "${YELLOW}⚠️  发现 $warnings 个警告，建议处理后上传${NC}"
    exit 0
else
    echo -e "${RED}❌ 发现 $errors 个错误和 $warnings 个警告${NC}"
    echo -e "${RED}请处理后再上传到GitHub！${NC}"
    exit 1
fi
```

---

## 总结

以上示例展示了：

1. **标准检查报告** - 包含完整的扫描和评估结果
2. **不同项目类型** - Python、Node.js等
3. **紧急情况处理** - 已公开仓库的处理流程
4. **清理前后对比** - 具体的代码变更示例
5. **验证脚本** - 自动化验证工具

使用这些示例作为参考，可以更好地理解和应用GitHub安全检查流程。
