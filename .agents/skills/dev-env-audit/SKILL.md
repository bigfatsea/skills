---
name: dev-env-audit
description: "Audit the local development environment (macOS + zsh): detect installed language SDKs (Python/Node/Java/Go/Rust/Ruby/C#/.NET/Swift/Objective-C/PHP/Lua/Zig/Julia/Dart/Flutter/Erlang/Elixir/C/C++/Git), how each was installed, version-manager conflicts (e.g. pyenv+uv, nvm+fnm, rvm+rbenv, brew+asdf), PATH resolution problems across shell scenarios (path_helper), and whether dev caches are relocated to an external SSD; then produce a diagnosis and per-language migration plan following the per-language best-practice baseline (uv / fnm+pnpm / SDKMAN / asdf / rustup / rbenv / dotnet-install / Xcode / Homebrew / zigup / juliaup / fvm / brew git). Use whenever the user asks to 检查/审计/体检开发环境、看某个语言是不是装乱了、为什么 python/node/git/php/dotnet 解析到错误路径或旧版本、清理多余的版本管理器、检查缓存有没有外置到 SSD, or asks 'what SDKs do I have installed', 'is my dev setup correct', 'audit my toolchain' — even for a single language. Read-only: never installs, uninstalls, or edits shell config; it outputs a report with commands for the user to run themselves."
---

<!-- Ver 2026-07-19 05:30, by Claude Sonnet 5 -->

# dev-env-audit — 开发环境审计

只读审计本机开发环境，对照 per-language 最佳实践基线产出诊断报告 + 迁移建议。
**本 skill 全程只读**：探测脚本和你执行的所有命令都不得修改任何文件、不得安装/卸载任何东西、不得联网下载。报告给出命令，由用户自己执行。

## 设计哲学（总体指导方针）

以下原则是本 skill 一切判定和建议的推导起点，执行中任何环节与之冲突时以本节为准。
**产出报告时，第一节必须先摘要声明这些原则**（3-5 行，至少含第 1/3/5 条），并注明：全部诊断与建议都建立在这套理念上；若用户不认同（例如偏好用 mise 统一管理所有语言），后续迁移建议对其参考价值有限，应先对齐理念再谈方案。

1. **只探测、只分析、只建议，绝不执行。** 核心功能就是全面了解系统实况 + 给出合理建议；安装/卸载/改配置/联网都不做，变更命令只出现在报告里，由用户确认后自行执行。
2. **事实与解读分离。** scan 只陈述全部事实，不做判断、也不因"良性"而隐藏任何事实；判定规则集中在 references；报告在完整事实之上做解读。
3. **每种语言用其领域的权威工具**（uv / fnm / rustup / rbenv / juliaup…），或一个工具管一类强耦合生态（SDKMAN for JVM、asdf for OTP+Elixir）。**反对"一个工具统一所有语言"的路线**——不认同、不推荐 mise 类方案。
4. **官方优先于第三方。** 语言原生机制能解决的（GOTOOLCHAIN、.NET 多 SDK 并存、多 Xcode + xcode-select）不引入额外工具；第三方工具须有明确的不可替代价值。
5. **尊重存量的合理选择。** 同类等价工具（mise↔asdf、zigup↔zvm）运转正常就不建议互迁；系统默认"未治理"是合法状态；缓存外置是可选项不是义务——**半外置的漂移才是最危险状态**。
6. **生效值优先于配置表象。** 判定以工具自身报告的实际落位为准（环境变量会骗人），并覆盖三种 shell 场景（交互终端 / GUI App / 脚本）。
7. **原则性指导，不做精细版本管控。** 关注工具链结构是否健康，不纠结细微版本号差异。
8. **禁止编造。** 报告中的命令必须出自 references；references 的每条命令必须过 `_template.md` 的防幻觉自检清单。
9. **支持范围明确：macOS；zsh 完整支持，bash 降级支持，fish 等其他 shell 不支持。** 诚实声明不覆盖，胜过错误覆盖。

## When NOT to use

