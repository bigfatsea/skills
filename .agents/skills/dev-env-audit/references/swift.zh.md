<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Swift / Objective-C —— 权威管理器: Xcode 自带（多版本靠多个 Xcode.app + xcode-select）

## 1. 基线

- 推荐工具：**Xcode 自带的工具链**。绝大多数 Swift/Objective-C 开发是 iOS/macOS App 开发，Swift 版本和 Xcode 版本强绑定（每个 Xcode 版本只搭配特定范围的 Swift 版本），独立于 Xcode 单独切换 Swift 版本的场景很少见。
- **多版本场景**：装多个 `Xcode.app`（改名区分，如 `Xcode-15.app`/`Xcode-16.app`），用 `xcode-select -s` 切换系统默认，或 `xcrun --toolchain` 做单次调用级别的切换，不改全局默认。这是 Apple 官方支持、也是业界标准做法——覆盖模拟器、签名工具、Interface Builder 等 Xcode 全套工具链，第三方工具（如 swiftenv、asdf-swift）覆盖不到这些。
- **例外**：纯服务端/跨平台 Swift（Linux 环境，不涉及 Xcode）用 `swiftenv` 或官方 swift.org 工具链快照更合适——这条 reference 主要针对 macOS 上的 Apple 平台开发。
- 达标最小特征集：
  - `xcode-select -p` 指向预期的 Xcode.app
  - `swift --version` 和当前 `xcode-select` 选中的 Xcode 版本一致

## 2. 深挖探测（只读）

```bash
xcode-select -p
swift --version
xcodebuild -version

# 系统里装了几个 Xcode
ls -d /Applications/Xcode*.app 2>/dev/null

# 是否用了第三方 swift 版本管理（跨平台/服务端场景）
command -v swiftenv; ls -d ~/.swiftenv 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| 只有一个 Xcode，`xcode-select -p` 指向它 | OK | 达标，单版本场景 |
| 多个 Xcode.app 共存，`xcode-select -p` 指向预期的那个 | OK | 达标，多版本场景 |
| 多个 Xcode.app 共存，但 `swift --version` 和预期不符 | WARN | `xcode-select` 选错了，或某处用了 `DEVELOPER_DIR` 环境变量覆盖 |
| 纯服务端 Swift 场景装了 swiftenv | OK | 这条场景 swiftenv 合理，不要套用 Xcode 那一套判定 |
| asdf-swift 插件在管理版本 | WARN | 该插件非官方、维护活跃度低，Apple 平台开发场景不推荐；服务端场景建议换 swiftenv 或官方工具链快照 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装/切换 Xcode**：从 App Store 或 developer.apple.com 下载所需版本，重命名后放进 `/Applications`，然后：
   ```bash
   sudo xcode-select -s /Applications/Xcode-16.app
   sudo xcodebuild -license accept   # 切换到未接受过许可的新 Xcode 版本时需要
   ```
3. **处理旧的**：多个 Xcode.app 本身不冲突，可以并存；只在磁盘紧张时删除不用的版本（Xcode 单个体积可达十几 GB）。
4. **【可选】外置存储**：Xcode.app 本身不建议放外置盘（首次启动会做本地组件安装，外置盘掉线会导致 Xcode 打不开）；模拟器运行时（Simulator runtimes）体积大，可以在 Xcode 设置里单独清理，不属于"外置"范畴。
5. **验证**：
   ```bash
   xcode-select -p; swift --version; xcodebuild -version
   ```

## 5. 已知坑

- **`sudo xcode-select -s` 影响全系统**：这是系统级切换，不是当前 shell 级别；如果只想给单次命令换工具链，用 `xcrun --toolchain <identifier> -- <command>`，不要动全局默认。
- **切换到新 Xcode 版本必须先接受许可**：不接受许可（`sudo xcodebuild -license accept`）会导致 `xcodebuild`/`swift` 等命令直接报错拒绝执行。
- **`DEVELOPER_DIR` 环境变量会覆盖 `xcode-select` 的选择**：CI 环境或某些 shell 配置里设了这个变量，会让 `xcode-select -p` 显示的和实际生效的 Xcode 对不上，深挖时要一并检查 `echo $DEVELOPER_DIR`。
