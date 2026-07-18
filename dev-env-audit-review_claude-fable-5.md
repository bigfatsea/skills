<!-- Ver 2026-07-18 20:05, by Claude Fable 5 -->

# dev-env-audit Skill 全面 Review 报告

范围：`.agents/skills/dev-env-audit/` 下全部 21 个文件（SKILL.md、3 个 scripts、17 个 references）。
方法：逐文件精读 + 真机实测（三个脚本全部实际运行）+ 对可疑事实做二进制/命令级验证。

> **状态更新（2026-07-18 17:50）**：A 组四项已全部修复并测试通过（见文末"六、修复记录"）。
> **状态更新（2026-07-18 18:40，批次 2）**：B5/B6/B7/B8/B10/B11/B12、C15/C16 已修复；D1/D2 已拍板并落地；另采纳用户建议新增"外置变量三场景一致性检查"（见"六、修复记录·批次 2"）。批次 3（2026-07-18 19:15）：D3/D4/D5 已拍板（均维持现状），E6/E3/B9/C14 已落地，见"八、修复记录·批次 3"。

---

## 一、逐文件 Review 记录

### SKILL.md

- 四阶段流程（scan → 逐语言深挖 → 横切 → 报告）结构清晰，"清单不判断、判断在 reference"的职责切分是对的。
- 安全纪律（只读、不联网、不装卸）定义明确，且"凌驾于用户临时要求之上"的写法能防越权。
- **问题 [A4]**：Phase 1 写着"如果清单显示外置相关环境变量指向未挂载的卷，先问用户"——但 scan.sh 根本不输出任何环境变量，挂载检查在 Phase 3 的 probe-cache.sh 里。这条指令引用了不存在的输出，agent 执行到这里会找不到依据。
- 小问题：References 表格 17 行较长，但检索逻辑（Phase 1 命中什么读什么）成立，可接受。

### scripts/scan.sh（实测通过，3.3s）

- source chain 递归扫描是亮点，本机（集中式 dotfiles）实测正确追出了 `~/myenv/*.zsh` 链条。
- **问题 [B11]**：source 检测正则 `^[[:space:]]*(source|\.)` 只匹配行首 source，漏掉极常见的 `[[ -f x ]] && source x`、`[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh` 这种行内条件 source；变量展开只处理 `$HOME` 和 `~`，`$ZDOTDIR`/`${HOME}` 形式不展开。链条会被静默截断。
- **问题 [B12]**：`which -a "$c" | sort -u` 用字典序去重，破坏了 PATH 优先序——重复清单里第一行不再代表实际生效的那份（本机 java 一节，`/usr/bin/java` 排在 SDKMAN 之前纯属字典序巧合）。应改用 `awk '!seen[$0]++'` 保序去重。
- **问题 [C15]**：`dir_hint fnm "${FNM_DIR:-$HOME/.fnm}"` 里 `~/.fnm` 是旧版默认目录，新版 fnm 在 macOS 的默认位置不是它（XDG / Application Support），残留检测会漏；conda 漏了 `~/opt/miniconda3`（旧官方安装器默认）；缺 `~/.dotnet`、`~/.swiftenv` 的 dir_hint。
- **问题 [B7]**：brew 只查 `--formula`，但 flutter、dotnet-sdk、temurin（JDK 最常见 brew 装法）都是 **cask**，全部盲区。
- **问题 [C16]**：formula 正则漏 `go@1.xx`、`lua@5.x` 这类带版本号 formula（node@/php@/gcc@/openjdk@ 都覆盖了，唯独 go 和 lua 没有）。
- **问题 [C13]**：CLT 未安装的机器上 `/usr/bin/git、swift、clang、gcc` 是触发 GUI 安装弹窗的桩程序，probe_cmd 一跑会弹一排框——违背"无副作用"体验。可在开头 `xcode-select -p` 探测后跳过这批。
- **问题 [C14]**：`flutter --version` 在 fresh clone 的 flutter 上首次运行会**下载 Dart SDK**（联网 + 写盘），是只读承诺的一个真实漏洞。可改读 `<flutter>/version` 文件。
- 小问题：source chain 输出有重复（`env.zsh` 经 .zshrc 和 .zshenv 各走一遍），深度 >2 截断不提示。
- 验证过没问题：脚本顶层 `local`（zsh 脚本顶层合法）；`(shell function/alias, likely init'ed in ~/.zshenv)` 的推断（非交互非登录 zsh 确实只读 .zshenv）；rbenv 在本机正确显示为 shell function。

### scripts/probe-path.sh（实测通过，2.1s）

- 三场景（A/B/C）设计是本 skill 最有价值的检查，"登录非交互最容易漏配"的判断准确。
- alias-INFO 分支实测有效：本机 `python3` 在 C 场景被 `alias python3='uv run python'` 接管，正确降级为 INFO 而非 WARN——`command -v` 对 alias 的输出确实以 `alias ` 开头（已验证）。
- `tail -1` 兜交互 shell 噪音、`/usr/bin` 回落时的 path_helper 提示，都是对的。
- 小问题：只比对 `command -v` 路径，不比对版本；不输出各场景的完整 `$PATH`（差异出现时要人工再查一轮才能定位是哪段 PATH 变了）。属可改进项，非错误。

