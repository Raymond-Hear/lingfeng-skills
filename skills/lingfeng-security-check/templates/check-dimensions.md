# 安全检查维度

本文档定义了GitHub安全检查的6个核心维度。

## 维度总览

| 维度 | 优先级 | 检查内容 | 风险等级 |
|------|--------|----------|----------|
| 1. 凭证和密钥 | 最高 | API密钥、密码、Token、私钥 | 🔴🔴🔴 |
| 2. 个人信息(PII) | 高 | 姓名、邮箱、电话、地址 | 🟡 |
| 3. 本地路径 | 高 | 绝对路径、本地IP | 🟡 |
| 4. 敏感文件 | 最高 | .env、credentials、日志 | 🔴🔴🔴 |
| 5. 商业敏感 | 中高 | 内部地址、未公开信息 | 🟠 |
| 6. Git配置 | 中 | .gitignore、历史记录 | 🔵 |

---

## 维度1：凭证和密钥（最高优先级）🔴

### 检查内容

#### API密钥
```
搜索关键词:
- api_key, apikey, API_KEY, apiKey
- secret, SECRET, secret_key
- password, passwd, pwd, PASSWORD
- token, TOKEN, access_token, auth_token, bearer_token
- key, KEY, private_key, public_key
- jwt, json_web_token, session_key
```

#### 服务特定密钥
```
- AWS: aws_access_key, aws_secret_key
- Google: google_api_key, google_credentials
- Azure: azure_key, azure_subscription_key
- OpenAI: openai_api_key, OPENAI_API_KEY
- GitHub: github_token, GITHUB_TOKEN
- Stripe: stripe_api_key, stripe_secret_key
- Twilio: account_sid, auth_token
```

#### 证书和私钥
```
文件扩展名:
- *.key
- *.pem
- *.crt
- *.cert
- *.der
- *.p12
- *.pfx

文件名:
- id_rsa
- id_ed25519
- id_ecdsa
- private_key
- server.key
- client.cert
```

### 风险评估

| 情况 | 风险等级 | 处理建议 |
|------|----------|----------|
| 生产环境密钥 | 🔴🔴🔴 严重 | 立即撤销，使用环境变量 |
| 测试环境密钥 | 🔴🔴 高 | 撤销或使用环境变量 |
| 开发环境密钥 | 🟠 中高 | 使用环境变量 |
| 已过期密钥 | 🟢 低 | 可删除 |
| 演示密钥 | 🟢 低 | 可保留或用占位符 |

---

## 维度2：个人身份信息(PII) 🟡

### 检查内容

#### 联系方式
```
搜索关键词:
- email, e-mail, mail, EMAIL
- phone, mobile, tel, telephone
- address, location, ADDRESS
- contact, CONTACT
```

#### 账户信息
```
搜索关键词:
- username, userid, user_name
- account, ACCOUNT, profile
- handle, screen_name
```

#### 个人标识
```
搜索关键词:
- name, NAME (结合上下文)
- real_name, full_name
- id_card, ssn, passport
- birthday, dob
```

### 风险评估

| 信息类型 | 风险等级 | 处理建议 |
|---------|----------|----------|
| 邮箱地址 | 🟡 中 | 删除或用占位符 |
| 电话号码 | 🟡 中 | 删除 |
| 家庭地址 | 🟠 中高 | 删除 |
| 真实姓名 | 🟢 低 | 可选删除 |
| 用户名 | 🟢 低 | 可选删除 |

---

## 维度3：本地路径和环境信息 🟡

### 检查内容

#### Windows路径
```
模式:
- C:\\Users\\[用户名]
- D:\\[驱动器]\\...
- %USERPROFILE%\\
- %APPDATA%\\

示例:
C:\Users\YourName\Documents
C:\Users\John\AppData\Local
D:\Projects\MyProject
```

#### Unix路径
```
模式:
- /Users/[用户名] (macOS)
- /home/[用户名] (Linux)
- ~/[用户名]
- /usr/local/
- /opt/

示例:
/Users/john/Documents
/home/john/projects
~/config
/usr/local/bin
```

#### 本地地址
```
模式:
- localhost
- 127.0.0.1
- 0.0.0.0
- 192.168.x.x (私有IP)
- 10.x.x.x (私有IP)
- 172.16.x.x - 172.31.x.x (私有IP)
```

#### 数据库连接字符串
```
模式:
- mongodb://[user:pass@]host:port/db
- mysql://[user:pass@]host:port/db
- postgresql://[user:pass@]host:port/db
- redis://[pass@]host:port
- sqlite:///path/to/db
```

### 风险评估

| 路径类型 | 风险等级 | 处理建议 |
|---------|----------|----------|
| 含用户名的完整路径 | 🟡 中 | 替换为YOUR_USER_PATH |
| 通用用户路径 | 🟢 低 | 可保留 |
| 本地IP地址 | 🟢 低 | 替换为YOUR_HOST |
| 数据库连接 | 🟠 中高 | 使用环境变量 |

---

## 维度4：配置和敏感文件 🔴

### 检查的文件类型

#### 环境变量文件
```
文件名:
- .env
- .env.local
- .env.development.local
- .env.test.local
- .env.production.local
- .envrc
- .flaskenv
```

#### 凭证文件
```
文件名:
- credentials.json
- cred.json
- creds.json
- credentials.yml
- credentials.yaml
- secrets.yml
- secrets.yaml
- secret.txt
- keys.json
- auth.json
- .aws/credentials
- .aws/config
```

#### 密钥文件
```
文件扩展名:
- *.key
- *.pem
- *.cert
- *.crt
- *.der
- *.p12
- *.pfx
- *.keystore
- *.jks
```

