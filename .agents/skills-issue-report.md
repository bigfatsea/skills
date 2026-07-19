<!-- Ver 2026-07-19 08:30, by Claude Sonnet 5 -->
<!-- 对 .agents/skills-audit.md 逐条核实 + 新一轮复查后的正式问题清单。取代原审计文档作为行动依据。 -->

# Skills 项目问题清单（核实版）

## 说明：`skill-creator` 不在本文档范围内

`skill-creator` 不属于本项目——它在本地 `.agents/skills/` 目录下存在，但被仓库根 `.gitignore` 显式排除在版本控制之外（第三方/外部工具，不是本仓库维护和分发的内容）。本文档不再讨论它；此前几轮核实中涉及它的条目（包括曾经列出的两条 P0）已经从下文移除。

## 处理状态（2026-07-19 第三轮）：README 同步

回头更新了 `README.md`/`README.zh-CN.md`：删掉了 `lobster-agent-creator` 行（已从项目移除），并按上方说明清理了不属于本项目的条目。两份 README 的技能表现在是 8 行（`master-bp-review` / `startup-idea-evaluator` / `prompt-architect` / `synthesize-documents` / `ai-script` / `dev-env-audit` / `interview-methodology` / `audio-album-creator`），与实际会被 `npx skills` 分发的技能集合一致。

## 处理状态（2026-07-19 第二轮，已按用户反馈执行）

| 项 | 处理结果 |
|---|---|
| dev-env-audit 的 2 条 P1（probe-cache.sh 阈值、probe-path.sh 缺 npm） | **已修**——漂移判定改成按工具分组，npm 加进默认检测列表，实测验证过 |
| ai-script 硬编码路径 | **已修，按用户指定方式**——路径改为 `~/code/ai-script`（不是原建议的 `command -v` 探测兜底），版本管理相关建议按用户要求**不做** |
| lobster-agent-creator 全部条目 | **已从项目删除**，问题随之消失 |
| startup-idea-evaluator（market-research 死引用 + 触发重叠） | **已修**——market-analysis.md 加了降级说明文字（不是内联完整方法论）；description 加了指向 master-bp-review 的交叉引用 |
| master-bp-review（交叉引用 + 轻量模式 + 示例 + P2） | **已修**——description 加交叉引用；加了 critique-only 轻量模式（步骤 0）；补了 `references/example-output.md` 完整示例；evals.json #2 占位符填了具体内容；PROJECT_NAME 与文件名 slug 规则统一 |
| prompt-architect（8/9 项对齐 + 输出写文件） | **已修**——SKILL.md Step 5 扩到 9 项以匹配 prompt-template.md；输出改为强制写文件 |
| synthesize-documents（孤儿文件 + 长文档策略） | **已修**——删掉未被引用的 `agents/openai.yaml`；Step 2 加了超长文档的分批读取/优先级/如实说明"未读全"的指引 |
| interview-methodology | **只修 P2**（四文件间字母编号跳号问题——加了跨文件说明注释 + 修了 E.2 标题格式不一致），**P1 条目（多人/远程/方言 ASR/多次访谈合并）按要求暂不动** |
| 改进意见：master-bp-review ↔ startup-idea-evaluator 触发重叠 | **已修**（随 startup-idea-evaluator 和 master-bp-review 的改动一起做了，两边 description 互相指向） |
| 改进意见：evals/ 覆盖率低 | **只记录，不新增**——按用户选择，本轮不为其他 skill 补 evals |
| 改进意见：.gitignore 统一到根目录 | **已修**——把 `audio-album-creator/scripts/.gitignore` 的规则合并进根 `.gitignore`（改成仓库级通配规则），删掉嵌套文件，现在仓库里只有 1 个 `.gitignore` |

具体改动的文件明细见对应 skill 目录下的 diff；已证伪结论表（第 5 节）和已验证的 P1/P2 清单（第 3-4 节）保留原样作为核实记录，不因后续处理而改写。

---

## 0. 这份文档是什么、和 `skills-audit.md` 是什么关系