### scripts/probe-cache.sh（实测通过，0.3s）

- 三态分类（external / local-custom / unset）+ "漂移最危险"的定性正确；未挂载卷 FAIL 的判定和 `/Volumes/<vol>` 取层逻辑正确。
- **问题 [A1]**：`classify UV_VIRTUALENV_DIR uv` —— **`UV_VIRTUALENV_DIR` 不是 uv 的环境变量**。已用 `strings` 扫 uv 0.11.28 二进制验证：不存在该变量（存在的是 UV_CACHE_DIR / UV_TOOL_DIR / UV_PYTHON_INSTALL_DIR / UV_PROJECT_ENVIRONMENT 等）。讽刺的是这台机器的环境里恰好设了它，正在静默无效——这正是 java.md §5 批判的"Maven 假变量坑"。uv 没有"全局 venv 目录"概念（项目 venv 是项目内 `.venv`，由 `UV_PROJECT_ENVIRONMENT` 控制相对/绝对位置）。
- **问题 [A3]**：`classify SDKMAN_DIR ""` 的 tool 参数为空 → 永不跳过。没装 SDKMAN 的机器上 SDKMAN_DIR unset 也计入 `n_unset`，只要有任一变量外置就误报 drift WARN。应改成按 `${SDKMAN_DIR:-~/.sdkman}` 目录存在性 gate（SDKMAN 是 shell 函数，`command -v` 本来就测不到，这正是留空的原因，但留空的副作用没处理）。
- **问题 [B6]**：漂移判定只数环境变量，不使用已经采集到的工具生效值。用户用 `go env -w GOCACHE=...` 或 `pnpm config set store-dir` 完成外置时，env var 为空 → 计入 unset → 误报 drift；脚本明明打印了 effective 值却不参与判定。
- **问题 [B5]**：核查清单与 references 脱节——references §4 推荐的 `COMPOSER_CACHE_DIR`、`RBENV_ROOT`、`FVM_HOME`、`JULIAUP_DEPOT_PATH`/`JULIA_DEPOT_PATH`、`VCPKG_DOWNLOADS`/`VCPKG_DEFAULT_BINARY_CACHE`、`DOTNET_ROOT`、`GOMODCACHE` 一个都不在 probe-cache.sh 里。按 reference 做完外置的用户，横切检查却看不见。
- **问题 [B10]**：maven `<localRepository>` 若指向外置卷，只做 external 计数，不做挂载检查——它是唯一绕过 FAIL 逻辑的外置路径。
- 亮点：不跑 `mvn help:evaluate`（会联网下插件）而只读 settings.xml，并注明权威命令让用户自己跑——只读纪律执行得很严谨。

### references/python.md

- uv 单一权威、pyenv/conda init 残留判定、CARGO_HOME 劫持坑、alias 只在交互 shell 生效——内容质量高，§5 的坑都是真坑。
- **问题 [A1] 同源**：§4 第 4 步 `export UV_VIRTUALENV_DIR=...` 是编造的变量（见上）。四个 UV_* 变量里三真一假。
- 小问题 [C17]：§2 可加 `which -a pip3`——本机实测 pip3 解析到 Xcode 内置 Python 3.9 的 pip，是极具迷惑性的常见信号，现有探测抓不到。
- 小问题：未提 uv 装到 `~/.local/bin` 后需确认该目录在 PATH（uv 安装器会处理，但集中式 dotfiles 用户可能丢）。

### references/node.md

- corepack shim 坑、pnpm store 三不认、brew node 必须真卸——都对。"pnpm store 只认 `pnpm config set`"已实测（`npm_config_store_dir` 注入不改变 `config get` 结果）。
- fnm vs asdf 的取舍写得诚实（不是无条件推荐）。
- **问题 [D2]**：§4 推荐 `export NPM_CONFIG_PREFIX=<外置>` 与 fnm 的多版本隔离相矛盾——全局包固定进单一 prefix 后，native module 是按编译时 node 版本 ABI 的，切 node 版本即坏；且 skill 自己主张"全局包统一走 pnpm"，NPM_CONFIG_PREFIX 基本没有存在必要。属需要拍板的设计矛盾（见第三节 D2）。

### references/java.md

- `/usr/bin/java` 转发器、Maven 假变量、SDKMAN_DIR 装前生效、JAVA_HOME 派生 current——全部准确，是全套 references 里质量最高的一篇。
- 小问题：brew 只 grep formula `openjdk`，temurin cask 装法测不到（`/usr/libexec/java_home -V` 能兜住，因为 cask JDK 注册进系统目录，所以影响有限）。

### references/go.md