- 用户要求**直接执行**迁移/安装/卸载 —— 超出本 skill 边界。先产出完整报告，再告诉用户：报告里的变更命令需要他逐条确认后自行执行（或明确授权后另起任务处理）。
- 项目级依赖问题（某个 repo 的 node_modules / venv 坏了）—— 本 skill 管机器级工具链，不管单个项目。

## 执行流程（四阶段）

所有脚本用 `zsh` 运行（不是 bash——脚本是 zsh 语法）。脚本路径相对本 skill 目录。

### Phase 1 — 范围探测（1 次调用）

```bash
zsh scripts/scan.sh
```

输出是纯清单：每种语言 / 版本管理器 / 包管理器的存在性、路径、一行版本，外加 brew 重复安装和 PATH 重复项。**清单不做判断**，判断规则在各语言 references 里。

读清单后定范围：
- **先看 `login shell` 这节**。本 skill 全部 PATH/init 分析假设 zsh；不是 zsh 时按档降级并在报告开头显式声明：
  - **bash**：工具存在性、版本、缓存外置结论仍然有效；references §2 的 grep 目标本来就含 `~/.bash_profile ~/.bashrc`，init 残留分析大体可用；但 probe-path 三场景是 zsh 口径，PATH 场景结论要注明"按 zsh 规则测得，bash 的加载规则（login 读 .bash_profile、非 login 读 .bashrc）不同，需用户自行对应"。
  - **fish 及其他**：只保留存在性/版本/缓存外置三类结论；PATH 与 shell 配置分析整体声明"未覆盖（本 skill 仅支持 zsh/bash 配置体系）"，不要硬套。
- 存在的语言 → 进入 Phase 2 深挖；不存在的直接跳过（不要加载它的 reference）。
- 注意 `(dir found, command not on PATH)` 类条目——目录在但命令不在，通常意味着"装过、初始化代码被删了或还残留着"，这是 Phase 2 要重点追查的信号。
- 记住 `shell config source chain` 这节列出的文件全集。用户若用集中式 dotfiles 框架（`~/.zshrc`/`~/.zprofile`/`~/.zshenv` 只有几行 `source` 语句，真正的 init/PATH 逻辑在别处），Phase 2 各 reference §2 里那些字面 `~/.zshrc ~/.zprofile ~/.zshenv` 的 grep 会大概率落空——这不代表逻辑不存在，把 source chain 列出的文件一并加进 grep 目标，落空了才能下"确实没有"的结论。

### Phase 2 — 逐语言深挖（只对存在的语言）

对 Phase 1 命中的每种语言：

1. Read `references/<lang>.md`（python / node / java / go / rust / ruby / git / csharp / swift / php / lua / zig / julia / dart / erlang-elixir / cpp）。
2. 按其 **§2 深挖探测** 逐条执行命令。命令全部只读，可以多个 Bash 调用并行。**必须真的执行，禁止凭记忆脑补输出。**
3. 按其 **§3 判定规则** 把发现归类为 OK / WARN / FAIL。
4. 发现异常时允许自主追查（例如发现 pyenv 目录，就去 grep shell 配置里的 init 残留；发现两个 uv，就 `which -a uv` 查全）。追查也必须只读。

用户只问单一语言时：Phase 1 和 Phase 3 仍要完整跑（冲突常藏在用户没问的地方），Phase 2 只深挖用户问的语言即可，但若 Phase 1 清单里其他语言有明显异常（如同语言双管理器），在报告末尾提一句。

### Phase 3 — 横切检查（2 次调用）

```bash
zsh scripts/probe-path.sh        # PATH 三场景检测（macOS path_helper 坑）
zsh scripts/probe-cache.sh       # 缓存外置环境变量清单核查
```

