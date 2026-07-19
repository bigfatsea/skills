<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Rust — The Authoritative Version Manager: rustup

## 1. Baseline

- Recommended tool: **rustup** (Rust’s official first‑class citizen version manager; even the mise author admitted “better DX than what mise likely could ever accomplish”).
- Minimum acceptable feature set:
  - `which -a rustc cargo` returns exactly one entry each, resolving to `$CARGO_HOME/bin` (default `~/.cargo/bin`)
  - No brew rust coexistence

## 2. Deep Probe (read-only)

```bash
which -a rustc cargo rustup
rustc --version; cargo --version
rustup show 2>/dev/null

# Side-by-side channels
brew list --formula 2>/dev/null | grep -E '^rust$'

# Home directory placement (external check)
echo "RUSTUP_HOME=${RUSTUP_HOME:-<unset, default ~/.rustup>}"
echo "CARGO_HOME=${CARGO_HOME:-<unset, default ~/.cargo>}"
ls -d ~/.rustup ~/.cargo 2>/dev/null
```

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| Managed by rustup, rustc/cargo unique | OK | Meets standard |
| brew rust and rustup coexist | FAIL | Conflicts on PATH; uninstall brew rust |
| Only brew rust, no rustup | WARN | Works but lacks toolchain/component management capability; recommend migration |
| One of RUSTUP_HOME/CARGO_HOME is external, the other default | WARN | Drift; both variables should be set together |
| CARGO_HOME is set and uv is also installed under `$CARGO_HOME/bin` | INFO | Not an error, but inform the user where uv is installed (see cross‑impact pitfall in python.md §5) |

## 4. Migration Plan (Five‑Step Method)

1. **Assess current state** — full §2.
2. **Install rustup** (if using external storage, perform step 4 first, then install):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
3. **Remove old installation**:
   ```bash
   brew uninstall rust      # previously installed via brew
   ```
4. **[Optional] External storage** (**must be set before installation**; changing after installation will not move files):
   ```bash
   export RUSTUP_HOME="/Volumes/<disk>/dev-cache/rustup"
   export CARGO_HOME="/Volumes/<disk>/dev-cache/cargo"
   ```
5. **Verify**:
   ```bash
   rustc --version; cargo --version
   which rustc cargo        # should point to $CARGO_HOME/bin
   ```

## 5. Known Pitfalls

- **RUSTUP_HOME / CARGO_HOME take effect before installation**: the rustup installation script reads these variables at install time to decide placement; changing them afterwards will not move the toolchain.
- **CARGO_HOME affects more than just Rust**: the official uv installation script detects `CARGO_HOME` and installs uv into `$CARGO_HOME/bin` (see python.md §5 for details). During audit, if `CARGO_HOME` is set, also check `which -a uv`.
- **PATH injection method**: rustup relies on `$CARGO_HOME/env` or the install script writing to shell configuration to add `$CARGO_HOME/bin` to PATH. Users with centralized configuration management should check whether the install script added lines to `~/.zshrc`.