- GOTOOLCHAIN 论述准确，"单版本 brew go 是终点不是将就"的定调正确，`golang.org/dl/goX.Y.Z` 官方侧装方案给得好。
- **问题 [A2]**：§4 `asdf set --global golang latest` —— **asdf 0.16+ 没有 `--global` 旗标**。已实测本机 asdf 0.20：`asdf set` 的旗标是 `--home/-u` 和 `--parent/-p`。`--global` 是把旧语法（`asdf global golang latest`，≤0.15）和新命令拼接出来的幻觉命令，照抄必报错。
- GOCACHE ≠ GOMODCACHE 的坑写得好，但 probe-cache.sh 只查 GOCACHE（见 B5/B6）。

### references/rust.md

- 内容准确紧凑。CARGO_HOME 与 uv 的联动坑双向互引（python.md ↔ rust.md），做得好。无发现。

### references/ruby.md

- rvm implode 特例、path_helper 反超 shim、"纯 Ruby vs 多语言"选择轴（明确不是"单版本 vs 多版本"）、brew ruby 的 native extension ABI 论证——质量高。
- **问题 [A2] 同源**：`asdf set --global ruby <version>` 同样错误。
- PATH 夺回代码片段（`path=("$d" "${path[@]:#$d}")`）是正确的 zsh 习语。

### references/git.md

- Apple 冻结 git、path_helper 双层坑、"逻辑在 source chain 里 ≠ 缺失"的两条判定规则——准确且分寸好。无实质问题。

### references/csharp.md

- dotnet-install + global.json 的定调正确，"global.json 缺 SDK 硬报错（不像 GOTOOLCHAIN 自动下载）"的对比准确。
- 小问题 [B7] 同源：brew 侧只 grep formula `^dotnet`，常见的 `dotnet-sdk` cask 测不到。
- 小问题 [C18]：§4 用 `--install-dir "$DOTNET_ROOT"` 装到自定义目录后，未提示还需把该目录加进 PATH 且持久 export DOTNET_ROOT，否则装完找不到命令。
- 尺度问题：§2 `find . -name global.json` 是项目级探测，而 SKILL.md 明言"管机器级不管项目级"——轻微越界（dart.md 同）。

### references/swift.md

- 多 Xcode + xcode-select 的官方路线、DEVELOPER_DIR 覆盖坑、license 坑——准确。服务端 Swift 例外划分清楚。无实质问题。

### references/php.md

- keg-only 机制、扩展按版本编译——准确。
- **问题 [A2] 同源**：`asdf set --global php <version>` 同样错误。
- 小问题 [C20]：Composer 安装建议 `sudo mv composer.phar /usr/local/bin/`——`brew install composer` 或放 `~/.local/bin`（免 sudo）都更符合本 skill 自身的 brew 优先偏好。

### references/lua.md

- 大版本不兼容、rocks 按版本分目录——准确。**[A2] 同源**：`asdf set --global lua`。

### references/zig.md

- **验证过没问题**：`brew install zigup` 成立（homebrew-core 确有 zigup formula，已查）。"非官方但事实标准"的披露诚实。
- 疏漏 [E5]：zig 版本管理领域 zigup 并非唯一活跃方案（zvm、anyzig 等在竞争），"社区事实标准"的说法偏强；"ziglang.org 官方文档也会引用类似工具"这句出处存疑，建议软化或删除。

### references/julia.md

- juliaup 官方地位、channel 概念坑、/Applications 遗留 .dmg 坑——准确。`JULIAUP_DEPOT_PATH`/`JULIA_DEPOT_PATH` 均为真实变量。无实质问题。

### references/dart.md

- fvm 定位（项目级锁定而非全局替代）、flutter doctor 权威入口——准确。`brew tap leoafarias/fvm` 路线已验证存在。
- **验证过没问题**：§2 的 find 写法（`-maxdepth` 出现在 `-o` 之后）在 macOS BSD find 下实测正常无警告（GNU find 会警告，但本 skill 明确只针对 macOS）。
- 关联问题 [C14]：单版本方案 `git clone flutter` 后，首次跑 `flutter --version` 会下载 Dart SDK——scan.sh 的探测在这种半成品状态下有副作用。

### references/erlang-elixir.md

- OTP/Elixir 兼容矩阵、`.tool-versions` 必须成对钉版本、Rebar3 单独装——准确且是真实痛点。**[A2] 同源**：`asdf set --global erlang/elixir`。

### references/cpp.md

- "C/C++ 无统一版本管理器、靠系统原生机制并存"的定调诚实；vcpkg vs Conan 不强行分胜负、asdf-gcc 不推荐——分寸都对。CC/CXX 混用 ABI 坑真实。无实质问题。

### references/_template.md

- 五节结构与全部 references 实际一致；"命令必须来自可信出处，不要写推测的命令"这条纪律写在了模板里——但恰恰被 [A1][A2] 违反，说明纪律缺执行手段（见 E6）。

---

## 二、综合分析

整体评价：**这是一个设计成熟度相当高的 skill**。职责分层（scan 不判断 / reference 判断 / 脚本横切）、只读纪律、"装前设变量"类时序坑、path_helper 三场景检测、source chain 意识——这些是大多数同类工具（包括开源的 mac 环境体检脚本）都没做到的深度。三个脚本真机全部跑通，无语法错误。