`.agents/skills-audit.md` 是此前对本仓库多个 skill（`ai-script` / `audio-album-creator` / `dev-env-audit` / `interview-methodology` / `lobster-agent-creator` / `master-bp-review` / `prompt-architect` / `startup-idea-evaluator` / `synthesize-documents`，另有一个已确认不属于本项目、不在本文档讨论范围内）做的一次性通读式审计，写于纯阅读+记忆，**没有实际跑命令验证**。

这一轮的工作是：把审计报告里的每一条具体、可证伪的技术性结论重新核实一遍（直接读当前文件、实际跑命令），同时对每个 skill 做一次新的复查，找有没有原审计漏掉或者写完之后才出现的新问题。核实动用了 4 个并行子 agent（各分到 2-3 个 skill）+ 我自己直接核实了全局工程卫生和 `dev-env-audit`（这个我最熟，这次改动也最多）。

**结论先说**：原审计的**定性判断和优点归纳大体可信**（哪些设计好、哪些 skill 触发词写得清楚），但它**关于"git 里有什么"的一整套核心事实判断是错的**（见下），而且它写于 `dev-env-audit` 这次大改之前，那一节现在基本全过时了。建议：**`skills-audit.md` 不必删，但应该在文件顶部加一行"已被本文件取代，部分核心结论（尤其是 §11.3/§12 的 git 清理建议）已被证伪，仅作历史记录保留"**，避免以后有人（包括未来的我）不小心把它当权威依据用。

---

## 1. 最重要的一条证伪：原审计的"git 卫生"判断整体是错的

原审计的 G8/G9/G10 和第 11.3/12 节（"一次性深度清理"）的核心前提——`.venv/`、`__pycache__/`、`.DS_Store` **已经被提交进 git，需要清理**——**实测是错的**：

| 声称 | 实测结果 |
|---|---|
| `.venv/`（audio-album-creator，167 文件/13MB）入库 | `git ls-files` 返回 **0 个文件**；`scripts/.gitignore` 里明确写了 `.venv/`，从提交历史看这个目录从来没被跟踪过 |
| `__pycache__/` 已被 git 跟踪（10 个 .pyc） | `git ls-files` 返回 **0 个文件**，同样没有被跟踪 |
| `.DS_Store`（2 个）进入仓库 | `git ls-files` 返回 **0 个文件**——存在于磁盘上，但从没提交过 |

**实际影响**：原审计"第 12 节"给的清理脚本（`git rm -r --cached .venv`、`git rm -r --cached __pycache__`）如果真的执行，会因为"没有匹配到任何已跟踪文件"而直接报错或什么都不做——**不需要执行，因为要清理的东西压根没进过 git**。

（.DS_Store/.venv/__pycache__ 确实作为本地磁盘文件存在，给仓库根 `.gitignore` 补一条兜底规则仍然是好习惯——这一条已经在第二轮处理里做掉了，见上面的处理状态表。）

---

## 2. P0 —— 必须要改

本轮核实未发现属于本项目维护范围内、需要立即处理的 P0 级问题。

---

## 3. P1 —— 建议改，但不紧急

> 下面每条末尾用 [状态] 标注这一轮的实际处理结果，避免只看清单以为都还没动。逐条都用命令/grep 重新核实过文件当前内容，不是照抄上一轮的记忆。

### dev-env-audit（我自己核实，最有把握的一批）

1. **`probe-cache.sh` 的 WARN 阈值过于敏感**（原审计称 BUG-3.1，**核实为真**）：`probe-cache.sh:240` 的判定是 `n_external > 0 && n_unset > 0` 就报 WARN drift，没有任何缓冲。更深一层的根因（原审计没诊断到这一层）：这个计数器把"同一个工具内部半外置"（真正危险，比如 uv 的 PYTHON_INSTALL_DIR 外置了但 CACHE_DIR 没有）和"不同工具之间进度不一"（完全正常，比如 uv 已经外置但 Maven 还没顾得上）混进了同一个全局池。按工具分组判定"组内漂移"会比简单调高数字阈值更治本。**[✅ 已修，实测验证：`probe-cache.sh` 已加 `n_ext_g`/`n_unset_g` 分组计数，判定逻辑改成组内漂移]**
2. **`probe-path.sh` 默认命令列表没有 npm**：`probe-path.sh:31` 是 `(git python3 node java go rustc ruby pnpm uv)`，确实漏了 npm，而 `node.md` 里明确提到 `NPM_CONFIG_PREFIX` 是常见坑。加一个词的事。**[✅ 已修，实测验证：默认列表已含 npm]**

