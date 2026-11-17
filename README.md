<div align="center">

# 🧰 lingfeng-skills

#### 聆风Raymond 每天在用的 AI Agent Skills，都开源在这里

[![License](https://img.shields.io/badge/License-MIT-yellow)](./LICENSE)
[![Skills](https://img.shields.io/badge/Skills-6-10B981)](#-技能目录)

![Claude Code](https://img.shields.io/badge/Claude_Code-Skill-D97706)
![Codex](https://img.shields.io/badge/Codex-Skill-10B981)
![40+ Agents](https://img.shields.io/badge/AgentSkills_Standard-Compatible-8B5CF6)

</div>

都是在自己工作流里跑通了一段时间的 Skill，遵循 [Agent Skills](https://agentskills.io) 开放标准，
Claude Code、Codex、Qoder、Kimi Code、Cursor 等 40+ 支持该标准的 Agent 都能装。

---

## 📋 技能目录

| 名字 | 一句话 | 依赖 |
|---|---|---|
| 🛡️ [**lingfeng-security-check**](skills/lingfeng-security-check/) | 上传 GitHub 前全面扫描敏感信息、隐私数据、本地路径，给出清理方案 | 无（纯提示词） |
| 🔬 [**lingfeng-deep-research-prompt**](skills/lingfeng-deep-research-prompt/) | 把一句话的深度研究需求优化成结构化提示词，适配 Perplexity / OpenAI Research / 千问 | 无（纯提示词） |
| 👋 [**lingfeng-jike**](skills/lingfeng-jike/) | 即刻客户端：扫码登录、刷动态、发帖评论搜索，token 自动刷新 | Python ≥3.10 + requests |
| 🖼️ [**lingfeng-xhs-article-to-images**](skills/lingfeng-xhs-article-to-images/) | Markdown 长文转小红书 3:4 图片组，8 套皮肤模板 + Playwright 截图 | Node ≥18 + Playwright |
| 📝 [**github-readme-writer**](skills/github-readme-writer/) | 用花叔式标题、徽章和导航写 GitHub README，按需添加公开作者资料 | 无（纯提示词） |
| 🌐 [**website-page-optimization-coach**](skills/website-page-optimization-coach/) | 从访客视角优化网页结构、按钮和状态提示，改掉空泛的 AI 文案 | 无（纯提示词） |

> 🌟 **独立仓库项目**（体积较大或带完整发布流程，单独维护）：
> [howto-topic-skill](https://github.com/Raymond-Hear/howto-topic-skill) — 把你和 AI 的对话变成能发的小红书 how-to 选题，写入飞书选题库

---

## 📦 安装方式

### 直接下载 ZIP

- [下载 GitHub README 写作](https://github.com/Raymond-Hear/lingfeng-skills/releases/download/skills-2026-11-17/github-readme-writer-share.zip)。解压后把整个 `github-readme-writer` 文件夹放进项目的 `.agents/skills/`，在 Codex 新聊天里调用 `$github-readme-writer`。
- [下载网站产品页优化教练](https://github.com/Raymond-Hear/lingfeng-skills/releases/download/skills-2026-11-17/website-page-optimization-coach.zip)。解压后把整个 `website-page-optimization-coach` 文件夹放进项目的 `.agents/skills/`，在 Codex 新聊天里调用 `$website-page-optimization-coach`。

### 方式一 · 对你的 Agent 说一句话（推荐）

```
帮我安装这个 skill：https://github.com/Raymond-Hear/lingfeng-skills/tree/main/skills/<skill-name>
```

把 `<skill-name>` 换成想装的，比如 `lingfeng-security-check`。Agent 会自己 clone 到对应目录。

### 方式二 · skills CLI 挑装

```bash
# 列出全部可用技能
bunx skills add Raymond-Hear/lingfeng-skills -l

# 安装单个
bunx skills add Raymond-Hear/lingfeng-skills -g --skill lingfeng-security-check -y

# 全部安装到 ~/.agents/skills/
bunx skills add Raymond-Hear/lingfeng-skills -g --skill '*' -y
```

### 方式三 · 手动 clone

```bash
git clone --depth 1 https://github.com/Raymond-Hear/lingfeng-skills.git
cp -r lingfeng-skills/skills/<skill-name> ~/.agents/skills/
```

### 依赖说明

- `lingfeng-security-check` / `lingfeng-deep-research-prompt` / `github-readme-writer` / `website-page-optimization-coach`：装完即用；
- `lingfeng-jike`：需 Python ≥3.10，首次使用按 SKILL.md 提示 `pip install requests qrcode[pil]`；
- `lingfeng-xhs-article-to-images`：需 Node ≥18，进入目录后 `npm install && npx playwright install chromium`。

---

## 🤝 署名与致谢

- [lingfeng-xhs-article-to-images](skills/lingfeng-xhs-article-to-images/) 基于
  [bozhouDev/xhs-article-to-images](https://github.com/bozhouDev/xhs-article-to-images)（MIT）收录整理，版权归原作者 Bozhou 所有。
- [website-page-optimization-coach](skills/website-page-optimization-coach/) 的网页文案编辑借鉴了 [Paul Bakaus 的 Impeccable](https://github.com/pbakaus/impeccable) 中的 `clarify` 和 `distill`。
- 本仓库自有内容按 MIT 许可开源。

## License

[MIT](LICENSE) © 2026 聆风Raymond