但 review 坐实了一个结构性风险：**references 里存在编造的命令/变量，而 skill 的全部判定和迁移方案都以 references 为唯一事实源**（SKILL.md 明文"命令必须出自 reference，禁止编造"）。当 reference 本身编造时，这条纪律反而放大错误——agent 会理直气壮地把 `UV_VIRTUALENV_DIR` 和 `asdf set --global` 写进给用户的迁移命令。两处错误的性质相同：把两个真实东西的记忆拼接成一个不存在的东西（uv 的真变量名拼上 venv 概念；asdf 旧版 `global` 关键字拼上新版 `set` 命令）。

第二个结构性问题是**脚本与 references 的双向脱节**：references §4 推荐的外置变量，probe-cache.sh 大半不核查（B5）；SKILL.md Phase 1 引用 scan.sh 没有的输出（A4）。三个组件各自演进后没有做一致性对账。

---

## 三、问题分组清单

### A 组：必改（坐实的错误，照抄即坏）—— ✅ 已全部修复（2026-07-18）

| # | 位置 | 问题 | 实际修法 | 状态 |
|---|---|---|---|---|
| A1 | python.md §4；probe-cache.sh | `UV_VIRTUALENV_DIR` 不存在（strings 扫 uv 0.11.28 二进制证实），设了静默无效 | python.md 删除该 export，补充"uv 无全局 venv 目录、项目 venv 由 `UV_PROJECT_ENVIRONMENT` 控制、`UV_VIRTUALENV_DIR` 是流传的假变量"说明；probe-cache.sh 删除 classify 行并留防复发注释 | ✅ 已修复 |
| A2 | go/ruby/php/lua/erlang-elixir 五个 .md §4 | `asdf set --global` 旗标不存在（实测 asdf 0.20：只有 `--home/-u`、`--parent/-p`） | 五处统一改为 `asdf set -u <name> <version>`，行内注明 asdf ≤0.15 旧语法 `asdf global` | ✅ 已修复 |
| A3 | probe-cache.sh | `classify SDKMAN_DIR ""` 永不跳过 → 无 SDKMAN 机器误报 drift WARN | gate 改为 `[[ -n "$SDKMAN_DIR" \|\| -d "$HOME/.sdkman" ]]`（比原提议的纯目录检查更严：变量指向未挂载卷时目录不存在，纯目录 gate 会把该 FAIL 一起吞掉） | ✅ 已修复 |
| A4 | SKILL.md Phase 1 | 指令引用 scan.sh 不存在的输出（外置 env 指向未挂载卷） | 选了"挪到 Phase 3"方案（KISS，不动 scan.sh）：删除 Phase 1 该条，在 Phase 3 probe-cache 说明处补"报 FAIL 时先问用户挂载还是跳过" | ✅ 已修复 |

### B 组：建议改（重要疏漏/不一致，影响审计质量）

| # | 位置 | 问题 | 状态 |
|---|---|---|---|
| B5 | probe-cache.sh | 核查清单缺 references 推荐的 COMPOSER_CACHE_DIR、RBENV_ROOT、FVM_HOME、JULIAUP_DEPOT_PATH/JULIA_DEPOT_PATH、VCPKG_*、DOTNET_ROOT、GOMODCACHE——按 reference 外置后横切检查看不见 | ✅ 已修复（批次 2，另补 BUN_INSTALL/DENO_DIR，即顺带解决 E7） |
| B6 | probe-cache.sh | drift 只数 env var，不用已打印的 effective 值；`go env -w`、`pnpm config set` 完成的外置会被误判为 unset | ✅ 已修复（批次 2：uv/pnpm/go/maven 改用工具生效值判定，`go env -changed` 识别显式配置） |
| B7 | scan.sh + java/csharp.md | brew 检测只查 formula；flutter、dotnet-sdk、temurin 均为 cask，全盲区 | ✅ 已修复（批次 2：scan.sh 增加 cask 清单节） |
| B8 | scan.sh | 不检测双 Homebrew（Apple Silicon 上 `/usr/local/bin/brew` Intel 残留）——经典冲突源 | ✅ 已修复（批次 2） |
| B9 | 全局 | mise 只在 scan 里探测存在性，没有任何判定规则；mise+fnm / mise+asdf 并存（现实中越来越常见）时 agent 无章可循 | ⏳ 待办 |
| B10 | probe-cache.sh | maven localRepository 指向外置卷时不做挂载检查，是唯一绕过 FAIL 的路径 | ✅ 已修复（批次 2：走统一的 classify_eff 挂载检查） |
| B11 | scan.sh | source 正则漏 `[[ -f x ]] && source x` 行内条件 source；不展开 `$ZDOTDIR` | ✅ 已修复（批次 2；本机实测新抓出 `~/.p10k.zsh`、`.zshenv -> password.zsh` 等旧版全部漏掉的真实链条） |
| B12 | scan.sh | `which -a \| sort -u` 破坏 PATH 优先序，重复清单首行 ≠ 生效者 | ✅ 已修复（批次 2：`awk '!seen[$0]++'` 保序去重，实测首行与 `command -v` 一致） |

