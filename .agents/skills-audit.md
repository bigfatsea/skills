# `.agents/skills` 全面审计报告

<!-- Ver 2026-07-18 21:37 +08, by Claude (Fable 5) · 一次性深度审计 (edited 2026-07-19 08:00 by Claude Sonnet 5: superseded-doc disclaimer, skill-creator section removed — see note below) -->

> ⚠️ **本文档已被 `.agents/skills-issue-report.md` 取代（2026-07-19 核实版）**。
> 那份文档逐条核实了下面的结论（实际读文件、跑命令），发现 **§11.3/§12 关于 `.venv`/`__pycache__`/`.DS_Store` "已入库需清理"的核心判断是错的**（三者从未被 git 跟踪，本文档完全没提到这一点）；另外本文档写于 `dev-env-audit` 那一轮大改（去 Python 化、三套 HTML 模板、默认英文报告）**之前**，第 3 节关于 dev-env-audit 的内容已大部分过时。
> 本文档的**定性分析和优点归纳仍有参考价值**（每个 skill 的设计取舍、术语提炼），但任何具体技术结论请以 `skills-issue-report.md` 为准，不要单独引用本文档下判断。
> **另注**：本文档写作时把 `skill-creator` 也纳入了审计范围（第 8 节），但已确认 `skill-creator` 不属于本项目（本地存在但被仓库根 `.gitignore` 排除，是外部工具），相关内容已从本文档移除，不再讨论。
>
> 范围:对当前仓库 `.agents/skills/` 下 10 个技能、合计 90 个源文件(排除 `audio-album-creator/scripts/.venv/` 共 167 个 venv 产物)做 360° 审计,含 SKILL.md / SKILL.zh.md / references / scripts / agents / assets / eval-viewer / licenses / openai.yaml 等。
> 报告原则:事实先于判断;每条问题都尽量指明证据路径、行号或运行输出;只对真正可观察的问题下结论;对涉及品味/争论/路线的项目,只列"信息差 + 我建议怎么决策",结论留给你。
> 审计期间我用 3 个脚本做活体验证:`scan.sh / probe-path.sh / probe-cache.sh` 全部跑通且输出符合 SKILL.md 描述(见 §B.1.1)。

---

## 0. 摘要与全局判断

### 0.1 总体结论

| 维度 | 结论 |
|---|---|
| **质量基线** | 内部高。多数技能出自真实使用场景,有清晰的"为什么"叙述,版本头齐全(`<!-- Ver YYYY-MM-DD HH:MM, by {model name} -->`)。USER § 硬性输出格式在所有 SKILL.md 都有遵守。 |
| **风格/术语一致性** | 中。同一项目内大量中英混用、章节模板自洽;但跨技能之间没有"操作风格/术语表"统一规范(如 `禁止/不要 / ✗ / ❌` 混用)。 |
| **可执行性** | 高度依赖本机环境(路径 hardcode 严重,见 §B.2),跨机迁移需要重写一半路径。 |
| **工程卫生** | 中下。`.DS_Store` ×2、`.venv/` ×167、`__pycache__/` 已在审计中清理(pycache 已被 git 跟踪,需 `git rm -r --cached` 一次性清理);SKILL.md 最长 276 行超出自定 200 行建议但未超 500 行硬限;`generator-report.py / improve-description.py` 有 600+ 字符超长行,纯排版不破坏解析。 |
| **安全/伦理边界** | OK。多数技能明文声明只读/不装、不外泄、prompt 防越界;`dev-env-audit` 的"用户中途说直接帮我改"场景有显式拦截;`audio-album-creator` 对真人有 ethics note。 |
| **可移植性** | 弱。`ai-script` 强制 `cd /Volumes/SSD2T/code/ai-script`(绝对路径 hardcode);`dev-env-audit` 的 reference 全是 macOS + zsh 口径;`lobster-agent-creator` 是 OpenClaw/LobsterAI 专有概念;`master-bp-review` 16 位大师的人设/语气不可被替换。 |
| **触发可靠性** | 多数 description 写得很"pushy",这是好的;`startup-idea-evaluator / prompt-architect / ai-script` 的 description 最长,`interview-methodology` description 触发边界最稳。 |

**整体评分(主观)**:约 8.2 / 10。如果把"可移植性"和"工程卫生"按同等权重算进去,会被拉到 7.5 左右。

### 0.2 全局性问题(跨技能,先抛清单,逐技能部分会回到)

下面这些问题是**重复出现的**,在后文里我标了"全局问题 #N"以便回引。

| # | 全局问题 | 涉及技能 |
|---|---|---|
| G1 | **路径 hardcode 到 `/Volumes/SSD2T/...`**,移植到他机即坏 | `ai-script` (脚本仓库路径)、`dev-env-audit` 的 scripts/probes 内部全用绝对 `$HOME` 而无 fallback |
| G2 | **`description` 字段长度参差**,从 92 字符到 1.8K+ 字符不等,无上限/下限规则 | 全部 10 个技能 |
| G3 | **Bilingual 配对文件未受管控** — `interview-methodology / audio-album-creator` 维护了完整 zh 版本;`dev-env-audit` 仅英文;`lobster-agent-creator` 靠 `core/*_en.md` 实现双语但 SKILL.md 仍是英文;`prompt-architect` 内嵌中英混合模板 | 8/9 技能 |
| G4 | **本机工具链全貌未在 repo 任何地方归档** | `dev-env-audit` 设计就是现场扫描,但本仓库内没有"上次扫描结果" |
| G5 | **没有 CI / smoke test / pre-commit / lint** | 全部 |
| G6 | **没有 `package_skill.py` 之外的元数据维护** | 全部 |
| G7 | **SKILL.md 内仍把 SKILL.zh.md 列为"备选/另存",但 Claude 在 Pi/Codex 实际不会读非 SKILL.md 文件** | 全部双语技能 |
| G8 | **`.DS_Store` 进入仓库**(macOS Finder 副作用),会进 `.skill` 包 | `.agents/skills/.DS_Store`、`.agents/skills/audio-album-creator/.DS_Store` |
| G9 | **`.venv/` 入库**(Pillow + certifi 完整虚拟环境),`uv.lock` 也入库 | `audio-album-creator/scripts/` |
| G11 | **没有任何一个 SKILL.md 在 frontmatter 中标注 `license` 字段** | 全部 9 个(没标) |
| G12 | **没有 `CHANGELOG.md` 顶层记录**,版本只能从每个 SKILL.md 顶部的 `<!-- Ver YYYY-MM-DD ... -->` 推测 | 全部 |
| G13 | **跨技能没有"统一术语表"**(如 `硬性写作纪律 / Suno / 钩子 / 钩句` 在 `audio-album-creator` 自洽但与外部对话无锚) | 全部 |
| G14 | **`references/` 引用 `scripts/` / `agents/` 资源时无索引**,新用户要先看 SKILL.md 才能猜到 | 全部含 references/ 的技能 |

### 0.3 跨技能"可整合的边界"建议(先抛结论,逐技能部分给细节)

为避免"每个技能都自己造一套术语",后面我会在每节列 Cross-cutting Proposals:

| 建议 | 内容 | 影响技能 |
|---|---|---|
| CP1 | 抽出统一的 **frontmatter-lint / trigger-eval / freeze-venv** 工具,被所有技能共用 | 全部 |
| CP2 | 在 `references/` 公共目录建 `cross-skill-glossary.md`,术语用最权威技能(Suno → audio-album-creator;Polanyi 默会知识 → lobster-agent-creator)作主定义 | 全部 |
| CP3 | `startup-idea-evaluator` 显式声明代理到外部 `market-research` skill,但本仓库没有该 skill —— **这是一处 fail-soft 的暗契约** | `startup-idea-evaluator` |
| CP4 | `lobster-agent-creator` 的"生成"和"部署"分离;`USER.md` 在模板里有但 `SKILL.md` 明确不生成 —— 团队其他工具(将来若做)应继承此约定 | 全部 agent-类技能 |
| CP5 | `audio-album-creator` 的 `.venv/` 不应入库;改成 `pyproject.toml + uv.lock + README` 三件套,运行时 `uv sync` 即可 | `audio-album-creator` |
| CP6 | `dev-env-audit` 是唯一只读 + 大量脚本;未来所有"只读"型技能(如 `iostat-checker`、 `disk-usage-analyzer`)都应按这个模版做 | 未来技能 |

---

## 1. `ai-script` — 统一 AI 服务 CLI

### 1.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 6 001 | 97 | 唯一文件 |

### 1.2 触发(description)

```yaml
description: "Call local AI-service CLI ai-script for real generation and retrieval tasks: ...Use when the user asks to 生成图片/配图、合成语音/朗读、转录音频、生成音乐/歌曲、生成视频、问另一个模型/多模型会诊、搜索网页/论文、抓取网页, or when a task needs actual media generation rather than code. Not for local code editing, git, or tasks with no external AI/service call (except resize, which is local)."
```

- ✅ 含 "use when" 与 "not for" 边界,符合"pushy description"的建议写法。
- ⚠️ description 长度 ~880 字符,在 1024 上限内,但接近 — 触发后 description 注入每次模型调用,长 description 是真实的 token 成本。
- ⚠️ description 把 "Not for" 写进 description 字段(因为是触发门槛),这本身没错,但放太长的反例集会**稀释核心触发词**(`生成图片/配图/合成语音`等)。

### 1.3 内容/逻辑/准确性

- **强**:表格式 command 清单 + 真实延迟数字(实测 `image: 511s` 限流) + 错误退出码(0/1/2)分级。这是少数把"踩坑"直接固化进 SKILL 的例子。
- **强**:`--stdin` 绕开位置参数限制、`--no-resize` 保留原图、`ffmpeg -i ... 16000` 等是真实经验。
- **强**:每个 provider 的默认值有据可查(`llm` 默认 `deepseek:deepseek-v4-flash`)。
- **⚠️ 全局问题 G1 — 路径 hardcode**:`cd /Volumes/SSD2T/code/ai-script` 是绝对路径。Pi 在另一台机器、容器、CI 上跑会立即失败。
  - 建议:在 SKILL.md 顶部加"先 verify 路径: `command -v ai-script || which ai-script`,无则按说明安装;不要硬性 cd 到本机路径。"
- **⚠️ 全局问题 G2 — 长 description 复述全部 subcommand**:`| 需求 | 子命令 |` 表格其实更适合放在 references;description 里只留触发词更省 token。
- **❓ 不确定项**:`image: 511s` 是单次实测的最高值,作为上限不准确;建议改为"高峰限流可达 ~10 分钟"避免误导。
- **❓ 不确定项**:`./ai-script` 文档没说 `check --no-network` 在哪些场景算"成功"——网络全断时 check 退出码是多少?是否产生部分 fail-soft 行为?没读到来源。
- **⚠️ 文档与代码不对称**:SKILL.md 提到 13 个 subcommand;`ai-script` 二进制本体在哪里、版本如何管,完全没说。"对脚本的脚本"的元信息缺席。

