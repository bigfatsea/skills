<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# Zig — Authoritative Manager: zigup (Community De Facto Standard)

## 1. Baseline

- Recommended tool: **zigup**. Note that it is not an official tool released by the Zig core team, but a community project (homebrew-core has a formula); competing alternatives include zvm, anyzig, etc. This field has not yet produced a single winner — this skill selects zigup based on current adoption preference. If the user is already using zvm or similar tools and they are working normally, under the principle of "respect existing choices" it is not recommended to switch between them.
- Minimum required feature set:
  - `zig version` resolves to a zigup-managed version
  - No manually downloaded/extracted zig binary coexisting on PATH with a zigup-managed version

## 2. Deep Probe (Read-only)

```bash
which -a zig zigup
zig version
zigup list 2>/dev/null

# Is there a manually downloaded/extracted zig installed? (Common practice: extract to ~/zig or /usr/local/zig then manually add to PATH)
ls -d ~/zig /usr/local/zig 2>/dev/null
```

## 3. Decision Rules

| Discovery | Verdict | Reason |
|---|---|---|
| zig is managed by zigup and unique | OK | Meets standard |
| Manually downloaded zig binary and zigup-managed version both on PATH | WARN | Which one takes effect depends on PATH order; easy to use the wrong version unknowingly |
| Only manually downloaded zig, no version management tool | WARN | Zig version iterations are fast; the language itself still has breaking changes; recommend setting up zigup for easy switching |

## 4. Migration Plan (Five-Step Method)

1. **Detect current state** — §2 full set.
2. **Install zigup**:
   ```bash
   brew install zigup      # or other installation methods from zigup project README
   zigup <version>
   zigup default <version>
   ```
3. **Handle old**: For the manually downloaded/extracted zig directory, after confirming no scripts/projects have hard-coded references to it, it can be deleted, and also remove the line that manually added PATH from shell config.
4. **[Optional] External storage**: zigup supports a custom installation directory; see `zigup --help` for exact parameters and set it before installation to avoid moving it later.
5. **Verify**:
   ```bash
   zig version; which zig
   zigup list
   ```

## 5. Known Pitfalls

- **zigup is not an official tool**: If project CI or team conventions require "zero third-party tools", the official route is to manually download the tarball for the corresponding version from ziglang.org/download and maintain multi-version switching yourself (e.g., naming extraction directories by version number and managing PATH yourself). zvm/anyzig and similar tools are competing alternatives at the same level as zigup; finding any in normal operation does not count as WARN.
- **Zig language itself is still rapidly changing**: There may be real syntax/standard library changes between different 0.x versions; the wrong version will manifest as a compilation error; check the version number before debugging the code.