### C 组：可改可不改（小问题，看维护意愿）

| # | 位置 | 问题 |
|---|---|---|
| C13 | scan.sh | CLT 缺失机器上 git/swift/clang/gcc 桩会弹 GUI 安装框；开头查 `xcode-select -p` 可免 |
| C14 | scan.sh | `flutter --version` 在 fresh clone 上会下载 Dart SDK（联网+写盘）；可读 `<flutter>/version` 文件替代 |
| C15 | scan.sh | dir_hint：fnm 的 `~/.fnm` 是旧默认；conda 漏 `~/opt/miniconda3`；缺 `~/.dotnet`、`~/.swiftenv` — ✅ 已修复（批次 2，另补 `~/.juliaup`） |
| C16 | scan.sh | brew 正则漏 `go@1.xx`、`lua@5.x` — ✅ 已修复（批次 2） |
| C17 | python.md | §2 加 `which -a pip3`（本机实测 pip3 落在 Xcode Python 3.9，现有探测抓不到） |
| C18 | csharp.md | `--install-dir` 后未提需同时持久化 DOTNET_ROOT + PATH |
| C19 | probe-path.sh | 差异出现时不输出各场景完整 `$PATH`，定位要人工二次查 |
| C20 | php.md | Composer 建议 `sudo mv` 到 /usr/local/bin；`brew install composer` 或 `~/.local/bin` 更省事免 sudo |
| C21 | scan.sh | source chain 重复打印（同文件经多入口各走一遍）、深度 >2 静默截断 |
| C22 | csharp/dart.md | `find .` 项目级探测与"机器级审计"的自我定位轻微冲突 |

### D 组：两难抉择（需要拍板，改与不改取决于偏好）

| # | 抉择 | 两边的代价 |
|---|---|---|
| D1 | probe-cache 判定以 env var 为准（现状）还是以工具 effective 值为准 | ✅ 已拍板并落地（批次 2）：采用折中方案——uv/pnpm/go/maven 用 effective 值判定，其余保持 env var 口径 |
| D2 | node.md 是否保留 `NPM_CONFIG_PREFIX` 外置建议 | ✅ 已拍板并落地（批次 2）：删除外置建议，§3 增判定行、§5 增"与版本管理器相克"坑；probe-cache 保留状态上报（已设的机器要在报告里提示移除） |
| D3 | 是否把 mise 升格为与 fnm/asdf 并列的基线选项 | ✅ 已拍板（2026-07-18，用户）：**不升格**。本 skill 哲学是"每语言用领域权威工具，或一工具管一类生态（SDKMAN for JVM）"，不认同一统所有的路线。落地为 SKILL.md 的 mise 判定规则（见批次 3） |
| D4 | scan.sh 重复清单是否对"已知良性对"降噪 | ✅ 已拍板（用户）：**不降噪**。scan 展示一切事实，在事实之上做解读；不因"良性"而隐藏，避免用户对系统实况一无所知。维持现状，无代码改动 |
| D5 | probe-path 的 WARN 是否也应比对版本号 | ✅ 已拍板（用户）：**不加**。本 skill 做原则性指导，不做细粒度版本控制，细微版本差异不是关注点。维持现状，无代码改动 |

### E 组：疏漏 / 市面更优方案 / 验证盲点

| # | 内容 |
|---|---|
| E1 | **双 Homebrew / Rosetta 架构检测缺失**（同 B8，属"市面体检脚本普遍有、本 skill 没有"的项）：`arch`、`uname -m` vs brew prefix 的交叉验证 |
| E2 | **磁盘占用不量化**：外置的核心动机是省内置盘，但全程没有一个 `du -sh` 级别的缓存体积报告（只读可做），报告说服力打折 |
| E3 | **shell 前提未验证**：skill 假设 zsh，但从不检查 `dscl . -read ~/ UserShell` / `$SHELL`；bash/fish 用户跑出来的结论会系统性失真，应在 Phase 1 显式确认并在非 zsh 时声明降级 |
| E4 | **launchd/GUI 真实环境未覆盖**：probe-path 用 `zsh -l -c` 近似 GUI App 环境，但真实 launchd 环境不继承任何 shell 配置（`launchctl getenv PATH` 才是真值）；现状是合理近似，可在 SKILL.md 注明此局限 |
| E5 | zig 生态：zigup 之外 zvm、anyzig 在竞争，"社区事实标准"说法偏强；"ziglang.org 官方文档引用类似工具"出处存疑 |
| E6 | **纪律缺执行手段**：_template.md 写了"命令必须来自可信出处，不要写推测的命令"，但 A1/A2 恰恰是推测拼接的产物。建议给 skill 加一个轻量自检脚本或 checklist（新增/修改 reference 时，逐条命令在真机或 `--help` 层面验证一遍），否则同类错误还会进来 |
| E7 | probe-cache 未覆盖但存在的外置面：`BUN_INSTALL`、`DENO_DIR`、`PIP_CACHE_DIR`、`HOMEBREW_CACHE`——scan 探测了 bun/deno 却没有对应缓存核查 — ✅ 大部分已修复（批次 2 补 BUN_INSTALL/DENO_DIR；PIP_CACHE_DIR/HOMEBREW_CACHE 未加：前者被 uv 基线取代，后者是安装中转不是长期缓存，价值低） |

