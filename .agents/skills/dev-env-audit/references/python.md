<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# Python — Authoritative Manager: uv

## 1. Baseline

- Recommended tool: **uv** (the single authoritative replacement for pyenv + pip + venv + pipx + poetry; industry consensus in 2026).
- Minimum required feature set:
  - `command -v uv` exists and `which -a uv` returns only one location
  - No `pyenv init` / `conda initialize` code is active in shell configuration
  - In non-interactive scenarios, `python3` does not resolve to `/usr/bin/python3` (or you knowingly accept the system version as fallback)

## 2. Deep Probe (Read-only)

```bash
# How many pythons on PATH, and which ones
which -a python python3
# pip3 often drifts independently: on many machines pip3 resolves to Xcode built-in Python's pip (different source from python3), extremely deceptive
which -a pip3

# uv itself: path, version, any multiple coexisting copies (CARGO_HOME pitfall, see §5)
which -a uv
uv --version
uv python list --only-installed
uv tool list
uv cache dir

# Old managers: pyenv / conda / pipx / python.org pkg
command -v pyenv && ls ~/.pyenv/versions 2>/dev/null
ls -d ~/miniconda3 ~/anaconda3 ~/miniforge3 2>/dev/null
command -v pipx && pipx list 2>/dev/null
ls /Library/Frameworks/Python.framework/Versions 2>/dev/null   # installed via python.org .pkg; in zsh, avoid using glob (causes error when no match)

# Init residue (the most common source of conflicts: thinking it was uninstalled, but initialization code is still there)
# Note: first check the "shell config source chain" from scan.sh — centralized dotfiles framework
# (e.g., ~/myenv/*.zsh) may place init code in sourced files, a literal rc file
# grep empty does not mean it's absent, include files from the source chain in the grep targets below
grep -n 'pyenv init' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc 2>/dev/null
grep -n 'conda initialize' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc 2>/dev/null

# brew python (can be kept as dependency layer, but should not be used directly at PATH top)
brew list --formula 2>/dev/null | grep -i python

# Non-interactive resolution (alias only works in interactive shells; scripts/cron/subprocess see this)
zsh -c 'command -v python3; python3 -V'
```

## 3. Judgment Rules

| Finding | Judgment | Reason |
|---|---|---|
| uv unique, no pyenv/conda init active | OK | Meets standard |
| uv and pyenv init both active | FAIL | pyenv shim directory hijacks PATH, python3 resolution drifts |
| conda initialize block still in shell config | FAIL | conda modifies PATH and registers hooks, conflicts with uv |
| ~/.pyenv or conda directory residue but init removed | WARN | harmless residue, suggest confirming and deleting to free space |
| pipx still managing global tools | WARN | suggest `uv tool install` one by one to reinstall then discard pipx |
| `which -a uv` returns more than one | FAIL | version may be stuck on the old one unknowingly (see §5 CARGO_HOME pitfall) |
| brew python exists but not at PATH top | OK | layered non-overlapping: left for brew formula that depend on it, don't touch |
| brew python at PATH top and uv exists | WARN | PATH order issue, uv-managed python should take precedence |
| no uv, only one brew/system python | WARN | usable but not recommended; provide migration plan |
| non-interactive `python3` resolves to /usr/bin/python3 and user has scripting scenarios | WARN | see §5 alias pitfall, suggest `uv python install --default` as fallback |
| top-level rc file grep empty, but files in source chain contain pyenv init/conda initialize | FAIL/WARN (depends on content) | logic hidden in centrally managed files, not absent — apply judgment of corresponding row above |

## 4. Migration Plan (Five-step Method)

1. **Detect current state** — §2 full set.
2. **Install uv**:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   After installation, open a new terminal to confirm: `command -v uv` (usually `~/.local/bin/uv`; if `CARGO_HOME` set, may be under `$CARGO_HOME/bin`, see §5).
3. **Handle old ones**:
   - pyenv: May not need to uninstall, but **must** delete/comment out the `eval "$(pyenv init -)"` etc. initialization code in shell config.
   - conda: Comment out the entire `# >>> conda initialize >>>` block.
   - pipx global tools: Note down list from `pipx list`, then `uv tool install <pkg>` one by one to reinstall (reinstall cleaner than data migration).
   - brew python: **Leave it alone** — serve as dependency for brew formula that rely on it, as long as it doesn't end up at PATH top and you don't pip install into it.
4. **[Optional] External storage** (must be set before installing anything with uv for the first time; changing variables afterwards will not move existing data):
   ```bash
   export UV_CACHE_DIR="/Volumes/<disk>/dev-cache/uv_cache"
   export UV_PYTHON_INSTALL_DIR="/Volumes/<disk>/dev-cache/uv_pythons"
   export UV_TOOL_DIR="/Volumes/<disk>/dev-cache/uv_tools"
   ```
   venv has no corresponding external variable: uv has no concept of a global venv directory; a project venv is the `.venv` inside the project (its location can be changed per project with `UV_PROJECT_ENVIRONMENT`, generally not externalized). The widely rumored `UV_VIRTUALENV_DIR` is not a uv environment variable; setting it silently has no effect.
5. **Verify**:
   ```bash
   which python; python -V
   uv python list --only-installed
   uv tool list
   zsh -c 'command -v python3; python3 -V'   # separately verify non-interactive scenario
   ```

## 5. Known Pitfalls

- **CARGO_HOME hijacks installation location**: uv's official install script detects `CARGO_HOME` and installs itself into `$CARGO_HOME/bin` instead of `~/.local/bin`. If later another copy is installed elsewhere, the two are unaware of each other, PATH order determines which one takes effect, version may stay on the old one. After installation always run `which -a uv`, if more than one keep only one.
- **alias only takes effect in interactive shells**: `alias python="uv run python"` cannot cover shebang / Makefile / `subprocess` / cron. For non-interactive scenarios, use `uv python install <version> --default` to create unversioned `python`/`python3` symlinks in uv bin directory as fallback. The two mechanisms serve different purposes, never expect one to cover both.
- **UV_* variables do not move things**: Changing install/cache directory variables leaves previously installed Python versions and existing venvs in place; existing venvs still point to old interpreter paths (explicitly stated in uv official docs), requiring manual rebuild.
- **System /usr/bin/python3 is very old and restricted**: Resolving to it is usually not what the user wants.
