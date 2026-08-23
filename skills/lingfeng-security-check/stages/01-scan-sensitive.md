# 阶段1：扫描敏感信息

## 目标
全面扫描项目中可能存在的敏感信息，涵盖6个核心维度。

## 扫描流程

### 步骤1：获取项目信息

首先了解项目结构：
```bash
# 获取文件列表（使用Glob工具）
# 查找所有代码文件、配置文件、文档文件
```

**需要扫描的文件类型：**
- 代码文件：.py, .js, .ts, .java, .go, .rb, .php 等
- 配置文件：.json, .yaml, .yml, .ini, .conf, .env 等
- 文档文件：.md, .txt, .rst 等
- 脚本文件：.sh, .bat, .ps1 等
- 模板文件：.html, .css, .sql 等

### 步骤2：扫描6个维度

#### 维度1：凭证和密钥（最高优先级）

**搜索关键词：**
```
api_key, apikey, API_KEY, apiKey
secret, SECRET, secret_key
password, passwd, pwd, PASSWORD
token, TOKEN, access_token, auth_token, bearer_token
key, KEY, private_key, public_key
jwt, json_web_token, session_key
oauth, oauth_token, client_secret
credential, cred, credentials
aws_access_key, aws_secret_key
google_credentials, azure_key
```

**检查模式：**
```python
# 硬编码的密钥
API_KEY = "sk-..."
secret = "..."
password = "..."

# 配置文件中的密钥
{
  "api_key": "...",
  "secret": "..."
}
```

**输出格式：**
```
🔴 [凭证] [文件路径]:[行号]
   类型: API密钥/密码/Token等
   预览: sk-****[前4字符]
   风险: 高
```

#### 维度2：个人身份信息(PII)

**搜索关键词：**
```
email, e-mail, mail, EMAIL
phone, mobile, tel, telephone
address, location, ADDRESS
username, userid, user_name
account, ACCOUNT, profile
contact, CONTACT
name, NAME (结合上下文判断)
```

**检查模式：**
```markdown
作者：张三
邮箱：zhangsan@example.com
电话：13800138000
```

**输出格式：**
```
🟡 [个人信息] [文件路径]:[行号]
   类型: 邮箱/电话/姓名等
   内容: 具体内容
   风险: 中/低
```

#### 维度3：本地路径和环境信息

**搜索关键词：**
```
# Windows路径
C:\\Users\\, C:\\Users\\[用户名]
D:\\, E:\\

# Unix路径
/Users/, /home/, /home/[用户名]
~/[用户名]

# 本地地址
localhost, 127.0.0.1, 0.0.0.0
192.168., 10., 172.16.
file:///

# 数据库连接
mongodb://, mysql://, postgresql://
redis://, sqlite:///
```

**检查模式：**
```python
# 硬编码的本地路径
config_path = "C:\Users\YourName\\config.json"
db_url = "mongodb://localhost:27017"
```

**输出格式：**
```
🟡 [本地路径] [文件路径]:[行号]
   类型: Windows路径/本地IP等
   原始: C:\Users\YourName\\...
   建议: YOUR_USER_PATH
```

#### 维度4：配置和敏感文件

**检查文件名：**
```
.env, .env.local, .env.production
credentials.json, cred.json, creds.yml
secrets.yml, secrets.yaml, secret.txt
*.key, *.pem, *.cert, *.crt
id_rsa, id_ed25519
database.yml, config.ini
settings.py (可能包含密钥)
*.log, logs/
```

**输出格式：**
```
🔴 [敏感文件] [文件路径]
   类型: .env/凭证文件等
   风险: 高
   建议: 添加到.gitignore
```

#### 维度5：商业敏感信息

**搜索关键词：**
```
internal, INTERNAL
intranet, INTRANET
private, PRIVATE
undisclosed, UNDISCLOSED
unreleased, UNRELEASED
confidential, CONFIDENTIAL
proprietary, PROPRIETARY
```

**检查模式：**
```javascript
const API_URL = "https://api.internal.company.com";
```

**输出格式：**
```
🟠 [商业敏感] [文件路径]:[行号]
   类型: 内部地址等
   风险: 中
   建议: 使用占位符
```

#### 维度6：Git配置和隐藏文件

**检查项：**
- 是否存在 .gitignore
- .gitignore 是否完善
- 是否有大文件（>50MB）
- 是否有不必要的追踪文件

**检查文件：**
```
.vscode/, .idea/
*.swp, *.swo
.DS_Store, Thumbs.db
__pycache__/, node_modules/
```

**输出格式：**
```
🔵 [Git配置] 检查项
   发现: 具体问题
   建议: 具体措施
```

### 步骤3：汇总扫描结果

按优先级排序：
1. 🔴 高优先级：凭证、密钥、敏感文件
2. 🟠 中高优先级：商业敏感信息
3. 🟡 中优先级：个人信息、本地路径
4. 🔵 配置优先级：Git配置
5. 🟢 低优先级：其他信息

## 输出示例

```
═══════════════════════════════════════════════════════════
  安全扫描报告 - 阶段1：敏感信息扫描
═══════════════════════════════════════════════════════════

📁 项目: [项目路径]
📊 扫描文件数: [数量]
⏱️ 扫描时间: [时间]

───────────────────────────────────────────────────────────

🔴 高风险发现 (3个)
───────────────────────────────────────────────────────────

1. [凭证] config/config.py:15
   类型: API密钥
   预览: OPENAI_API_KEY = "sk-abc1..."
   风险: 高
   建议: 使用环境变量替换

2. [凭证] .env:3
   类型: 环境变量文件
   预览: API_KEY=sk-xxx
   风险: 高
   建议: 添加到.gitignore

3. [敏感文件] credentials.json
   类型: 凭证文件
   风险: 高
   建议: 添加到.gitignore或加密

───────────────────────────────────────────────────────────

🟠 中高风险发现 (2个)
───────────────────────────────────────────────────────────

[继续列出...]

───────────────────────────────────────────────────────────

🟡 中风险发现 (5个)
───────────────────────────────────────────────────────────

[继续列出...]

───────────────────────────────────────────────────────────

🔵 配置问题 (2个)
───────────────────────────────────────────────────────────

[继续列出...]

═══════════════════════════════════════════════════════════
✅ 扫描完成
═══════════════════════════════════════════════════════════

总计发现: 12个问题
- 🔴 高风险: 3个
- 🟠 中高风险: 2个
- 🟡 中风险: 5个
- 🔵 配置问题: 2个

进入阶段2: 评估风险和影响...
```

## 注意事项

- 使用Grep工具搜索关键词
- 使用Glob工具查找文件
- 根据文件类型调整搜索策略
- 注意区分真阳性（真正的敏感信息）和假阳性（无害的关键词）
- 对每个发现提供上下文，帮助用户判断
