<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Lua —— 权威管理器: Homebrew（单版本）/ ASDF（多版本）

## 1. 基线

- **单版本场景**：`brew install lua` 即可。Lua 生态没有强势的专属版本管理器（不像 Python 有 uv、Ruby 有 rbenv），社区没有形成"必须用某个专用工具"的共识。
- **多版本场景**：`asdf-lua` 插件是多语言统一场景下的通用最优解。
- 达标最小特征集：
  - `lua -v` 解析到预期版本
  - 没有系统自带 lua（部分 Linux 发行版/macOS 历史版本自带）和 brew/asdf 装的版本互相冲突

## 2. 深挖探测（只读）

```bash
which -a lua lua5.1 lua5.3 lua5.4
lua -v

brew list --formula 2>/dev/null | grep -E '^lua(@[0-9.]+)?$'
asdf current lua 2>/dev/null
asdf list lua 2>/dev/null

luarocks --version 2>/dev/null
luarocks config lua_version 2>/dev/null   # luarocks 是按 Lua 版本区分 rocks 目录的
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| lua 唯一来源，版本符合预期 | OK | 达标 |
| brew lua 与 asdf lua 同时存在 | WARN | 不一定冲突（取决于谁在 PATH 前面），但容易混淆当前生效版本，建议统一到一个 |
| 版本是 5.1 但项目/依赖要求 5.3/5.4（或反之） | FAIL | Lua 大版本之间有真实的语言不兼容（不像多数语言的小版本升级），不是简单的"新版本更好" |
| LuaRocks 装的 rocks 在切换 Lua 版本后找不到 | INFO | LuaRocks 的 rocks 目录是按 Lua 版本分开的，切版本后需要重新安装依赖，不是丢失 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套，**注意确认项目实际需要哪个 Lua 大版本**（5.1/5.3/5.4 互不兼容）。
2. **装权威管理器**：
   ```bash
   # 单版本
   brew install lua

   # 多语言全栈统一
   asdf plugin add lua
   asdf install lua <version>
   asdf set --global lua <version>
   ```
3. **处理旧的**：确认系统自带的 lua（如有）不在 PATH 前排，不需要卸载（通常也卸不掉）。
4. **【可选】外置存储**：
   ```bash
   export LUAROCKS_CONFIG="/Volumes/<盘>/dev-cache/luarocks/config.lua"   # 需要在 config 文件里指定 rocks_trees 路径
   ```
5. **验证**：
   ```bash
   lua -v; which lua
   luarocks --version
   ```

## 5. 已知坑

- **Lua 大版本之间不兼容**：5.1→5.2→5.3→5.4 每次大版本都有真实的语法/语义变化（不是简单的新特性叠加），装错大版本会导致脚本直接报语法错误，排查时第一步永远是确认版本号对不对，而不是怀疑代码本身。
- **LuaRocks 的 rocks 目录按 Lua 版本分离**：切换 Lua 版本后看起来"包都不见了"，其实是装在另一个版本的目录里，需要针对新版本重新 `luarocks install`。
