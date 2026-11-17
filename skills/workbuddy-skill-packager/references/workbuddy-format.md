# WorkBuddy 技能包规范

结构按 WorkBuddy 开放平台的[技能文档](https://open.workbuddy.cn/docs/skill)。ZIP 中放一层与 `name` 一致的技能目录，里面有 `SKILL.md` 和用得上的 `references/`、`scripts/`、`templates/`。

## 元信息映射

| 字段 | 如何填写 |
| --- | --- |
| `name` | 优先沿用原 Skill 的小写英文标识，可包含数字和连字符。它也是 ZIP 内的目录名。 |
| `display_name` / `display_name_en` | 中英文展示名。可以沿用已有市场名称。 |
| `description` | 一句话说明实际能力和使用场景。 |
| `description_zh` / `description_en` | 给技能市场读者看的中英文简介，体现实际功能和依赖条件。 |
| `version` | 沿用已确认的技能版本。首次发布 WorkBuddy 版且原版无版本时，可用 `1.0.0`。 |
| `author` | WorkBuddy 要求提供合作方名称。用明确的公开作者或发布者名称。可用已确认的公开项目或组织名满足匿名分享需求。来源不明的第三方包先核实作者和授权。 |
| `examples_zh` / `examples_en` | 可选。各写 2 至 3 条实际可做的示例请求，保持两种语言语义一致。 |
| `allowed-tools` | 可选。平台指定白名单时再填写逗号分隔的已核实工具名。 |

## 资源与兼容性

- `references/` 放流程补充、示例、知识、许可文本或供模型阅读的 Markdown 模板。正文用 `@references/file.md` 引用，路径按技能目录相对定位。可把 `assets/readme-template.md` 移到 `references/readme-template.md`，并同步改正文。需要时保留更多资源，跟着文件查到实际引用为止。
- `scripts/` 放可执行脚本，正文写清从技能目录调用的命令、环境、参数和产出。`templates/` 放供运行或复制的模板脚本与配置。迁移后用新路径核对调用方。验证未知的第三方脚本前先检查代码和依赖。
- `agents/openai.yaml` 等平台专用清单中的展示信息可转入 WorkBuddy 字段。涉及工具、登录或权限的配置以确认过的 WorkBuddy 能力为准。
- 保留原作者和许可归属。需要随包分发的许可和声明，可保留原文放入 `references/`。作者变量或空白作者档案继续按原工作流使用，平台的 `author` 字段独立填写。
- 文档给的是文件布局与字段规范。用户要求提交或遇到解析差异时，按当前官方文档和平台报错核对。

## 调用打包脚本

在暂存位置分别准备 `metadata.json`、正文 `body.md` 和资源目录。JSON 使用表中的字段名、字符串和字符串数组。正文从 Markdown 标题开始。把要随 ZIP 发布的资源放在暂存资源目录的三个标准子目录下。需要全部为单文件时省略 `--resources`。

```text
python <此技能目录>/scripts/package_skill.py --metadata metadata.json --body body.md --resources staged-resources --output <输出目录>/<skill-name>-workbuddy.zip
```

脚本用 Python 3.9 及以上版本的标准库生成 YAML、检查 `@references/...` 路径并写出 ZIP。若运行环境没有 Python，沿用上面的布局用可用 ZIP 工具打包，再解压检查每个必填字段、引用和文件清单。