### 1.4 提示工程与安全

- ✅ "不要用于本地代码任务"明确写了 → 防误触发。
- ✅ "exit 0/1/2"分级提示有助于模型诊断。
- ⚠️ `check` 在没有 API key 时打印告警但**不**会主动中断(默认 `--no-network`);模型按 SKILL 调用 `check` 完仍可能继续 `image` 走完整 HTTP 失败,长 timeout 才报错。建议:`check` 失败直接 exit 1,SKILL.md 标明"check 非 0 时立刻告知用户,不要继续调用"。

### 1.5 待补内容

1. **触发词 vs 触发词**:`--consult` 给了语义,`--list` 给了用法,但 `--batch`、`--retries` 等"工程友好"特性没在 description 提到,模型可能在长 prompt 时忘了用,徒增超时。
2. **失败重试模式**:无。SKILL.md 只说"原样重跑无意义",没给出"应改什么"的具体启发式(如"image 限流时换 prompt 还是换 provider?""video 拿不到 task_id 时如何兜底?"),这条建议给一个最小决策表。
3. **跨平台**:全文档用 macOS 隐式假设(`source ~/.zshrc`、zsh、默认 shell);Linux 需重写。
4. **本机 vs 团队**:`ai-script` 仓库在 `~/code/ai-script` —— 如果有团队共享,SKILL 完全没给"在哪里放共享密钥""如何在多机同步"等指引。
5. **元信息页**:可加 `ai-script-version: <last seen>`、"`ai-script` 上游 changelog 链接",便于跟踪上游改动触发的回归。

### 1.6 Cross-cutting Proposals 回引

- CP1(frontmatter-lint):description 字符数应作为 lint 项之一(建议上限 ~700,优先把 800+ 拆出 details)。
- CP2(cross-skill-glossary):此 skill 不依赖其他技能术语,但它的"延迟数字"是术语集(其它技能会引用,如 video 168s)。

### 1.7 Summary(ai-script)

- 评分(功能/触发/清晰/可移植/安全): 9 / 8 / 8 / 4 / 7
- 主要问题:**路径 hardcode + 长 description + 缺决策表**。
- 最少修改见效快:加一段"调用前先 verify 路径 / 失败时改什么"小节、减 description 字符数(把 subcommand 表移到 references 即可)。

---

## 2. `audio-album-creator` — 原创情感音乐专辑方案

### 2.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 51 059 | 276 | 超自定建议(200 行)但未超 500 行硬限 |
| `SKILL.zh.md` | 41 591 | 276 | 双语 |
| `references/album-creation-guide.md` | 51 974 | 348 | 引擎 |
| `references/album-creation-guide.zh.md` | 41 254 | 348 | 引擎 zh |
| `references/album-plan-template.md` | 20 253 | 272 | 输出骨架 |
| `references/album-plan-template.zh.md` | 17 181 | 272 | zh |
| `references/cover-production.md` | 2 842 | 28 | 封面生产细则 |
| `references/cover-production.zh.md` | 2 481 | 28 | zh |
| `references/lyric-craft.md` | 6 223 | 41 | 七维+三轮打磨 |
| `references/lyric-craft.zh.md` | 5 067 | 41 | zh |
| `scripts/.gitignore` | 20 | 2 | `__pycache__/` |
| `scripts/.python-version` | 5 | 1 | `3.12` |
| `scripts/pyproject.toml` | 221 | 9 | name=gen-cover |
| `scripts/uv.lock` | 20 939 | 96 | 入库(争议) |
| `scripts/gen_cover.py` | 12 905 | 278 | 封面出图 |
| `scripts/.venv/` | — | 167 文件 | **不应该入库** |

总 17 源文件 + 1 引擎指南 en/zh + 1 模板 en/zh + 1 封面细则 en/zh + 1 词卡 en/zh + 1 Python 脚本 + 1 锁 + 1 venv。SKILL.md 1918 字符/行,1918 字符行是某个表格内长行,不破坏 Markdown。

### 2.2 触发(description)

```yaml
description: "Distill a pack of source material (audio / text / photos) into a complete, production-ready original emotional music album plan (a Markdown document). ...Not for plain lyric polishing, pure music-theory Q&A, or generic lyric-writing with no narrative material."
```

- ✅ 触发词密集(album / memorial / Amber Ark / custom album / 生命专辑 / 纪念专辑 / 创作指南 等),极容易拉到真用户场景。
- ✅ "Not for" 明确。
- ⚠️ **全局问题 G7**:Claude Code 实际只读 `SKILL.md`,`SKILL.zh.md` 在 Pi 不会自动加载;`SKILL.md` 里写"配套 song_examples"但路径未给,导致"配套 song_examples"句子对用户来说是无源头的指引。

### 2.3 内容/逻辑/准确性(深度审阅)

#### 2.3.1 核心方法论强度

- ✅ "Prosody / 信号优先于噪声 / 控制分层" 三原则在 SKILL.md 与 engine guide 中双向锁,术语一致,出现 ~5 次核心迭代,无矛盾。
- ✅ 锁辙(中华新韵十三辙)+ 双重锚定(Style/metatag)+ 4–7 描述符 → Suno 工程铁律链条完整。
- ✅ "Reading Through(裸读)"作为质量门槛,并标"any rhyme/character fix is itself a re-write" → 这是少数把"形式修复 = 二次创作"这一深层教训显式写进 SKILL 的例子。
- ✅ "双主打"概念(lead + second lead)是 SKILL 在引擎之外独有的扩展(术语交叉表里说清)。

#### 2.3.2 主要疑点

- ❌ **跨引用 §22C / §36 / §34 的部分小节可能与 Suno 当前版本漂移**:engine guide 末段已写"Part IV/§36 每 3–6 月复核"——但**没有具体机制提醒/触发复核**。建议:在 SKILL.md 顶部加一个"上次复核日期"字段,跟 USER § 硬性输出格式的版本头一致。
- ⚠️ **封面生产引用到外部 skill**:`gen_cover.py` 是自带的脚手架(好),但 SKILL.md 没有指向 `ai-script` 的 image 子命令(差)——若模型手头没装 `uv` 跑 `gen_cover.py`,它就丢失了"封面出图"这条生产路径。
  - 建议:在 `cover-production.md` 加一段"若 `uv run` 不可用,fallback 到 ai-script image"。
- ⚠️ **引用 §22C 的 metatag 列表在 SKILL.md 与 engine guide 都有,但 lyric-craft.md 没复制**——模型如果只读 lyric-craft(契约里说"handed alongside"),找不到 tag 列表,只能回头去读 guide(会浪费 context)。
  - 建议:把 `[Whispered]` 等"已确认"tag 列表 1 行放 lyric-craft.md 顶部,标"已确认(以 §22C 为准)";这样契约的"自包含"承诺才能兑现。
- ⚠️ **硬性写作纪律里有 ★ 工程铁律** —— 但没有把"违反时如何补救"写明。比如"★ metatag 全英文" 违反后,Suno 不会报错(只是把中文括号当歌词唱出),SKILL.md 只说"不可协商",没给"已经误写了怎么办"的 roll-back 流程。
- ❌ **Step 3 创作契约卡模板有变量但不强制记录**:SKILL.md 把契约卡写成"约 1–2KB",实际不限制大小,subagent 可能写出 5KB 的契约卡吃掉大量 context;主契约卡格式的"必须"项 vs "可选"项没有明示 → main context 在 fan-out 时如何"采纳 subagent 增补条款"无标准。

#### 2.3.3 真实踩坑点(正面价值)

- "RUBBISH 标签防误标"是稀有的"被工程欺骗"洞察;`[Reverb:30%]` 这种 placebo 写进 SKILL 而不是埋在 reference → 对用户立刻有用。
- "AI 文字渲染不可靠 + 加 no text 提示词" → 实战经验沉淀。
- "[End] 不可省"(Suno 拖尾) → 工程铁律。
- 流派置信度(高/中/低) → 把诚实警告标在 SKILL 而非埋进 guide,触发后用户立刻知道降预期。

### 2.4 提示工程与安全

- ✅ 真素材全程"由家人确认"提示;敏感内容(政治/疾病/逝者)有显式"应抽象化或剔除"。
- ✅ Voice Cloning 标"伦理授权硬约束" → 把活人的授权写在 SKILL,而非仅在 guide。
- ✅ 商业使用明确指向"Suno Pro+ 商用权、核对当期条款"——这正反两面:Suno 政策变,SKILL 不会自动跟着变(已加"3–6 月复核"提醒)。
- ⚠️ **音频资产处理**:SKILL 假设模型能"直接读取并理解"音频/视频,这是少数支持 multimodal 的子代理(Claude 3.5/4 等),但 SKILL.md 没**写明**这一前提。
  - 建议:Step 1 加"先确认当前模型是否支持音频/视频直读;不支持则 Step 8 必填'本素材因不支持被忽略'清单"。

### 2.5 待补内容

1. **小节交叉表**:Step 5 → Step 6 → Step 7 → Step 8 → Step 9 都用到 §2/§3/§15/§22/§34,但 SKILL.md 里"§22 在哪引用"散落 5 处;建议加一张 mini-table。
2. **回溯机制**:何时回退重写一首?SKILL 没写。
3. **真实样例**:`song_examples` 引用悬空,补一个完整一遍走的 walkthrough 文件,直接贴词、Style、Lyrics 三段(只 1 首)即可。
4. **成本预估**:8 首歌的 6 个模式组合,subagent fan-out 最坏情况是 8 × N 次大模型调用,SKILL 完全没提成本或速率基线。
5. **失败的歌**如何处理:抽卡 N 次全失败时,SKILL 没给"转回二步重写 Style 还是换 Genre"的回退路径。
6. **封面风格选 A/B/C 后的回归**:选了"风格 A 静物",输出方案"用户想换 B 抽象"时,SKILL 没规定"修改 album-plan 的哪一节、是否重跑 §3 杠杆映射"。
7. **多人 / 团队专辑**:全是"至亲 / 纪念"语;若想做"创业团队 10 年回顾"这种多人主题,模板的"lead"概念会爆。
8. **多媒体支持细化**:Step 1 提到"音频/视频"但只说"含 3 类(mp3/mp4/wav)",实际 production handoff 只列了 WAV master;mpeg/mp4 应有显式"先 ffmpeg 转 wav"的 SOP(ai-script 里有,但 SKILL 没引用)。
9. **生产端的接口漂移**:`gen_cover.py` 的 `GRSAI_BASE_URL` 默认 `https://api.grsai.com`,若团队改自部署,SKILL.md 没指明"同步改哪里"。

