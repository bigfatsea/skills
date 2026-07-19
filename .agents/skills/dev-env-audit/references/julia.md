<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Julia — Authoritative Manager: juliaup (Official)

## 1. Baseline

- Recommended tool: **juliaup**. The installer/version manager maintained and officially promoted by JuliaLang since 2022 (github.com/JuliaLang/juliaup). The julialang.org official download page now directs users to install juliaup, and no competing alternatives exist in the ecosystem.
- Minimum feature set to qualify:
  - `julia --version` resolves to a version managed by juliaup
  - `juliaup status` shows a clear default channel/version

## 2. Deep probe (read-only)

```bash
which -a julia juliaup
julia --version
juliaup status 2>/dev/null

# Check for residual manually installed old versions (common early practice: download .dmg or tarball and manually install to /Applications or ~/julia)
ls -d /Applications/Julia-*.app ~/julia 2>/dev/null
```

## 3. Assessment rules

| Finding | Assessment | Reason |
|---|---|---|
| julia is managed by juliaup and is the only instance | OK | Meets standard |
| Manually installed Julia (.app or tarball) coexists with a juliaup version | WARN | Which one takes effect depends on PATH order; recommend unifying to juliaup |
| Only manually installed old version(s), no juliaup | WARN | Usable but version upgrade/switch is cumbersome; recommend migration |

## 4. Migration plan (5‑step method)

1. **Detect current state** — complete §2.
2. **Install juliaup**:
   ```bash
   curl -fsSL https://install.julialang.org | sh
   juliaup add release       # install the latest stable release
   juliaup default release
   ```
3. **Handle old installations**: For manually installed Julia.app or tarball, after confirming no projects are hardcoded to its specific path, they can be deleted.
4. **[Optional] External storage**: juliaup supports adjusting the location of packages and compilation caches via `JULIAUP_DEPOT_PATH`/`JULIA_DEPOT_PATH`; set these before installation.
5. **Verify**:
   ```bash
   julia --version; which julia
   juliaup status
   ```

## 5. Known pitfalls

- **juliaup's channel concept**: `juliaup add release`/`lts`/`nightly` installs “channels” rather than fixed version numbers; only `juliaup status` reveals the specific version a channel actually resolves to. Do not assume the version is manually pinned just by looking at `julia --version`.
- **Manually installed old versions are easily forgotten in /Applications**: Julia’s early official distribution method was .dmg, and many machines still have such manually installed versions, which will conflict with a later installed juliaup.
