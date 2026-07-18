<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# C / C++ —— 权威工具链: Homebrew(gcc/clang)（单版本）/ 系统原生多版本机制（多版本）

## 1. 基线

- C/C++ 生态没有统一的语言级版本管理器（不像 Python/Node/Ruby 那样有事实标准工具）。macOS 上单版本场景直接用 Xcode Command Line Tools 自带的 clang，或 `brew install gcc` 装一份真正的 GCC。
- **多版本场景**：靠系统原生机制并存，不是某个第三方版本管理器：
  - Homebrew 的 `gcc@13`/`gcc@14` 这类具体版本 formula 会装出带版本号的独立命令（`gcc-13`），天然并存，不需要切换工具。
  - Xcode 侧靠装多个 Xcode.app + `xcode-select`（详见 `swift.md`）切换 clang 版本。
  - Linux 上是系统包管理器的 `update-alternatives`。
  - **ASDF 的 gcc/clang 插件维护活跃度低，只在需要跨 Linux/macOS 统一脚本化管理的边缘场景下才考虑**，不是主流选择。
- 包/构建管理器：**vcpkg + CMake**（微软发布的跨平台 C++ 包管理器，和 CMake 集成最成熟）；Conan 是另一个同级的成熟选项，两者目前仍在互相竞争，不是分出胜负的领域，选哪个更多看团队习惯和现有项目集成情况。
- 达标最小特征集：
  - `cc --version`/`gcc --version`/`clang --version` 解析到预期的编译器和版本
  - 项目实际使用的编译器（通过 `CC`/`CXX` 环境变量或 CMake 里显式指定）和检测到的版本一致，没有隐性使用了另一个编译器

## 2. 深挖探测（只读）

```bash
which -a cc gcc clang cmake

cc --version 2>&1 | head -3
clang --version 2>&1 | head -3
gcc --version 2>&1 | head -3

brew list --formula 2>/dev/null | grep -E '^gcc(@[0-9]+)?$'
brew list --versions gcc 2>/dev/null

cmake --version 2>/dev/null
vcpkg version 2>/dev/null
conan --version 2>/dev/null

echo "CC=$CC CXX=$CXX"
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| clang（Xcode CLT）或 brew gcc 唯一，版本符合预期 | OK | 达标 |
| 多个 brew gcc@x 版本共存，各自带版本号命令，无人手动改动默认 `gcc` alias | OK | 达标，多版本场景的自然状态，不需要额外工具 |
| `CC`/`CXX` 环境变量指向的编译器和实际检测到的默认编译器不一致 | WARN | 项目构建时容易混用两种编译器产出的目标文件，导致 ABI 不兼容的链接错误 |
| 用 asdf-gcc/asdf-clang 插件 | INFO | 能用，但维护活跃度低，非主流选择，不视为问题也不特别推荐 |
| 没装 vcpkg/Conan，项目有第三方 C++ 依赖但靠手动下载源码管理 | WARN | 建议引入包管理器，减少手动管理依赖版本的负担 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套，确认项目实际要求的编译器和版本。
2. **装编译器**：
   ```bash
   xcode-select --install       # Xcode CLT 自带 clang，多数场景够用
   brew install gcc             # 需要真正 GCC（而非 clang）时
   brew install gcc@13          # 需要具体版本共存时
   ```
   包管理器：
   ```bash
   git clone https://github.com/microsoft/vcpkg.git
   ./vcpkg/bootstrap-vcpkg.sh
   brew install cmake
   ```
3. **处理旧的**：多个 brew gcc@x 版本本身不冲突，可以并存；只在磁盘紧张时卸载不用的具体版本。
4. **【可选】外置存储**：
   ```bash
   export VCPKG_DOWNLOADS="/Volumes/<盘>/dev-cache/vcpkg-downloads"
   export VCPKG_DEFAULT_BINARY_CACHE="/Volumes/<盘>/dev-cache/vcpkg-cache"
   ```
5. **验证**：
   ```bash
   cc --version; cmake --version
   vcpkg version
   ```

## 5. 已知坑

- **混用编译器导致 ABI 不兼容**：同一个项目如果部分目标文件用 clang 编译、部分用 gcc 编译，链接阶段可能报出令人困惑的符号找不到错误，根因通常是 `CC`/`CXX` 在构建过程中被不同工具/脚本设置成了不同值。
- **ASDF 的 C/C++ 编译器插件不是主流**：C/C++ 生态本身缺乏对"用统一版本管理器管编译器"这件事的强共识，不要把 asdf-gcc/asdf-clang 当成理所当然的默认选择去推荐。
- **vcpkg 和 Conan 的选择目前仍是团队偏好问题**：不是本 reference 需要强行分出胜负的领域，审计时发现任一都不算 WARN。
