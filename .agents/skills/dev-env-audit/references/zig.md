<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Zig —— 权威管理器: zigup（社区事实标准）

## 1. 基线

- 推荐工具：**zigup**。注意它不是 Zig 核心团队发布的官方工具，而是社区项目，但因为 Zig 本身还在 0.x 阶段、版本迭代快，社区已经把它当成事实标准使用——ziglang.org 官方文档也会引用类似工具管理版本切换的做法。
- 达标最小特征集：
  - `zig version` 解析到 zigup 管理的版本
  - 没有手动下载解压的 zig 二进制和 zigup 管理的版本同时挂在 PATH 上

## 2. 深挖探测（只读）

```bash
which -a zig zigup
zig version
zigup list 2>/dev/null

# 是否有手动下载解压装的 zig（常见做法：解压到 ~/zig 或 /usr/local/zig 再手动加 PATH）
ls -d ~/zig /usr/local/zig 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| zig 由 zigup 管理且唯一 | OK | 达标 |
| 手动下载的 zig 二进制和 zigup 管理的版本都在 PATH 上 | WARN | 谁生效取决于 PATH 顺序，容易在不知情下用错版本 |
| 只有手动下载的 zig，没有版本管理工具 | WARN | Zig 版本迭代快、语言本身仍有 breaking change，建议上 zigup 方便切换 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 zigup**：
   ```bash
   brew install zigup      # 或按 zigup 项目 README 里的其他安装方式
   zigup <version>
   zigup default <version>
   ```
3. **处理旧的**：手动下载解压的 zig 目录，确认没有脚本/项目硬编码指向它之后可以删除，同时把手动加的 PATH 那一行从 shell 配置里删掉。
4. **【可选】外置存储**：zigup 支持自定义安装目录，具体参数以 `zigup --help` 为准，装前设好，避免装完再搬。
5. **验证**：
   ```bash
   zig version; which zig
   zigup list
   ```

## 5. 已知坑

- **zigup 不是官方工具**：如果项目 CI 或团队约定要求"零第三方工具"，官方路线是从 ziglang.org/download 手动下载对应版本的 tarball，自己维护多版本切换（比如按版本号命名解压目录，自己管 PATH）。
- **Zig 语言本身仍在快速变化**：不同 0.x 版本之间可能有真实的语法/标准库变化，装错版本表现为编译错误，先查版本号再查代码。
