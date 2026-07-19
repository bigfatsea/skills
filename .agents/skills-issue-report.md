<!-- Ver 2026-07-19 06:00, by Claude Sonnet 5 -->
<!-- 对 .agents/skills-audit.md 逐条核实 + 新一轮复查后的正式问题清单。取代原审计文档作为行动依据。 -->

# Skills 项目问题清单（核实版）

## 处理状态（2026-07-19 第二轮，已按用户反馈执行）

| 项 | 处理结果 |
|---|---|
| skill-creator 的 2 条 P0 | **跳过不改**——外部安装的 skill，不是本项目维护范围 |
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

具体改动的文件明细见对应 skill 目录下的 diff；已证伪结论表（第 5 节）和已验证的 P0/P1/P2 清单（第 2-4 节）保留原样作为核实记录，不因后续处理而改写。

---

## 0. 这份文档是什么、和 `skills-audit.md` 是什么关系

`.agents/skills-audit.md` 是此前对本仓库 10 个 skill（`ai-script` / `audio-album-creator` / `dev-env-audit` / `interview-methodology` / `lobster-agent-creator` / `master-bp-review` / `prompt-architect` / `skill-creator` / `startup-idea-evaluator` / `synthesize-documents`）做的一次性通读式审计，写于纯阅读+记忆，**没有实际跑命令验证**。

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

**遗漏的关键事实**：仓库根 `.gitignore` 第 8 行是 `.agents/skills/skill-creator`——**整个 `skill-creator` 目录被显式排除在版本控制之外**（看起来是有意为之，大概率是引入的第三方/官方工具，不想被本仓库 fork 管理）。原审计完全没提到这一点，导致它对 `skill-creator` 的"该不该入库""其他 skill 打包会不会继承它的 Apache 2.0 协议"等推论都建立在错误前提上。

**实际影响**：原审计"第 12 节"给的清理脚本（`git rm -r --cached .venv`、`git rm -r --cached __pycache__`）如果真的执行，会因为"没有匹配到任何已跟踪文件"而直接报错或什么都不做——**不需要执行，因为要清理的东西压根没进过 git**。

（.DS_Store/.venv/__pycache__ 确实作为本地磁盘文件存在，长期来看给仓库根 `.gitignore` 补一条兜底规则仍然是好习惯，但这是"面向未来的保险"，不是"现在就要清理的紧急问题"——放进下面的"改进意见"而不是 P0/P1。）

---

## 2. P0 —— 必须要改（真实存在、当下就会出问题或有风险）

### 2.1 `skill-creator/scripts/quick_validate.py`、`package_skill.py`：实测直接崩溃，且 SKILL.md 的说法被现场证伪

- 实测 `python3 -c "import yaml"` → `ModuleNotFoundError: No module named 'yaml'`。
- 实测 `python3 scripts/quick_validate.py .` → 同样的 traceback，**脚本直接崩溃**，不是"可能有问题"，是真的跑不起来。
- `SKILL.md` 正文里明确写"`package_skill.py` 只需要 Python 和文件系统"——这句话被上面的现场崩溃直接证伪。
- 这不是"文档没写清楚依赖"这种一般缺口，而是**工具在当前实测环境里根本不可用，且文档撒了一个可验证的谎**。

**建议**：加 `requirements.txt`/`pyproject.toml` 声明 `PyYAML`（或者在脚本里 `try/except ImportError` 给出"pip install pyyaml"的清楚提示），同时把 SKILL.md 那句"只需要 Python 和文件系统"改成准确的依赖说明。

（提醒：`skill-creator` 整个目录不受本仓库 git 管理，见第 1 节；这个问题是文件在磁盘上确实会崩溃，跟"要不要入库"是两回事，一样要修。）

### 2.2 `skill-creator/eval-viewer/generate_review.py`：无条件杀掉端口上的任意进程

- 每次启动本地预览服务器前，都会跑 `lsof -ti :{port}` 然后 `SIGTERM` 掉绑定在那个端口（默认 3117）上的**所有**进程——**不检查那个进程是不是自己之前启动的实例**，也不问用户确认。
- 如果用户凑巧有别的东西（比如一个开发中的服务）绑在同一个端口上，会被无声杀掉。