#### 日志文件
```
文件名/模式:
- *.log
- logs/
- error.log
- access.log
- debug.log
- npm-debug.log
- yarn-error.log
```

#### 临时和缓存文件
```
目录/文件:
- tmp/
- temp/
- *.tmp
- *.cache
- cache/
- .cache/
- __pycache__/
- node_modules/
- vendor/
```

#### 编辑器和IDE配置
```
目录/文件:
- .vscode/
- .idea/
- *.swp
- *.swo
- *~
- .project
- .classpath
- .settings/
- *.sublime-project
- *.sublime-workspace
```

#### 系统文件
```
文件名:
- .DS_Store (macOS)
- Thumbs.db (Windows)
- desktop.ini (Windows)
- .Spotlight-V100
- .Trashes
```

### 风险评估

| 文件类型 | 风险等级 | 处理建议 |
|---------|----------|----------|
| .env文件 | 🔴🔴🔴 严重 | 立即添加到.gitignore |
| credentials.json | 🔴🔴🔴 严重 | 加密或移除 |
| *.key, *.pem | 🔴🔴🔴 严重 | 立即添加到.gitignore |
| 日志文件 | 🟠 中高 | 添加到.gitignore |
| 编辑器配置 | 🟢 低 | 添加到.gitignore |
| 系统文件 | 🟢 低 | 添加到.gitignore |

---

## 维度5：商业敏感信息 🟠

### 检查内容

#### 内部地址
```
搜索关键词:
- internal, INTERNAL
- intranet, INTRANET
- private, PRIVATE
- staging, STAGING
- dev, development

模式:
- https://internal.*.com
- https://intranet.*.com
- https://dev.*.com
- https://staging.*.com
- api.internal.*
```

#### 未公开信息
```
搜索关键词:
- undisclosed, UNDISCLOSED
- unreleased, UNRELEASED
- confidential, CONFIDENTIAL
- proprietary, PROPRIETARY
- secret, SECRET (商业)

示例:
- "未发布的功能"
- "即将推出"
- "内部测试"
```

#### 客户数据
```
搜索关键词:
- customer, CUSTOMER
- client, CLIENT
- user_data, USER_DATA
- personal_info, PERSONAL_INFO

示例:
- 客户名单
- 销售数据
- 用户统计
```

### 风险评估

| 信息类型 | 风险等级 | 处理建议 |
|---------|----------|----------|
| 内部API地址 | 🟠 中高 | 用占位符或环境变量 |
| 未公开功能 | 🟡 中 | 从公开代码中移除 |
| 客户数据 | 🔴🔴 高 | 完全移除 |
| 商业策略 | 🟠 中高 | 从公开代码中移除 |

---

## 维度6：Git配置和隐藏文件 🔵

### 检查内容

#### .gitignore 检查
```
检查项:
- .gitignore 文件是否存在
- 是否包含必要的忽略规则
- 是否忽略了敏感文件
- 规则格式是否正确
```

#### 敏感文件追踪状态
```
检查项:
- .env 是否被Git追踪
- credentials.json 是否被追踪
- *.key 文件是否被追踪
- 大文件是否被追踪

检查命令:
git ls-files | grep -E "\.env$|credentials|\.key$"
```

#### 大文件检查
```
检查项:
- 是否有大于50MB的文件
- 是否有大于100MB的文件
- 是否需要使用Git LFS

检查命令:
find . -type f -size +50M -not -path "./.git/*"
```

#### Git历史检查
```
检查项:
- 历史中是否有敏感信息
- 是否有敏感文件被删除但历史中仍存在

检查命令:
git log --all --full-history -- "*secret*"
git log --all --full-history -- "*.env"
```

### 风险评估

| 问题类型 | 风险等级 | 处理建议 |
|---------|----------|----------|
| .env被追踪 | 🔴🔴🔴 严重 | 立即从追踪中移除 |
| 历史中有敏感信息 | 🔴🔴🔴 严重 | 清理Git历史 |
| 缺少.gitignore | 🟠 中高 | 创建并配置 |
| 大文件未处理 | 🟡 中 | 使用Git LFS或移除 |
| 编辑器文件被追踪 | 🟢 低 | 添加到.gitignore |

---

## 检查优先级排序

```
优先级1（最高）:
├── 维度1: 凭证和密钥
└── 维度4: 敏感文件

优先级2:
├── 维度5: 商业敏感信息
└── 维度2: 个人信息

优先级3:
├── 维度3: 本地路径
└── 维度6: Git配置
```

---

## 搜索模式汇总

### 正则表达式模式

```regex
# 凭证和密钥
(api_key|apikey|API_KEY|secret|password|token|bearer|jwt).*=.*["\']?[a-zA-Z0-9]{20,}

# 本地路径
(C:\\\\Users\\\\|/Users/|/home/)[a-zA-Z0-9_]+

# 邮箱地址
\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b

# IP地址
\b(?:\d{1,3}\.){3}\d{1,3}\b

# API端点
https?://[a-z0-9]+\.internal\.[a-z]+
```

### Grep命令示例

```bash
# 搜索凭证
grep -r "api_key\|API_KEY\|secret\|password" --include="*.py" --include="*.js" --include="*.json"

# 搜索本地路径
grep -r "C:\\Users\\\|/Users/\|/home/" --include="*.py" --include="*.md"

# 搜索邮箱
grep -r -E "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" --include="*.md" --include="*.py"

# 搜索内部地址
grep -r "internal\|intranet" --include="*.js" --include="*.py"
```
