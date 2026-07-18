<!-- Ver 2026-07-19 02:00, by Claude Sonnet 5 -->
<!-- 方案文档：dev-env-audit 报告输出优化 + 实施后视觉评审修订 -->

# 方案文档：dev-env-audit 报告输出优化

> **本文性质**：调研 + 设计 + 比选方案文档。**不实施、不修改任何现有文件**。
> **下一步**：等用户拍板后，再分阶段落地。
>
> **作者注**：完整阅读了 `SKILL.md` 主文件、3 个 shell 脚本（`scan.sh` / `probe-path.sh` / `probe-cache.sh`）、`_template.md` 及 13 个语言 reference（python / node / git / java / go / rust / ruby / csharp / swift / php / zig / julia / dart / erlang-elixir 等）。本方案完全尊重现有 skill 的设计哲学（只读 / 每语言权威工具 / 尊重存量），只在"输出层"做改良，不碰判定逻辑。

---

## 0. 一句话结论（TL;DR）

**推荐方案 B**：保留并强化 Markdown 报告（首屏加"分数 + 立即行动 + TL;DR 表"），**额外**产出一份**自包含的单页 HTML 报告卡**（带 0-100 总分、OK/WARN/FAIL 计数、Top 3 行动项、关键发现卡片），用户可选生成。这是"最小投入、最大冲击力"的平衡点。

---

## 1. 现状梳理

### 1.1 目标用户群体（来自用户描述）

| 分层 | 占比（估） | 对 skill 的诉求 |
|---|---|---|
| **初学者** | 主力之一 | 需要"我该装什么、为什么、怎么装"的引导；不知道 best practice |
| **中级用户** | 主力之一 | 大致知道套路，但希望省下"自己研究"的时间；想要"现状诊断 + 一键迁移脚本" |
| **资深用户** | 少数 | 自家熟悉的语言门儿清，**但跨到另一个不那么熟的语言时也需要指引** |
| **专家级（写工具链的人）** | 极小 | 本 skill 不必为他们优化 |

**核心结论**：报告要"**首屏让初中级一眼看懂全貌**"，而不是默认读者会耐心读完七节。

### 1.2 当前报告七节结构（SKILL.md Phase 4）

```
0. 理念声明（哲学 9 条摘要）
1. 总体结论（PASS/WARN/FAIL + 3 个发现）
2. 逐语言状态表（语言|现用|推荐|状态|动作|风险）  ← 六列宽表
3. 冲突清单（症状→根因→影响）
4. 缓存外置状态（已外置/未外置/漂移）
5. 逐语言迁移方案（五步法）
6. 执行顺序建议
末尾：可重跑验证命令 | 需手工执行的变更命令
```

### 1.3 当前报告的痛点（按用户视角归纳）

| # | 痛点 | 影响人群 | 严重度 |
|---|---|---|---|
| 1 | **首屏就是"哲学宣言"**，用户要读完才能看到结论 | 初/中级 | 高 |
| 2 | **没有总分/评级**，要自己数 OK/WARN/FAIL | 全员 | 高 |
| 3 | **状态表 6 列太宽**，移动端/聊天里渲染容易溢出 | 全员 | 中 |
| 4 | **没有"立即行动 Top 3"**，要通读全文才知道先干啥 | 初/中级 | 高 |
| 5 | **大量命令行原文**，路径/版本号堆叠，缺乏视觉层级 | 初学者 | 中 |
| 6 | **jargon 没解释**：`shim`、`path_helper`、`asdf shim`、`init 残留` 等术语直接出现 | 初学者 | 高 |
| 7 | **没有分享载体** —— 没 Markdown 之外的形态，没法"晒" | 中级（社交属性） | 中 |
| 8 | **整体偏极客向**，缺少"温暖/完成感"的视觉收尾 | 初/中级 | 中 |
| 9 | 报告没有"乐观发现"区块（只报问题不报好事，影响观感） | 全员 | 低 |

---

## 2. 调研：参考工具与设计灵感

> 本节列出调研过的类似思路。**不是要抄**，是抽取"形态学"，让我们的方案站在巨人肩膀上。

### 2.1 类似工具分析（按借鉴价值排序）