**建议**：杀之前先检查目标进程的 cmdline/父进程是否确实是本工具自己的前一次运行，或者干脆改成"端口被占用就换一个空闲端口"而不是杀进程。

---

## 3. P1 —— 建议改，但不紧急

### dev-env-audit（我自己核实，最有把握的一批）

1. **`probe-cache.sh` 的 WARN 阈值过于敏感**（原审计称 BUG-3.1，**核实为真**）：`probe-cache.sh:240` 的判定是 `n_external > 0 && n_unset > 0` 就报 WARN drift，没有任何缓冲。更深一层的根因（原审计没诊断到这一层）：这个计数器把"同一个工具内部半外置"（真正危险，比如 uv 的 PYTHON_INSTALL_DIR 外置了但 CACHE_DIR 没有）和"不同工具之间进度不一"（完全正常，比如 uv 已经外置但 Maven 还没顾得上）混进了同一个全局池。按工具分组判定"组内漂移"会比简单调高数字阈值更治本。
2. **`probe-path.sh` 默认命令列表没有 npm**：`probe-path.sh:31` 是 `(git python3 node java go rustc ruby pnpm uv)`，确实漏了 npm，而 `node.md` 里明确提到 `NPM_CONFIG_PREFIX` 是常见坑。加一个词的事。

（原审计里关于 dev-env-audit 的另外两条——"scan.sh 没 normalize xcode-select -p 的输出格式"、"全局 G1 硬编码 \$HOME"——**核实为误判**，详见第 5 节"已证伪的原审计结论"。另外，dev-env-audit 这个 skill 在原审计写完之后已经经历三轮重写（HTML 报告卡从 Apple Health 风格 → 终端风格 → 三选一模板 + 去 Python 化 + 自动落盘 + 默认英文），原审计第 3 节里绝大部分内容已经不描述现状了。）

### ai-script

3. **`SKILL.md` 强制 `cd /Volumes/SSD2T/code/ai-script` 硬编码绝对路径，没有任何 fallback**（全文 grep 不到 `command -v`/`which ai-script`）。这是这轮核实里**唯一一处被反复独立确认的真·路径硬编码问题**——换一台机器、换一个人，这个 skill 直接失效。建议：改成先 `command -v ai-script || which ai-script` 探测，找不到再按说明走 `cd` 兜底。
4. `check` 子命令失败后没有告诉模型"应该停下来，不要继续跑昂贵的调用"——纯文档缺口，容易导致限流/超时排查绕远路。
5. 全文没提 `ai-script` 自身怎么做版本管理/更新。

### lobster-agent-creator

6. **`core/USER.core.md` 硬编码了 Stanford 本人的真实姓名/背景/哲学清单**，而且跟 `core/IDENTITY.core.md` 的写法**不对称**——`IDENTITY.core.md` 对"agent 名字"用了规范的 `{{NAME}}` 占位符，但 `USER.core.md` 对"用户名字/背景"却是字面值而不是占位符，这直接导致"看起来像模板但其实是真人数据"的误导。
7. `SKILL.md:96` 硬编码代理地址 `http://127.0.0.1:7890`，`SKILL.md:101` 硬编码"待业在家，2026-06-20"这个具体人生状态——两者都是每次生成新 agent 时会被机械复制进 `TOOLS.md`/`MEMORY.md` 的种子文本。
8. SKILL.md 全文没有说明白"这是不是一个只为 Stanford 本人设计的单人工具"——如果以后想让别人复用这套机制，第 6/7 条的内容都需要先通用化；如果就是单人自用工具，这条不算问题，但至少应该在 SKILL.md 里写清楚这个假设，别人看到时才不会误用。

（这几条是不是问题，很大程度取决于这个 skill 到底是"给别人用的模板"还是"Stanford 自己的私人工具"——这是原审计"§11.5 需要你拍板的争议项"里已经列出的开放问题，这轮核实的价值是把具体证据钉死了，决策还是要你来做。）

### startup-idea-evaluator

