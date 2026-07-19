<!-- Ver 2026-07-17 17:30, by Claude Sonnet 5 -->

# Git — Recommended: brew git (avoid Apple’s frozen version)

## 1. Baseline

- Recommended: **git installed via brew** and prioritized over `/usr/bin/git` on the PATH.
- Background: To avoid GPLv3 obligations, Apple **freezes the git included with Xcode CLT at an old version** (long stuck around 2.39.x; only security patches are backported, never a version upgrade). If you do nothing, `/usr/bin/git` will always be an outdated version.
- Git does not need multi‑version management; the only two questions are “which copy to use + PATH order”.

## 2. In‑depth Probe (read‑only)

```bash
which -a git
git --version

brew list --versions git 2>/dev/null    # Has brew ever installed git?

# Three‑scenario analysis (git is the most common victim of the path_helper pitfall):
# Do not run manually; probe-path.sh covers it uniformly.
# (Running manually in an interactive session may cause prompt‑plugin stderr noise.)
#   zsh scripts/probe-path.sh git

# Does the PATH reclaim logic appear in both required files?
# Caution: do not grep only the literal paths ~/.zshrc/~/.zprofile.
# First inspect the “shell config source chain” shown by scan.sh:
# If .zshrc/.zprofile merely source other files (a centralized dotfiles framework,
# e.g. ~/myenv/pathorder.zsh), the real reclaim logic lives in those sourced files.
# Include them in the grep target as well.
grep -n 'homebrew/bin' ~/.zshrc ~/.zprofile 2>/dev/null | tail -5
# Example: if the source chain shows ~/.zprofile -> ~/myenv/pathorder.zsh, change to:
#   grep -n 'homebrew/bin' ~/.zshrc ~/.zprofile ~/myenv/pathorder.zsh 2>/dev/null
```

## 3. Judgment Rules

| Finding | Verdict | Reasoning |
|---|---|---|
| brew git exists and resolves to it in all three scenarios | OK | Meets the requirement |
| Only /usr/bin/git (around 2.39.x) exists | WARN | Usable, but the version is frozen by Apple; recommend installing brew git |
| brew git installed but some scenario resolves to /usr/bin/git | WARN | path_helper overrides the order (especially the “login non‑interactive” scenario); add PATH logic to .zprofile |
| Interactive terminal works, but `zsh -l -c` falls back to /usr/bin/git | WARN | Classic “only configured in .zshrc, omitted .zprofile”; GUI apps / launchd scenarios will use the old git |
| Top‑level rc files show nothing, but the reclaim logic is found in files on the source chain, and all three scenarios resolve consistently | OK | Logic exists and is effective; it is simply placed in a centrally managed file, not missing |
| Top‑level rc files show nothing, nothing is found even tracing to the end of the source chain, and some scenario resolves to /usr/bin/git | WARN | The reclaim logic is truly missing; add it per §4 |

## 4. Migration Plan (five‑step process)

1. **Inspect the current state** — full §2.
2. **Install brew git**:
   ```bash
   brew install git
   ```
3. **Handle the old copy**: `/usr/bin/git` is a system file; **do not delete it (and you cannot)**. The goal is to place the brew copy ahead of it.
4. **[Optional] External storage**: Not applicable (the git binary itself has no need for external cache relocation).
5. **Verify + reclaim PATH**: After installation, `which git` will most likely still point to `/usr/bin/git` (brew’s directory is placed later by path_helper). Append the following to **the very end of `~/.zshrc`** and **also to `~/.zprofile`**:
   ```bash
   for d in "/opt/homebrew/bin"; do
     [[ -d "$d" ]] && path=("$d" "${path[@]:#$d}")
   done
   ```
   (For Intel Mac, use `/usr/local/bin`.) Then validate (run `zsh scripts/probe-path.sh git` to cover the three scenarios):
   ```bash
   which git; git --version                 # Should resolve to /opt/homebrew/bin/git
   ```

## 5. Known Pitfalls

- **path_helper double pitfall**: In a login shell the system re‑prepends `/usr/bin` after user configuration. First layer: setting PATH order at the beginning of `~/.zshrc` is useless; you must reclaim at **the very end**. Second layer (more subtle): `~/.zshrc` is only loaded by interactive shells; “login non‑interactive” (`zsh -l -c`, commonly used by GUI Apps / launchd / IDEs when resolving the environment) does not read it — the same reclaim logic must be placed in `~/.zprofile` as well. Debugging method: test `zsh -c` / `zsh -l -c` / `zsh -l -i -c` all three (probe-path.sh does this automatically).
- **`softwareupdate --list` cannot fix the git version**: CLT updates are frequent, but the git version number inside never increases; waiting for a system update is pointless.
