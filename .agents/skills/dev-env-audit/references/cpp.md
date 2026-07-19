<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# C / C++ – Authoritative Toolchain: Homebrew (gcc/clang) (Single Version) / System-Native Multi-Version Mechanism (Multi-Version)

## 1. Baseline

- The C/C++ ecosystem lacks a unified language-level version manager (unlike Python/Node/Ruby, which have de facto standard tools). On macOS, for single-version scenarios, simply use the clang bundled with Xcode Command Line Tools, or `brew install gcc` to install a real GCC.
- **Multi-version scenarios**: rely on native system mechanisms to co-exist, not on a third-party version manager:
  - Homebrew’s version-specific formulas like `gcc@13`/`gcc@14` install independent commands with version suffixes (`gcc-13`) – they naturally coexist without a switching tool.
  - On the Xcode side, install multiple Xcode.app bundles and use `xcode-select` (see `swift.md` for details) to switch clang versions.
  - On Linux, that role is filled by the system package manager’s `update-alternatives`.
  - **The ASDF gcc/clang plugins have low maintenance activity; consider them only in fringe scenarios that require unified scripted management across Linux/macOS** – they are not a mainstream choice.
- Package / build manager: **vcpkg + CMake** (Microsoft’s cross-platform C++ package manager, with the most mature CMake integration); Conan is another equally mature option. The two are still competing and no clear winner has emerged – the choice is more a matter of team habits and existing project integration.
- Minimum feature set to pass:
  - `cc --version` / `gcc --version` / `clang --version` resolve to the expected compiler and version.
  - The compiler actually used by the project (via `CC`/`CXX` environment variables or explicitly specified in CMake) matches the detected version, with no hidden use of a different compiler.

## 2. Deep Probe (Read-Only)

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

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| Single clang (Xcode CLT) or brew gcc, version matches expectations | OK | Passes baseline |
| Multiple brew gcc@x versions coexist, each with its own versioned command, and no one has manually altered the default `gcc` alias | OK | Passes baseline; natural state in a multi-version scenario, no extra tool needed |
| `CC`/`CXX` environment variables point to a compiler different from the detected default compiler | WARN | During builds, it’s easy to mix object files from two compilers, leading to ABI-incompatible link errors |
| asdf-gcc / asdf-clang plugin is used | INFO | Works, but low maintenance activity; not a problem, but also not particularly recommended |
| vcpkg/Conan not installed, and the project has third-party C++ dependencies managed by manually downloading source code | WARN | Recommend introducing a package manager to reduce the burden of manual dependency-version management |

## 4. Migration Plan (Five-Step Method)

1. **Audit current state** — Full §2, confirm the compiler and version the project actually requires.
2. **Install compiler**:
   ```bash
   xcode-select --install       # Xcode CLT brings its own clang; sufficient in most cases
   brew install gcc             # When a real GCC (not clang) is needed
   brew install gcc@13          # When a specific version must coexist
   ```
   Package manager:
   ```bash
   git clone https://github.com/microsoft/vcpkg.git
   ./vcpkg/bootstrap-vcpkg.sh
   brew install cmake
   ```
3. **Deal with old versions**: Multiple brew gcc@x versions do not conflict and can coexist; uninstall unused specific versions only when disk space is tight.
4. **[Optional] External storage**:
   ```bash
   export VCPKG_DOWNLOADS="/Volumes/<volume>/dev-cache/vcpkg-downloads"
   export VCPKG_DEFAULT_BINARY_CACHE="/Volumes/<volume>/dev-cache/vcpkg-cache"
   ```
5. **Verify**:
   ```bash
   cc --version; cmake --version
   vcpkg version
   ```

## 5. Known Pitfalls

- **Mixing compilers causes ABI incompatibility**: If within the same project some object files are compiled with clang and others with gcc, the link step may produce confusing “undefined symbol” errors. The root cause is usually that `CC`/`CXX` were set to different values by different tools/scripts during the build process.
- **ASDF’s C/C++ compiler plugins are not mainstream**: The C/C++ ecosystem lacks strong consensus on using a unified version manager to manage compilers. Do not promote asdf-gcc/asdf-clang as a sensible default.
- **Choosing between vcpkg and Conan remains a matter of team preference**: It is not an area where this reference needs to anoint a winner. Finding either during an audit is not a WARN.
