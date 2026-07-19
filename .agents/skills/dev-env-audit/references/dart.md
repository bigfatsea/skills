<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# Dart / Flutter — Authoritative Managers: Official SDK (single‑version) / fvm (multi‑version)

## 1. Baseline

- **Single‑version scenario**: install the official Flutter SDK directly (includes Dart; download from flutter.dev or `git clone` the Flutter repository). No extra tools are needed — fvm is designed for “locking different Flutter versions per project”; installing it for single‑version users is over‑engineering.
- **Multi‑version scenario**: **fvm** (Flutter Version Management) is the de facto standard in the Flutter community. Although not an official Google release, it is widely adopted and supports per‑project version locking, identified by `.fvmrc`/`.fvm/` directories.
- Minimum feature set for compliance:
  - `flutter --version` resolves to the expected version
  - Under a multi‑project scenario, each project actually uses the version pointed to by `.fvm/flutter_sdk`, not the global default version

## 2. Deep Probe (Read‑Only)

```bash
which -a flutter dart fvm
dart --version

# Do not run flutter --version: it performs update checks (network) and, on a fresh clone, it will also download the entire Dart SDK on first run — read the version from the version file in the SDK root (the flutter command is under <SDK>/bin/):
cat "$(dirname "$(dirname "$(command -v flutter)")")/version" 2>/dev/null

fvm list 2>/dev/null

# Project‑level clues: meaningful only when the audit is run inside a project directory; not a machine‑wide must‑check
find . -maxdepth 2 -name '.fvmrc' -o -maxdepth 2 -path '*/.fvm' 2>/dev/null
```

## 3. Judgment Rules

| Finding | Verdict | Rationale |
|---|---|---|
| Single‑version scenario; official SDK is the sole one | OK | Compliant; fvm is unnecessary |
| Multi‑version scenario; managed by fvm and every project has `.fvmrc`/`.fvm` | OK | Compliant |
| Multiple projects require different Flutter versions, but only one global SDK and no fvm | WARN | Prone to version drift: “this project runs on someone else’s machine but fails on mine” |
| fvm installed, but a certain project lacks `.fvmrc` and uses the global version | INFO | Not necessarily a problem; verify whether the project truly does not need version locking |

## 4. Migration Plan (Five Steps)

1. **Detect current state** — §2 full set.
2. **Install the authoritative manager(s)**:
   ```bash
   # Single‑version: Official SDK
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"

   # Multi‑version: fvm
   brew tap leoafarias/fvm && brew install fvm
   fvm install stable
   fvm use stable            # Run inside the project directory; generates .fvmrc/.fvm
   ```
3. **Handle old installations**: if multiple Flutter SDKs were previously installed manually (different directories for different versions, manually switching PATH), after migrating to fvm they can be deleted, and use `fvm install <version>` for unified management instead.
4. **[Optional] External storage**: fvm’s version cache directory can be adjusted via the `FVM_HOME` environment variable; set it before installation.
5. **Verification**:
   ```bash
   flutter --version; dart --version
   fvm list
   flutter doctor
   ```

## 5. Known Pitfalls

- **fvm is per‑project locking, not a global replacement**: `fvm use` is executed inside a specific project directory; the generated `.fvm` symlink only takes effect for that project. Don’t expect that installing fvm will automatically solve global version issues — it solves the problem of “different projects needing different versions”.
- **`flutter doctor` is the authoritative verification entry point**: when encountering any version or toolchain issue, run this command first. It checks a whole set of peripheral dependencies such as Xcode/Android Studio/CocoaPods, not just the Flutter version itself. Note that it, like `flutter --version`, will go online (update checks / first‑time Dart SDK download), so it only appears in §4/§5 for the **user to run themselves**; it is prohibited to execute during the audit probe phase.
