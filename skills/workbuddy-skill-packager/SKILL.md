---
name: workbuddy-skill-packager
description: 将已有或刚完成的 Agent Skill 转成 WorkBuddy 开放平台可上传的 Skill ZIP，并在内容定稿后准备 512×512 px 的上传头像。用户提到“转成 WorkBuddy 版”“技能要上传到 WorkBuddy”“适配 Work Body”或要修复 WorkBuddy 的技能包解析时使用。适用输入包括本地 Skill 目录、SKILL.md、ZIP 和可读取的仓库。
---

# WorkBuddy Skill 打包

当用户说这个 Skill 需要在 WorkBuddy 使用或上传到 WorkBuddy 时，接着当前创建流程完成适配和打包。已有 Skill 时直接用用户指定的版本。交付一个能下载的 `<skill-name>-workbuddy.zip`，生成的转换文件放在暂存目录。

1. **读源文件。** 找到目标 `SKILL.md`，沿着正文读实际依赖的资源，核对现有作者、版本、许可和运行条件。ZIP 先查看文件列表，再把所需文件复制到暂存目录。目录含多个 Skill 时，根据用户指定的名称选中目标。
2. **按目标平台改写。** 读 [WorkBuddy 适配规范](references/workbuddy-format.md)，映射标题、简介、示例和版本。把正文和内部资源引用改成 WorkBuddy 能使用的写法。保留原业务流程、输出要求、用户选择和权利声明。只在已有上下文无法确定公开作者，或多个 Skill 都符合指向时询问，并先准备可独立完成的内容。
3. **核对能力。** 查找 Codex 专属工具、连接器、权限或运行时。能从已提供的 WorkBuddy 能力找到等价操作时再替换。优先保留可独立执行的流程，其余说明需要的连接器或手工步骤。核心功能缺少可用的实现时，说明 ZIP 的适用范围与差异。
4. **打包并回读。** 用适配规范中的命令执行 `scripts/package_skill.py`。检查 ZIP 的单层技能目录、元信息、引用和目录内容。核对实际需要的脚本、模板、许可与依赖。公开分享时检查包里仅包含获准公开的资料，清除本机路径、凭证和私有作者档案。
5. **复核并定稿。** 有 WorkBuddy 会话可用时，用它复核文案和测试示例，根据复核结果修正并重打 ZIP。见 [WorkBuddy 内容复核与头像](references/workbuddy-release.md)。交付能直接使用的 ZIP，简要说明能力差异和检查结果。
6. **定稿后选头像。** 如果是准备提交 WorkBuddy，先给 ZIP，再请用户选择一张候选图或在聊天中上传原图。已有指定图就直接处理成 512×512 px。头像作为独立文件交付。收到上传授权后，在开放平台分别上传 ZIP 和头像，并回读表单状态。修复解析失败时用用户看到的错误和当时上传的文件定位。