（原审计里关于 dev-env-audit 的另外两条——"scan.sh 没 normalize xcode-select -p 的输出格式"、"全局 G1 硬编码 \$HOME"——**核实为误判**，详见第 5 节"已证伪的原审计结论"。另外，dev-env-audit 这个 skill 在原审计写完之后已经经历三轮重写（HTML 报告卡从 Apple Health 风格 → 终端风格 → 三选一模板 + 去 Python 化 + 自动落盘 + 默认英文），原审计第 3 节里绝大部分内容已经不描述现状了。）

### ai-script

3. **`SKILL.md` 强制 `cd /Volumes/SSD2T/code/ai-script` 硬编码绝对路径，没有任何 fallback**（全文 grep 不到 `command -v`/`which ai-script`）。这是这轮核实里**唯一一处被反复独立确认的真·路径硬编码问题**——换一台机器、换一个人，这个 skill 直接失效。建议：改成先 `command -v ai-script || which ai-script` 探测，找不到再按说明走 `cd` 兜底。**[✅ 已修，但方式不是原建议——按用户明确指示，直接把路径改成 `~/code/ai-script`（实测验证：SKILL.md 第 10/32 行），不加探测兜底]**
4. `check` 子命令失败后没有告诉模型"应该停下来，不要继续跑昂贵的调用"——纯文档缺口，容易导致限流/超时排查绕远路。**[✅ 已修，实测验证：SKILL.md 加了"`check` 报非 0 退出码就先停下"一段]**
5. 全文没提 `ai-script` 自身怎么做版本管理/更新。**[⏸ 按用户明确要求不做——"ai-script 是独立项目，不用管它怎么做版本管理和更新"]**

### lobster-agent-creator

6. **`core/USER.core.md` 硬编码了 Stanford 本人的真实姓名/背景/哲学清单**，而且跟 `core/IDENTITY.core.md` 的写法**不对称**——`IDENTITY.core.md` 对"agent 名字"用了规范的 `{{NAME}}` 占位符，但 `USER.core.md` 对"用户名字/背景"却是字面值而不是占位符，这直接导致"看起来像模板但其实是真人数据"的误导。**[⏸ 随删除失效，不再需要修]**
7. `SKILL.md:96` 硬编码代理地址 `http://127.0.0.1:7890`，`SKILL.md:101` 硬编码"待业在家，2026-06-20"这个具体人生状态——两者都是每次生成新 agent 时会被机械复制进 `TOOLS.md`/`MEMORY.md` 的种子文本。**[⏸ 随删除失效]**
8. SKILL.md 全文没有说明白"这是不是一个只为 Stanford 本人设计的单人工具"——如果以后想让别人复用这套机制，第 6/7 条的内容都需要先通用化；如果就是单人自用工具，这条不算问题，但至少应该在 SKILL.md 里写清楚这个假设，别人看到时才不会误用。**[⏸ 随删除失效]**

（这几条已经随 `lobster-agent-creator` 被整体删除而不再适用，实测确认目录已不存在，保留在这里只作为历史核实记录。）

### startup-idea-evaluator