| 工具 | 借鉴点 | 不借鉴的点 |
|---|---|---|
| **Lighthouse**（Web 性能审计） | 0-100 分 + 4 个分项分（性能/可访问性/最佳实践/SEO） + 颜色等级 | 报告太长，不适合我们 |
| **Geekbench**（硬件跑分） | **单个大数字** + 单项小数字 —— "晒分"友好 | 只评硬件，不分维度 |
| **GitHub Status Checks** | ✅ ⚠️ ❌ 三色 + 每条 1-2 行说明 | 太工程师风、缺美感 |
| **`brew doctor`** | 列表式输出，每条带"如何修" | 无总分、无视觉 |
| **`flutter doctor`** | 检查项 + ✅ ❌ + 发现问题给命令 | 无总分 |
| **`rustup doctor`** | **分类清晰**（工具链 / 配置 / 网络） | 无总分 |
| **`pnpm doctor`** | 有结构、有进度感 | 无总分 |
| **Codecov / shields.io** | **徽章视觉**（一个 badge 表达一切） | 信息太简 |
| **GitHub README 状态卡片**（如 `top-level-await` 兼容表） | 单元格 + 颜色，扫一眼知道全貌 | 静态、不适合动态审计 |
| **Apple Health 三环**（活动/锻炼/站立） | **3 个并列分项**视觉聚合 | 数据维度跟我们不同 |
| **Credit Karma / 信用分** | 单一大数字 + 几个分项 + "建议怎么改" | 太金融化 |

### 2.2 视觉设计参考

| 参考来源 | 启发点 |
|---|---|
| **Stripe 定价页** | 卡片分层、留白克制、配色收敛 |
| **Linear 官网** | 极简但有质感、暗黑模式审美 |
| **Vercel Dashboard** | 数字主导、辅助信息灰阶 |
| **Apple Activity Rings** | 三色环 = "三个维度同时达标"的视觉比喻 |
| **Notion 状态报告** | "完成度 N%" 形式的进度感 |
| **iStat Menus / Mac 系统报告** | 极简单页、技术人审美 |

### 2.3 关键借鉴决策

- **从 Lighthouse 借**：0-100 总分 + 颜色等级（绿/黄/红）+ 几个分项分
- **从 Geekbench 借**：单一大数字主导视觉
- **从 `flutter doctor` 借**：每项带 ✅/❌，问题旁直接给修复命令
- **从 Credit Karma 借**："立即行动 Top N"（不让用户消化整篇报告）
- **从 Apple Health 三环借**：可视化"三大维度"（稳定性 / 一致性 / 现代性）

---

## 3. 候选方案

### 方案 A：纯 Markdown 优化（最小改动）

**做法**：只改 SKILL.md 的 Phase 4 输出规范，重新定义七节顺序与首屏内容。

**首屏结构**（在原有"理念声明"之前插入）：

```markdown
# 🩺 Dev Env Health Check

> 📊 **总评：78/100 ⚠️**  ·  🟢 OK: 12  ·  🟡 WARN: 3  ·  🔴 FAIL: 1

## 🚨 立即行动（Top 3）

1. 🔴 **Python** — pyenv init 仍在 `~/.zshrc` 第 23 行生效，与 uv 抢 PATH
2. 🟡 **Node** — brew node 与 fnm 并存，需 `brew uninstall node`
3. 🟡 **缓存** — UV_PYTHON_INSTALL_DIR 外置了但 UV_CACHE_DIR 还在默认，漂移

## 🎯 一分钟看懂

| 语言 | 现用 | 推荐 | 状态 |
|---|---|---|---|
| Python | uv 0.4 | uv | ✅ |
| Node | brew + fnm | fnm + pnpm | 🔴 |
| Git | Apple 2.39 | brew git | 🟡 |
| ... | | | |

---
（下面是原有七节，照旧输出）
```

**优点**：
- 零新脚本、零新依赖
- 用户拿到 Markdown 在任何渲染器（GitHub / VSCode / 飞书 / 钉钉 / ChatGPT 聊天）都好看
- 改动只在 SKILL.md Phase 4 一节

**缺点**：
- 仍无法"晒" —— 聊天里看到分数是文本，要截图才有视觉冲击
- Markdown 在不同客户端渲染差异大（GitHub 支持 `<details>`，有些 IM 不支持）

**实施成本**：低（只改 SKILL.md 一节，约 +100 行规范）

---

### 方案 B：Markdown + HTML 单页报告卡（推荐）

**做法**：方案 A 的 Markdown 优化 **加上** 一个新脚本 `scripts/render-card.sh`（或 `render-card.py`），把 scan 数据渲染成**自包含的单页 HTML 文件**（CSS 内联、无外部依赖、可直接双击打开、也可截图发出去）。

