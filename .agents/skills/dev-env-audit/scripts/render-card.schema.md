<!-- Ver 2026-07-19 03:00, by Claude Sonnet 5 -->

# JSON Summary Schema (dev-env-audit)

The agent writes a JSON file during Phase 4 to `/tmp/dev-env-audit-summary.json`.
`scripts/render-card.sh` merges this file into one of three self-contained HTML
templates (`render-card.terminal.html` / `render-card.paper.html` / `render-card.brutalist.html`)
to produce the standalone HTML report card. There is no Python in this path —
the merge is a mechanical `sed`+`awk` text substitution (see `render-card.sh`),
and all rendering (grade letter, colors, DOM layout) happens in plain JS
embedded in the template itself, which runs when the file is opened in a browser.

**This file is the agent's contract**: produce JSON that matches this schema exactly,
or the card won't render correctly. The skill's overall philosophy (read-only /
per-language authoritative tools / respect existing setups) doesn't change because
of this layer — the JSON is just the same analysis you already did, written out
as structured data. Zero new facts, zero new judgment calls.

**Language**: report content (titles, details, language names) should default to
**English** — this is the default output language for the whole audit report,
not just this JSON. Only write Chinese here if the user explicitly asked for a
Chinese-language report. The HTML templates' own labels ("Top Actions",
"Stability", "Languages", etc.) are English-only in all three themes regardless —
they're fixed chrome, not user-facing prose, so there's no Chinese variant of the
templates themselves.

---

## Choosing a template

Three templates exist, named `terminal` / `paper` / `brutalist` — same information,
same quality bar, deliberately different visual genres (dark terminal-window card /
light editorial-certificate card / bold neo-brutalist card). Pick one:

- If the user named one of the three by name when they asked for the audit
  (e.g. "use the paper template"), pass that name as `render-card.sh`'s 3rd argument.
- Otherwise, omit the argument — `render-card.sh` picks one uniformly at random
  via `$RANDOM`. **Do not ask the user which one they want.** This skill never
  pauses mid-run for style preferences; if there's ever genuine uncertainty about
  something, it goes into the report as a note, not into a question back to the user.

```bash
zsh scripts/render-card.sh /tmp/dev-env-audit-summary.json <output.html> [terminal|paper|brutalist]
```

---

## 顶层字段

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `timestamp` | string | ✅ | ISO 8601，例如 `"2026-07-18T21:30:00+08:00"` |
| `host` | object | ✅ | `{os: string, shell: string}`，例如 `{"os": "macOS 14.5", "shell": "/bin/zsh"}` |
| `score` | int | ✅ | 0-100 总分（按 SKILL.md §4.2 规则算） |
| `tier` | string | ✅ | 见下方"tier 映射"；HTML 卡片据此派生大号字母等级(A-F)，不需要单独提供字母字段 |
| `tier_label` | string | ✅ | 人类可读标签，英文（模板里直接渲染），例如 `"Needs Attention"` |
| `tier_emoji` | string | ✅ | `"🟢"` / `"🟡"` / `"🟠"` / `"🔴"`（当前渲染器不使用，保留供未来/其他消费者用） |
| `counts` | object | ✅ | `{ok: int, warn: int, fail: int}`，跨所有语言的合计 |
| `scores` | object | ✅ | `{stability: int, consistency: int, modernity: int}`，每个 0-100，渲染为三条紧凑进度条 |
| `languages` | array | ✅ | 见 Languages 段 |
| `top_actions` | array | ✅ | 见 Top Actions 段（最多 3 条） |
| `positive_findings` | array | ✅ | 见 Positive Findings 段（至少 1 条） |
| `report_md` | string | ❌ | 见 Report Link 段；提供后 HTML 卡片会显示一个"打开 Markdown 报告"的链接 |
| `conflicts` | array | ❌ | 见 Conflicts 段（可选；agent 已写进 Markdown 报告的，这里可省） |
| `cache_status` | array | ❌ | 见 Cache Status 段（可选；预留扩展） |

---

