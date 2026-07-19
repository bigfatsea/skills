<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# Dart / Flutter —— 权威管理器: 官方 SDK（单版本）/ fvm（多版本）

## 1. 基线

- **单版本场景**：直接装官方 Flutter SDK（自带 Dart，flutter.dev 下载或 `git clone` flutter 仓库）。不需要引入额外工具——fvm 是为"多项目各自锁定不同 Flutter 版本"设计的，单版本用户装它属于过度设计。
- **多版本场景**：**fvm**（Flutter Version Management）是 Flutter 社区事实标准，虽非 Google 官方发布，但被广泛采纳，支持按项目锁定版本、`.fvmrc`/`.fvm/` 目录标识。
- 达标最小特征集：
  - `flutter --version` 解析到预期版本
  - 多项目场景下每个项目实际用的是 `.fvm/flutter_sdk` 指向的版本，不是全局默认版本

## 2. 深挖探测（只读）

```bash
which -a flutter dart fvm
dart --version

# 不要跑 flutter --version:它会做更新检查(联网),fresh clone 上首次运行还会下载
# 整个 Dart SDK——版本从 SDK 根目录的 version 文件读(flutter 命令在 <SDK>/bin/ 下):
cat "$(dirname "$(dirname "$(command -v flutter)")")/version" 2>/dev/null

fvm list 2>/dev/null

# 项目级线索:仅当用户在项目目录里运行审计时有意义,不是机器级必查项
find . -maxdepth 2 -name '.fvmrc' -o -maxdepth 2 -path '*/.fvm' 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| 单版本场景，官方 SDK 唯一 | OK | 达标，不需要 fvm |
| 多版本场景，fvm 管理且项目都有 `.fvmrc`/`.fvm` | OK | 达标 |
| 多个项目需要不同 Flutter 版本，但只有一个全局 SDK、无 fvm | WARN | 容易出现"这个项目在别人机器上能跑,我这里报错"的版本漂移问题 |
| fvm 装了但某项目没有 `.fvmrc`，用的是全局版本 | INFO | 不一定是问题，确认该项目是否真的不需要锁版本 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装权威管理器**：
   ```bash
   # 单版本：官方 SDK
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"

   # 多版本：fvm
   brew tap leoafarias/fvm && brew install fvm
   fvm install stable
   fvm use stable            # 在项目目录内执行，生成 .fvmrc/.fvm
   ```
3. **处理旧的**：如果之前是手动装的多份 Flutter SDK（不同目录代表不同版本，手动切 PATH），迁移到 fvm 后可以删除，改用 `fvm install <version>` 统一管理。
4. **【可选】外置存储**：fvm 的版本缓存目录可以通过 `FVM_HOME` 环境变量调整，装前设好。
5. **验证**：
   ```bash
   flutter --version; dart --version
   fvm list
   flutter doctor
   ```

## 5. 已知坑

- **fvm 是项目级锁定，不是全局替代**：`fvm use` 是在具体项目目录下执行的，生成的 `.fvm` 软链接只对该项目生效，不要指望装了 fvm 就自动解决全局版本问题——它解决的是"不同项目要不同版本"这个问题。
- **`flutter doctor` 是权威验证入口**：任何版本/工具链问题优先跑这个命令，它会检查 Xcode/Android Studio/CocoaPods 等一整套外围依赖，不只是 Flutter 本身的版本。注意它和 `flutter --version` 一样会联网（更新检查/首次初始化下载 Dart SDK），所以只出现在 §4/§5 让**用户自己跑**，审计探测阶段禁止执行。