**HTML 单页报告卡设计**（参考 Lighthouse + Geekbench + Apple Health 三环）：

```
┌─────────────────────────────────────────────┐
│  🛠️  Dev Environment Health                 │
│                                              │
│           ┌──────┐                           │
│           │  78  │   / 100                   │
│           └──────┘   ⚠️ Needs Attention     │
│                                              │
│   🟢 OK 12    🟡 WARN 3    🔴 FAIL 1         │
│                                              │
│   三环（stability / consistency / modern）   │
│      ◯          ◐           ◯                │
│                                              │
│  Top 3 Actions                               │
│  1. 🔴 Python — 移除 pyenv init ...         │
│  2. 🟡 Node   — 卸载 brew node ...          │
│  3. 🟡 Cache  — 补齐外置变量 ...            │
│                                              │
│  Languages                                   │
│  Python ✅   Node 🔴   Git 🟡   ...         │
│                                              │
│  📅 2026-07-18  ·  macOS ·  zsh              │
└─────────────────────────────────────────────┘
```

**视觉锚点**：
1. **一个大数字**（总分）—— 借鉴 Geekbench / Credit Karma
2. **三色计数条** —— 一眼看出整体态势
3. **三个小圆环** —— 三大维度的子分，借鉴 Apple Health
4. **Top 3 行动卡** —— 不让用户读完才动手
5. **语言状态网格** —— 单字母/单词 + emoji，扫一眼可读

**HTML 自包含要点**：
- 全部 CSS 内联在 `<style>` 块
- 无外链字体（用 `system-ui` / `-apple-system` 栈）
- 无 JS（纯展示）
- 单文件 ~5-10 KB
- 双击即可在浏览器打开
- 可截图、可打印（`@media print` 友好）

**优点**：
- Markdown 仍然给深度读者
- HTML 单页让中级用户"眼前一亮 + 想晒"
- 自包含、无依赖、可离线
- 实施成本仍可控（一个 shell 脚本 + 一段 HTML 模板字符串）

**缺点**：
- 多一个文件 / 多一个脚本要维护
- 不同浏览器渲染有微差（但都用 web 标准语法，问题不大）
- shell 拼 HTML 字符串很丑（**强烈建议用 Python** 而非纯 shell）

**实施成本**：中（新增 `scripts/render-card.py` 一个文件 + SKILL.md Phase 4 加 HTML 输出指令 + 一个 HTML 模板字符串 ≈ +250 行）

---

### 方案 C：完整重做（带 SVG 渲染 + 终端彩色输出 + 多语言）

**做法**：方案 B 的全部 + 终端实时彩色输出 + SVG 卡片 + Markdown/HTML/JSON 三格式输出 + 多语言。

**优点**：最终形态完美

**缺点**：违反"最小投入、最大效果"原则；过度工程化；维护成本高

**结论**：**不推荐**。除非 skill 用户量爆炸、需要品牌化输出，否则 C 是 over-engineering。

---

## 4. 评分体系设计（仅在选定方案 B/C 时落地）

### 4.1 总分（0-100）

```
总分 = 100
  - 每条 FAIL     -15
  - 每条 WARN     -5
  - 每条 INFO     -0
  - 缓存漂移检出  -10（"漂移是最危险状态"，见 SKILL.md §1-5）
  - PATH 三场景不一致 -8
  - Apple git（系统冻结版）无 brew 接管 -3
下限：0
```

**等级**：
- **90-100 🟢 Excellent** —— "可直接对外分享"
- **75-89 🟢 Good** —— "日常够用，建议处理 WARN"
- **60-74 🟡 Needs Attention** —— "有几处明显短板"
- **40-59 🟠 At Risk** —— "会偶发踩坑"
- **0-39 🔴 Critical** —— "强烈建议立即处理"

### 4.2 三个分项分（仅方案 B/C，借鉴 Apple Health 三环）

| 维度 | 含义 | 扣分项 |
|---|---|---|
| **Stability（稳定性）** | 没有 FAIL 级问题 | 每个 FAIL -20 |
| **Consistency（一致性）** | PATH 三场景一致 + 缓存无漂移 | PATH 不一致 -15 / 缓存漂移 -15 |
| **Modernity（现代性）** | 用了 per-language 权威工具 | 每个非权威管理器 -8 |

三环各自 0-100 分，环上颜色按分值分段。

### 4.3 取舍说明

