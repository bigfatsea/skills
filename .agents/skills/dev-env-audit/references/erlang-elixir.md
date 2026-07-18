<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Erlang / Elixir —— 权威管理器: ASDF（asdf-erlang + asdf-elixir，单/多版本都推荐）

## 1. 基线

- 推荐工具：**ASDF**（`asdf-erlang` + `asdf-elixir` 两个插件配套使用），**即使只用一个版本也推荐**，不是"多版本才需要"。
- 为什么单版本也不推荐 Homebrew：OTP（Erlang 虚拟机）和 Elixir 之间有严格的版本兼容矩阵（见 hexdocs.pm/elixir 的 Compatibility and Deprecations 页面），Homebrew 装的系统 OTP 版本经常和目标 Elixir 版本要求的范围对不上，报错通常是隐晦的运行时/编译错误，不是清晰的"版本不兼容"提示——ASDF 能显式钉死两者的搭配版本，容错性明显更高。
- 达标最小特征集：
  - `erl -eval 'halt().' -noshell` 之类的探测能确认 OTP 版本
  - `elixir --version` 显示的 Elixir/OTP 搭配落在官方兼容矩阵范围内
  - `.tool-versions` 里 erlang 和 elixir 两行版本号是匹配的搭配

## 2. 深挖探测（只读）

```bash
which -a erl elixir mix

elixir --version 2>&1
erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().' 2>/dev/null

asdf current erlang 2>/dev/null
asdf current elixir 2>/dev/null

brew list --formula 2>/dev/null | grep -E '^(erlang|elixir)$'

# 项目锁定的版本搭配
cat .tool-versions 2>/dev/null | grep -E 'erlang|elixir'
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| asdf 管理 erlang+elixir，两者搭配落在官方兼容矩阵内 | OK | 达标 |
| brew erlang/elixir 装的版本搭配不在官方兼容矩阵内 | FAIL | 大概率触发隐晦的运行时错误，需要重新按矩阵搭配安装 |
| `.tool-versions` 只写了 elixir 没写 erlang（或反之） | WARN | 两者必须配套钉版本，只写一个会跟着 asdf 全局/系统默认走，容易漂移 |
| asdf 与 brew 装的 erlang/elixir 同时存在 | WARN | 谁生效取决于 PATH 顺序，建议统一到 asdf |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套，**务必先查官方兼容矩阵确认目标版本搭配**（hexdocs.pm/elixir/compatibility-and-deprecations.html）。
2. **装 asdf 插件**：
   ```bash
   asdf plugin add erlang
   asdf plugin add elixir
   asdf install erlang <version>
   asdf install elixir <version>
   asdf set --global erlang <version>
   asdf set --global elixir <version>
   ```
3. **处理旧的**：
   ```bash
   brew uninstall erlang elixir   # 之前 brew 装的
   ```
4. **【可选】外置存储**：
   ```bash
   export ASDF_DATA_DIR="/Volumes/<盘>/dev-cache/asdf"   # 必须在装插件之前设好，erlang/elixir 都装在这下面
   ```
5. **验证**：
   ```bash
   elixir --version
   erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().'
   asdf current erlang; asdf current elixir
   ```

## 5. 已知坑

- **OTP/Elixir 版本必须配套，不能各自为政**：官方有明确的兼容矩阵，装了不匹配的搭配不会在安装阶段报错，而是在实际编译/运行项目时才暴露，排查成本高，装之前先查矩阵比装完再排查省事得多。
- **Rebar3（Erlang 的构建工具）有时需要单独安装**：不是所有 asdf-erlang 安装都会自动带上 Rebar3，缺失时用 `mix local.rebar` 或参考 rebar3 官方安装说明单独补装。