9. **`references/market-analysis.md` 反复引用一个叫 `everything-claude-code:market-research` 的 skill**（SKILL.md、README.md、market-analysis.md 三处），但本仓库 `.agents/skills/` 下**根本没有这个 skill**——这是一处"暗契约"：真跑到这一步时，模型大概率会静默退化成"凭自己的常识判断市场"，而不会有任何提示告诉用户"这部分其实没有真实数据支撑"。**[✅ 已修，实测验证：`market-analysis.md` 第 5 行起加了"if not available"降级说明，按你选的方案（加降级文字，不内联完整方法论）]**
10. description 里"When in doubt, use it"再加上明确把"reviews pitch/deck logic"列为触发场景，跟 `master-bp-review` 的地盘直接重叠——用户随手扔一个"看看这个 idea/deck"，两个 skill 都可能抢触发。**[✅ 已修，实测验证：description 已删除"reviews pitch/deck logic"触发词，加了"用 master-bp-review 替代"的显式分流句]**

### master-bp-review

11. **没有"只点评不重写"的轻量模式**——每次调用都是 5 位大师全套点评 + 强制重写 BP，不像 `startup-idea-evaluator` 有 Mode A（快速）/ Mode B（深度）两档。用户如果只想听点意见，也会被迫收到一份完整重写稿。**[✅ 已修，实测验证：SKILL.md 新增"### 0. Decide: Full Review (default) or Critique-Only"]**
12. description 没有指向 `startup-idea-evaluator`——用户给"只有想法没有文档"时，这个 skill 会拒绝，但不会告诉用户该去哪。**[✅ 已修，实测验证：description 末尾加了指向 startup-idea-evaluator 的句子]**
13. 没有任何一份填好的完整示例输出（`review-template.md` 全是占位符）。**[✅ 已修，实测验证：新增 `references/example-output.md`，一份完整填好的虚构示例]**

### prompt-architect

14. **`prompt-template.md` 的骨架是 9 项，但 `SKILL.md` Step 5 自己说的结构是 8 项**——两边对不上。这个 skill 本身是"帮别人写清楚、别自相矛盾的 spec"，结果自己的模板和正文不一致，值得优先修。**[✅ 已修，实测验证：SKILL.md Step 5 列表已扩到 9 项，与 prompt-template.md 逐项对应]**
15. 没有说清楚交付形式是直接输出文本还是要写文件。**[✅ 已修，按用户明确要求写死为"写文件"——实测验证：Output format 一节加了"Write the final output to a file"]**

### synthesize-documents

16. **`agents/openai.yaml` 是一个 OpenAI Custom GPT 的 manifest 文件**，用的是 OpenAI 专属占位符语法（`$synthesize-documents`），跟 Claude Code/Pi 的机制完全不相关；而且 `grep` 整个 `SKILL.md` **完全没有引用这个文件**，它是一个孤儿文件，摆错了目录（放在 `agents/` 容易被误认为是"agent 人设模板"）。建议删除或者迁到单独的 `platforms/openai/` 之类的地方，并加说明。**[✅ 已修（选了"删除"，不是迁移）——实测验证：`agents/` 目录已不存在]**
17. 没有对"输入文档特别长（比如 5 份各 10 万字）"给出任何分治策略（顺序读/map-reduce/抽样）。**[✅ 已修，实测验证：SKILL.md 加了"Handling very long documents"一段]**

### interview-methodology

18. 没有多人/夫妻/群体访谈的指引（全部假设单一受访者）。**[⏸ 按用户要求暂不动]**
19. 没有远程/视频访谈的指引（全部假设面对面）。**[⏸ 按用户要求暂不动]**
20. 没有方言专项 ASR 工具对比（虽然承认方言是转写的最大挑战）。**[⏸ 按用户要求暂不动]**
21. 没有"同一受访者多次访谈之后怎么合并笔记"的规则。**[⏸ 按用户要求暂不动]**

---

## 4. P2 —— 可改可不改

你只圈了其中 2 条要改，其他明确"暂时不动"，逐条标了状态：