9. **`references/market-analysis.md` 反复引用一个叫 `everything-claude-code:market-research` 的 skill**（SKILL.md、README.md、market-analysis.md 三处），但本仓库 `.agents/skills/` 下**根本没有这个 skill**——这是一处"暗契约"：真跑到这一步时，模型大概率会静默退化成"凭自己的常识判断市场"，而不会有任何提示告诉用户"这部分其实没有真实数据支撑"。
10. description 里"When in doubt, use it"再加上明确把"reviews pitch/deck logic"列为触发场景，跟 `master-bp-review` 的地盘直接重叠——用户随手扔一个"看看这个 idea/deck"，两个 skill 都可能抢触发。

### master-bp-review

11. **没有"只点评不重写"的轻量模式**——每次调用都是 5 位大师全套点评 + 强制重写 BP，不像 `startup-idea-evaluator` 有 Mode A（快速）/ Mode B（深度）两档。用户如果只想听点意见，也会被迫收到一份完整重写稿。
12. description 没有指向 `startup-idea-evaluator`——用户给"只有想法没有文档"时，这个 skill 会拒绝，但不会告诉用户该去哪。
13. 没有任何一份填好的完整示例输出（`review-template.md` 全是占位符）。

### prompt-architect

14. **`prompt-template.md` 的骨架是 9 项，但 `SKILL.md` Step 5 自己说的结构是 8 项**——两边对不上。这个 skill 本身是"帮别人写清楚、别自相矛盾的 spec"，结果自己的模板和正文不一致，值得优先修。
15. 没有说清楚交付形式是直接输出文本还是要写文件。

### synthesize-documents

16. **`agents/openai.yaml` 是一个 OpenAI Custom GPT 的 manifest 文件**，用的是 OpenAI 专属占位符语法（`$synthesize-documents`），跟 Claude Code/Pi 的机制完全不相关；而且 `grep` 整个 `SKILL.md` **完全没有引用这个文件**，它是一个孤儿文件，摆错了目录（放在 `agents/` 容易被误认为是"agent 人设模板"）。建议删除或者迁到单独的 `platforms/openai/` 之类的地方，并加说明。
17. 没有对"输入文档特别长（比如 5 份各 10 万字）"给出任何分治策略（顺序读/map-reduce/抽样）。

### interview-methodology

18. 没有多人/夫妻/群体访谈的指引（全部假设单一受访者）。
19. 没有远程/视频访谈的指引（全部假设面对面）。
20. 没有方言专项 ASR 工具对比（虽然承认方言是转写的最大挑战）。
21. 没有"同一受访者多次访谈之后怎么合并笔记"的规则。

### skill-creator（其余，非 P0）

22. `run_eval.py` 硬依赖 `claude` CLI（本机确实装了，但没有任何前置检查/报错提示，换个环境就会静默坏掉）。
23. `package_skill.py` 的 `EXCLUDE_DIRS` 没排除 `.venv`——打包 `audio-album-creator` 会把 13MB 的 venv 整个塞进 `.skill` 文件。
24. eval 数据未经 HTML-safe 转义就塞进 `<script>` 标签（理论上如果内容含 `</script>` 会提前截断标签）——技术上真实存在，但因为是纯本地单用户工具、处理的是用户自己的数据，实际风险低，仍建议顺手用 `<script type="application/json">` + `JSON.parse` 的写法修一下（跟这次 dev-env-audit 的 HTML 卡片用的是同一套安全模式）。
25. 8/10 个 skill 没有 `evals/` 目录，`skill-creator` 自己也没有——没法用它自己的机制测它自己。

---

## 4. P2 —— 可改可不改

- `dev-env-audit` 的 `cpp.md` 没有专门讨论"只装 brew gcc、完全不装 Xcode CLT"这个边界情况——文档完整性小缺口，不是错误。
- `interview-methodology` 四个 reference 文件之间的字母编号（A/B/C/D/E/F/G/H）跳号不连续——现在不影响使用，以后改章节容易出错。
- `master-bp-review` 的 `evals/evals.json` 第 2 条测试用例的 prompt 字段留了个没填的占位符 `[user provides a document path...]`，这条 eval 现在跑不了。
- `master-bp-review` 的 `{PROJECT_NAME}`（模板里）和 `{project-name}`（文件名规则）命名风格不一致——功能影响很小。
- `audio-album-creator` 的 `pyproject.toml` description 是中文，`uv lock` 可能报警告（未实测证实）。
- `audio-album-creator` 的 `gen_cover.py --retries` 默认 1，建议改 2 跟 `ai-script` 对齐——这是意见不是事实问题。
- `skill-creator` 的 `.claude/commands/<id>.md` 碰撞风险——真实但概率很低（随机 8 位 hex 后缀 + 正常退出会自动清理），只有在进程被强杀时才会留下孤儿文件。
- 各 skill 的 `description` 字段长度从 300 多字符到 1150+ 字符不等，参差是真实的，但从来不是"必须改"级别的问题。

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