- probe-path.sh 对关键命令分别在"非登录非交互 / 登录非交互 / 登录交互"三种 zsh 场景下解析，三者不一致即 WARN。"登录非交互"（GUI App、launchd 常用）是最容易漏配的一档。深挖某语言时可追加单独检查：`zsh scripts/probe-path.sh <cmd>`（git.md / ruby.md §2 即此用法）。注意 `zsh -l -c` 是 GUI App/launchd 环境的**近似模型**（真实 launchd 环境需 `launchctl getenv PATH` 才能精确取到），足以定位绝大多数问题；报告若涉及 launchd 级精确诊断，需注明这一近似。
- probe-cache.sh 对照外置清单逐项核查：uv/pnpm/go/maven 这类"环境变量会骗人"的条目按**工具自身报告的生效值**判定（能捕捉 `go env -w`/`pnpm config set` 完成的外置），其余按本进程继承的环境变量判定；末尾还做外置变量的**三场景一致性检查**（变量只写在 ~/.zshrc 时 GUI App/launchd 看不到 = 隐性漂移）。**漂移判定按工具分组**（uv/node/jvm/go/rust/asdf/poetry/php/ruby/dart/julia/cpp/dotnet/bun/deno/lua 各自一组）：只有同一组内既有变量外置、又有变量未外置才算漂移并 WARN；不同组之间进度不一致（比如 uv 全外置了、Maven 还没顾得上）是正常状态，不算漂移——外置本来就是可选项，不该被要求"要做就全做"。若它报 FAIL（路径指向未挂载的卷），**不要中途停下来问用户**——跳过外置检查、继续走完剩余流程，在报告里注明"检测到外置路径未挂载，本次跳过该项核查；挂载磁盘后可重跑 `zsh scripts/probe-cache.sh` 复核"。
- 两个脚本的主体读取的是**本进程继承的环境**（输出首行会声明快照口径）；跨场景差异由 probe-path.sh（PATH）和 probe-cache.sh 末节（外置变量）分别覆盖。

### Phase 4 — 综合报告

Phase 4 自动产出**三个产物**，全程不停下来问用户（HTML 模板没指定就随机选一个，报告语言默认英文，任何不确定性一律写进报告，不打断执行）：

1. **JSON 结构化摘要** → 写到 `/tmp/dev-env-audit-summary.json`（agent 内部数据，HTML 渲染器消费它）
2. **Markdown 主报告** → 直接输出到对话窗口（人读，含全部细节），**同时**保存一份到 `~/Desktop/dev-env-audit/dev-env-audit-report-<timestamp>.md`
3. **HTML 单页报告卡** → `zsh scripts/render-card.sh /tmp/dev-env-audit-summary.json ~/Desktop/dev-env-audit/dev-env-audit-report-<timestamp>.html [terminal|paper|brutalist]`，**默认每次都生成**，不是可选项

`<timestamp>` 取同一个值贯穿本次运行（例如 `date +%Y%m%d-%H%M%S`），MD 和 HTML 必须落在同一目录、文件名同 stem——HTML 卡片里"打开 Markdown 报告"的链接是相对路径，全靠这个约定才能点开。目录不存在就 `mkdir -p ~/Desktop/dev-env-audit`；这不违反"只读"哲学——只读指的是不改动被审计系统的既有文件/配置，产出报告本身是本 skill 的核心交付物，新建目录/新建文件从一开始就是允许的（JSON 落 `/tmp` 也是同样道理）。

#### 4.0 报告语言（默认英文）

报告默认用**英文**撰写——标题、发现、建议、JSON 里所有 `title`/`detail` 字段全部英文，这是本 skill 输出的默认语言，跟你与用户对话用的语言无关。只有用户明确要求"写中文报告"时才切换成中文（结构不变，只换文字）。三套 HTML 模板本身的固定标签（"Top Actions" "Stability" "Languages" 等）**只有英文一个版本**，不随报告语言切换——它们是外壳，真正的内容都来自 JSON。

#### 4.1 Markdown 报告结构

报告开头**必须**先出"首屏三件套"（分数 + 立即行动 + 一分钟看懂），让初中级用户三秒看完全貌；**然后**才进入细节七节。

**首屏三件套**（必出，紧凑、不展开，默认英文，示例）：

