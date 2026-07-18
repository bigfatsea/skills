<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Julia —— 权威管理器: juliaup（官方）

## 1. 基线

- 推荐工具：**juliaup**。JuliaLang 官方自 2022 年起维护并主推的安装器/版本管理器（github.com/JuliaLang/juliaup），julialang.org 官方下载页现在直接引导装 juliaup，生态里没有与之竞争的替代方案。
- 达标最小特征集：
  - `julia --version` 解析到 juliaup 管理的版本
  - `juliaup status` 能看到明确的 default channel/版本

## 2. 深挖探测（只读）

```bash
which -a julia juliaup
julia --version
juliaup status 2>/dev/null

# 是否有手动装的旧版本残留（早期常见做法：下载 .dmg 或 tarball 手动装到 /Applications 或 ~/julia）
ls -d /Applications/Julia-*.app ~/julia 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| julia 由 juliaup 管理且唯一 | OK | 达标 |
| 手动装的 Julia（.app 或 tarball）与 juliaup 版本共存 | WARN | 谁生效取决于 PATH 顺序，建议统一到 juliaup |
| 只有手动装的旧版本，无 juliaup | WARN | 可用但版本升级/切换麻烦，建议迁移 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 juliaup**：
   ```bash
   curl -fsSL https://install.julialang.org | sh
   juliaup add release       # 装最新稳定版
   juliaup default release
   ```
3. **处理旧的**：手动装的 Julia.app 或 tarball，确认没有项目硬编码指向它的具体路径后可以删除。
4. **【可选】外置存储**：juliaup 支持通过 `JULIAUP_DEPOT_PATH`/`JULIA_DEPOT_PATH` 调整包和编译缓存的落位，装前设好。
5. **验证**：
   ```bash
   julia --version; which julia
   juliaup status
   ```

## 5. 已知坑

- **juliaup 的 channel 概念**：`juliaup add release`/`lts`/`nightly` 装的是"频道"而不是死版本号，`juliaup status` 才能看到频道实际解析到的具体版本，别只看 `julia --version` 就以为版本是手动钉死的。
- **手动装的旧版本容易被遗忘在 /Applications**：Julia 早期官方分发方式就是 .dmg，很多人机器上还留着这种手动装的版本，会和后来装的 juliaup 冲突。
