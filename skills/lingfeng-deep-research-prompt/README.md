# Deep Research Prompt 优化助手

<div align="center">

**将简单的 research 请求优化为有效的提示词**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange.svg)](https://claude.ai/claude-code)

</div>

---

## 📖 简介

**Deep Research Prompt 优化助手** 是一个 Claude Code Skill，专门帮助你将简单的 research 请求转化为结构化、专业的提示词，适用于各种 AI 深度研究工具。

### ✨ 主要功能

- 🔍 **智能分析请求** - 识别研究类型、关键实体、复杂度
- 📊 **系统化研究框架** - 提供 6 种专业研究框架
- 🎯 **子问题拆解** - 自动拆解 3-5 个核心研究问题
- 📚 **信息来源指引** - 明确应该关注的信息源类型
- 📝 **输出格式规范** - 规定最终输出的结构和格式
- 🌐 **多平台优化** - 支持 Perplexity、OpenAI Research、千问深度研究等

---

## 🎯 适用场景

| 场景 | 示例请求 | 推荐框架 |
|------|----------|----------|
| 📢 事件/发言整理 | "整理xxx在2026达沃斯论坛的发言" | 时间线框架 |
| 📈 趋势分析 | "分析AI Agent在2026年的发展趋势" | PEST分析框架 |
| 🏢 公司研究 | "研究Anthropic的商业模式" | 商业模式画布 |
| 💡 观点整理 | "整理专家对AI发展的不同观点" | 多维度对比框架 |
| 🔬 探索了解 | "了解一下量子计算的最新进展" | 概览+重点深入框架 |

---

## 🚀 快速开始

### 安装步骤

#### 方式 1: 自动安装（推荐）

```bash
# 克隆仓库
git clone https://github.com/Raymond-Hear/deep-research-prompt.git

# 复制到 Claude Code skills 目录
# Windows
xcopy /E /I deep-research-prompt "%USERPROFILE%\.claude\skills\deep-research-prompt"

# macOS/Linux
cp -r deep-research-prompt ~/.claude/skills/
```

#### 方式 2: 手动安装

1. **下载文件**
   - 下载整个仓库的 ZIP 文件，或使用 `git clone`

2. **创建目标目录**
   ```bash
   # Windows
   mkdir %USERPROFILE%\.claude\skills\deep-research-prompt

   # macOS/Linux
   mkdir -p ~/.claude/skills/deep-research-prompt
   ```

3. **复制文件**
   - 将所有文件复制到 `~/.claude/skills/deep-research-prompt/` 目录
   - 确保目录结构如下：
     ```
     deep-research-prompt/
     ├── SKILL.md
     ├── stages/
     ├── templates/
     └── examples/
     ```

4. **重启 Claude Code**
   - 完全关闭 Claude Code
   - 重新启动应用

---

## 📖 使用方法

### 基本使用

1. **启动 Claude Code**

2. **调用 Skill**
   ```
   /deep-research-prompt
   ```

3. **输入你的研究请求**
   ```
   整理吴恩达在2026达沃斯论坛的发言
   ```

4. **回答引导问题**
   - 选择目标平台（Perplexity / OpenAI Research / 千问 / 通用）
   - 选择详细程度（快速版 / 标准版 / 完整版）

5. **获取优化后的提示词**
   - Skill 会生成完整的、结构化的研究提示词
   - 复制提示词到你选择的研究工具

---

## 🛠️ 配置选项

### 支持的平台

| 平台 | 特点 | 优化重点 |
|------|------|----------|
| **Perplexity** | 实时搜索、来源引用丰富 | 强调实时性和来源链接 |
| **OpenAI Research** | 深度分析、综合能力 | 强调多角度思考和批判性评估 |
| **千问深度研究** | 中文内容、本地化 | 强调中文信息源和本地化环境 |
| **通用版本** | 适用于所有平台 | 平衡的通用配置 |

### 详细程度

| 版本 | 适用场景 | 输出内容 |
|------|----------|----------|
| **快速版** | 时间有限、快速获取信息 | 5-7个核心要点 |
| **标准版** | 常规研究（推荐） | 完整框架、详细分析 |
| **完整版** | 专业用途、需要详尽信息 | 极度详尽、含对比分析 |

---

## 📂 项目结构

```
deep-research-prompt/
├── SKILL.md                           # Skill 主配置文件
├── stages/                            # 工作流阶段
│   ├── 01-analyze-request.md         # 阶段1: 分析请求
│   ├── 02-generate-prompt.md         # 阶段2: 生成提示词
│   └── 03-refine-adjust.md           # 阶段3: 调整优化
├── templates/                         # 可复用模板
│   ├── research-framework.md         # 6种研究框架
│   ├── output-format.md              # 4种输出格式
│   └── prompt-template.md            # 完整提示词模板
├── examples/                          # 使用示例
│   └── sample-optimizations.md       # 5个示例案例
└── README.md                          # 本文档
```

---

## 🎨 研究框架

Skill 内置 6 种专业研究框架：

| 框架 | 适用场景 | 特点 |
|------|----------|------|
| **时间线框架** | 事件/发言整理 | 按时间顺序+主题分类 |
| **PEST分析框架** | 趋势分析 | 政治、经济、社会、技术 |
| **SWOT分析框架** | 战略分析 | 优势、劣势、机遇、威胁 |
| **多维度对比框架** | 观点整理 | 支持方、反对方、中立方 |
| **商业模式画布** | 公司研究 | 9大模块分析 |
| **概览+重点深入框架** | 探索了解 | 总览+重点领域 |

---

## 📝 示例

### 示例 1: 事件发言整理

**输入**:
```
整理吴恩达在2026达沃斯论坛的发言
```

**输出**:
- 📋 完整的时间线梳理
- 🏷️ 按主题分类的观点
- 💬 重要引用汇总
- 📰 媒体反响整理

### 示例 2: 趋势分析

**输入**:
```
分析AI Agent在2026年的发展趋势和商业机会
```

**输出**:
- 📊 PEST四维度分析
- 🎯 5个核心研究问题
- 💡 商业机会识别
- ⚠️ 风险与挑战评估

### 示例 3: 公司研究

**输入**:
```
研究Anthropic的商业模式
```

**输出**:
- 🏢 商业模式画布（9大模块）
- 📊 财务和融资情况
- 🆚 竞争对手分析
- 🔮 发展前景预测

---

## 🔧 高级使用

### 自定义提示词

Skill 支持在生成后进行调整：

1. **调整详细程度** - 快速版 ↔ 标准版 ↔ 完整版
2. **移除某些维度** - 去掉不需要的部分
3. **针对特定工具优化** - 选择目标平台
4. **调整输出格式** - 自定义输出结构

### 批量处理

可以连续处理多个 research 请求，每个请求都会：
- 独立分析
- 生成专属提示词
- 保持上下文连贯性

---

## 💡 最佳实践

### ✅ 推荐做法

1. **明确研究目标** - 越具体的目标，生成的提示词越有效
2. **选择合适平台** - 根据需求选择 Perplexity/OpenAI/千问
3. **充分利用框架** - 让 Skill 选择最合适的研究框架
4. **参考示例** - 查看 examples/ 目录中的示例案例
5. **迭代优化** - 根据反馈调整提示词

### ❌ 避免做法

1. ❌ 过于宽泛的请求（如"了解一下AI"）
2. ❌ 忽略平台差异（不同平台有不同的优势）
3. ❌ 跳过调整环节（阶段3的调整很重要）
4. ❌ 不阅读生成结果（确保提示词符合需求）

---

## 🤝 贡献

欢迎贡献！你可以：

1. **报告问题** - [提交 Issue](https://github.com/Raymond-Hear/deep-research-prompt/issues)
2. **提出建议** - [提交 Feature Request](https://github.com/Raymond-Hear/deep-research-prompt/issues)
3. **提交代码** - Fork 项目，创建 Pull Request

---

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

---

## 🙏 致谢

- 感谢 Claude Code 团队提供的 Skill 系统
- 感谢所有贡献者和用户的支持

---

## 📞 联系方式

- **GitHub**: [Raymond-Hear](https://github.com/Raymond-Hear)
- **Issue**: [提交问题](https://github.com/Raymond-Hear/deep-research-prompt/issues)

---

## 🌟 Star History

如果这个项目对你有帮助，请给它一个 ⭐ Star！

---

<div align="center">

**Made with ❤️ by Raymond-Hear**

[⬆ 返回顶部](#deep-research-prompt-优化助手)

</div>
