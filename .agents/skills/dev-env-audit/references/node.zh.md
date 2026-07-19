<!-- Ver 2026-07-18 20:33, by Claude Sonnet 5 -->

# Node.js —— 权威管理器: fnm + pnpm

## 1. 基线

- 推荐工具：**fnm**（版本管理，比 nvm 快 10-40x）+ **pnpm**（包管理，官方独立安装器装）。
- **多语言全栈统一场景的备选**：已经用 ASDF 管理其他语言、更看重"一套工具、一套心智模型"而非极致速度的用户，可以用 `asdf-nodejs` 插件替代 fnm。这是"省心 vs 更快"的取舍，不是无条件的升级——ASDF 靠 shim 转发，fnm 靠环境变量直接切换，纯 Node 场景 fnm 仍然更快、启动开销更低。不要同时装两者。
- 达标最小特征集：
  - `node` 解析到 fnm（或 asdf）管理的路径；`which -a node` 无 brew/系统份
  - `command -v pnpm` 解析到独立安装位置（不含 `fnm_multishells` 字样，见 §5）
  - nvm / volta / n 的初始化代码不在 shell 配置里生效

## 2. 深挖探测（只读）

```bash
which -a node npm pnpm

# 旧管理器
ls -d ~/.nvm 2>/dev/null
command -v volta; ls -d ~/.volta 2>/dev/null
command -v n; ls -d /usr/local/n 2>/dev/null

# init 残留（先看 scan.sh 的 source chain，集中式 dotfiles 框架把 init 代码
# 放进被 source 的文件里时，字面 rc 文件 grep 落空不代表没有，把 source chain
# 上的文件也加进下面的 grep 目标）
grep -n 'NVM_DIR\|nvm.sh' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc 2>/dev/null
grep -n 'VOLTA_HOME' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null

# brew node（与 fnm 冲突，必须真卸载，不能只停用）
brew list --formula 2>/dev/null | grep -E '^node(@[0-9]+)?$'

# fnm 状态
fnm --version; fnm list 2>/dev/null; fnm current 2>/dev/null

# pnpm：路径最关键——是不是 corepack 在 fnm 版本目录里生成的 shim
command -v pnpm
pnpm config get store-dir 2>/dev/null   # store 位置只认这条命令，环境变量会骗人

# 全局包清单（迁移前要记录，迁移后逐个重装）
npm ls -g --depth=0 2>/dev/null

# NPM_CONFIG_PREFIX 是两层配置：shell 变量之外，~/.npmrc 里可能有独立持久化的一份
# （来自某次 npm config set prefix ...），只查 env 会漏掉这一层，见 §5
echo "env: ${NPM_CONFIG_PREFIX:-<unset>}"
grep -n '^prefix' ~/.npmrc 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| node 由 fnm 管、pnpm 独立安装且唯一 | OK | 达标 |
| brew node 与 fnm 并存 | FAIL | 两个 node 抢 PATH，必须卸载 brew node |
| nvm/volta/n init 代码仍生效 | FAIL | 与 fnm 抢 PATH/hook |
| ~/.nvm 等目录残留但 init 已删 | WARN | 无害残留，确认后可删 |
| `command -v pnpm` 含 `fnm_multishells` 或 fnm 版本目录 | WARN | corepack shim 抢占了独立 pnpm（见 §5），调 PATH 顺序 |
| 只有 brew node、无任何管理器 | WARN | 可用但非推荐；单版本用户风险低，多项目多版本必坑 |
| yarn/npm/pnpm 混用全局包 | WARN | 建议全局包统一到 pnpm |
| NPM_CONFIG_PREFIX 已设且在用 fnm/nvm 等版本管理器 | WARN | 全局包脱离按版本隔离，native module 切 Node 版本即坏（见 §5）；建议直接移除该变量，让 fnm 恢复默认按版本隔离——同时查 `~/.npmrc` 里有没有独立持久化的 `prefix=`（两处都要删才生效，见 §5）。"迁去 pnpm 全局"不是这条的解法，pnpm 的 global 目录同样是固定路径、不提供按版本隔离 |
| 顶层 rc 文件 grep 落空，但 source chain 上的文件里能 grep 到 NVM_DIR/VOLTA_HOME | FAIL | 逻辑藏在集中管理的文件里，不是没有 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套，**务必先 `npm ls -g --depth=0` 记下全局包**。
2. **装 fnm + pnpm**：
   ```bash
   curl -fsSL https://fnm.vercel.app/install | bash     # 或 brew install fnm
   curl -fsSL https://get.pnpm.io/install.sh | sh -     # pnpm 用官方独立安装器，不要依赖 corepack
   ```
   pnpm 安装脚本默认会往 `~/.zshrc` 追加配置——若用户采用集中配置管理，提醒检查并把内容挪到自己的配置文件。
   ```bash
   fnm install --lts
   fnm default <version>
   ```
3. **处理旧的**：
   - brew node：**必须真卸载** `brew uninstall node`（留着必抢 PATH）。
   - nvm/volta/n：删掉/注释 shell 配置里对应初始化代码即可，不必卸载本体。
   - 全局 npm 包：按第 1 步清单 `pnpm install -g <pkg>` 逐个重装；pnpm 版验证可用后，再 `npm uninstall -g <pkg>` 清理旧副本（破坏性，逐个确认）。
4. **【可选】外置存储**：
   ```bash
   export FNM_DIR="/Volumes/<盘>/dev-cache/fnm"    # Node 版本本体的落位,装第一个版本之前设好
   export NPM_CONFIG_CACHE="/Volumes/<盘>/dev-cache/npm-cache"
   pnpm config set store-dir "/Volumes/<盘>/dev-cache/pnpm-store"   # store 必须用这条命令改，环境变量/mv 目录都不生效
   ```
   **不要设 `NPM_CONFIG_PREFIX`**：它把 npm 全局包钉进单一目录，破坏 fnm 的按 Node 版本隔离（见 §5）。已设的建议移除——**但要查两处**：shell 里的 `export NPM_CONFIG_PREFIX=...` 之外，`~/.npmrc` 里也可能有一行独立持久化的 `prefix=...`（来自某次 `npm config set prefix ...`），只删环境变量、这行不删，npm 依然会读到旧值。`grep -n '^prefix' ~/.npmrc` 先查一下。"全局工具改走 pnpm" 不是这条的解法，见 §5。
5. **验证**：
   ```bash
   node -v; npm -v; pnpm -v
   command -v node pnpm      # node 应在 fnm 路径；pnpm 不应含 fnm_multishells
   pnpm config get store-dir
   ```

## 5. 已知坑

- **corepack pnpm shim**：只要在 fnm 管理的 Node 下跑过 `corepack pnpm ...`，corepack 就会在**该 Node 版本自己的 bin 目录**生成一个 pnpm shim。它和独立安装的 pnpm 是两个东西，谁生效看 PATH 顺序。`command -v pnpm` 结果里出现 `fnm_multishells` 即中招——把 pnpm 独立安装目录（如 `~/Library/pnpm`）在 PATH 里挪到 fnm 目录之前。
- **pnpm store 位置三不认**：不认环境变量、不认直接 mv 目录、只认 `pnpm config set store-dir`。
- **brew node 是"必须卸"而非"停用即可"**：它把 node/npm 装进 `/opt/homebrew/bin`，那个目录必然在 PATH 里，无 init 代码可删，唯一解法是卸载。
- **pnpm 安装脚本加料 ~/.zshrc**：装完检查有没有被追加配置块。
- **NPM_CONFIG_PREFIX 与版本管理器相克**：固定全局 prefix 后，`npm -g` 装的 native module 绑定安装时那个 Node 版本的 ABI，fnm 一切版本就坏；nvm 干脆检测到就直接报错拒绝工作。真正的解法是移除这个变量，让 fnm 恢复默认的"每个 Node 版本各自独立 global 目录"——**不是"改走 pnpm"**：pnpm 的全局目录（`pnpm root -g`，实测不随 fnm 当前 Node 版本变化）跟 npm 固定 prefix 是同一种结构（单一、与 Node 版本无关的固定目录），对含 native binding 的包一样没有 ABI 免疫力，只是把风险从 npm 的目录搬到 pnpm 的目录。判断某个全局包该不该担心：看它是否含 `.node` 文件/`binding.gyp`（纯 JS 包、或自带独立可执行文件不经 `require()` 加载的包不受影响）。
- **NPM_CONFIG_PREFIX 是两层配置，不是一层**：`export NPM_CONFIG_PREFIX=...`（shell 变量）之外，`npm config set prefix <path>` 会把同样的值持久化写进 `~/.npmrc` 的 `prefix=` 行——这是独立于 shell 环境变量的第二个来源。移除时只删 shell 变量、不检查 `~/.npmrc`，npm 依然会读到 `~/.npmrc` 里的旧值。`npm config get prefix` 只能看到当前生效值，看不出来自哪一层；用 `grep -n '^prefix' ~/.npmrc` 或 `npm config list -l` 才能定位。判定和迁移步骤都必须两处一起查（已同步进 §2/§3/§4）。
