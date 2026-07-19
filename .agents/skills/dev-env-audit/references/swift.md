<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Swift / Objective-C — Authoritative Manager: Xcode Built-in (Multiple Versions via Multiple Xcode.app + `xcode-select`)

## 1. Baseline

- **Recommended tool:** the toolchain built into Xcode. The vast majority of Swift/Objective‑C development is iOS/macOS app development, and the Swift version is tightly bound to the Xcode version (each Xcode release supports only a specific range of Swift versions). Switching Swift versions independently of Xcode is rare.
- **Multi‑version scenario:** install multiple `Xcode.app` instances (rename them to distinguish, e.g. `Xcode-15.app`/`Xcode-16.app`), use `xcode-select -s` to switch the system default, or use `xcrun --toolchain` for a single‑invocation switch without changing the global default. This is Apple’s officially supported workflow and the industry standard — it covers the full Xcode toolchain (simulator runtimes, code‑signing tools, Interface Builder, etc.) that third‑party managers like `swiftenv` or `asdf-swift` do not cover.
- **Exception:** for pure server‑side / cross‑platform Swift (Linux environments, no Xcode), `swiftenv` or official swift.org toolchain snapshots are more appropriate — this reference targets Apple‑platform development on macOS.
- Minimum compliant feature set:
  - `xcode-select -p` points to the expected `Xcode.app`
  - `swift --version` matches the Xcode version currently selected by `xcode-select`

## 2. Deep Probe (Read‑Only)

```bash
xcode-select -p
swift --version
xcodebuild -version

# How many Xcode versions are installed on the system
ls -d /Applications/Xcode*.app 2>/dev/null

# Was a third‑party Swift version manager used? (cross‑platform / server‑side scenario)
command -v swiftenv; ls -d ~/.swiftenv 2>/dev/null
```

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| Only one Xcode, `xcode-select -p` points to it | OK | Meets the baseline; single‑version scenario |
| Multiple Xcode.app coexist, `xcode-select -p` points to the expected one | OK | Meets the baseline; multi‑version scenario |
| Multiple Xcode.app coexist, but `swift --version` does not match expectations | WARN | `xcode-select` is set incorrectly, or the `DEVELOPER_DIR` environment variable is overriding it elsewhere |
| In a pure server‑side Swift scenario, `swiftenv` is installed | OK | `swiftenv` is reasonable in this scenario; do not apply the Xcode‑based judgment rules |
| The `asdf-swift` plugin is managing the version | WARN | The plugin is unofficial and has low maintenance activity; not recommended for Apple‑platform development. For server‑side use, prefer `swiftenv` or official toolchain snapshots. |

## 4. Migration Plan (Five Steps)

1. **Assess current state** — run the full §2 probe.
2. **Install / switch Xcode**: download the required version from the App Store or developer.apple.com, rename it, and place it in `/Applications`. Then:
   ```bash
   sudo xcode-select -s /Applications/Xcode-16.app
   sudo xcodebuild -license accept   # Required when switching to a new Xcode version whose license hasn’t been accepted yet
   ```
3. **Handle old installations**: multiple `Xcode.app` bundles do not conflict with each other and can coexist; delete unused versions only when disk space is tight (a single Xcode can be over ten GB).
4. **[Optional] External storage**: placing `Xcode.app` itself on an external drive is not recommended (first launch performs local component installation; if the drive disconnects, Xcode may become unusable). Simulator runtimes are large but can be cleaned individually in Xcode settings — that does not fall under “external storage.”
5. **Verify**:
   ```bash
   xcode-select -p; swift --version; xcodebuild -version
   ```

## 5. Known Pitfalls

- **`sudo xcode-select -s` affects the entire system** — it’s a system‑level switch, not scoped to the current shell. If you only need to use a different toolchain for a single command, use `xcrun --toolchain <identifier> -- <command>` instead of altering the global default.
- **You must accept the license agreement when switching to a new Xcode version** — without accepting it (`sudo xcodebuild -license accept`), commands like `xcodebuild` and `swift` will refuse to run and exit with an error.
- **The `DEVELOPER_DIR` environment variable overrides the `xcode-select` selection** — if this variable is set in a CI environment or a shell configuration, it can cause a mismatch between what `xcode-select -p` reports and which Xcode is actually used. During deep probing, always check it with `echo $DEVELOPER_DIR`.