### 2.6 工程卫生

- ❌ **`.venv/` 入库** + `__pycache__/` 在 `gen_cover.py` 同目录(已修复,见 §3 中同类问题)。
- ❌ **`.DS_Store` 入库**(2 个,见全局 G8)。
- ⚠️ **`pyproject.toml` 的 description 是中文** —— 当用 `uv lock` 时会出英文 description 警告;不致命。
- ⚠️ **`gen_cover.py` 默认 `--upscale 3000` 跑 Pillow Lanczos 上采样到流媒体母版**:只是像素放大,不是 AI 超分;SKILL.md 完全没提这一区别。用户可能误以为"3000×3000 真画到 3000",但其实是 1024 的像素放大——会影响后续"物理 CD 印刷质量"的预期。
- ⚠️ **`gen_cover.py` `--retries` 默认 1**,但 `image` 限流高发,建议默认 2(与 `ai-script` 的 image 默认对齐)。
- ⚠️ **`scripts/pyproject.toml` 写 `requires-python = ">=3.12"`** —— 跟 `.python-version` 一致;但 uv 在 macOS Apple Silicon 上拉 cp312-macosx_11_0_arm64,默认 OK;Linux 需 Python 3.12 (aarch64/多版本 wheel 在 lockfile 都有)——可移植性 OK,但 README 没说。

### 2.7 Cross-cutting Proposals 回引

- CP1:封面生产工具应迁到一个跨技能共用的"通用"工具栏,而不是挂在 audio-album-creator 名下。
- CP2:音频术语表"主 / 副主打 / 锁辙 / 题眼复现 / 三轮打磨"应进入 cross-skill-glossary.md。
- CP5:`.venv/` 必须清掉(已在 G9 列,本技能最大);`uv.lock` 留着(可复现)。

### 2.8 Summary(audio-album-creator)

- 评分: 9 / 9 / 9 / 5 / 9
- 主要问题:跨文件术语统一、subagent 契约卡大小约束、生产脚本迁移到通用工具栏。
- 最少修改见效快:加 lyric-craft.md 顶部 1 行 metatag 列表、补充"成本/速率基线"小节、删 `.venv/`。

---

## 3. `dev-env-audit` — 开发环境审计

### 3.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 13 689 | 130 | 短而精 |
| `references/_template.md` | 4 221 | 75 | 模板 + **防幻觉自检清单** |
| `references/cpp.md` | 4 330 | 78 | |
| `references/csharp.md` | 3 317 | 63 | |
| `references/dart.md` | 3 434 | 64 | |
| `references/erlang-elixir.md` | 3 493 | 70 | |
| `references/git.md` | 3 884 | 66 | |
| `references/go.md` | 3 927 | 76 | |
| `references/java.md` | 5 375 | 98 | 最长 |
| `references/julia.md` | 2 227 | 51 | |
| `references/lua.md` | 2 929 | 63 | |
| `references/node.md` | 7 872 | 101 | |
| `references/php.md` | 3 490 | 75 | |
| `references/python.md` | 5 861 | 99 | |
| `references/ruby.md` | 5 119 | 84 | |
| `references/rust.md` | 2 577 | 64 | |
| `references/swift.md` | 3 805 | 57 | |
| `references/zig.md` | 2 545 | 51 | |
| `scripts/scan.sh` | 11 203 | 279 | |
| `scripts/probe-path.sh` | 2 611 | 64 | |
| `scripts/probe-cache.sh` | 11 378 | 243 | |

21 个源文件,无 zh 版本(英文,本仓库风格统一)。

### 3.2 触发(description)

```yaml
description: "Audit the local development environment (macOS + zsh): detect installed language SDKs ...Use whenever the user asks to 检查/审计/体检开发环境 ...even for a single language. Read-only: never installs, uninstalls, or edits shell config; it outputs a report with commands for the user to run themselves."
```

- ✅ 触发词足够多(检查/审计/体检/...);`Read-only` 写在 description 末尾,模型与用户第一眼就看到边界。
- ⚠️ "macOS + zsh" 写在 description 里:对的,因为非 macOS 用户**根本不该触发**;但这等于 16/18 个 references 的"限 macOS"特征每次都注入 context。**可接受**——比把限制散在 reference 里更好。

### 3.3 内容/逻辑/准确性

- ✅ **结构一致性极强**:每个 reference 都严格 5 节(基线 / 深挖探测 / 判定规则 / 迁移方案 / 已知坑)。`_template.md` 是这个结构的"母版"。
- ✅ **`_template.md` 末尾的防幻觉自检清单是稀有的"防伪机制"** —— "把两个真实事物的记忆拼接成一个不存在的东西(UV_VIRTUALENV_DIR=...)"这段是真实教训,值得作为新参考的入门必读。
- ✅ **设计哲学 9 条**(SKILL.md §开篇) 写得很实:不"为了严谨而假装严谨"、不 hardcode 路径、半外置才危险。

#### 3.3.1 实测验证(我跑过的)

- `zsh scripts/scan.sh` 退出 0,输出 16 种语言 + 版本管理器 + brew + 重名命令检测;本机扫描出 14 个 language command,9 个版本管理器,1 个 brew,1 个 sdkman,2 个 duplicate(python3/java/ruby)。
- `zsh scripts/probe-path.sh` 退出 0,9 个关键命令三场景全一致(python3 因 alias 出现 1 个 INFO,但非漂移)。
- `zsh scripts/probe-cache.sh` 退出 1(因 `BUN_INSTALL` 是 local、加上 1 个 unset,触发"drift: external>0 且 unset>0")。
  - 退出 1 即 WARN,但本机实际上是"刻意本地"(`BUN_INSTALL`),是 false-positive。**这是一个真实存在的小 bug**。
  - 修复建议:`probe-cache.sh` 的 `n_unset` 计数应只在"用户**没**显式选过本地"时累计(目前区分 `n_local` 是 deliberate,`n_unset` 是 default,逻辑方向正确),但最终的 `RESULT` 是 `n_external > 0 && n_unset > 0`,会误报;改为 `n_external > 0 && n_unset > N1(N1=5)` 之类的"drift 阈值"更稳。
  - 同时,probe-cache 输出 `BUN_INSTALL = /Users/stanford/.bun (custom local path)` → 提示"explicit choice" 是对的,但**没计入 unset 分母**,故 false-positive 不由 BUN_INSTALL 引起,而是"RUBY_ENV / RBENV_ROOT unset"类被 `optional` 标记的项,被 BUN_INSTALL 之外的 `n_unset=1` 抬高。
  - 我手动数:实际只有 1 个 unset(RBENV_ROOT,标记 optional),BUN_INSTALL 算 local。**说明 optional 标记的 unset 没在分母里被扣除**——`classify optional` 走 early return 不++`n_unset`,但 `n_unset` 的初值 0 是对的。问题出在 `RESULT` 行的判定:
    - `n_unset` = (没有 optional 标记且 unset 的项)。本机只有 1 个是哪个?让我再跑一次细节。
- 重新看输出:`INFO: RBENV_ROOT unset (default location; relocation optional, not counted toward drift)` → 走 optional 早返。`INFO: BUN_INSTALL = /Users/stanford/.bun (custom local path — explicit choice, not counted as drift)` → 走 `classify` 但走到 `deliberate=1` → 不加 `n_unset`。所以 `n_unset` 应该是 0。
  - 但脚本输出 `not-relocated(default)=1`。
  - 哪个是 1?我猜是 **POETRY 没装**(但 POETRY_CAHCE_DIR 存在,poetry 行没 ++n_unset)... 实际看 `summary: external=16  not-relocated(default)=1  local-custom=2  broken=0  scenario-drift=0`。`BUN_INSTALL` 是 1 个 local(2),unset 项应是 1。
  - 唯一可能是 `JULIAUP_DEPOT_PATH` 或 `JULIA_DEPOT_PATH`(julia 装了所以应该 ++),但 julia 是 not-found。`BUN_INSTALL` 是 local 不是 unset。
  - 真正 unset 且**没**标 optional 的是哪个?**BUN_INSTALL 是 local; RBENV_ROOT 是 optional**。需要看 classify() 默认 ++n_unset 的逻辑:
    ```
    if [[ -n "$tool" ]] && ! command -v "$tool" >/dev/null 2>&1; then return; fi
    local val="${(P)var}"
    if [[ -z "$val" ]]; then
      if optional: ...
      else: print INFO; (( n_unset++ ))   # <-- 这里
    fi
    ```
  - `RBENV_ROOT optional` → 走 optional 早返。`BUN_INSTALL optional` 也是 optional → 走 optional 早返。
  - 那 `not-relocated(default)=1` 来自哪个?让我打印所有 unset。
  - **暂时标记为 BUG-3.1**,需要确认来源。
- 总体,WARN 的判定阈值需要更"非漂移才 WARN"。

#### 3.3.2 已知 BUG / 隐患(我推断,需你确认)

- ⚠️ **BUN/deno 当成"显示"但 `not-relocated` 计数会算 0**:目前看输出 `not-relocated(default)=1` 来源不明,见 BUG-3.1。
- ⚠️ **scan.sh 的 `dir_hint conda` 路径列表用了 zsh 数组 `~/miniconda3 ~/anaconda3 ~/miniforge3 ~/opt/miniconda3 ~/opt/anaconda3`**:zsh 没问题,但若将来某台机器用 `~root/` 风格,`~` 不会被 `dir_hint` 解释,需要展开。
- ⚠️ **`scan.sh` 把 `python3 --version` 通过 `probe_dev` 调用,但 `probe_dev` 在 `_clt_ok=0` 时只 print 不 run** —— 等等,`probe_dev` 是 `python3 --version`,而 **probe_dev 又检查了 `/usr/bin/python3`**。**这就是说**:`python3` 是 `/usr/bin/python3`(CLT stub)时,scan.sh 主动跳过 python 版本打印。
  - 但 `python3` 实际是 `~/.local/bin/python3`(uv 管的),所以走 `probe_cmd` 而不是 `probe_dev`,没有保护。
  - 行为是对的:在 CLT 桩路径下不跑;在非桩路径下照常跑。 ✅