---

## 四、验证过、确认不是问题的点（避免下轮 review 重复怀疑）

1. zsh 脚本顶层用 `local` 合法（实测无报错）——不是 bash 思维下的 bug。
2. probe-path 的 alias 分支能触发：zsh `command -v` 对 alias 输出以 `alias ` 开头（实测），本机 python3 正确判为 INFO。
3. `brew install zigup`、`brew install fvm`（leoafarias tap）均真实存在。
4. dart.md 的 find 写法在 macOS BSD find 下无警告、结果正确。
5. "pnpm store-dir 只认 `pnpm config set`"实测成立（`npm_config_store_dir` 注入不生效）。
6. 三脚本真机运行全部通过：scan 3.3s / probe-path 2.1s / probe-cache 0.3s，输出格式与设计一致。
7. `JULIAUP_DEPOT_PATH`、`UV_TOOL_DIR`、`UV_PYTHON_INSTALL_DIR`、`DOTNET_ROOT`、`GOTOOLCHAIN`、asdf 0.16+ 的 `asdf set` 命令本身——均为真实存在。

---

## 五、（原"建议执行顺序"已由下两节取代）

## 六、修复记录（2026-07-18 A 组）

改动文件（8 个）：SKILL.md、scripts/probe-cache.sh、references/{python,go,ruby,php,lua,erlang-elixir}.md，均已 bump 版本头。

测试证据（全部实测通过）：

1. **语法**：三个脚本 `zsh -n` 全部通过。
2. **回归**：本机重跑 probe-cache.sh → `external=15 unset=0 local-custom=1 broken=0, RESULT OK, exit 0`（较修复前少的 1 个 external 正是被移除的假变量 UV_VIRTUALENV_DIR，符合预期）。
3. **A3 场景一（无 SDKMAN 机器）**：`env -u SDKMAN_DIR zsh -f scripts/probe-cache.sh` → SDKMAN_DIR 行消失、不计入 unset，drift 误报消除。
4. **A3 场景二（指向未挂载卷）**：`SDKMAN_DIR=/Volumes/NOPE-9999/sdkman` → 正确报 `FAIL ... NOT mounted`，exit 1；正常场景 exit 0。
5. **残留检查**：`grep -rn 'set --global|UV_VIRTUALENV_DIR'` 仅剩两处刻意保留的警示注释（python.md、probe-cache.sh），无遗漏。
6. 测试方法备注：直接跑场景测试会被本机 `~/.zshenv`（重新 export SDKMAN_DIR）干扰，须用 `zsh -f` 跳过 rc 文件——这本身再次印证了 skill 里"集中式 dotfiles 会改写子 shell 环境"的论断。

## 七、修复记录·批次 2（2026-07-18 18:40）与剩余事项

### 批次 2 改动内容

改动文件：scripts/probe-cache.sh（重写）、scripts/scan.sh、references/node.md、SKILL.md（Phase 3 描述同步）。

1. **probe-cache.sh 重构**（B5+B6+B10+D1 落地）：
   - 判定口径分两层：uv（`uv cache dir`/`uv python dir`/`uv tool dir`）、pnpm（`config get store-dir`）、go（`go env GOCACHE/GOMODCACHE` + `go env -changed` 识别显式配置）、maven（settings.xml）按**工具生效值**判定；其余按继承环境变量判定。
   - 补齐核查清单：COMPOSER_CACHE_DIR、RBENV_ROOT、FVM_HOME、JULIAUP_DEPOT_PATH、JULIA_DEPOT_PATH、VCPKG_DOWNLOADS、VCPKG_DEFAULT_BINARY_CACHE、DOTNET_ROOT、BUN_INSTALL、DENO_DIR。
   - maven localRepository 走统一挂载检查（消除唯一绕过 FAIL 的路径）。
   - **新增校准（测试中发现）**：RBENV_ROOT/DOTNET_ROOT/BUN_INSTALL 标记为 optional——它们是本体安装目录且 reference 认可"不外置是常态"，unset 不再计入漂移分母，否则每台装了 rbenv 的正常机器都会被拖成 WARN（本机就复现了这个误报）。
2. **新增"外置变量三场景一致性检查"**（采纳用户的 env 思路）：probe-cache 末节把清单内变量在 A/B/C 三种 zsh 场景下分别取值比对，抓"变量只写在 ~/.zshrc、GUI App/launchd 看不到"的隐性漂移。刻意**不做全量 `env` dump**——会把 secrets（API keys）带进审计报告，且噪音大；机制上 `${(P)var}` 与 `env` 同源，定向清单已是"最终落地值"口径。
3. **scan.sh 修订**（B7+B8+B11+B12+C15+C16）：brew cask 清单节、双 Homebrew 前缀检测、source 正则支持行内条件 source + `${HOME}`/`$ZDOTDIR` 展开、which -a 保序去重、dir_hint 补新版 fnm 默认目录/`~/opt` conda/`~/.dotnet`/`~/.swiftenv`/`~/.juliaup`、formula 正则补 `go@`/`lua@`。
4. **D2 落地**：node.md 删除 `NPM_CONFIG_PREFIX` 外置建议，§3 增判定行、§5 增"与版本管理器相克"坑；probe-cache 保留其状态上报并注明报告中要提示移除。