1. **`skills-audit.md` 建议保留但加免责声明**，而不是当权威文档继续用——见第 0 节。它的定性分析（每个 skill 好在哪、术语提炼）依然有参考价值，但第 1 节说的那批"git 卫生"结论已经被证伪，且 dev-env-audit 那一节已经严重过时。
2. **`master-bp-review` ↔ `startup-idea-evaluator` 的触发重叠是真实的、被两轮核实反复确认的**——建议在两边 description 里都加一句显式的"if X 用这个/if Y 用那个"，而不是留着让用户自己碰运气。
3. **"暗契约"模式**（skill 里引用一个本仓库不存在的另一个 skill，且没有 fallback 语言）目前至少确认了 `startup-idea-evaluator → market-research` 这一处——建议定一条通用规则：以后任何 skill 引用外部/未来 skill 时，要么标注"待实现"，要么写清楚"如果不可用，按 X 降级处理"。
4. **`evals/` 覆盖率低**（10 个里只有 2 个有）——如果你在意"改了 description 之后会不会误触发/漏触发"这件事，这是个系统性缺口，不是某一个 skill 的问题。
5. **`skill-creator` 作为"帮你做其他 skill 的工具"，自己有 P0 级问题**（崩溃的核心校验脚本 + 危险的杀端口默认行为）——这个工具的可靠性会直接影响你以后所有新 skill 的创建/校验流程，价值上可能比修任何一个具体业务 skill 都高。
6. 仓库根 `.gitignore` 目前对 `.venv`/`__pycache__`/`.DS_Store` 的保护是"东一个西一个"（skill-creator 整个目录忽略、audio-album-creator 有自己嵌套的 `.gitignore`），没有仓库级兜底规则。现状是干净的，不紧急，但加一条全局规则是便宜的保险。

---

## 7. 我的建议：第一批先做什么

按"性价比"排序（修复成本低 + 影响大的优先）：

1. **`skill-creator` 的两个 P0**——核心校验工具崩溃 + 无条件杀端口的危险默认行为。这个工具会被用来创建/校验你以后所有的新 skill，优先级最高，而且改动都不大（补依赖声明、加个进程归属检查）。
2. **`ai-script` 的硬编码路径**——加一行 `command -v` 探测，几分钟的事，但这是这轮核实里唯一"确凿无疑、影响面广"的可移植性问题。
3. **`dev-env-audit` 的 npm 遗漏 + probe-cache.sh 阈值**——我对这个 skill 最熟，改动也都很小（加一个词 + 调一个判定条件），可以顺手做掉。
4. **`master-bp-review` ↔ `startup-idea-evaluator` 的触发冲突**——纯文字改动（各自 description 加一句"if...use..."），成本几乎为零，但能解决一个真实存在、会反复发生的路由歧义。
5. **`startup-idea-evaluator` 的 market-research 死引用**——要么补一句"没有的话就用 LLM 自己的判断，并明确告知用户这是推理而非实测数据"的降级语言，要么把 market-analysis.md 里代理的内容直接内联进去，二选一，别再指向不存在的东西。

第 6-25 条（`lobster-agent-creator` 的个人信息硬编码、`master-bp-review` 的轻量模式、`prompt-architect` 的 8/9 项不一致、`synthesize-documents` 的孤儿文件、`interview-methodology` 的场景覆盖缺口等）都是"值得做但不做也不会立刻出问题"，可以往后排，其中 `lobster-agent-creator` 那几条尤其取决于你对"这个工具到底是不是要给别人用"的判断，我不替你下结论。

---

<!-- 本文件由 4 个并行核实 agent + 我自己对 dev-env-audit/全局工程卫生的直接核实汇总而成。原始核实过程记录（含每条 agent 的完整输出）留档在 _tmp/skills-issue-report-draft.md（gitignored，仅本地）。 -->