- 不做"加权"或"机器学习打分"——简单可解释最重要
- FAIL 权重高于 WARN（FAIL 影响功能，WARN 只是建议）
- 漂移扣分要狠（SKILL.md 哲学第 5 条明文"漂移是最危险状态"）

---

## 5. 方案对比与推荐

| 维度 | 方案 A | **方案 B（推荐）** | 方案 C |
|---|---|---|---|
| 首屏清晰度 | ✅ 显著提升 | ✅ 显著提升 | ✅✅ 极致 |
| 分享价值 | ❌ 仍只能文字 | ✅ 单页 HTML 可晒 | ✅ 多格式 |
| 实施成本 | 低 | 中 | 高 |
| 维护成本 | 低 | 中 | 高 |
| 对哲学的尊重 | ✅ 不动判定逻辑 | ✅ 不动判定逻辑 | ⚠️ 可能越界 |
| 跨客户端一致性 | ⚠️ 取决于渲染器 | ✅ HTML 浏览器统一 | ✅ |
| 用户惊喜度 | 😐 | 😊 | 🤩 |
| 与"投入产出比"原则的契合 | ✅ | ✅✅ | ❌ over-engineering |

### 推荐：方案 B

**核心理由**：
1. **首屏改造（方案 A 部分）解决"读不懂"**——这是基础盘
2. **HTML 单页（方案 B 增量）解决"想晒"**——这是拉开差距的部分
3. **不需要方案 C 的复杂度**——一个 Python 脚本 + 一段 HTML 模板就够
4. **完全不动判定逻辑**——符合 skill 的"只探测、只分析"哲学
5. **可选生成**——用户不愿意要 HTML 就只要 Markdown，零负担

---

## 6. 方案 B 实施细节（仅供确认后落地参考，本阶段不实施）

### 6.1 实施产物清单（若用户确认）

| 路径 | 类型 | 内容 |
|---|---|---|
| `SKILL.md` Phase 4 | 改写 | 新增"首屏三件套"（分数 + 立即行动 + TL;DR 表）规范 |
| `scripts/render-card.py` | 新增 | 读 scan/probe 输出 → 渲染单页 HTML |
| `references/_card-template.html` | 新增 | HTML 模板字符串（含内联 CSS） |
| `references/_card-template.html` 配套文档 | 新增 | 模板变量说明、可定制点（颜色 / 字体 / logo） |

### 6.2 HTML 模板关键设计点

1. **配色**：浅色 / 深色自动跟随 `prefers-color-scheme`
2. **字体**：`system-ui, -apple-system, "SF Pro Display", sans-serif`（macOS 原生体验）
3. **打印**：`@media print` 把背景色变浅、去掉 emoji、省略页脚
4. **可访问性**：分数配 `aria-label="Overall score 78 out of 100"`、颜色不单独承载信息（同时配 emoji / 文字）
5. **响应式**：移动端单列、桌面端网格
6. **水印**：底部小字 "Generated by dev-env-audit · <日期>" 标识来源

### 6.3 风险与权衡

| 风险 | 缓解 |
|---|---|
| HTML 在不同浏览器渲染差异 | 只用 web 标准语法，QA 过 Chrome / Safari / Firefox 三家 |
| 用户不知道有 HTML 产物 | SKILL.md 加显著说明："可选生成" |
| shell 拼 HTML 易错 | 用 Python 不用 shell |
| 模板与 scan 输出字段耦合 | 模板变量名集中管理，加注释 |

---

## 7. 待用户拍板的开放问题

1. **方案选择**：A / B / C / 暂缓？
2. **若选 B**：HTML 是"可选生成"还是"默认生成"？我倾向**可选**（不想让用户多一个文件）。
3. **评分阈值**：4.1 节的扣分权重是否合理？需不需要更宽松/严格？
4. **三环是否必要**：方案 B 的"三环"是 nice-to-have，没有也能用。要不要砍掉以减小模板体积？
5. **是否需要"乐观发现"区块**：当前报告只说问题。要不要加一节"✅ 已正确配置"？我倾向**加**（提升完成感，符合"激励分享"目标）。

---

## 8. 参考资料

