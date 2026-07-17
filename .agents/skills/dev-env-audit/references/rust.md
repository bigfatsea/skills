<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Rust —— 权威管理器: rustup

## 1. 基线

- 推荐工具：**rustup**（Rust 官方一等公民版本管理，连 mise 作者都承认"better DX than what mise likely could ever accomplish"）。
- 达标最小特征集：
  - `which -a rustc cargo` 各只有一份，解析到 `$CARGO_HOME/bin`（默认 `~/.cargo/bin`）
  - 无 brew rust 并存

## 2. 深挖探测（只读）

```bash
which -a rustc cargo rustup
rustc --version; cargo --version
rustup show 2>/dev/null

# 并存渠道
brew list --formula 2>/dev/null | grep -E '^rust$'

# 家目录落位（外置检查）
echo "RUSTUP_HOME=${RUSTUP_HOME:-<unset, default ~/.rustup>}"
echo "CARGO_HOME=${CARGO_HOME:-<unset, default ~/.cargo>}"
ls -d ~/.rustup ~/.cargo 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| rustup 管理、rustc/cargo 唯一 | OK | 达标 |
| brew rust 与 rustup 并存 | FAIL | 抢 PATH，卸载 brew rust |
| 只有 brew rust、无 rustup | WARN | 可用但没有 toolchain/组件管理能力，建议迁移 |
| RUSTUP_HOME/CARGO_HOME 一个外置一个默认 | WARN | 漂移，两个变量应同进退 |
| CARGO_HOME 已设且 uv 也装在 $CARGO_HOME/bin | INFO | 不是错误，但要让用户知道 uv 装哪了（联动坑见 python.md §5） |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 rustup**（外置者先做第 4 步再装）：
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
3. **处理旧的**：
   ```bash
   brew uninstall rust      # 之前 brew 装的
   ```
4. **【可选】外置存储**（**必须在安装之前设好**，装完再改不搬家）：
   ```bash
   export RUSTUP_HOME="/Volumes/<盘>/dev-cache/rustup"
   export CARGO_HOME="/Volumes/<盘>/dev-cache/cargo"
   ```
5. **验证**：
   ```bash
   rustc --version; cargo --version
   which rustc cargo        # 应指向 $CARGO_HOME/bin
   ```

## 5. 已知坑

- **RUSTUP_HOME / CARGO_HOME 装前生效**：rustup 安装脚本装的时候读这两个变量决定落位；装完再改，工具链不会搬家。
- **CARGO_HOME 影响的不只是 Rust**：uv 官方安装脚本探测到 `CARGO_HOME` 会把 uv 装进 `$CARGO_HOME/bin`（详见 python.md §5）。审计时发现 CARGO_HOME 已设，要顺带检查 `which -a uv`。
- **PATH 注入方式**：rustup 靠 `$CARGO_HOME/env` 或安装时写入 shell 配置把 `$CARGO_HOME/bin` 加进 PATH；集中配置管理的用户注意安装脚本是否往 `~/.zshrc` 加了料。