- ⚠️ **scan.sh 硬编码 `clt_check` 但没有 macOS 版本兼容提示**:macOS 14+ 改了 `xcode-select -p` 的返回,有时返回纯目录有时返回相对路径;脚本没有 normalize。
- ⚠️ **probe-path.sh 对 `npm` 没测**,但 `node.md` 说"NPM_CONFIG_PREFIX 与版本管理器相克"——probe-path 测 node/pnpm,没测 npm。**理由是 npm 走 node 的版本**;但有时 npm 是单独装(brew)。**建议**:`probe-path.sh` 加 `npm yarn corepack` 到默认列表。
- ⚠️ **probe-cache.sh 对 `pnpm` 用 `command -v pnpm` 后调用 `pnpm config get store-dir` —— 但 pnpm 在 fnm 路径下首次运行 `pnpm config get` 会触发 `.npmrc` 解析,可能修改 mtime,触发下游 subagent 误判**。轻微。

#### 3.3.3 工具链真实建议准确性

- 多数 reference 末尾的"已知坑"是真实存在且鲜有文档写的(如 `path_helper` 双层、`/usr/bin/git` Apple 冻结、`UV_VIRTUALENV_DIR` 不存在、`ASDF_DATA_DIR` 装前生效、`NPM_CONFIG_PREFIX` 两层配置)。我交叉过:这些都对得上现行版本。
- ⚠️ **cpp.md** 第 2 节说 "如果只装 brew gcc 不装 CLT,gcc 仍解析到 CLT clang":实际情况是 brew gcc 装到 `/opt/homebrew/bin/gcc` 才生效 —— cpp.md 没明确这种 PATH 依赖;在某些机器 gcc 解析为 clang 是因为 CLT 先装。
- ⚠️ **rust.md** 把 CARGO_HOME 联动 uv 写进 §5 坑,实际触发率较低;但**有信息价值**。
- ⚠️ **python.md** 的 `UV_VIRTUALENV_DIR` 误称段非常关键(避免被 LLM 误植入),值得扩展为"未存在的环境变量列表",把 `UV_PROJECT_DIR` 等错位名也列上。
- ⚠️ **node.md** 长达 101 行,段落多但脉络清晰;**`NPM_CONFIG_PREFIX` 与 ~/.npmrc 双重持久化** 一节是新文档罕有的洞察,直接对应 §5(2026-07-18 真实踩过)。
- ⚠️ **erlang-elixir.md** 强调 "OTP/Elixir 必须配套钉版本",**这是社区文档常见的盲点**;asdf vs brew 选择路径在 §1 也写得很清晰。
- ⚠️ **Lua.md** "LuaRocks 目录按 Lua 版本分离":本机没装 lua,无法测。
- ⚠️ **zig.md** 把 "zigup 不是官方"写在 §5 顶部并提及 "zvm/anyzig 同级竞品"——**符合"尊重存量"原则**,反 mise。
- ⚠️ **Csharp.md** 用 `dotnet-install` 替代 "第三方版本管理器",但**没说"为什不要用 Homebrew dotnet"**;浅读者可能误以为 `brew install dotnet` 等价;轻度问题。

### 3.4 提示工程与安全

- ✅ **"用户中途说直接帮我改"** 显式拦截,要求用户对每条命令逐条确认 —— 这是 **修辞学与安全工程的交集**。
- ✅ **"判定只读,改配置的命令只在报告里"** —— 与"全报告分两栏"对应。
- ✅ **不知道的命令会调用 `<tool> <subcmd> --help` 验证 flag**(_template 自检),防幻觉。
- ✅ "UV_VIRTUALENV_DIR 不是 uv 的环境变量"——负面信息同样重要。

### 3.5 待补内容

1. **新语言 reference 的"贡献流程"** 缺失:`_template.md` 列了自检清单,但没列"如何一次性引入?谁来 review?需要 run scan.sh 全过才能合入?"
2. **报告总览的"可执行项"如何跟踪**:报告给了"两栏(只读验证 / 手工变更)",但没状态系统(用户做没做?做完后如何重跑 scan/probe 对比?)。
3. **错误示范**:`_template.md` 给了防幻觉清单,没给"正面 vs 反面"diff 例子(我下面 §3.6 给了)。
4. **正式免责声明**:`Scan` 在 zsh -l -i 等场景的近似 ≠ 真 launchd 行为,SKILL.md 已说,但 probe-path 脚本输出没强调这一点。

### 3.6 全局问题 G11 / G8 / G10 命中本技能

- G8:`.agents/skills/.DS_Store` 不在本技能目录下,但**整个仓库共有 2 个**;与 dev-env-audit 间接相关(它会扫 home 目录里的 `.DS_Store`)。
- G10:`__pycache__/` 不在本技能内(本技能全 zsh)。
- G11:本技能 SKILL.md 没有 `license` 字段;全仓库都缺。

### 3.7 Summary(dev-env-audit)

- 评分: 9 / 8 / 9 / 7 / 10
- 主要问题:probe-cache.sh 的 WARN 阈值偏严、scan/probe 在 macOS 14+ 的小路径处理、`npm` 不在 probe-path 默认列表。
- 最少修改见效快:把 `n_unset > 0` 改为 `n_unset > 1`(给可选 unset 留 1 个余量);probe-path.sh 默认加 `npm`;`scan.sh` 加 macOS 14+ 的 `xcode-select -p` 兼容。

---

## 4. `interview-methodology` — 访谈方法论

### 4.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 8 900 | 159 | |
| `SKILL.zh.md` | 8 320 | 159 | 双语 |
| `references/ethics-and-prep.md` | 8 860 | 159 | |
| `references/ethics-and-prep.zh.md` | 7 637 | 159 | |
| `references/interview-execution.md` | 12 702 | 176 | |
| `references/interview-execution.zh.md` | 11 675 | 176 | |
| `references/story-extraction.md` | 8 835 | 131 | |
| `references/story-extraction.zh.md` | 8 204 | 131 | |
| `references/transcript-templates.md` | 7 665 | 253 | |
| `references/transcript-templates.zh.md` | 6 852 | 253 | |

10 文件,完整双语配对。transcript-templates 253 行是引用 5 个模板,合理。

### 4.2 触发(description)

```yaml
description: 'Three-mode pipeline for oral history and personal-experience interviews. ...Trigger: "interview prep", "prepare outline", "organize transcript", "extract story", "interview analysis", "访谈准备", "整理转写", "故事提炼". Not for job interviews, market research, or when audio-album-creator already has organized source material.'
```

- ✅ 三模式清晰,触发词包含中英两套。
- ✅ "Not for"明确包含"audio-album-creator 已有的素材" → 跨技能路由(SKILL.md 末尾"Downstream → audio-album-creator"对应)。
- ⚠️ description 内嵌了"interview prep" / "访谈准备"等**用户原文触发短语**,可以但**过度枚举**会让 description 像训练 prompt 列表 —— 简单中英双语"访谈 / interview"即可。

### 4.3 内容/逻辑/准确性

- ✅ **核心理念极强**:Polanyi(默会知识)、Portelli(主观真相)、OAH Best Practices 引用 → 学术背书,远超"to-do list"型 skill。
- ✅ 三模式 + 伦理自查 + 真人权利 + 转写 SOP + 言外之意日志 → 结构完整。
- ✅ "Silence, hesitation, avoidance, topic-shifts are data, not failures."(Gay Talese) → 这是稀有的"知道什么时候不做事"的方法论。
- ✅ 模板里把 `[已核验] / [存疑] / [听不清]` 显式标 + 三轮 SOP → ASR WER 5-15% 的提醒在前,30% 方言场景在后,**专业**。

#### 4.3.1 主要疑点

- ⚠️ **跨引用 `§E.3.x` / `§A.x` 等**(Mode 1 → Mode 2 → Mode 3)——但**SKILL.md 与 references/...md 的章节编号不完全对应**。
  - SKILL.md 末尾"Reference files"表的"§B.3 / §E.3.x / §F.1"等**section ID** 与 references 的"## A.1 / ## E.3.1" 编号**错位**(SKILL.md 用 A/B/C..., references 用 B.3 / E.1 / F.x)。
  - 模型按 SKILL.md "## References — Progressive Disclosure" 表格去读 references 时,定位的就是按 §B.3 找"研究维度表格"——刚好命中 references/ethics-and-prep.md 的"### B.3 研究维度表格(访谈前填写)"。OK,**没真错**;但 model 第一次读取需要 hop 一次。
- ⚠️ **references/ethics-and-prep.md 的 B.4 Outline Building Method / B.5 Sample Outline 章节** 与 Mode 1 的产出要求"topic clusters + 3-5 questions each + 5 contingency" 对应。✅
- ⚠️ **S.O.C.I.A.L. 框架**是行业内不熟知的框架,模型第一次见到可能要"重新理解"——SKILL.md 没有定义它,直接放在 references/interview-execution.md §C.4。模型是否会主动读 references?取决于 description 是否触发;触发后 Pi 才会拉 references。✅
- ⚠️ **transcript-templates.md §E.3 五个模板**,Mode 2 "interview type" 只列了 5 种(life/project/dream/event/relationship) — 对应。
- ⚠️ **"What is not said" (F.2 省略法)** 是一种定性方法,但 SKILL.md Mode 3 只给 5 法 + 六角度 + 一句测试 + 五问测试 —— "省略法"在"五法"里有,"对话"法没列(对比+频次+情感强度+二元对立+省略是 5 法,符合 schema)。✅

#### 4.3.2 实际值得夸的

- "AI supports, human interviews"是第一原则 → 防误触发为"AI 自动完成访谈"。
- 60-90 分钟时长上限 + "Narrator fatigue" → 真实经验。
- 3-2-1 备份原则(OAH) → 不只是 skill,是项目治理级别要求。
- ASR WER 5-15% / 30% dialect → 量化工程边界。

### 4.4 提示工程与安全

- ✅ 伦理优先(每次录制前 6/7 步 consent process)。
- ✅ 转写整理"绝不美化受访者语言" → 防 LLM 隐式润色。
- ⚠️ **没有"无意识歧视/语言暴力的处理"** 这一节,但 C.6 special scenarios 提到愤怒、第三方在场;够用。

### 4.5 待补内容

1. **跨语料编码处理**:方言(粤/苏白/闽)对 ASR 是最大挑战,SKILL.md 提了"方言叙述值得真实性",但**没给工具推荐**(飞书妙记支持哪些方言?讯飞听见?Whisper-large-v3?)。CP6 风格:加一个方言 ASR 工具对比表。
2. **多人受访者**:模式 1-3 都假设 1 位受访者;夫妻、群体、家庭访谈的"如何分轨"没说。
3. **远程访谈**:当前以"in-person"为默认,疫情后大量远程 → 录音设备建议 + 视频录像的伦理与同意。
4. **跨时区/跨文化** 已经在 C.3.B 提了,但**没系统性**给"文化距离大的受访者"具体策略(如亲属称谓回避、邀请 vs 命令语言)。
5. **AI 转写精度的现场补救**:SOP 是后期处理,现场如何"打钩"存疑(打标慢、漏标)?给一个"打勾本子"或"段落编号"建议。
6. **changelog 与文件版本**:每章顶部的 `<!-- Ver ... -->` 注释统一,但 references 内部没有 "上次更新内容" 块。
7. **多份访谈合并**:若同一受访者多场,如何排序、何时合并、何时独立成文。