### 批次 2 测试证据

- 两脚本 `zsh -n` 通过；probe-cache 1.4s、scan 3.5s。
- probe-cache 本机全量：uv/pnpm/go/maven 生效值判定全部正确（17 external / 0 not-relocated / 0 scenario-drift → OK, exit 0）。
- B11 实效验证：新正则抓出旧版全部漏掉的真实链条（`zshrc.zsh -> ~/.p10k.zsh`、`.zshenv -> password.zsh`/`secrets.zsh`/`proxy.zsh` 等行内条件 source）。
- B12 实效验证：duplicate 清单首行与 `command -v` 实际生效者一致（java 首行 /usr/bin/java）。
- 三场景 WARN 路径：用假 ZDOTDIR 注入"只在 .zshrc export GOCACHE"→ 正确报 `WARN: GOCACHE differs (C 档独漂)`，exit 1；正常场景 exit 0；未挂载卷场景 exit 1。
- `go env -changed` 在 go 1.26 实测可用（不可用时代码自动回落到 env var 口径，无害）。

### 剩余事项（批次 2 时点，已被批次 3 消化，见下）

## 八、修复记录·批次 3（2026-07-18 19:15）与最终待办

用户拍板：D3 不升格（反对一统所有的工具路线）、D4 不降噪（scan 展示一切事实）、D5 不加版本比对（原则性指导定位）——三条均无代码改动，已记入 D 组表格。共识项全部落地：

| # | 内容 | 落地方式 | 状态 |
|---|---|---|---|
| E6 | 防幻觉自检清单 | `_template.md` 文末新增 7 条强制清单（命令/flag 真机或 --help 验证、env var 用 strings/官方文档验证、brew info 核渠道、默认值查当前版本文档、版本论断标注时点、新变量同步 probe-cache.sh、无法验证的标注出处）；SKILL.md references 表改为"新增或修改任何 reference 之前必读" | ✅ |
| E3 | shell 前提检查 | scan.sh 输出最顶部新增 `login shell` 节（dscl 查 UserShell，fallback $SHELL）；SKILL.md Phase 1 增两档降级策略：bash=存在性/缓存结论有效+PATH 结论注明 zsh 口径需自行对应；fish 及其他=只保留存在性/版本/缓存外置，配置分析声明未覆盖 | ✅ |
| B9 | mise 判定规则 | SKILL.md 新增"mise 不设 reference、也不进基线"段：①与专属管理器管同一语言 → 按双管理器条目二选一（通常保专属工具）②已用 mise/asdf 做全栈统一且正常 → 尊重现状，不建议同类互迁 ③Node 例外，始终首选 fnm | ✅ |
| C14 | 脚本零联网 | scan.sh 不再跑 `flutter --version`（会做更新检查、fresh clone 会下载 Dart SDK），改读 SDK 根目录 `version` 文件（`:A` 解析 fvm 符号链接）；version 文件缺失时提示用户自行运行。至此三个脚本无任何联网路径 | ✅ |

测试：`zsh -n` 通过；scan.sh 全量重跑 3.5s，login shell 节正确显示 `/bin/zsh (zsh — audit assumptions hold)`，flutter 行从 version 文件读出 `Flutter 3.27.1` 与此前 `flutter --version` 输出一致。

### 最终待办（全部为可选项，看维护意愿）

- **C13**：CLT 缺失机器上 git/swift/clang/gcc 桩触发 GUI 弹窗——开头 `xcode-select -p` 探测可免（对已装 CLT 的机器无影响，属边角防御）。
- **C17–C22**：python.md 加 `which -a pip3`、csharp.md 补 DOTNET_ROOT/PATH 持久化提示、probe-path 差异时输出各场景完整 $PATH、php.md Composer 安装方式简化、source chain 去重与深度提示、csharp/dart 的 `find .` 项目级探测与机器级定位的轻微冲突。
- **E1**：Rosetta/arch 交叉验证（`uname -m` vs brew prefix）——双 brew 检测已覆盖主场景。
- **E2**：缓存体积 `du -sh` 量化（只读可做，增强报告说服力，但会显著拉长 scan 耗时，建议做成单独的可选脚本而非进默认流程）。
- **E4**：SKILL.md 注明"`zsh -l -c` 是 GUI/launchd 的近似而非精确模型（真实 launchd 用 `launchctl getenv PATH`）"。
- **E5**：zig.md "社区事实标准"措辞软化，提及 zvm/anyzig 竞争格局。

以上无一影响正确性（正确性问题已在 A 组和批次 2/3 清零），可攒到下次功能性改动时顺带处理。建议当前状态直接 commit 作为一个稳定版本。

