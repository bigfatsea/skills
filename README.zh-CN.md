<!-- Ver 2026-07-19 08:00, by Claude Sonnet 5 -->

[English](README.md)

# skills

可复用的 AI-agent 技能集合，覆盖商业评审、创业想法评估、prompt/spec 设计、内容创作，以及本地开发工具链。

本仓库按 [`npx skills`](https://www.npmjs.com/package/skills) 的标准结构组织，公开 GitHub 源为：

```text
https://github.com/bigfatsea/skills
```

## 技能列表

每个技能的 `SKILL.md` 是触发条件、工作流程和输出格式的唯一信息源。下表刻意只做索引，不复述细节——完整内容请看 `.agents/skills/<name>/SKILL.md`。

| 技能 | 何时使用 |
| --- | --- |
| `master-bp-review` | 已有一份商业计划书、pitch deck 或 memo（不是原始想法），想要多视角的投资人式/战略评审。 |
| `startup-idea-evaluator` | 想让一个创业想法、pivot 方向、GTM 路径或变现逻辑接受可行性判断。 |
| `prompt-architect` | 有一个粗糙的功能/产品/工程需求，想把它打磨成可直接交给 Claude Code 实现的 prompt。 |
| `synthesize-documents` | 手头有多份草稿/报告/memo，想合并成一份保留分歧和少数意见的综合文档。 |
| `ai-script` | 任务需要通过本地 `ai-script` CLI 调用真实的 AI 生成/检索能力：LLM、TTS、STT、图像、音乐、视频、网页/学术检索、抓取。 |
| `dev-env-audit` | 想对本机 macOS 开发环境做只读审计：SDK 安装方式、版本管理器冲突、PATH 漂移、缓存外置情况。 |
| `interview-methodology` | 正在准备访谈、整理转写稿，或从口述史材料中提炼故事核心。 |
| `audio-album-creator` | 有关于某个人或某段人生经历的素材（音频/文字/照片），想产出可直接投入制作的原创专辑方案。 |

## 安装

从 GitHub 列出可用技能：

```bash
npx -y skills add https://github.com/bigfatsea/skills --list
```

安装 GitHub 上的全部技能：

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill '*'
```

安装单个指定技能（名称需与 `.agents/skills/` 下的目录名一致）：

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill startup-idea-evaluator
```

将全部技能安装到指定 agent：

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill '*' -a codex -a claude-code
```

从本地克隆的仓库进行本地开发：

```bash
npx -y skills add . --list
npx -y skills add . --skill '*'
```

## 仓库结构

技能存放在标准发现路径下，一个技能一个目录，各自带有自己的 `SKILL.md`：

```text
.agents/skills/<skill-name>/SKILL.md
```

上面的技能列表是从该目录生成的——如需当前权威清单，运行 `ls .agents/skills` 查看，不要信任本文档里写死的列表。