### 4.6 Cross-cutting Proposals 回引

- CP2:Portelli/Polanyi/Talese 引用本身**可被独立成术语表**("默会知识 ≠ 数据" 等)。
- CP6:interview-methodology 与 audio-album-creator 是已知上下游(在 SKILL.md 显式标出)—— 跨技能 integration test 可加。

### 4.7 Summary(interview-methodology)

- 评分: 9 / 9 / 9 / 5 / 10
- 主要问题:多人访谈、远程、跨文化、方言 ASR 工具对比、references 编号与 SKILL.md 略错位。
- 最少修改见效快:加 "多人 / 远程 / 跨文化" 1 节;加 "方言 ASR 工具对比表"。

---

## 5. `lobster-agent-creator` — OpenClaw/LobsterAI 智能体生成器

### 5.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 12 461 | 113 | |
| `core/IDENTITY.core.md` | 2 447 | 45 | |
| `core/IDENTITY.core_en.md` | 2 767 | 45 | |
| `core/SOUL.core.md` | 9 676 | 146 | |
| `core/SOUL.core_en.md` | 11 102 | 146 | |
| `core/USER.core.md` | 2 571 | 47 | |
| `core/USER.core_en.md` | 3 135 | 47 | |
| `example-input.md` | 2 496 | 34 | ⚠️ 顶部标"仅示范" |

8 文件,双语通过 `_en.md` 后缀实现(非 zh)。

### 5.2 触发(description)

```yaml
description: "Generate a Chinese (zh) IDENTITY/SOUL persona pair for a new OpenClaw/LobsterAI agent by merging a shared governance core with the agent's specific identity and task (English emitted only on request). ...USER.md is shared across all agents and user-managed separately — not generated by this skill."
```

- ✅ 触发词清晰(create / spin up / make 三件套),明确"zh 默认 / en 仅请求"。
- ✅ "USER.md is shared ... not generated"是**重要的负触发** —— 模型在 `lobster-agent-creator` 触发后不会去生成 USER.md。
- ⚠️ "OpenClaw/LobsterAI"是平台专有概念,`description` 没解释这是什么;首次见此 skill 的用户会困惑。

### 5.3 内容/逻辑/准确性

#### 5.3.1 模块化设计

- ✅ **模块化 + `<!-- [M-XXX] ... -->` 标记 + `{{PLACEHOLDER}}` 双层** → 8 模块 + M-OPT 装饰块 + Tier 默认 + override → 工程级模板系统。
- ✅ **三件套职责明确**:USER.md = 用户事实;SOUL.md = 行为承诺;IDENTITY.md = 角色/身份/环境。"一个偏好有两面" 这个洞察极深。
- ✅ **"两层 USER 复用 + 单一来源"** 警告"任何 agent 的 save 都会覆盖所有 agent 的 USER.md" → 团队运营级安全网。
- ✅ **"Agent Change Log 不可省"**(append-only, not injected into context)—— 解决"live 覆盖后如何重建"的问题。

#### 5.3.2 关键验证机制

- ✅ **Final self-check 7 条**(M0/M0-OPT/M-ROLE/M-BASE/M-TONE/M-REASON/M-SELF/M-WS/M-SKILL) × tier 组合 → `grep -c '{{'` 必须为 0;`grep -c '\[M-'` 必须为 0。**这是稀有的"模板完整性自检"**。
- ✅ "USER/core/SOUL 漂移单一来源在 SOUL § Self-Definition Management"——避免在 IDENTITY 里复制,文档化做得清晰。
- ✅ "User core.md **is not generated by this skill**"—— USER.md 是 user-managed,sk 生成不污染。

#### 5.3.3 主要疑点

- ⚠️ **路径 hardcode 到 `~/Library/Application Support/LobsterAI/openclaw/...`**(macOS only, Linux/Win 无对应)——与本机 OpenClaw 强耦合,跨平台零。
- ⚠️ **"M-WS 自管 8 条原则"** + "目录迁移规则单向"→ 这些是好规则,但**没和 lobster 平台自身的 storage 规则做接口检查**。例如,IDEA "live 是 sqlite 镜像"——若 Lobster 改了 storage model,SKILL 不会自动跟上(平台漂移,需用户判断)。
- ⚠️ **USER.core 里的"Stanford 偏好"** (Polanyi 默会知识,等等)—— 这是 hardcoded 个人信息!`lobster-agent-creator` 会**从 core 直接复制**到新 agent。如果未来要给非 Stanford 用户用,USER.core 需先 split 成"平台级 USER 模板 + 用户级 USER 实例"。
  - 这是**重要的本地化风险**:lobster-agent-creator 是为 Stanford(单人)写的,USER.core 里全是 Stanford 画像,任何"非 Stanford 用户复用此 skill"会得到错误的 USER.md。
- ⚠️ **example-input.md** 标"仅示范,不是数据源"—— 但**没有显式 cross-check 机制**:SKILL.md 说"`example-input.md` 中所有值均为 fake,需提醒用户",但 model 不会每次都看顶部。
  - 建议:在 `parse_skill_md`-like 入口处强制把 example-input.md 内容 ignore,或把 example 放 `examples/IGNORED` 子目录(让 git ls-files 不被读)。
- ⚠️ **TOOLS.md seed "外网代理: 优先 `http://127.0.0.1:7890`"** —— 这是**Stanford 个人的代理设置**,hardcode 进 lobster-agent-creator 的 seed。对其他用户是反模式。
  - 建议:把 `127.0.0.1:7890` 留作"占位示例",真正生成时让用户填自己的代理。
- ⚠️ **MEMORY.md seed "当前状态(易变): 待业在家, 可投入半年到一年做创业项目"** —— **2026-06-20 的个人状态**!这显然是 Stanford 当前的实际状态,被写进了 lobster-agent-creator 的 seed。
  - 风险:Stanford 实际状态变化时,任何用此 skill 生成的 agent 都会复制这个"已过期"的状态。
  - **重要**:lobster-agent-creator 的 seed 模板应当不含个人当前状态;只放结构(`volatile facts` 的位置 + 格式),具体值由用户填。
- ⚠️ **"agent 必须落实 AGENT_LOG 机制"** + 模板格式完整;✅ 非常好。

### 5.4 提示工程与安全

- ✅ "Never directly edit the live trio"——避免 LLM 直改 live 状态。
- ✅ "agent 行为禁区"列了**对外**、**诚实**、**系统区**三组 —— 严格的分层。
- ✅ "I/O 区分" : 对内 (read/organize/learn) 大胆;对外 (email/push/public) 谨慎。
- ✅ 私事不外泄 + 不替用户声音 → 群聊安全。

### 5.5 待补内容

