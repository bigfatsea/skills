<!-- Ver 2026-07-18 17:40, by Claude Fable 5 -->

# Lua — Authoritative Manager: Homebrew (Single Version) / ASDF (Multi-Version)

## 1. Baseline

- **Single-version scenario**: `brew install lua` suffices. The Lua ecosystem has no dominant dedicated version manager (unlike Python with uv and Ruby with rbenv), and the community has not formed a consensus that “a specific tool must be used.”
- **Multi-version scenario**: The `asdf-lua` plugin is the optimal universal choice in multi-language unified scenarios.
- Minimum acceptable feature set:
  - `lua -v` resolves to the expected version
  - No conflict between a system-packaged Lua (found on some Linux distros / historical macOS versions) and the version installed via brew/asdf

## 2. Deep Probe (Read-Only)

```bash
which -a lua lua5.1 lua5.3 lua5.4
lua -v

brew list --formula 2>/dev/null | grep -E '^lua(@[0-9.]+)?$'
asdf current lua 2>/dev/null
asdf list lua 2>/dev/null

luarocks --version 2>/dev/null
luarocks config lua_version 2>/dev/null   # luarocks separates rocks directories by Lua version
```

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| Only one source of lua exists and the version matches expectations | OK | Meets requirements |
| brew lua and asdf lua both present | WARN | Not necessarily a conflict (depends on which one is earlier in PATH), but it’s easy to lose track of which version is actually effective; recommend consolidating onto one |
| Version is 5.1 but the project/dependencies require 5.3/5.4 (or vice versa) | FAIL | There are genuine language incompatibilities between Lua major versions (unlike minor upgrades in many languages); it’s not simply “newer is better” |
| Rocks installed with LuaRocks are not found after switching Lua versions | INFO | LuaRocks stores rocks in directories keyed by Lua version; after switching you need to reinstall dependencies — they aren’t lost |

## 4. Migration Plan (Five-Step Method)

1. **Inspect current state** — full §2 probe; **pay special attention to which Lua major version the project actually requires** (5.1/5.3/5.4 are mutually incompatible).
2. **Install the authoritative manager**:
   ```bash
   # Single version
   brew install lua

   # Multi-language full-stack unification
   asdf plugin add lua
   asdf install lua <version>
   asdf set -u lua <version>    # -u/--home writes .tool-versions in home directory; for asdf ≤0.15 old syntax was asdf global lua <version>
   ```
3. **Handle old items**: Ensure the system-packaged lua (if any) is not early in PATH; no need to uninstall (usually impossible to remove anyway).
4. **[Optional] External storage**:
   ```bash
   export LUAROCKS_CONFIG="/Volumes/<disk>/dev-cache/luarocks/config.lua"   # must specify the rocks_trees path in the config file
   ```
5. **Verify**:
   ```bash
   lua -v; which lua
   luarocks --version
   ```

## 5. Known Pitfalls

- **Incompatibility between Lua major versions**: Every major release from 5.1→5.2→5.3→5.4 introduces real syntax/semantic changes (not just additive features). Installing the wrong major version can cause scripts to fail with syntax errors. The first step in troubleshooting should always be to confirm the version number, not to doubt the code itself.
- **LuaRocks separates rock directories by Lua version**: After switching Lua versions it may appear that “all packages are gone,” but they are actually installed in the directory for the other version. You need to run `luarocks install` again for the new version.
