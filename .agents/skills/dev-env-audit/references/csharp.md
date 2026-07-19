<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# C# / .NET — Authoritative Manager: Official dotnet-install (Unified Single/Multi-Version Solution)

## 1. Baseline

- Recommended tool: **Official `dotnet-install` script** (published by Microsoft, `https://dot.net/v1/dotnet-install.sh`). The .NET SDK natively supports multiple SDK versions coexisting on the same machine (each version installed in its own directory without overwriting), project-level version pinning is done via the `sdk.version` field in `global.json`, making third-party version managers unnecessary and uncompetitive.
- Minimum qualifying feature set:
  - `dotnet --list-sdks` shows the expected version(s)
  - No `global.json` resolution failures caused by missing SDK versions required by projects
  - No simultaneous, conflicting manual PATH overrides (for example, both brew dotnet and the official installation each adding to PATH's top level)

## 2. Deep probe (read-only)

```bash
which -a dotnet
dotnet --version
dotnet --list-sdks
dotnet --list-runtimes

# Is there also a brew installation? (Both can run in a session, but having both easily leads to version mismatches)
brew list --formula 2>/dev/null | grep -E '^dotnet'

# Project-level clue: only meaningful when auditing from a project directory; not a required machine-level check
find . -maxdepth 2 -name 'global.json' 2>/dev/null
```

## 3. Decision rules

| Finding | Verdict | Reason |
|---|---|---|
| dotnet from a single source (either official installer or brew), `--list-sdks` shows the expected version(s) | OK | Meets criteria |
| Both official installer and brew dotnet are installed | WARN | Not a fatal conflict (.NET SDK itself supports multi-version coexistence), but having two installation sources easily leads to messy version management; recommended to unify to one |
| Project has `global.json` but the pinned SDK version is not installed | FAIL | `dotnet build` will error out directly due to missing SDK; install the required version via `dotnet-install` |
| Only one version, no global.json requirement | OK | Sufficient for single-project scenarios |

## 4. Migration plan (five-step method)

1. **Check current state** — the full §2 probe.
2. **Install official dotnet-install**:
   ```bash
   curl -sSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
   chmod +x dotnet-install.sh
   ./dotnet-install.sh --channel LTS          # or --version <specific version>
   ```
   Defaults to installing into `~/.dotnet`; the script will prompt to add `~/.dotnet` to PATH.
3. **Handle old installations**: If `brew install dotnet` was previously used, confirm that no project depends on the brew-specific installation path, then `brew uninstall dotnet` to avoid both installation sources being maintained.
4. **[Optional] External storage**:
   ```bash
   export DOTNET_ROOT="/Volumes/<disk>/dev-cache/dotnet"   # dotnet-install supports --install-dir to specify directory
   ./dotnet-install.sh --channel LTS --install-dir "$DOTNET_ROOT"
   ```
   After installing to a custom directory, the export of `DOTNET_ROOT` and the `PATH` addition of `$DOTNET_ROOT` must be **persistently written into shell configuration**, otherwise `dotnet` won't be found in new terminals.
5. **Verify**:
   ```bash
   dotnet --version; dotnet --list-sdks
   which dotnet
   ```

## 5. Known pitfalls

- **Missing SDK after global.json version pinning results in hard error**: Unlike Go's GOTOOLCHAIN which auto-downloads, .NET throws a hard error when the SDK version required by `global.json` is not found; you need to manually install the missing version using `dotnet-install --version <version>`.
- **Version mismatch from multiple installation sources**: The brew dotnet formula's update cadence is out of sync with Microsoft's official releases; mixing two installation sources can easily lead to situations where "it works locally but CI reports SDK version mismatch."