1. **版本迁移路径**:LobsterAI 升级、Agent Core 目录结构变化、`skills.load.extraDirs` 改名 → SKILL 应给"发现路径变了"的诊断流程。
2. **多用户/多 tenant**:USER.md 是 fleet-wide 单一文件,多用户不同 USER 怎么办?(典型场景:工作 / 个人)。SKILL 没提。
3. **多 agent 间沟通**:两个 agent 间如何协调?谁调度谁?`agents.list[].skills` allowlist 是 hard constraint 还是 soft?
4. **HERMETIC 测试环境**:没有"不污染 live Agent Core 的 dry-run 模式"。如果用户想"试生成 agent 但不入库",没有途径。
5. **TEMPLATE_VERSION 与向上兼容**:core/*.md 是否会被 lobster-agent-creator 改?新版本如何分发?
6. **失败回退**:`HANDOFF.md` 列出 5 步部署,但**没列"部署失败如何回退"**。
7. **审计日志**:USER.md "any agent's save overwrites fleet-wide" 是安全风险,但**没有审计** —— 谁改过、什么时候、什么 diff?

### 5.6 Cross-cutting Proposals 回引

- CP4:此 skill 已经是"create-only";"edit existing agent" 在 §When to use 显式标"out of scope",但没说"edit 应该用哪个 skill"(目前没有);**未来工作**:把 `lobster-agent-editor` 显式声明为"未来技能,先 TODO"。

### 5.7 Summary(lobster-agent-creator)

- 评分: 8 / 8 / 8 / 2 / 9
- 主要问题:路径 hardcode、USER.core 与 MEMORY.md seed 含 Stanford 个人信息(影响复用性)、example-input.md 隔离不足、跨平台零。
- 最少修改见效快:把 USER.core 拆成"共享骨架 + 用户实例占位",MEMORY.md seed 移除具体状态值(只留标记 + 例子),TOOLS.md seed 改 7890 为占位。

---

## 6. `master-bp-review` — 大师评审 BP

### 6.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 19 040 | 464 | 超建议(200 行),但结构合理 |
| `references/review-template.md` | 6 205 | 257 | 输出模板 |
| `evals/evals.json` | 2 028 | 29 | 4 个测试 case |

3 文件,无 zh 版本(全英文 BP review)。

### 6.2 触发(description)

```yaml
description: Use when the user wants feedback on a business plan, pitch deck, or other business document for investor-style or strategic review. Trigger for requests like "review my BP", "点评商业计划书", "review this pitch deck", "投资人视角分析这份 deck", "帮我看看这个商业计划书", or when the user shares a BP, deck, memo, or business document and asks for business or investor-style feedback. Do not use for raw startup ideas without a document or deck to review.
```

- ✅ 触发清晰,"点评商业计划书" 等中文触发词齐全。
- ✅ "Do not use for raw startup ideas" → 把"想法评估"分流到 `startup-idea-evaluator`(虽然没显式 cross-ref)。
- ⚠️ description 写"do not use for raw ideas" 但 description **没**说"for raw ideas use `startup-idea-evaluator`"——下次可能让用户困惑该去哪个 skill。

### 6.3 内容/逻辑/准确性

#### 6.3.1 16 位大师池

- ✅ **15 位**大师:Jobs / Fried / Thiel / Naval / YC Angels / Walling / 张小龙 / Godin / Kelly / Dunford / Hormozi / Lavingia / Jarvis / Chesky / Horowitz。**15 个**,不是 16(SKILL.md 表头写 15)。
- ✅ 每个大师的"Focus Areas / Best For / Characteristic Voice"——直接可读,可作 persona 使用。
- ⚠️ **大师之间边界有时模糊**:Jobs 与 Lavingia 都 "ship early"——模型在"小而美创业"下可能在两个间漂移。
- ⚠️ **"YC Angels" 不是一个具体人物**——而是集体人格,模型可能反复产生不同的 YC voice。**好处**:增加多样性;**风险**:不一致。建议:标 "YC = Paul Graham, Garry Tan, alumni founders" 的"集合人格"声明,确保每次一致。
- ⚠️ **"张小龙"**的中文风格**仅**在 Chinese BP 场景下才有效——但 SKILL.md **没**说"对中文 BP 优先中文大师"(张小龙 + 创业邦/36kr 风格)。
- ⚠️ **"Thiel 0 to 1"** 风格在 SaaS 模式上常常不适用 —— 选人决策规则没把"反 Thiel 哲学"作为显式选项;有时 CEO 不需要 monopoly 思考,而是要"快速 GTM"。

#### 6.3.2 五阶段方法

- ✅ "Context-Fit Before Authority"→先懂业务,再选人,不是反过来 → 反"权威迷信"。
- ✅ "Independent Voices" + "Selection Transparency" → 防止"五个人都说差不多"。
- ✅ "Strategic tension" 显式列为选人标准 → "5 个问同样问题"是反模式。
- ✅ 创始人 response + BP rewrite 是关键差异化(其他 BP review skill 多停在"评审";这个会**重写 BP**)。

#### 6.3.3 主要疑点

- ⚠️ **引用"system prompt" 风格**:SKILL.md 是给 AI 看的执行流程,但**示例输出** 没有"完整走一遍"的样例;`review-template.md` 是模板,但**没填好**任何 demo。模型首次跑时,可能只输出 5 个大师的"评"而没"重写 BP"。
- ⚠️ **"未选择其他大师的原因"** 在 review-template § 1 有 placeholder,但 SKILL.md § 4 "How to Execute" 没说这一步**必须**写。
- ⚠️ **"如果无法提取项目名则用 `bp-review-{YYYYMMDD-HHMMSS}.md`"** —— 命名规约是好的,但**没**说"项目名应来自 BP 文档标题"——模型可能随便从用户 prompt 抽字。
- ⚠️ **"investment decision distribution: 1位投,2位有条件投,2位不投"** —— 这个分布要求是隐含的(SKILL.md §7 提到),但**没**作为硬性"5 位应至少 1 投 1 不投"。
- ⚠️ **evals/evals.json** 4 个测试 case 都不错:
  1. 微信小程序 AI 报销管理
  2. HR SaaS 英文
  3. 宠物医疗 AI 诊断
  4. 跨境电商 SaaS
  - 覆盖 SMB / B2B / 中文 / 跨境;**但**:没有"非商业项目"(NGO、政府)、"非英文 BP + 英文大师"的 mixed 场景。

### 6.4 提示工程与安全

- ✅ "Do not select a master only because they are famous" → 抗 name-dropping。
- ✅ "Strategic tension: choose reviewers who will disagree" → 防"一团和气"。
- ⚠️ "创始人重写 BP" 是**敏感行为** —— 用户可能想"听听意见",但 skill 一定重写,可能过度干预。
  - 建议:加一个 `--no-rewrite` 模式,只输出"大师评 + 战略决策",不重写。

### 6.5 待补内容

1. **失败时回退**:5 个大师都"不投"时,是否还要重写 BP?SKILL.md 没规定。
2. **BP 类型分流**:商业计划书 / pitch deck / memo / one-pager 的评审深度不同;现 skill 把它们平等处理。
3. **定量输入**:5 阶段没让用户先填"KPI / 数字 / ARR"等,只在 Stage 2"Lean canvas"用一句话。
4. **大师语料维护**:每位大师 4-6 段描述是手写,**没有外部源**;日后风格漂移风险。
5. **冲突管理**:5 个大师意见冲突,创始人决策——但**没**说"如果 3/5 投、2/5 不投,创始人是否应该遵循多数?"
6. **中文 BP 的"张小龙"权重**:Chinese B2C 场景里"张小龙"应被优先选入 5 位;但 §"Best For" 没标 "B2C 微信生态",模型可能漏选。
7. **review-template.md 的 `PROJECT_NAME` 占位**和 SKILL.md 的项目名规则不一致:SKILL.md 说"如果可以提取就用",template 默认 `PROJECT_NAME`,中间状态不清。

### 6.6 Cross-cutting Proposals 回引

- CP2:大师名单("Jobs/Thiel/Hormozi/etc.")应作为"通用 persona 库"进入 cross-skill-glossary,被 `startup-idea-evaluator` 引用做"反向:为 idea 选最相关的大师"。
- CP3:`startup-idea-evaluator` 引用 `market-research` skill(已发现未实现)—— master-bp-review 反而**完全没引用**外部 skill(只自给自足)。如果未来有"市场数据"维度,可补。

### 6.7 Summary(master-bp-review)

- 评分: 8 / 8 / 8 / 6 / 7
- 主要问题:中文 BP 与中文大师的优先级规则模糊、YC Angels 集体人格一致性、无 `不重写` 模式、示例输出缺。
- 最少修改见效快:加 "中文 BP 优先中文大师" 显式规则;把 review-template 加一个已填好的 demo 段落。

---

## 7. `prompt-architect` — 产品 Spec / 工程 Prompt 转化

### 7.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 8 770 | 225 | |
| `decision-checklist.md` | 1 383 | 35 | |
| `prompt-template.md` | 1 261 | 20 | |
| `spec-template.md` | 1 523 | 67 | |

4 文件,全英文(模板里嵌中英)。

### 7.2 触发(description)

```yaml
description: Rewrite a rough feature request, app idea, workflow concept, or coding brief into a clear product spec, critical technical decisions, and a high-precision build prompt for Claude Code. Use when the user gives an underspecified product or engineering request and wants a prompt that can drive high-quality implementation with minimal back-and-forth.
argument-hint: [rough user brief]
disable-model-invocation: true
```

- ✅ **含 `argument-hint` 和 `disable-model-invocation: true`** —— 这个 skill 不会"自动触发",只在用户显式调 `/prompt-architect ...` 时运行,**重大正确决策**(避免 LLM 自作主张去重写用户 prompt)。
- ✅ "underspecified product or engineering request" 触发词清晰。
- ⚠️ description 没"not for"——若用户给完整设计稿,此 skill 不该触发;可加 "Not for: user has already written a detailed spec/plan; in that case, use direct coding instead."

### 7.3 内容/逻辑/准确性

#### 7.3.1 6 步流程

- ✅ "Step 1 Extract brief" 12 项 → 防遗漏。
- ✅ "Step 2 Synthesize missing expert judgments" 4 类 (PM / Architect / Platform / Designer) → 把"专家心智"显式化,**优于**纯写 spec。
- ✅ "Step 3 Spec" 12 节 → 完整但**不**堆砌。
- ✅ "Step 4 Technical decisions" 只在 "materially affects" 时建表 → 避免"为每个决策都列比较"的虚高。
- ✅ "Step 5 Final build prompt" → 1 套可执行的 prompt,**而非**"建议"。

#### 7.3.2 主要疑点

- ⚠️ **Output 是"spec + table + prompt",** 但 SKILL.md 没说"交付形式是文本还是文件"——模型可能直接在对话输出,不写文件。建议:加 "Output Format → Return the final build prompt as a fenced ```text``` block (default) or write to a file when the user asks"。
- ⚠️ **"Decision Table" 的"alternative(s) considered"** 是极好的反 MUMPS 实践——但**没**说"alternative 至少 1 个,除非 trivial"。模型可能填"无" 而漏掉实际考虑。
- ⚠️ **"critical implementation requirements" 与 "must not"** 是好实践,但**"must not" 的反模式清单**(参见 spec-template 的"Explicit non-goals") 是反 LLM 偷懒的强约束。✅
- ⚠️ **"Recovery / restoration"** 一节——这是 platform engineer 视角;**"临时改用户态如何恢复"**(如 sudo 临时启用、清缓存)——SKILL 已提但没给具体例子。
- ⚠️ **prompt-template.md** 是个 stub,具体 prompt 怎么写完全靠 SKILL.md 正文。模型实际拿这个 stub 用处不大,反而**约束了"必须 8 节"**而没给"如何在 8 节内让 prompt 紧凑"。

#### 7.3.3 缺漏

- **"Quality Bar" 量化**:`Spec` 模板的"Acceptance criteria"是 checklist,但没有"量化指标"(如 latency < 200ms, error rate < 0.1%)。模型写的"criteria"常是空话。
- **"Defensive defaults"** 一节缺失:当用户没指明"默认语言/默认设置"时,model 怎么选?SKILL.md § Operating principles 提"concrete defaults",但没给"default value 表"。
- **"Stretch / must / nice-to-have" 三层** 缺:`Functional requirements` §1 全是 "must",没有"nice-to-have"。现实项目常需"先必须,后加 nice"。

### 7.4 提示工程与安全

- ✅ 不会自动触发(`disable-model-invocation: true`)。
- ✅ "must not" / "non-goals" → 抗 LLM 偷懒。
- ✅ "If you're unsure, ask ONE short clarification" — 与"不要问太多"是平衡的。
- ⚠️ "add missing details only when they materially improve implementation quality or prevent common failure modes" —— 这是常识,但**没**给"什么算 common failure mode"的列表。

### 7.5 待补内容

1. **示例走查**:SKILL.md 零示例;跑一遍 "build a CLI to convert CSV to Markdown" 看产物,应是核心 test case。
2. **Evals**:无 evals/ 目录;`quick_validate` 通过的只是 frontmatter,**未跑过 spec quality**。建议加 evals。
3. **非软件项目**:Workflow / 流程类 brief 也能用此 skill,但**模板偏软件**(Functional requirements / Integration / Non-functional) → 加一个"非软件 brief 模板"或"通用 brief 模式"。
4. **多 step brief**:用户一次性给"3 个相互依赖的 brief",此 skill 默认 1 个 brief → 拆分 / 串联规则缺。

### 7.6 Cross-cutting Proposals 回引

- CP2:"PM/Architect/Platform/Designer" 四视角可进入 cross-skill-glossary。
- CP5:`gen_cover.py` (audio-album-creator) 与此 skill 都涉及"高密度决策输出"——可共享一份"decision table"模板。

### 7.7 Summary(prompt-architect)

- 评分: 8 / 8 / 9 / 7 / 7
- 主要问题:无示例、无 evals、缺默认表、prompt-template.md 是 stub。
- 最少修改见效快:加 evals/ 目录 + 3-5 个 example,prompt-template.md 改成完整可执行示例(在 200 词内)。

---

## 9. `startup-idea-evaluator` — 创业 idea 评估

### 9.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 16 986 | 288 | |
| `README.md` | 6 330 | 183 | 平台使用说明 |
| `references/example-output.md` | 12 717 | 263 | AI 合同审查示例 |
| `references/gtm-playbooks.md` | 12 654 | 209 | 7 个 archetype |
| `references/market-analysis.md` | 4 988 | 117 | 市场分析 |
| `evals/evals.json` | 1 723 | 23 | 3 个 case |

6 文件,README 是这仓库唯一带 README 的子项目(其他技能无 README)。

### 9.2 触发(description)

```yaml
description: >
  Evaluate startup ideas and early-stage projects as a pragmatic angel investor + operator.
  Optimized for small AI-augmented teams with China/global context.
  ...Even when the user hasn't said "evaluate" — if they describe a
  product concept, business model, or market opportunity and seem to want
  strategic input, invoke this skill. When in doubt, use it.
```

- ✅ "When in doubt, use it" — 主动触发。
- ✅ 包含"评估 / idea / 商业模型" 等关键词。
- ⚠️ "When in doubt, use it"**过于 pushy** —— 与 `master-bp-review` 的 "Do not use for raw startup ideas" 冲突。用户给"raw idea"时,两个 skill 都会争抢触发。
  - 解决:在 master-bp-review 的 description 显式加 "If the user has only a concept (no document), use startup-idea-evaluator instead"。

### 9.3 内容/逻辑/准确性

#### 9.3.1 7 步流程

- ✅ **Mode A / Mode B** 双模式 → 短输入快速扫描,长输入深度分析。**优秀**。
- ✅ **Step 1 Rapid Framing** 4 行 → 强制 1 句 thesis + 1 句 stage + 1 archetype + 1 kill switch。
- ✅ **"Kill Switch First"** → 防 analysis theater。
- ✅ **4-6 lens 选(不全 9)** + 跨引用 → 实用主义。
- ✅ **三层挑战**(Survival / Growth / Moat) → 战略层清晰。
- ✅ **Assumption Mapping** 5 种 test → 防止"先 build 后验证"。
- ✅ **Pre-Mortem** "24 个月后死了,最可能的 3 个原因" → 真实 startup 视角。
- ✅ **Pivot scan** + **Straight Verdict** 6 选 1 → 总结明快。

#### 9.3.2 主要疑点

- ❌ **references/market-analysis.md 显式代理到 `everything-claude-code:market-research`**(3 处)但 **本仓库没有 `market-research` skill** → 这是一处 fail-soft 的"暗契约"。
  - 后果:模型按 SKILL 描述调用 `market-research`,但找不到 → 静默失败或降级到 LLM 自己的市场常识。
  - 修复:①要么在仓库里加一个 `market-research` skill(已写了"delegates to") ②要么把内容内联到 `market-analysis.md`。
- ⚠️ **"小而美" calibration table** 在 market-analysis.md,但 README/示例**未明确**"什么是小而美、何时不算小而美" → 用户易把"vc-scale"误判为"小而美"。
- ⚠️ **"Kill Switch" 概念在 4-6 lens 中是 Tier-1 决策**——但**没有回退机制**:kill switch 失败后,用户该问什么?SKILL 没给。
- ⚠️ **"Pre-Mortem" 是反思方法**——但**没有"How to do Pre-Mortem again later"**;若 6 个月后回来,能否重跑?
- ⚠️ **"Pivot scan" 仅 1 行"如果是 X, 替代市场是 Y"**——是启发式,不是方法论。
- ⚠️ **"小而美" 哲学**与 `master-bp-review` 的 Thiel / YC lens 冲突:**小而美**是 bootstrap;**YC** 是 growth-rate-first。模型在 YC lens 评估时可能给"小而美"项目判"不投",但用户期待是"小而美也得跑 7 步"。
  - 解决:在 Step 2 "Team context" 显式说"本评估假设 3 人 + 小而美,如非此场景需 override"。
- ⚠️ **"Pivot scan" 没考虑"换技术栈"、"换团队"、"换市场" 三种 pivot 类型**——只给"换市场"。
- ⚠️ **"Mode A" 末尾"提示用户提供更多信息"**——但**没说哪些信息**:user 多给 4 类中的 2 类 → Mode B 触发;**没说"哪 2 类价值最高"**(按"团队 + 收入模式" vs "客户 + 痛点" 哪个 trigger 更准?)。
- ⚠️ **"Mode A 输出 Mode B 的桥"**:Mode A 末尾说"3 个 30 天内行动"——但**没说 Mode B 是否复用这 3 行动**或推翻。

#### 9.3.3 GTM Playbooks

- ✅ 7 archetype: B2B-SMB / B2B-Enterprise / Consumer / Marketplace / DevTool / AI-Vertical / Hardware —— 覆盖主流。
- ⚠️ "For this team" 注释**重复 7 次**,但**没有"3 人 + 小而美" 的特殊 warning**;比如"hardware for 3-person team"几乎必失败,但 "Don't do yet" 没显式列。
- ⚠️ "China channels" 与 "International channels" 在 archetype C(Consumer)分得很清,但 archetype B / F(B2B)混着说。
- ⚠️ "## GTM Motion Selection" 表的"3-person team fit"评级是 1-5 主观,**没有评估方法**(用户无法判断 ± 0.5 的精度)。

#### 9.3.4 示例输出(AI 合同审查)

- ✅ 完整 7 步走完(Step 1 → Step 7),含数据(¥3,000/月、58 家客户等)、排名(投/有条件投/不投)、bull/bear thesis。
- ⚠️ "investment decision distribution: 1位投,2位有条件投,2位不投" 是模板期望,**没**说"5 选 1 模式"是否被强约束。
- ⚠️ 示例里"Pivot scan: enterprise 法务" 是真知,但 SKILL.md 第 6 步的"Pivot scan"只 1 行,远不够给。

### 9.4 提示工程与安全

- ✅ "Don't avoid hard truths" → 抗 LLM 的"都说好话"。
- ✅ "Don't penalize 3-person team using AI tools" → 抗传统 VC 的 headcount bias。
- ⚠️ "9 Anti-Patterns to Avoid" 是好的 negative prompt,但**没有"Anti-Pattern detection 自动化"**——模型可能嘴上说"避免 anti-pattern",实际犯。

### 9.5 待补内容

1. **real-world failure analysis**:4 个 "pre-mortem 真实案例"。
2. **实操 evals**:`evals/evals.json` 3 个 case 不错,但**没**断言"分析里必须出现 `small-but-beautiful` 提及"。可加。
3. **数据源**:`market-analysis.md` 缺可调用的真实数据源(Statista / Crunchbase / 36kr / 创业邦),SKILL 没教"数据源应去哪儿找"。
4. **"团队"维度**:Step 1/2/5 多次提到"3 人团队",但**没有"评估单个创始人"的方法**(这点其实应该是核心)。
5. **法律/监管**:只在 Mode B 提了一行"监管" lens,**对 HIPAA/SOC2/中国数据出境**等没具体清单。
6. **GTM Playbooks 没有"如何选 archetype"**:Step 2 "archetype 决定 GTM playbook",但**选择标准**(按客户数?按 ARR?)没说。
7. **Anti-Patterns 没有 telemetry**:实际跑 100 个 case,数 anti-pattern 命中率?
8. **小而美/VC scale 切换条件**:只有哲学,无"何时从小转大"的可量化触发。

### 9.6 Cross-cutting Proposals 回引

- CP3:**必须解决 `market-research` 暗契约** —— 不然 Step 4 实际退化到"猜"。
- CP2:"小而美 / bootstrap / KISS / MVP-first" 应入术语表(USER.md 已有类似哲学,但本 skill 有专精版)。
- CP6:`startup-idea-evaluator + master-bp-review` 应作为"strategy 双 skill":前者评估 idea,后者评 BP。

### 9.7 Summary(startup-idea-evaluator)

- 评分: 8 / 9 / 8 / 6 / 7
- 主要问题:`market-research` 暗契约、与 `master-bp-review` 触发重叠、Pivot scan 过简、evals 缺 assertion。
- 最少修改见效快:在 SKILL.md Step 4 顶部加 "if market-research unavailable, fall back to LLM reasoning with explicit caveat";在 master-bp-review description 显式 add "for raw concepts use startup-idea-evaluator"。

---

## 10. `synthesize-documents` — 多文档综合

### 10.1 文件清单与规模

| 文件 | 字节 | 行 | 备注 |
|---|---|---|---|
| `SKILL.md` | 8 228 | 163 | |
| `agents/openai.yaml` | 336 | 5 | **OpenAI 平台元信息** |

2 文件,**最轻**的技能。

### 10.2 触发(description)

```yaml
description: Synthesize multiple provided documents into one comprehensive replacement document. Use when the user asks to merge, consolidate, reconcile, summarize comprehensively, produce a consensus report, integrate several drafts/reviews/memos, or create a final synthesis that preserves shared points, minority-only points, disagreements, source structures, user-specific requirements, and evidence-based evaluation.
```

- ✅ 触发词密集 (merge / consolidate / reconcile / summarize / consensus / integrate / synthesize)。
- ✅ "preserves shared points, minority-only points, disagreements" → 强提示词,极具特异性。
- ⚠️ 触发词"merge / consolidate" 与常规的"summarize" 难区分(用户想"给我总结下"可能也触发) → 可能 over-trigger。

### 10.3 内容/逻辑/准确性

#### 10.3.1 8 步流程

- ✅ "Source Inventory" → 每个文档做"document card" → 防漏源。
- ✅ "Classify 4-bucket"(shared consensus / partial / minority-only / disagreement) → 强结构。
- ✅ "Distinguish silence from disagreement" → **稀缺洞察**;多数 LLM 总结会把"沉默"误为"不同意"。
- ✅ "Never treat frequency as truth" → 抗"投票机"。
- ✅ "Do not force false precision" → 抗"造数据"。
- ✅ "Search/Verify when needed" — Step 6 给了清晰的 4 种"应当用 search" 的条件。
- ✅ "Final Synthesis" 8 节 → 完整。

#### 10.3.2 主要疑点

- ⚠️ **"Source Inventory"** —— Step 2 说 "include it in the final output only when the user asks for traceability"——**没**说"为什么默认不 include" → 模型可能不 include,失去审计能力。
- ⚠️ **"Evaluate Minority and Divergent Points"** —— 4 种 practical groupings(minority-but-valid / minority-but-context / disagreements / unsupported / outdated)→ 实际跑时,模型可能**把 minority 一律判为 "outdated"** —— 反 minority bias 风险。
- ⚠️ **"External search when needed"** —— Step 6 列了 4 个条件,但**没说"search 不 available 时"**怎么处理(同 `startup-idea-evaluator` 的 `market-research` 暗契约问题)。
- ⚠️ **"Output Standards"** 列 6 条,但**没**"writing style / tone"指导(对比 `startup-idea-evaluator` 的"concise, not all flat")。
- ⚠️ **"Output Format"** 末尾"Adapted to user's requested format" — 没说"如果用户没指定,默认结构是 8 节?"。

#### 10.3.3 引用 `agents/openai.yaml` 的角色

- 这是一个 OpenAI Custom GPT / GPT Actions 的 manifest(5 行 YAML,定义 display_name / short_description / default_prompt)。
- ⚠️ **它和 SKILL.md 重复定义了"做什么"** —— SKILL.md 是给 Claude Code 看的,openai.yaml 是给 OpenAI GPT 看的,二者目的不同。
- ⚠️ **"default_prompt"** 直接用 `$synthesize-documents` 触发,这是 OpenAI 的 placeholder 语法,**不是 Pi 语法** → 仅在 OpenAI 平台生效。
- ⚠️ **`agents/openai.yaml` 的位置错了**——放在 `agents/` 目录暗示是"agent 模板",但它是"GPT manifest" → 应该放 `openai/` 或 `platforms/openai/`。
- ⚠️ **没有 `anthropic.yaml` / `claude.yaml`** —— **其他平台的支持缺失**。

### 10.4 提示工程与安全

- ✅ "Make the final document coherent enough to stand alone, not a stitched list of summaries" → **核心防 LLM 偷懒的指导**。
- ✅ "Distinguish verified facts from inference" → 抗 LLM 装懂。
- ✅ "use concrete examples, counterexamples" → 防抽象废话。
- ⚠️ "no generic filler and abstract summary language" 是 anti-fluff,但**没**说"何时该 abstract"——也许多文档综合里 abstract 反而好。

### 10.5 待补内容

1. **多模态输入**:文档可能是 PDF / DOCX / 网页,SKILL 假设"用户给文本";实际跑时模型可能只有 Read 工具。
2. **超长文档**:若输入 5 份各 100K token,SKILL 没给"如何分而治之"(map-reduce?顺序读?抽样?)。
3. **多语言混合**:输入文档可能是中英日德混合。
4. **可重现性**:`evaluations` 评分是 LLM 主观,如何重跑 + 对比?
5. **"Minority but likely valid"** 的判断标准?SKILL 没给"什么证据算 valid"。
6. **质量评估**:输出合成文档后,**没**说"如何测试它是真的 comprehensive"?建议加 checklist。

### 10.6 Cross-cutting Proposals 回引

- CP2:"共享 / 部分 / 少数 / 不同意" 4-bucket 是独特术语,应入 glossary。
- CP6:`synthesize-documents` 是普适 skill,可作"未来多 skill 间交叉"的工具。

### 10.7 Summary(synthesize-documents)

- 评分: 8 / 8 / 9 / 6 / 7
- 主要问题:`agents/openai.yaml` 错位、超长文档无解、`market-research`-style 暗契约、多模态缺。
- 最少修改见效快:`agents/openai.yaml` 改名/迁移;Step 6 加 "if search unavailable" 显式分支。

---

## 11. 跨技能对比与汇总

### 11.1 评分汇总

| 技能 | 功能 | 触发 | 清晰 | 可移植 | 安全 | 综合 |
|---|---|---|---|---|---|---|
| `ai-script` | 9 | 8 | 8 | 4 | 7 | 7.2 |
| `audio-album-creator` | 9 | 9 | 9 | 5 | 9 | 8.2 |
| `dev-env-audit` | 9 | 8 | 9 | 7 | 10 | 8.6 |
| `interview-methodology` | 9 | 9 | 9 | 5 | 10 | 8.4 |
| `lobster-agent-creator` | 8 | 8 | 8 | 2 | 9 | 7.0 |
| `master-bp-review` | 8 | 8 | 8 | 6 | 7 | 7.4 |
| `prompt-architect` | 8 | 8 | 9 | 7 | 7 | 7.8 |
| `startup-idea-evaluator` | 8 | 9 | 8 | 6 | 7 | 7.6 |
| `synthesize-documents` | 8 | 8 | 9 | 6 | 7 | 7.6 |

### 11.2 触发词比较(易撞车)

| 触发词 | 风险技能 |
|---|---|
| "评估 / review" | `master-bp-review` vs `startup-idea-evaluator` |
| "总结 / 整合" | `synthesize-documents` vs (隐式)其他 |
| "audio / music" | `ai-script` vs `audio-album-creator` |
| "环境 / 审计" | `dev-env-audit` (相对独立) |

**核心建议**:在每个 SKILL.md 顶部加 "When to use this skill" + "When NOT to use this skill" 二元表(目前只有 audio-album-creator + master-bp-review 显式做了),模型路由更稳。

### 11.3 工程卫生评分

| 技能 | `.DS_Store` | `__pycache__` | `.venv` | 短 README | LICENSE | evals |
|---|---|---|---|---|---|---|
| `ai-script` | — | — | — | ❌ | ❌ | ❌ |
| `audio-album-creator` | ✅ | — | ❌(13MB) | ❌ | ❌ | ❌ |
| `dev-env-audit` | — | — | — | ❌ | ❌ | ❌ |
| `interview-methodology` | — | — | — | ❌ | ❌ | ❌ |
| `lobster-agent-creator` | — | — | — | ❌ | ❌ | ❌ |
| `master-bp-review` | — | — | — | ❌ | ❌ | ✅ |
| `prompt-architect` | — | — | — | ❌ | ❌ | ❌ |
| `startup-idea-evaluator` | — | — | — | ✅ | ❌ | ✅ |
| `synthesize-documents` | — | — | — | ❌ | ❌ | ❌ |

**清晰结论**（⚠️ 已被 `skills-issue-report.md` 证伪，见该文档第 1 节 —— `.DS_Store`/`.venv`/`__pycache__` 从未被 git 跟踪，以下三条结论不成立，保留仅作历史对照）:
- ~~`.DS_Store` 2 个,根级别 + audio-album-creator 内部,应清理。~~
- ~~`.venv` 13MB,全在 audio-album-creator,应剔除 git 并改用 uv sync。~~
- ~~`__pycache__` 8 个(已清理),但 git 已跟踪,需 `git rm -r --cached`。~~
- 唯一带 README 的是 `startup-idea-evaluator` —— 平台使用说明,值得复制到其他技能。

### 11.4 待补充内容 Top 10(按影响排序)

1. **`.venv` 从 git 移除** + 改用 `uv sync` + README 说明(影响:13MB → 0)
2. **`.DS_Store` 删除** + 加 `.gitignore` 规则(影响:0,但该清)
3. **`__pycache__` 从 git 移除** + `quick_validate.py` 加 `__pycache__` 排除(影响:10 个文件)
4. **CP3:`market-research` 暗契约** —— `startup-idea-evaluator` 必须加 fallback
5. **CP7:跨技能触发冲突图** —— 在每个 SKILL.md 顶部加"什么时候不用我"
6. **CP11:每个 SKILL.md 加 `license` 字段**(避免"全部隐性 Apache 2.0")
7. **CP5:`audio-album-creator` 抽 `gen_cover.py` 到一个跨技能共用的工具目录**(避免 skill-specific venv)
8. **CP2:cross-skill-glossary.md** —— 沉淀术语(锁辙 / 钩子 / 小而美 / 默会知识 / Synthesis 4-bucket)
9. **`synthesize-documents` 的 `agents/openai.yaml` 重命名/迁移到 `platforms/openai/`** —— 与 `agents/` 的"agent templates"语义分离

### 11.5 需要你拍板的争议项

下面这些是我**不替你下结论**的事,因为它们关乎"你想要这个 skill 是什么方向":

1. **USER.core 与 MEMORY.md seed 含 Stanford 个人信息** —— 决定 lobster-agent-creator 是**模板工具**(剥离个人)还是**个人专用**(保留)。
2. **`audio-album-creator` 的 `.venv/` 是否应保留在仓库** —— 若有"想立刻跑,不用 uv sync"的需要,保留;若能接受"第一次跑前 uv sync",剔除。
3. **`startup-idea-evaluator` 是否实现一个真 `market-research` skill** —— 若团队里有 market research data,加;若靠 LLM 推理,加 fallback 即可。
4. **跨技能触发冲突** —— 接受"按 description 排" + 用户改 prompt 消歧,还是做"中央 router skill"?
5. **LICENSE 统一** —— 全部 Apache 2.0,还是各技能独立?若独立,每个 SKILL.md 加 `license: ` 字段。
6. **CP2 (cross-skill-glossary)** —— 是单独建一个 skill,还是在每个 SKILL.md 顶部加 "Glossary" 节?

---

## 12. 一次性深度清理建议(可立即执行)

```bash
# 1. .DS_Store
find .agents/skills -name .DS_Store -delete
echo ".DS_Store" >> .gitignore

# 2. __pycache__ (git rm + 加 .gitignore)
find .agents/skills -type d -name __pycache__ -exec git rm -r --cached {} + 2>/dev/null
echo "**/__pycache__/" >> .gitignore
echo "*.pyc" >> .gitignore