- `dev-env-audit` 的 `cpp.md` 没有专门讨论"只装 brew gcc、完全不装 Xcode CLT"这个边界情况——文档完整性小缺口，不是错误。**[⏸ 未要求，暂不动]**
- `interview-methodology` 四个 reference 文件之间的字母编号（A/B/C/D/E/F/G/H）跳号不连续——现在不影响使用，以后改章节容易出错。**[✅ 已修，实测验证：`interview-execution.md`/`.zh.md` 第 154-156 行加了跨文件说明注释，`transcript-templates.md`/`.zh.md` 的 E.2 标题格式也统一了]**
- `master-bp-review` 的 `evals/evals.json` 第 2 条测试用例的 prompt 字段留了个没填的占位符 `[user provides a document path...]`，这条 eval 现在跑不了。**[✅ 已修（这条虽不在你圈的 2 条 P2 里，但和 master-bp-review 的 P1 改动一起顺手做了）——实测验证：占位符已替换成具体的 HR SaaS 场景描述]**
- `master-bp-review` 的 `{PROJECT_NAME}`（模板里）和 `{project-name}`（文件名规则）命名风格不一致——功能影响很小。**[✅ 已修，实测验证：SKILL.md 第 438 行改成 `{project-name-slug}` 并说明与 `{PROJECT_NAME}` 的对应关系]**
- `audio-album-creator` 的 `pyproject.toml` description 是中文，`uv lock` 可能报警告（未实测证实）。**[⏸ 未要求，暂不动]**
- `audio-album-creator` 的 `gen_cover.py --retries` 默认 1，建议改 2 跟 `ai-script` 对齐——这是意见不是事实问题。**[⏸ 未要求，暂不动]**
- 各 skill 的 `description` 字段长度从 300 多字符到 1150+ 字符不等，参差是真实的，但从来不是"必须改"级别的问题。**[⏸ 未要求，暂不动]**

---

## 5. 已证伪的原审计结论（原文说错了，这次核实推翻）

把这些单独列出来，是因为它们容易被以后的人再次当真：

| 原审计说法 | 核实结果 |
|---|---|
| G8/G9/G10：`.venv`/`__pycache__`/`.DS_Store` 已入库，需要 `git rm --cached` 清理 | **错**，三者都没被 git 跟踪过，见第 1 节 |
| dev-env-audit 的 scripts 内部"全用绝对 \$HOME 而无 fallback"，归入 G1 硬编码问题 | **错**，`$HOME` 是标准 shell 变量，本身就是可移植写法，跟 `ai-script` 那种把某个人具体磁盘路径写死完全是两回事，不该归为同一类问题 |
| `scan.sh` 没有 normalize macOS 14+ `xcode-select -p` 返回格式的变化 | **错**，`scan.sh` 只用这条命令的**退出码**，从来没解析过它的输出文本，没有"格式变化"这个风险点 |
| `master-bp-review` 是"16 位大师"但表头写 15，有 off-by-one | **错**，全文搜不到"16"，就是 15 位 |
| `master-bp-review` 的 "YC Angels" 没有定义具体是谁 | **错**，SKILL.md 白纸黑字写了"Paul Graham + Garry Tan + alumni founders" |
| `startup-idea-evaluator` 的"小而美"哲学跟 growth/VC lens 冲突、没有显式校准 | **错**，明确写了反模式"不要把 VC scale 当默认目标，小而美是合法且经常更好的结果"（而且这个 skill 根本没有 Thiel/YC 人格系统，那是 master-bp-review 的机制，原审计把两个 skill 搞混了）|
| `startup-idea-evaluator` 的 evals 没断言"小而美"要出现 | **错**，eval #1 的 expected_output 明确要求"必须包含小而美校准" |
| `synthesize-documents` 的 Step 6 没有"search 不可用"的兜底方案 | **错**，明确写了"没有 search 就说明结论只基于提供的文档" |
| `prompt-architect` 的 Decision Table 没强制至少一个 alternative | **错**，白纸黑字要求"alternative(s) considered"是必填列 |
| `interview-methodology` 的 SKILL.md 章节编号跟 references 对不上，还举了个 `§F.1` 的例子 | **错**，核实过的编号全部对得上，而且原审计自己举的 `§F.1` 例子在 SKILL.md 里根本不存在（原审计编造了这个例子）|

---

## 6. 改进意见（项目级，不针对单个 skill）