```markdown
# Dev Environment Health Check

> **Overall: $SCORE / 100 $EMOJI $TIER_LABEL** (Excellent / Good / Needs Attention / At Risk / Critical)
> 🟢 OK: $OK  ·  🟡 WARN: $WARN  ·  🔴 FAIL: $FAIL

## Top 3 Actions
1. 🔴 $ACTION_1
2. 🟡 $ACTION_2
3. 🟡 $ACTION_3

## One-Minute Overview

| Language | Current | Recommended | Status |
|---|---|---|---|
| ... | | | |

---
(the original 7 detail sections follow below)
```

**细节七节**（沿用原有结构，本节做小幅调整；默认英文撰写，下面小标题保留中文只是给 agent 看的说明）：

0. **理念声明** —— 3-5 行摘要设计哲学（至少含第 1/3/5 条：只建议不执行、每语言用领域权威工具而非一统工具、尊重存量合理选择），并注明：全部诊断与建议基于这套理念，不认同者本报告参考价值有限。
1. **总体结论** —— 用分数 + 等级开头；PASS/WARN/FAIL 仍标，但分数才是"对外晒的资产"；最重要的 3 个发现（合并同一根因）。
2. **逐语言状态表** —— 简化为 `Language | Current (incl. install channel) | Recommended | Status` **四列**。原"需要的动作"和"风险"两列移到第 5 节，避免首屏表过宽。
3. **冲突清单** —— 每条写"Symptom → Root cause → Impact"。
4. **缓存外置状态** —— 已外置 / 未外置 / 漂移 三类。**漂移才是最危险的状态**，要重点标出。
5. **逐语言迁移方案** —— 只列需要动作的语言；按 reference §4 五步法；**承接第 2 节移过来的"需要的动作"和"风险"两列**。命令必须出自 reference，禁止编造。每个破坏性命令单独标注风险，引用 reference §5。
6. **执行顺序建议** —— 跨语言排依赖：先装新再卸旧（先装 fnm 才能卸 brew node）；CARGO_HOME 要在装 uv 前定下来；SDKMAN_DIR / RUSTUP_HOME / ASDF_DATA_DIR 必须装前设好。
7. **✅ 乐观发现** —— 把"已正确配置"的事项列出来。一来对初中级是"做对了什么"的教学，二来让晒出去的报告不显得全是问题。**至少 1 条**，鼓励 3-5 条。例（英文）：
   - ✅ Python on uv, PATH is unique, no pyenv/conda leftovers
   - ✅ Rust on rustup, single rustc/cargo install
   - ✅ Cache uniformly relocated to `/Volumes/SSD/dev-cache/`, no drift

报告末尾固定分栏，绝不混排：

- **可直接再跑的只读验证命令**
- **需你确认后手工执行的变更命令**

写作纪律：

- 同一根因的多个 WARN 合并成一条。
- 读者是"三个月后忘了当初怎么配的自己"——每条建议写清 why，不只给命令。
- 机器特定值（如外置盘具体路径）如实展示，不假设所有机器都一样。
- **首屏三件套要"3 秒可读"**：立即行动项每条不超过 1 行；TL;DR 表只放存在的语言；状态用 emoji + 颜色字（不是裸文字）。
- **任何需要用户拍板/确认的地方，写进报告（如"待确认"小节或行内标注），不要中途打断执行去问。**

#### 4.2 评分规则（首屏分数怎么算）

```
Score = 100
  - each FAIL             -15
  - each WARN             -5
  - each INFO             -0
  - cache drift detected  -10 (drift is the most dangerous state — design philosophy #5)
  - PATH inconsistent across 3 scenarios  -8 (probe-path.sh reports WARN)
  - Apple git with no brew takeover       -3 (version freeze is a latent risk even without conflict)
floor: 0
```

等级：