## 九、终审 Review（2026-07-18 20:00，批次 4）

对三批修改后的全套文件做交叉一致性复核（SKILL.md 流程 vs 脚本实际行为、references §4 变量 vs probe-cache 清单、只读/零联网承诺全链路），并按"简单直接修 / 复杂留待定"分流。

### 终审新发现（4 项，全部当场修复）

| # | 位置 | 问题 | 处理 |
|---|---|---|---|
| F1 | node.md §4 | probe-cache 核查 FNM_DIR，但 reference 从没教用户外置它（Node 版本本体的落位）——反向脱节 | ✅ §4 补 `export FNM_DIR`（注明装版本前设好） |
| F2 | lua.md §4 ↔ probe-cache | LUAROCKS_CONFIG 是 reference 推荐的外置变量，但不在 probe-cache 清单 | ✅ 加入 classify（optional 档）与三场景比对清单 |
| F3 | dart.md §2 | 探测层仍指示 agent 跑 `flutter --version`（更新检查联网、fresh clone 下载 Dart SDK）——C14 只修了 scan.sh 漏了 reference | ✅ §2 改读 SDK 根目录 version 文件（POSIX 写法，实测输出 3.27.1）；§5 注明 flutter doctor/--version 同理只许用户自己跑 |
| F4 | scan.sh | C13 原分析漏了 pip3——它也是 CLT 桩，会弹 GUI 安装框 | ✅ 纳入 probe_dev 保护 |

### 挂账简单项清零（8 项）

- **C13** ✅ scan.sh 新增 `probe_dev`：未装 CLT 时 /usr/bin 下的 python3/pip3/git/swift/clang/gcc 只登记路径不执行，杜绝 GUI 弹窗。
- **C17** ✅ python.md §2 加 `which -a pip3`（含"pip3 常独立漂移到 Xcode Python"注释）。
- **C18** ✅ csharp.md §4 补"DOTNET_ROOT + PATH 需持久写进 shell 配置"。
- **C20** ✅ php.md Composer 改 `brew install composer` 首选，官方安装器改放 `~/.local/bin` 免 sudo。
- **C21** ✅ scan.sh source chain 加 `_scan_seen` 保边去重：边仍全部展示（标 `already traversed above`），每文件只深入一次。实测副产品：`.bash_profile/.bashrc -> env.zsh` 等此前被重复展开淹没的边现在清晰可见。
- **C22** ✅ csharp/dart.md 的 `find .` 标注"项目级线索，仅当用户在项目目录运行时有意义，非机器级必查项"。
- **E4** ✅ SKILL.md Phase 3 注明 `zsh -l -c` 是 GUI/launchd 的近似模型（精确值需 `launchctl getenv PATH`），并补"深挖语言可 `probe-path.sh <cmd>` 传参"用法说明。
- **E5** ✅ zig.md 措辞软化：注明 zvm/anyzig 同级竞争、选 zigup 是采用度偏好、存量 zvm 用户按"尊重存量"原则不建议互迁、发现任一正常工作不算 WARN。

### 设计哲学落档（本批核心交付）

- SKILL.md 新增 **"设计哲学（总体指导方针）"** 章节，九条：①只探测/分析/建议、绝不执行 ②事实与解读分离（不因良性而隐藏）③每语言用领域权威工具或一工具管一类生态，反对一统所有 ④官方优先于第三方 ⑤尊重存量合理选择、半外置漂移最危险 ⑥生效值优先于配置表象、覆盖三场景 ⑦原则性指导不做精细版本管控 ⑧禁止编造（自检清单背书）⑨支持范围：macOS；zsh 完整 + bash 降级 + fish 等不支持。
- Phase 4 报告改为**固定七节（0-6）**：新增第 0 节"理念声明"——3-5 行摘要哲学（至少含 ①③⑤），注明全部建议基于此理念，不认同者本报告参考价值有限。
- shell 支持范围定案（用户拍板：仅 bash+zsh）已写入哲学第 ⑨ 条与 Phase 1 降级策略。

### 终审测试证据

三脚本 `zsh -n` 通过；scan 3.3s 全量正常（去重后 source chain 每文件展开一次、边全保留）；probe-cache / probe-path 均 exit 0；dart.md 新版本文件命令实测输出与 flutter --version 一致。

### 最终待定清单 —— ✅ 已拍板（2026-07-18，用户）：三项均不做，保持简化

| # | 事项 | 结论 |
|---|---|---|
| P1（原 C19） | probe-path 检出差异时输出各场景完整 `$PATH` | 不做——差异场景 agent 可自行追查，不预置冗余输出 |
| P2（原 E1） | Rosetta/arch 深度交叉验证 | 不做——双 brew 检测已覆盖主场景 |
| P3（原 E2） | 缓存体积 `du -sh` 量化（独立可选脚本） | 不做——维持三脚本极简结构 |

### 终审结论

正确性问题为零，文档与脚本、references 与 probe-cache 清单、只读/零联网承诺三条主线全部对齐。所有发现项均已关闭（修复或明确拍板不做），无遗留待定。本报告即为本轮 review 的完整存档。
