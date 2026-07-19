<!-- Ver 2026-07-18 17:40, by Claude Fable 5 -->

# Ruby — Authoritative Manager: rbenv (for Pure Ruby Developers) / ASDF (for Polyglot Full-Stack Unification)

## 1. Baseline

- Choose one of the two recommended tools; **Homebrew is not recommended for either**:
  - **rbenv**: The first choice for pure Ruby developers (who rarely use other languages) — lightweight, focused, and the most mainstream in the community.
  - **ASDF**: For polyglot full-stack developers who already use ASDF to manage other languages, wanting a single tool to unify their mental model.
  - This choice axis is “pure Ruby developer vs. polyglot full-stack developer”, **not “single version vs. multiple versions”**. Even if a pure Ruby developer uses only one version, rbenv is still better than Homebrew; even if a polyglot developer uses only one Ruby version, ASDF’s unification benefit outweighs the extra mental overhead.
  - **Why Homebrew is not recommended (even with a single version)**: Ruby’s native extension gems are compiled against a specific Ruby version ABI. `brew upgrade ruby` silently bumps the minor version without your explicit request, and previously compiled native extension gems will likely break — this is the actual reason the Ruby community generally avoids Homebrew even for single-version, single-project usage, beyond the “multi-language unification” argument.
  - Most people use Ruby infrequently — using the system’s bundled ruby without any manager is also an acceptable state (report it as “unmanaged, migrate on demand”, not a FAIL).
- Minimum feature set to meet the standard:
  - `which ruby` resolves to rbenv shims or asdf shims; the corresponding tool shows an explicit global version.
  - ~/.rvm does not exist (RVM conflicts with both and must be completely uninstalled, see §5).

## 2. Deep Probe (Read-Only)

```bash
which -a ruby
ruby -v

# rbenv status
rbenv versions 2>/dev/null
rbenv global 2>/dev/null

# rvm (the only manager that MUST be truly uninstalled) — first inspect scan.sh's source chain, literal rc files
# if grep finds nothing, also include files sourced by centralized dotfiles frameworks in the grep target
ls -d ~/.rvm 2>/dev/null
grep -n 'rvm' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile 2>/dev/null

# whether shims are overtaken by path_helper: do not manually run the three-scenario commands here
# (interactive shell triggers stderr noise from user prompt plugins) — covered uniformly by probe-path.sh:
#   zsh scripts/probe-path.sh ruby
```

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| rbenv or asdf manages, shim priority correct | OK | Meets standard, both paths are recommended states, neither superior |
| RVM exists (directory or init line) | FAIL | Fundamental conflict with rbenv/asdf, must `rvm implode` to completely uninstall |
| rbenv/asdf installed but login shell resolves to /usr/bin/ruby | WARN | path_helper overrides shim (see §5), add PATH recapture logic to .zprofile |
| Only system ruby, no manager, user does not write Ruby | INFO | Legitimate state, no action needed |
| brew ruby at top of PATH | WARN | Regardless of whether the developer is polyglot or not, migration is recommended (native extension ABI risk, see §1); migrate to rbenv or asdf depending on whether the user is a polyglot full-stack developer |
| grep on top-level rc files finds nothing, but rvm is found in files on the source chain | FAIL | Logic hidden in centrally managed files, not absent |

## 4. Migration Plan (Five Steps)

1. **Check current state** — full §2; also confirm whether the user is a pure Ruby developer or a polyglot full-stack developer (determines which path to take, see §1).
2. **Install the authoritative manager**:
   ```bash
   # Pure Ruby developer
   brew install rbenv
   rbenv install <version>
   rbenv global <version>

   # Polyglot full-stack developer (already using asdf for other languages)
   asdf plugin add ruby
   asdf install ruby <version>
   asdf set -u ruby <version>   # -u/--home writes to home directory .tool-versions; asdf ≤0.15 old syntax is asdf global ruby <version>
   ```
3. **Handle the old one** — RVM is a special case, **must be completely uninstalled**, cannot merely disable:
   ```bash
   rvm implode          # RVM's built-in uninstall command
   # then delete all RVM-related PATH/initialization code from ~/.zshrc etc.
   ```
4. **[Optional] External storage**: rbenv versions are installed in `~/.rbenv/versions`, usually small in size and normally not externalized; if necessary, set `RBENV_ROOT` to point to an external drive (set before installing versions).
5. **Verify** (must verify all three shell scenarios; Ruby is a hotbed of path_helper pitfalls, use `zsh scripts/probe-path.sh ruby`):
   ```bash
   ruby -v; which ruby
   rbenv versions
   ```

## 5. Known Pitfalls

- **`rvm implode` is the only correct solution**: RVM deeply modifies the shell environment (functions, PATH, gem paths); being “installed but not used” will still cause continuous conflicts. It is the only old manager that must be completely uninstalled.
- **path_helper overrides shims**: In macOS login shells, `path_helper` reorders `/usr/bin` and others to the front after user configuration, causing rbenv shims to be overtaken → in new terminals, ruby resolves to the old system version, but manually `source ~/.zshrc` makes it normal again, easily mistaken for “random issue”. Permanent fix: place a “reclaim PATH” logic snippet on the **last line** of `~/.zshrc` and also in `~/.zprofile`:
  ```bash
  for d in "$HOME/.rbenv/shims" "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" "/opt/homebrew/bin"; do
    [[ -d "$d" ]] && path=("$d" "${path[@]:#$d}")
  done
  ```
  Putting it only in .zshrc will miss “login non-interactive” shells (GUI Apps / launchd use `zsh -l -c`, which do not read .zshrc) — this is exactly what scenario B in probe-path.sh catches.
