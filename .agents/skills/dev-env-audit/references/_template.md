<!-- Ver 2026-07-18 19:10, by Claude Fable 5 -->

# <Language> — Authoritative Manager: <tool>

> When adding support for a new language, copy this file as `references/<lang>.md`. Do not add or remove any of the five sections—
> the agent accesses sections as needed: §2 is read-only execution, §3 is judgment, §4 is the migration plan that goes into the report, §5 is risk annotations that go into the report.
> All commands must come from a trusted source (official documentation / verified setup guide); do not write speculative commands.
> **After writing, you must go through the “anti-hallucination checklist” at the end—this applies equally when modifying an existing reference.**

## 1. Baseline (What the recommended state looks like)

- Recommended tool: <tool>, with a one-sentence justification (why it is the single authority in this language domain).
- Minimum set of qualifying characteristics (all satisfied = OK):
  - `command -v <tool>` returns a result and `which -a <tool>` shows only one location
  - No initialization code from any other language manager of the same language is still active in shell configuration
  - <language primary command> resolves to the expected path

## 2. Deep probe (Read-only command list; the agent executes each one in order)

```bash
# Trace installation channels + multi-version coexistence
which -a <primary command>
brew list --versions <relevant formula> 2>/dev/null

# Manager's own state
<tool> --version
<tool> <list subcommand>

# Leftovers from old managers: characteristic directories + init code in shell config
ls -d ~/.<old manager directory> 2>/dev/null
grep -n '<old manager initialization signature>' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null

# Actual location where cache/data directory is placed (prefer asking the tool itself; environment variables can lie)
<tool's cache query command>
```

## 3. Judgment rules (Find → OK / WARN / FAIL)

| Finding | Judgment | Rationale |
|---|---|---|
| <tool> on PATH and unique, no old manager init remnants | OK | Meets the baseline |
| <tool> and old manager init both active | FAIL | shim/PATH conflict, resolution drift |
| Old manager directories remain but init has been removed | WARN | Harmless but recommended to clean up, to prevent accidental re‑activation by sourcing |
| <tool> is missing, but only one language instance exists from a single source | WARN | Usable but not the recommended path |
| Multiple copies of the same <tool> appear on PATH | FAIL | Version may silently stay on an older copy |

## 4. Migration plan (Five-step method; provide full commands when referenced in the report)

1. **Assess current state** — Same as §2.
2. **Install the new authoritative manager** — `<official installation command>`; after installation, verify the resolved path with `command -v <tool>`.
3. **Deal with the old** — Specify what must be uninstalled, what only requires removal of init code, and what can be left alone (with reasons).
4. **[Optional] External storage** — List of environment variables; note which ones must be set before installation.
5. **Verification** — Read-only verification commands plus expected output.

## 5. Known pitfalls (Reference when reporting risks)

- <Pitfall 1: Symptom → Root cause → Mitigation>
- <Pitfall 2>

---

## Anti-hallucination checklist (Go through every item when adding or modifying a reference; must not be skipped)

The most typical mistake when an LLM writes this kind of document is **stitching together memories of two real things into something that does not exist**  
(real examples: `asdf set --global` = old `asdf global` combined with new `asdf set`;  
`UV_VIRTUALENV_DIR` = uv’s real variable naming style combined with a non‑existent global venv concept).  
After writing from memory, verify point by point:

- [ ] **Every command / subcommand / flag**: Actually run it on your machine, or at least check `<tool> <subcmd> --help` to confirm the flag exists. For tools that have had major CLI changes across versions (asdf 0.16 rewrite), note the applicable version.
- [ ] **Every environment variable**: Confirm via official documentation; if the tool is installed locally, use `strings "$(command -v <tool>)" | grep <VAR>` to verify the name really exists in the binary.
- [ ] **Every installation channel**: Run `brew info <formula|cask>` to confirm it exists and distinguish formula vs. cask; verify installation script URLs character‑by‑character against the official README—do not recall domain names from memory.
- [ ] **Every assertion of “tool X’s default directory / default behavior”**: Check current documentation—defaults are the most likely to drift with versions (fnm’s default directory has changed before).
- [ ] **Version‑number‑related assertions** (e.g., “Apple git is frozen at 2.39.x”): Clearly state that it is a fact at the time of writing, avoiding absolute phrasing.
- [ ] **New variables must be synchronized into `scripts/probe-cache.sh`** (the external‑variable list in §4 and the script’s verification checklist must be consistent; avoid the gap where a reference recommends something but the cross‑cutting check cannot see it).
- [ ] For items that cannot be verified locally (tool not installed): Mark inline as “Not verified locally, source: <link / document name>”—prefer marking over guessing.