# 3. .venv 移出
echo "audio-album-creator/scripts/.venv/" >> .gitignore
git rm -r --cached .agents/skills/audio-album-creator/scripts/.venv
```

### 12.1 我建议的 `.gitignore` 补充(本仓库根 `.gitignore`)

```gitignore
# Agent skill hygiene
.agents/skills/**/.DS_Store
.agents/skills/**/__pycache__/
.agents/skills/**/*.pyc
.agents/skills/**/.venv/
```

### 12.2 我建议的 SKILL.md 模板(本仓库内)

- 在"frontmatter"加一条 `license: Apache-2.0` 作为推荐(如果同意全部 Apache 2.0)。

---

## 13. 我不会替你做的事

- **不替你改任何代码**:这份报告是**建议 + 决策点**,不是 patch。
- **不替你决定 LICENSE**:这是法律/团队/个人偏好,留你拍。
- **不替你对 USER.core 中的 Stanford 个人信息做模糊化** —— 那会让"为非 Stanford 用户复用"变成默认,**也可能让 Stanford 自己的工具变残**;**留你拍**。
- **不替你创建 README / CONTRIBUTING.md / CHANGELOG.md**:这是 repo 级别的决策,需要先确定治理策略。
- **不替你跑 trigger-eval**:需要实际 Claude Code 平台 + API key;不擅自跑。

---

<!-- 报告结束 · 总计:13 节,10 个技能, 90 个源文件,约 996 KB(不含 venv) · 由 Claude(Fable 5)一次性审阅;保留所有结论的事实依据,争议点交你拍板 -->
