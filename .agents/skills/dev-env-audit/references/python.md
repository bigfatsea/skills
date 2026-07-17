<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Python —— 权威管理器: uv

## 1. 基线

- 推荐工具：**uv**（取代 pyenv + pip + venv + pipx + poetry 的单一权威；业界 2026 共识）。
- 达标最小特征集：
  - `command -v uv` 有，且 `which -a uv` 只有一份
  - shell 配置里没有 pyenv init / conda initialize 代码在生效
  - 非交互场景下 `python3` 不落到 `/usr/bin/python3`（或已知情接受系统版兜底）

## 2. 深挖探测（只读）

```bash
# PATH 上有几个 python，分别是谁
which -a python python3

# uv 本体：路径、版本、是否多份共存（CARGO_HOME 坑，见 §5）
which -a uv
uv --version
uv python list --only-installed
uv tool list
uv cache dir

# 旧管理器：pyenv / conda / pipx / python.org pkg
command -v pyenv && ls ~/.pyenv/versions 2>/dev/null
ls -d ~/miniconda3 ~/anaconda3 ~/miniforge3 2>/dev/null
command -v pipx && pipx list 2>/dev/null
ls /Library/Frameworks/Python.framework/Versions 2>/dev/null   # python.org .pkg 装的；zsh 下别用 glob(无匹配时报错)

# init 残留（冲突的最常见根源：以为卸载了，其实初始化代码还在）
grep -n 'pyenv init' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc 2>/dev/null
grep -n 'conda initialize' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc 2>/dev/null

# brew python（可留作依赖层，但不该在 PATH 顶层被直接用）
brew list --formula 2>/dev/null | grep -i python

# 非交互解析（alias 只在交互 shell 生效，脚本/cron/subprocess 看的是这个）
zsh -c 'command -v python3; python3 -V'
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| uv 唯一、无 pyenv/conda init 生效 | OK | 达标 |
| uv 与 pyenv init 并存生效 | FAIL | pyenv shim 目录抢 PATH，python3 解析漂移 |
| conda initialize 块仍在 shell 配置 | FAIL | conda 改 PATH 且注册 hook，与 uv 打架 |
| ~/.pyenv 或 conda 目录残留但 init 已删 | WARN | 无害残留，建议确认后删除释放空间 |
| pipx 仍在管全局工具 | WARN | 建议逐个 `uv tool install` 重装后弃用 pipx |
| `which -a uv` 多于一份 | FAIL | 版本可能停在旧的那份而不自知（见 §5 CARGO_HOME 坑） |
| brew python 存在但不在 PATH 顶层 | OK | 分层不交叉：留给依赖它的 brew formula 用，不动它 |
| brew python 在 PATH 顶层且 uv 存在 | WARN | PATH 顺序问题，应让 uv 管的 python 优先 |
| 无 uv，仅一份 brew/系统 python | WARN | 可用但非推荐；给迁移方案 |
| 非交互 `python3` 落到 /usr/bin/python3 且用户有脚本场景 | WARN | 见 §5 alias 坑，建议 `uv python install --default` 兜底 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 uv**：
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   装完新开终端确认：`command -v uv`（通常 `~/.local/bin/uv`；若设过 `CARGO_HOME` 则可能在 `$CARGO_HOME/bin`，见 §5）。
3. **处理旧的**：
   - pyenv：可不卸载，但**必须**删掉/注释 shell 配置里 `eval "$(pyenv init -)"` 等初始化代码。
   - conda：注释掉 `# >>> conda initialize >>>` 整块。
   - pipx 全局工具：`pipx list` 记下清单，逐个 `uv tool install <pkg>` 重装（重装比迁移数据干净）。
   - brew python：**留着不动**——给依赖它的 brew formula 当依赖，只要不进 PATH 顶层、不往里 pip install。
4. **【可选】外置存储**（必须在第一次用 uv 装东西**之前**设好；事后改变量不会搬家）：
   ```bash
   export UV_CACHE_DIR="/Volumes/<盘>/dev-cache/uv_cache"
   export UV_PYTHON_INSTALL_DIR="/Volumes/<盘>/dev-cache/uv_pythons"
   export UV_VIRTUALENV_DIR="/Volumes/<盘>/dev-cache/uv_venvs"
   export UV_TOOL_DIR="/Volumes/<盘>/dev-cache/uv_tools"
   ```
5. **验证**：
   ```bash
   which python; python -V
   uv python list --only-installed
   uv tool list
   zsh -c 'command -v python3; python3 -V'   # 非交互场景单独验
   ```

## 5. 已知坑

- **CARGO_HOME 劫持安装位置**：uv 官方安装脚本探测到 `CARGO_HOME` 会把自己装进 `$CARGO_HOME/bin` 而非 `~/.local/bin`。若之后又在别处装了一份，两份互不知情，PATH 顺序决定谁生效，版本可能停在旧的。装完必跑 `which -a uv`，多于一份只留一个。
- **alias 只在交互 shell 生效**：`alias python="uv run python"` 覆盖不了 shebang / Makefile / `subprocess` / cron。非交互场景要用 `uv python install <version> --default` 在 uv bin 目录生成无版本号的 `python`/`python3` 符号链接兜底。两者分工不同，别指望一个机制覆盖两种场景。
- **UV_* 变量不搬家**：改了安装/缓存目录变量，已装的 Python 版本和已建的 venv 留在原地，现有 venv 还指向旧解释器路径（uv 官方文档明示），需要手动重建。
- **系统 /usr/bin/python3 很旧且有限制**：解析到它通常不是用户想要的。
