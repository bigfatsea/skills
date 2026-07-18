<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# C# / .NET —— 权威管理器: 官方 dotnet-install（单/多版本统一一套）

## 1. 基线

- 推荐工具：**官方 `dotnet-install` 脚本**（微软发布，`https://dot.net/v1/dotnet-install.sh`）。.NET SDK 原生支持多个 SDK 版本并存于同一台机器（各版本装在独立目录下，互不覆盖），项目级版本靠 `global.json` 里的 `sdk.version` 字段钉死，第三方版本管理器没有必要也没有竞争力。
- 达标最小特征集：
  - `dotnet --list-sdks` 能看到预期版本
  - 没有项目要求的 SDK 版本缺失导致的 `global.json` 解析失败
  - 没有同时存在的、互相冲突的手动 PATH 覆盖（比如 brew dotnet 和官方安装各装一份都往 PATH 顶层塞）

## 2. 深挖探测（只读）

```bash
which -a dotnet
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes

# brew 侧是否也装了一份（两者都会话跑起来，但装两份容易版本对不齐）
brew list --formula 2>/dev/null | grep -E '^dotnet'

# 项目级线索:仅当用户在项目目录里运行审计时有意义,不是机器级必查项
find . -maxdepth 2 -name 'global.json' 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| dotnet 唯一来源（官方安装器或 brew 二选一），`--list-sdks` 有预期版本 | OK | 达标 |
| 官方安装器和 brew dotnet 都装了 | WARN | 不是致命冲突（.NET SDK 本身支持多版本共存），但两个安装源容易版本管理混乱，建议统一成一个 |
| 项目有 `global.json` 但 pin 的 SDK 版本未安装 | FAIL | `dotnet build` 会直接报错缺 SDK，需要 `dotnet-install` 补装对应版本 |
| 只有一个版本、无 global.json 需求 | OK | 单项目场景足够 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装官方 dotnet-install**：
   ```bash
   curl -sSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
   chmod +x dotnet-install.sh
   ./dotnet-install.sh --channel LTS          # 或 --version <具体版本>
   ```
   默认装进 `~/.dotnet`，脚本会提示把 `~/.dotnet` 加进 PATH。
3. **处理旧的**：如果之前是 `brew install dotnet`，确认没有项目依赖 brew 那份的具体路径后 `brew uninstall dotnet`，避免两个安装源都在维护。
4. **【可选】外置存储**：
   ```bash
   export DOTNET_ROOT="/Volumes/<盘>/dev-cache/dotnet"   # dotnet-install 支持 --install-dir 参数指定
   ./dotnet-install.sh --channel LTS --install-dir "$DOTNET_ROOT"
   ```
   装到自定义目录后，`DOTNET_ROOT` 的 export 和 `PATH` 里加 `$DOTNET_ROOT` 都要**持久写进 shell 配置**，否则新终端里找不到 `dotnet` 命令。
5. **验证**：
   ```bash
   dotnet --version; dotnet --list-sdks
   which dotnet
   ```

## 5. 已知坑

- **global.json 版本钉死后找不到 SDK 会直接报错**：不像 Go 的 GOTOOLCHAIN 会自动下载，.NET 找不到 `global.json` 要求的 SDK 版本时是硬报错，需要手动用 `dotnet-install --version <版本>` 补装。
- **多安装源版本对不齐**：brew 的 dotnet formula 更新节奏和微软官方发布不同步，混用两个安装源容易出现"本地能跑、CI 环境报 SDK 版本不匹配"的问题。