1. **`skills-audit.md` 建议保留但加免责声明**，而不是当权威文档继续用——见第 0 节。它的定性分析（每个 skill 好在哪、术语提炼）依然有参考价值，但第 1 节说的那批"git 卫生"结论已经被证伪，且 dev-env-audit 那一节已经严重过时。**[✅ 已修，实测验证：`skills-audit.md` 顶部已有免责声明段落]**
2. **`master-bp-review` ↔ `startup-idea-evaluator` 的触发重叠是真实的、被两轮核实反复确认的**——建议在两边 description 里都加一句显式的"if X 用这个/if Y 用那个"，而不是留着让用户自己碰运气。**[✅ 已修，实测验证：两边 description 都已互相指向对方]**
3. **"暗契约"模式**（skill 里引用一个本仓库不存在的另一个 skill，且没有 fallback 语言）目前至少确认了 `startup-idea-evaluator → market-research` 这一处——建议定一条通用规则：以后任何 skill 引用外部/未来 skill 时，要么标注"待实现"，要么写清楚"如果不可用，按 X 降级处理"。**[🔸 部分处理——`startup-idea-evaluator → market-research` 这个具体实例已修（见 P1 第 9 条），但"通用规则"本身没有落成任何文档，以后再遇到同类情况还是要临时处理]**
4. **`evals/` 覆盖率低**——如果你在意"改了 description 之后会不会误触发/漏触发"这件事，这是个系统性缺口，不是某一个 skill 的问题。**[⏸ 按你的选择，只记录不新增——本轮没有为任何 skill 补 evals/]**
5. **仓库根 `.gitignore` 此前是"东一个西一个"**（`audio-album-creator/scripts/` 有自己嵌套的 `.gitignore`，没有仓库级兜底规则）——建议统一到根目录一份，其余全部合并进来。**[✅ 已修，实测验证：`find . -name .gitignore` 现在只返回 1 个文件（仓库根），`audio-album-creator/scripts/.gitignore` 已删除，其规则（`.venv/`、`__pycache__/`）连同 `.DS_Store` 兜底一起合并进根 `.gitignore` 的仓库级通配规则]**

---

## 7. 我的建议：第一批先做什么

按"性价比"排序（修复成本低 + 影响大的优先）：

1. **`ai-script` 的硬编码路径**——加一行 `command -v` 探测，几分钟的事，但这是这轮核实里唯一"确凿无疑、影响面广"的可移植性问题。
2. **`dev-env-audit` 的 npm 遗漏 + probe-cache.sh 阈值**——我对这个 skill 最熟，改动也都很小（加一个词 + 调一个判定条件），可以顺手做掉。
3. **`master-bp-review` ↔ `startup-idea-evaluator` 的触发冲突**——纯文字改动（各自 description 加一句"if...use..."），成本几乎为零，但能解决一个真实存在、会反复发生的路由歧义。
4. **`startup-idea-evaluator` 的 market-research 死引用**——要么补一句"没有的话就用 LLM 自己的判断，并明确告知用户这是推理而非实测数据"的降级语言，要么把 market-analysis.md 里代理的内容直接内联进去，二选一，别再指向不存在的东西。

**以上 1-4 已全部落地**（见文档顶部处理状态表 + 第 3 节逐条 [✅ 已修] 标注）。这份"第一批建议"是核实完成时给的排序，实际处理范围比这四条更大——第 3 节里除了 6-8（`lobster-agent-creator`，已随删除失效）和 18-21（`interview-methodology`，按你的要求本轮暂不动）之外，其余条目（9-17，含 startup-idea-evaluator/master-bp-review/prompt-architect/synthesize-documents 的全部 P1）**这一轮也都已经修完**，不再是"值得做但没做"的状态，逐条状态见第 3 节。

---

<!-- 本文件由 4 个并行核实 agent + 我自己对 dev-env-audit/全局工程卫生的直接核实汇总而成。原始核实过程记录（含每条 agent 的完整输出）留档在 _tmp/skills-issue-report-draft.md（gitignored，仅本地，不在本仓库分发范围内）。 -->