| Score | Tier | Emoji | Meaning |
|---|---|---|---|
| 90-100 | Excellent | 🟢 | share it as-is |
| 75-89 | Good | 🟢 | fine day to day, worth clearing the WARNs |
| 60-74 | Needs Attention | 🟡 | a few clear gaps |
| 40-59 | At Risk | 🟠 | occasional breakage likely |
| 0-39 | Critical | 🔴 | fix before doing anything else |

三维度分（HTML 卡片以三条紧凑横向进度条展示，Markdown 报告可省）：

- **Stability** = 100 - 20 × FAIL 数（最低 0）
- **Consistency** = 100 - 15 × PATH 不一致数 - 15 × 缓存漂移数（最低 0）
- **Modernity** = 100 - 8 × 非权威管理器数（最低 0）

#### 4.3 JSON 摘要

写到 `/tmp/dev-env-audit-summary.json`。schema 详见 `scripts/render-card.schema.md`，**必填字段**：

- `score` / `tier` / `tier_label` / `tier_emoji` / `counts.{ok,warn,fail}`
- `scores.{stability,consistency,modernity}`
- `languages[]`（每项：`name`, `current`, `recommended`, `status` ∈ `ok`/`warn`/`fail`/`info`）
- `top_actions[]`（每项：`severity`, `title`, `detail`；**最多 3 条，按严重度排序**）
- `positive_findings[]`（每项：`title`, `detail`；**至少 1 条**，否则报告显得全是问题）
- `host.{os,shell}`、`timestamp`（ISO 8601）
- `report_md`（**必填**，本次 Phase 4 写到磁盘的 Markdown 报告文件名，相对路径——见下一节，HTML 卡片靠它生成"打开完整报告"的链接）

`title`/`detail` 等自然语言字段按 §4.0 默认写英文。

#### 4.4 HTML 单页报告卡（默认产物，三选一皮肤）

不再依赖 Python：`scripts/render-card.sh` 是纯 `zsh` + `sed` + `awk`，把 JSON 机械地塞进三套静态模板之一（`render-card.terminal.html` / `render-card.paper.html` / `render-card.brutalist.html`）里唯一的占位符，模板本身的 HTML/CSS/JS 从不重新生成，也不需要模型手写。

```bash
zsh scripts/render-card.sh /tmp/dev-env-audit-summary.json \
  ~/Desktop/dev-env-audit/dev-env-audit-report-<timestamp>.html \
  [terminal|paper|brutalist]
```

- **模板怎么选**：用户在发起审计时如果点名了三个名字之一（比如"用 brutalist 模板"），就把名字传给第三个参数；**没点名就不传，脚本自己用 `$RANDOM` 随机选**——不要为了选风格去问用户。
- 三套模板信息架构完全相同，只是视觉风格不同：
  - `terminal` —— 深色终端窗口风格，等宽字体
  - `paper` —— 浅色编辑/证书风格，衬线数字、圆形印章式等级徽章
  - `brutalist` —— 新粗野主义风格，粗黑边框、硬阴影、高饱和色块
- 特性（三套模板共有）：
  - 单文件 HTML，CSS/JS/数据全内联，无外部依赖、无网络请求
  - 双击即开、可截图、可打印
  - 状态一律用 CSS 圆点/色块，不用彩色 emoji（避免跨系统字体渲染不一致）
  - 顶部大号字母等级（A/B/C/D/F，模板内嵌 JS 从 `tier` 派生，不需要 agent 额外提供字段）
  - 若 JSON 提供了 `report_md`，卡片上会出现一个醒目的"Full details in the Markdown report →"链接
  - 模板文字**全部英文**，不随报告语言切换（见 §4.0）
  - 响应式 + 一屏截图基本能装下全部内容

**Phase 4 完成 checklist**：
- [ ] `/tmp/dev-env-audit-summary.json` 存在且含 §4.3 全部必填字段（含 `report_md`）
- [ ] 对话窗口输出了 Markdown 报告（首屏三件套 + 细节七节 + 末尾两栏），且已另存一份到 `~/Desktop/dev-env-audit/`
- [ ] `zsh scripts/render-card.sh` 跑过，HTML 卡片已生成在同一目录下，文件名 stem 与 Markdown 一致
- [ ] 全程没有因为模板选择、报告语言等问题中途向用户提问