## Languages

每项：

```json
{
  "name": "Python",
  "current": "uv 0.4.18 (official)",
  "recommended": "uv",
  "status": "ok"
}
```

`status` ∈ `"ok"` / `"warn"` / `"fail"` / `"info"`。渲染时对应 CSS 圆点颜色（不是 emoji）：
- `ok` → 绿色圆点
- `warn` → 黄/琥珀色圆点
- `fail` → 红色圆点
- `info` → 灰色圆点（例如"系统默认未治理"）

**只列本机实际存在的语言**（scan.sh 命中的）。TL;DR 表里每条对应一行。
Java/Swift 这种"装了 Xcode 通常就有"的语言，按 scan.sh 命中后再问用户是否深挖（详见 SKILL.md references 表）。

---

## Top Actions

每项：

```json
{
  "severity": "fail",
  "title": "Python — remove leftover pyenv init",
  "detail": "~/.zshrc line 23 still runs `eval \"$(pyenv init -)\"`, which shadows uv on PATH"
}
```

`severity` ∈ `"fail"` / `"warn"`（没有 `"ok"`——正确的配置进 `positive_findings`）。

**最多 3 条**，按严重度排序（fail 优先于 warn）。超出的渲染器只取前 3。

---

## Positive Findings（乐观发现）

每项：

```json
{
  "title": "Python already on uv",
  "detail": "PATH is unique, no pyenv/conda leftovers; pip3 also resolves into uv's managed path"
}
```

**至少 1 条**——这是方案设计的关键：报告不能全是问题，必须有"做对了什么"让初中级用户获得完成感，也让晒出去的报告不显负能量。3-5 条是甜蜜点。

**写不出正面发现怎么办**：每台机器至少有一项 OK（如 Git 解析正常、Python 有 uv、缓存至少没漂移）。如果实在找不到（极端情况），写一条兜底如 `"Audit completed"`——但请认真找，**不要轻易退到这一步**。

---

## Report Link（可选，强烈建议提供）

```json
{
  "report_md": "dev-env-audit-report-20260719-2130.md"
}
```

一个**相对路径**（通常就是不带目录的文件名），指向 Phase 4 同时写到磁盘的 Markdown 报告文件。
`render-card.sh` 产出的 HTML 和这份 Markdown 报告**必须写在同一个目录**（例如都放在
`~/Desktop/dev-env-audit/` 下），这样相对链接不需要处理路径拼接就能点开。

提供了这个字段，卡片就会显示一个醒目的"Full details in the Markdown report →"链接/按钮；
不提供就不显示（比如你只是拿示例数据测渲染效果，没有对应的 md 文件）。

---

## Conflicts（可选）

每项：

```json
{
  "symptom": "pyenv init code still present in ~/.zshrc",
  "root_cause": "pyenv shim directory wins the PATH race",
  "impact": "python3 resolution drifts away from uv"
}
```

如果提供了，渲染器将来扩展时可在卡片里加一节；当前版本不展示。

---

## Cache Status（可选）

每项：

```json
{
  "item": "uv cache dir",
  "state": "external"
}
```

`state` ∈ `"external"` / `"local"` / `"drift"` / `"unmounted"`。当前渲染器不展示，预留扩展。

---

## tier 映射（与 SKILL.md §4.2 完全一致）

| 分数 | tier | tier_label | tier_emoji | 卡片大号字母 |
|---|---|---|---|---|
| 90-100 | `excellent` | `Excellent` | 🟢 | A |
| 75-89 | `good` | `Good` | 🟢 | B |
| 60-74 | `needs-attention` | `Needs Attention` | 🟡 | C |
| 40-59 | `at-risk` | `At Risk` | 🟠 | D |
| 0-39 | `critical` | `Critical` | 🔴 | F |

大号字母由模板内嵌 JS 从 `tier` 派生（`GRADE_MAP`），不需要 agent 额外提供字母字段。

---

## 三维度分公式（与 SKILL.md §4.2 完全一致）

- `scores.stability` = `max(0, 100 - 20 × fail_count)`
- `scores.consistency` = `max(0, 100 - 15 × path_drift_count - 15 × cache_drift_count)`
- `scores.modernity` = `max(0, 100 - 8 × non_authoritative_manager_count)`

`path_drift_count` = probe-path.sh 报告的不一致命令数（同一命令在 A/B/C 三场景解析到不同路径）。
`cache_drift_count` = probe-cache.sh 报告中归类为"drift"的项数（部分外置部分默认）。
`non_authoritative_manager_count` = 用了非基线推荐的管理器的语言数（如 Python 不用 uv 而用 conda、Node 不用 fnm 而用 nvm 等，按 references §3 判定）。

---

## 最小可工作示例

```json
{
  "timestamp": "2026-07-19T21:30:00+08:00",
  "host": {"os": "macOS 14.5", "shell": "/bin/zsh"},
  "score": 78,
  "tier": "good",
  "tier_label": "Good",
  "tier_emoji": "🟢",
  "counts": {"ok": 12, "warn": 3, "fail": 1},
  "scores": {"stability": 80, "consistency": 75, "modernity": 85},
  "languages": [
    {"name": "Python", "current": "uv 0.4.18 (official)", "recommended": "uv", "status": "ok"},
    {"name": "Node",   "current": "brew 20.x + fnm 1.x",  "recommended": "fnm + pnpm", "status": "fail"},
    {"name": "Git",    "current": "Apple 2.39 (system)",  "recommended": "brew git",   "status": "warn"},
    {"name": "Rust",   "current": "rustup 1.27",          "recommended": "rustup",     "status": "ok"}
  ],
  "top_actions": [
    {"severity": "fail", "title": "Node — uninstall brew node", "detail": "brew node and fnm both fight for PATH; run brew uninstall node"},
    {"severity": "warn", "title": "Git — install brew git", "detail": "Apple git is frozen at 2.39.x; PATH override needs an entry in both ~/.zshrc and ~/.zprofile"},
    {"severity": "warn", "title": "Cache — finish relocating", "detail": "UV_PYTHON_INSTALL_DIR is set but UV_CACHE_DIR isn't — half-relocated (drift)"}
  ],
  "positive_findings": [
    {"title": "Python already on uv", "detail": "PATH is unique, no leftovers; resolves correctly even in non-interactive shells"},
    {"title": "Rust already on rustup", "detail": "Single rustc/cargo install, CARGO_HOME already relocated"},
    {"title": "PATH consistent across scenarios", "detail": "git/node/python resolve identically across all three shell scenarios, no path_helper override"}
  ],
  "report_md": "dev-env-audit-report-20260719-2130.md",
  "conflicts": [
    {"symptom": "brew node coexists with fnm", "root_cause": "brew node installs to /opt/homebrew/bin/node, which is always on PATH", "impact": "node may resolve to the brew copy instead of fnm's"}
  ],
  "cache_status": [
    {"item": "uv python dir", "state": "external"},
    {"item": "uv cache dir", "state": "local"},
    {"item": "fnm dir", "state": "external"}
  ]
}
```

---

## 渲染器行为约定（写 JSON 时可以预设）

- `top_actions` 超 3 条 → 渲染器只取前 3，**不报错**
- `languages` 为空 → 显示一行 `"—"`
- `positive_findings` / `top_actions` 为空 → 渲染器仍渲染一行 `"None"`，**但 agent 应主动避免此情况**（这是设计本意）
- 缺字段 → JS 用 `|| {}` / `|| []` 兜底，不崩溃；`report_md` 缺失时链接整块不渲染
- `score` 超出 [0,100] 或非数字 → 渲染器 clamp 到边界（`clampScore()`）
- JSON 本身格式错误（agent 写坏了）→ 打开页面会看到一个明确的错误提示框，而不是空白页或崩溃
- 三个模板共享完全相同的 JS 渲染逻辑和 DOM class 名，只有 `<style>` 不同——以后如果要调整渲染行为，三个文件要同步改
