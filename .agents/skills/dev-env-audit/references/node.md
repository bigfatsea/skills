<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Node.js —— 权威管理器: fnm + pnpm

## 1. 基线

- 推荐工具：**fnm**（版本管理，比 nvm 快 10-40x）+ **pnpm**（包管理，官方独立安装器装）。
- 达标最小特征集：
  - `node` 解析到 fnm 管理的路径；`which -a node` 无 brew/系统份
  - `command -v pnpm` 解析到独立安装位置（不含 `fnm_multishells` 字样，见 §5）
  - nvm / volta / n 的初始化代码不在 shell 配置里生效

## 2. 深挖探测（只读）

```bash
which -a node npm pnpm

# 旧管理器
ls -d ~/.nvm 2>/dev/null
command -v volta; ls -d ~/.volta 2>/dev/null
command -v n; ls -d /usr/local/n 2>/dev/null

# init 残留
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
   export PNPM_STORE_DIR="/Volumes/<盘>/dev-cache/pnpm-store"
   export NPM_CONFIG_CACHE="/Volumes/<盘>/dev-cache/npm-cache"
   export NPM_CONFIG_PREFIX="/Volumes/<盘>/dev-cache/npm-global"
   pnpm config set store-dir "$PNPM_STORE_DIR"   # store 必须用这条命令改，环境变量/mv 目录都不生效
   ```
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