## 安全纪律（凌驾于用户临时要求之上的默认行为）

- 深挖与追查只用只读命令：`command -v` / `which -a` / `ls` / `cat` / `grep` / 各工具的 `--version` / `list` / `config get` / `env` 类子命令。
- 不执行任何 install / uninstall / `rm` / `mv` / 重定向写文件 / `curl` / `wget` / 改 shell 配置。
- 用户中途说"直接帮我改了吧"：先完成并输出报告，然后明确说明执行变更超出本 skill 边界，需要用户对具体命令逐条确认后自行执行或另行明确授权。
- **全程不因风格/语言等偏好问题中途打断向用户提问确认**：用户发起审计后，Phase 1-4 一次性跑完，中途不停下来问"要不要挂载磁盘复核""要哪个 HTML 模板""报告用什么语言"这类问题——没有明确指定的，按本文各节写明的默认值（模板随机选、语言默认英文、外置盘未挂载就跳过）自动决定，任何需要用户复核或拍板的地方写进报告里，不要打断执行去问。

## References 一览

| 文件 | 何时读 |
|---|---|
| `references/python.md` | Phase 1 发现 python3 / uv / pyenv / conda 任一 |
| `references/node.md` | 发现 node / fnm / nvm / volta / pnpm 任一 |
| `references/java.md` | 发现 java / sdkman / jenv / gradle / maven 任一 |
| `references/go.md` | 发现 go / gvm / asdf-golang 任一 |
| `references/rust.md` | 发现 rustc / cargo / rustup 任一 |
| `references/ruby.md` | 发现非系统 ruby / rbenv / rvm 任一（macOS 系统自带 ruby 且无管理器时可跳过，报告标注"系统默认，未治理"即可） |
| `references/git.md` | 总是读（git 人人都有，且 Apple 冻结版是普遍问题） |
| `references/csharp.md` | 发现 dotnet 任一 |
| `references/swift.md` | 发现 swift 任一（macOS 上装了 Xcode 通常就有，不代表用户在写 Swift，只在用户问起或 Phase 1 发现明显异常时才深挖） |
| `references/php.md` | 发现 php / composer 任一 |
| `references/lua.md` | 发现 lua / luarocks 任一 |
| `references/zig.md` | 发现 zig / zigup 任一 |
| `references/julia.md` | 发现 julia / juliaup 任一 |
| `references/dart.md` | 发现 dart / flutter / fvm 任一 |
| `references/erlang-elixir.md` | 发现 erl / elixir / mix 任一 |
| `references/cpp.md` | 发现 gcc / clang / cmake / vcpkg 任一——但 clang 几乎所有 Mac 都有（Xcode CLT 自带），只在用户明确写 C/C++、或 Phase 1 发现多个 gcc 版本/vcpkg 时才深挖，不要对每台机器都跑一遍 |
| `references/_template.md` | 新增或修改任何 reference 之前必读（含防幻觉自检清单），审计时不读 |

Bun / Deno 不设 reference：它们与 Node 不冲突、按需安装，scan.sh 的存在性信息足够；只在发现"brew 和官方脚本各装了一份"时报 WARN。

mise 不设 reference、也不进基线：本 skill 的哲学是**每种语言用其领域的权威工具**（uv / fnm / rustup…），或一个工具管一类生态（SDKMAN for JVM）；不认同"一个工具统一所有语言"的路线，永不主动推荐 mise。发现 mise 时的判定规则：
1. mise 与某语言的专属管理器**同时在管同一语言** → 按该语言 reference 的"同语言双管理器"条目处理（二选一，通常保专属工具）。
2. 用户已在用 mise（或 asdf）做全栈统一且运转正常 → **尊重现状**，不建议在 mise↔asdf 这类同类工具之间迁移——互换收益低于折腾成本。
3. Node 是明确例外：基线首选 fnm（见 node.md），不因"已有 mise/asdf"而改推。