- 内部资料：`SKILL.md`（Phase 4 报告规范）、`scripts/*.sh`（数据来源）、`references/*.md`（判定标准）
- 外部参考（仅设计灵感）：
  - [Lighthouse Scoring Guide](https://developer.chrome.com/docs/lighthouse/performance/performance-scoring) —— 0-100 评分体系
  - [Geekbench Result Browser](https://browser.geekbench.com/) —— 单数字主导视觉
  - [Apple Activity Rings](https://support.apple.com/en-us/108788) —— 多维分项可视化
  - [Credit Karma Dashboard](https://www.creditkarma.com/) —— 大数字 + Top N 行动
  - [shields.io](https://shields.io/) —— 状态徽章语言
  - `flutter doctor` / `rustup doctor` / `pnpm doctor` —— 同类 doctor 工具对照

---

---

## 9. 实施后视觉评审修订（2026-07-19，Claude Sonnet 5）

方案 B 已按本文档落地（`SKILL.md` Phase 4、`scripts/render-card.py`、`render-card.template.html`、`render-card.schema.md`）。实际跑出 HTML 之后用户反馈"简陋土气 + 页面偏大"，用 headless Chrome 截图核实后确认问题真实存在，做了以下调整：

### 9.1 保留的部分（评审确认做对了）

- **JSON 中间层架构**（agent 写结构化数据 → 渲染器消费）——判定逻辑与展示彻底解耦，未改动。
- **`positive_findings` 强制至少 1 条**——解决"报告只报坏消息"的观感问题，核心洞察未变。
- **`validate()` 校验 + stderr 警告**——工程习惯保留。
- **评分规则本身**（§4 的扣分权重）——未改动，问题出在展示层，不在判定层。

### 9.2 视觉方向的调整

实测发现三个问题：① 大量彩色 emoji（🛠️🟢🔴✅）跨平台字体渲染不一致，且和"Apple Health 风格浅灰圆角卡片"这套消费级视觉语言拼在一起显得廉价；② 5 个卡片纵向堆叠、三个 SVG 大圆环占地方但信息密度低，导致页面偏长，不满足"截图一屏装下"的诉求；③ 整体视觉语言更像消费级健康 App，不像面向开发者的审计工具（对照 SSL Labs / PageSpeed / neofetch / Linear / Vercel，这些同类对标都不靠彩色 emoji 做状态指示）。

调整为**终端窗口风格**：
- 单一深色"终端卡片"（等宽字体、窗口装饰点、顶部渐变强调线），不再是多个圆角卡片纵向堆叠。
- 大号字母等级（A/B/C/D/F，从已有的 `tier` 派生，`render-card.py` 里加 `GRADE_MAP`，**不需要改 JSON schema**）替代"总分卡片"单独占一整块。
- 三维度分从 3 个大 SVG 圆环压缩成 3 条紧凑横向进度条（`render_metric()` 替换 `render_ring()`）。
- Top Actions / Highlights（乐观发现）改双栏并排，而不是各占一整块纵向空间。
- 所有状态指示（语言状态、行动项、发现项）统一用 CSS 画的圆点（`.dot-ok/.dot-warn/.dot-fail/.dot-info`），不再用彩色 emoji 字符，跨平台渲染一致。
- 外层"桌面背景"跟随系统深浅色（浅色/深色渐变），终端卡片本身固定深色——品牌感统一，不会因为系统是浅色模式就整页变白、丢失"终端"识别度。

结果：实测同样数据量下，页面高度从约 1350px（900px 宽视口）压到约 620-660px，同一屏截图可以装下全部内容；`SKILL.md` §4.2/§4.4 中描述"三环"的文字已同步更新为"三条紧凑横向进度条"。

### 9.3 未变的部分

- 本地文件优先、无外部依赖、自包含单 HTML 文件——未变。
- 是否接入 Claude Code Artifact 做"可发链接"的增强层——仍未实现，维持"本地文件为主"的保底策略，等用户后续需要再加。

---

## 10. 去 Python 化 + 三套模板 + 自动化产出流程（2026-07-19，Claude Sonnet 5）

用户提出一个更彻底的思路：与其让 Python 脚本做字符串模板替换，不如把 HTML+CSS+JS 一次性写死成静态模板，模板里只留一个 JSON 数据占位符；生成报告时只需要把 agent 已经要产出的 JSON 原样"贴"进那个占位符，拼出最终的自包含 HTML——从而彻底不需要 Python，也不需要模型重新生成任何 HTML 结构。

### 10.1 验证过程

先用手工替换验证可行性：把示例 JSON 手动填进模板占位符，跟"脚本生成"的版本逐字节 diff，**完全一致**。又做了一次刻意的安全测试——塞入 `<script>alert(1)</script>`、`<img onerror=alert(1)>` 这类内容，因为渲染逻辑全程用 `element.textContent` 建 DOM（不是拼 innerHTML 字符串），浏览器结构性地把这些内容当纯文本显示，没有弹窗、没有破版，比 Python 版手动调用 `html.escape()` 更不容易出错（不存在"忘记转义"这种失误模式）。

再进一步：把"贴数据"这一步也做成纯 `sed`+`awk` 脚本（`render-card.sh`），不需要模型手工搬运 JSON、也不需要 Python：

```bash
sed 's#</#<\/#g' summary.json > escaped.json   # 唯一需要注意的机械规则：转义 "</" 防止提前截断 <script> 标签
awk -v datafile=escaped.json '/%%AUDIT_JSON_DATA%%/ { while ((getline line < datafile) > 0) print line; next } { print }' template.html > report.html
```

跟模板对比同样**逐字节一致**。这条流水线是 zsh 自带工具，跟 `scan.sh`/`probe-*.sh` 是同一套家伙事，不引入任何新依赖。

### 10.2 最终决定：删除 Python，采用模板+JS+shell 合并

- 删除 `render-card.py`、`render-card.template.html`（python `string.Template` 版本）。
- 新增 `scripts/render-card.sh`：纯 zsh + sed + awk 的合并脚本，处理转义 + 占位符替换 + 模板选择（随机或按名指定）+ 合并结果的完整性校验（占位符必须被替换掉，否则报错）。
- 新增三套自包含模板（同一套 JSON schema、同一套 JS 渲染逻辑，只有 `<style>` 不同）：
  - `render-card.terminal.html` —— 深色终端窗口风格（原方案的延续）
  - `render-card.paper.html` —— 浅色编辑/证书风格：衬线数字、双圈"印章"式等级徽章、暖白底墨色调色板
  - `render-card.brutalist.html` —— 新粗野主义风格：粗黑边框、硬阴影（无模糊）、高饱和色块、加粗大写字体
- 三套模板的 DOM 结构和 CSS class 名完全一致（JS 逻辑逐字节相同，只是各自套了不同的 `<style>`），这样以后要调整渲染行为，三份文件改法完全一样，不会出现"三套逻辑各自维护、逐渐分叉"的问题——代价是三个文件之间有 CSS/HTML 骨架的重复，但这是"每个文件必须自包含、零外部依赖"这条硬要求的必然代价，可接受。

### 10.3 配套的流程变化

- **模板选择**：用户发起审计时点名三选一（`terminal`/`paper`/`brutalist`）就按名字传给 `render-card.sh`；没点名就不传，脚本自己用 `$RANDOM` 随机选——不为了选风格去问用户。
- **HTML 从"可选产物"变成"默认产物"**：不再需要用户额外要求，Phase 4 每次都会生成。
- **新增"打开 Markdown 报告"链接**：JSON schema 加一个可选字段 `report_md`（相对文件名），三套模板的 JS 渲染器统一支持——提供了就在卡片上显示一个醒目的"Full details in the Markdown report →"链接。为了让这个相对链接点得开，Markdown 报告不再只输出到对话窗口，Phase 4 现在**同时**把它落盘到 `~/Desktop/dev-env-audit/dev-env-audit-report-<timestamp>.md`，跟同名的 `.html` 放在同一目录。
- **报告默认语言改成英文**：Markdown 报告正文和 JSON 里所有自然语言字段（`title`/`detail` 等）默认用英文撰写，不再跟随对话语言；用户明确要求中文才切换。三套 HTML 模板的固定标签（"Top Actions"/"Stability" 等）只有英文版，不随报告语言切换——它们是外壳，不是内容。
- **全程不中途提问**：模板选择、报告语言、探针脚本里原本"外置盘未挂载要不要问用户"的分支，全部改成"没有明确指定就按默认值自动决定，任何不确定性写进报告"，不再打断执行去问用户。

### 10.4 保留 / 未变的部分

- JSON schema 的核心字段（`score`/`tier`/`counts`/`languages`/`top_actions`/`positive_findings` 等）完全不变，只新增了一个可选字段 `report_md`。
- 评分规则（§4.2 的扣分权重）完全不变。
- "设计哲学 9 条"、判定逻辑、references 里的迁移方案——都不受这轮改动影响，改动始终只在输出/呈现层。

---

**文档结束。方案已完整落地：Markdown 报告（默认英文，同时落盘）+ 三选一 HTML 报告卡（默认自动生成，纯 shell 合成，无 Python）。后续如需迭代渲染逻辑，三套模板文件要同步改（JS 部分逐字节相同），本文档同步补充变更记录即可。**