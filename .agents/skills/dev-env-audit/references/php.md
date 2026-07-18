<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# PHP —— 权威管理器: Homebrew（单版本）/ ASDF（多版本或多语言全栈统一）

## 1. 基线

- **单版本场景**：`brew install php` 即可，简单直接。
- **多版本场景**：Homebrew 也能并行装 `php@8.1`/`php@8.3` 这类具体版本（都是 keg-only，不会互相覆盖 PATH），但切换需要手动 `brew link/unlink`，不如版本管理器顺手；已经用 ASDF 管理其他语言的多语言全栈开发者，直接用 `asdf-php` 插件统一体验更好。
- 达标最小特征集：
  - `php --version` 解析到预期版本
  - 没有 brew 装的多个 php 版本互相 unlink/link 导致的当前版本不确定状态

## 2. 深挖探测（只读）

```bash
which -a php
php --version

# brew 侧装了哪些版本
brew list --formula 2>/dev/null | grep -E '^php(@[0-9.]+)?$'
brew list --versions php 2>/dev/null

# asdf 侧（如果在用）
asdf current php 2>/dev/null
asdf list php 2>/dev/null

composer --version 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| php 唯一来源（brew 或 asdf），版本符合预期 | OK | 达标 |
| brew 装了多个 php@x.y 但没手动 link 任何一个 | WARN | 所有版本都 keg-only，`php` 命令可能解析不到预期版本或直接找不到，需要显式 `brew link php@x.y` |
| asdf php 与 brew php 同时被当作权威 | WARN | 两者可以不冲突共存（后装的 keg-only php@x.y 不会抢 PATH），但容易搞不清"现在到底是哪个在生效"，建议统一 |
| Composer 缺失，项目有 `composer.json` | WARN | 依赖管理没跑起来，装 Composer |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装权威管理器**：
   ```bash
   # 单版本 / 需要具体版本共存
   brew install php@8.3
   brew link --force php@8.3   # 需要它成为默认 php 命令时执行

   # 多语言全栈统一
   asdf plugin add php
   asdf install php <version>
   asdf set --global php <version>
   ```
   Composer（两条路径都需要）：
   ```bash
   curl -sS https://getcomposer.org/installer | php
   sudo mv composer.phar /usr/local/bin/composer
   ```
3. **处理旧的**：多余的 brew php 版本 `brew unlink php@<旧版本>`，不需要卸载（除非确认不再需要）。
4. **【可选】外置存储**：Composer 的全局缓存可以外置：
   ```bash
   export COMPOSER_CACHE_DIR="/Volumes/<盘>/dev-cache/composer-cache"
   ```
5. **验证**：
   ```bash
   php --version; which php
   composer --version
   ```

## 5. 已知坑

- **brew 的 versioned php@x.y formula 全部 keg-only**：装了不会自动出现在 PATH 上，必须 `brew link` 才会有 `php` 命令，这是 Homebrew 特意设计的（避免多个 php 版本互相覆盖），不是 bug。
- **切换 php 版本后扩展要重装**：xdebug 等 PHP 扩展是按版本编译的，`brew link` 切换默认版本后，之前装的扩展在新版本下不一定可用，需要针对新版本重新安装。
- **Composer 全局依赖和项目依赖分开**：`composer global require` 装的是全局工具，和项目 `composer.json` 里的依赖是两回事，别混着排查问题。
