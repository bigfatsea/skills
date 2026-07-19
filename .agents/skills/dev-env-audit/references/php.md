<!-- Ver 2026-07-18 20:00, by Claude Fable 5 -->

# PHP – Authoritative Manager: Homebrew (Single Version) / ASDF (Multi-Version or Multi-Language Full-Stack Unification)

## 1. Baseline

- **Single-version scenario**: `brew install php` is enough, simple and direct.
- **Multi-version scenario**: Homebrew can also install specific versions like `php@8.1`/`php@8.3` side-by-side (they are all keg-only and won’t overwrite each other’s PATH), but switching requires manual `brew link/unlink`, which is less convenient than a version manager. Full-stack developers already using ASDF to manage other languages should just use the `asdf-php` plugin for a unified experience.
- Minimum qualifying feature set:
  - `php --version` resolves to the expected version
  - No indeterminate state caused by multiple brew-installed PHP versions being unlinked/linked with each other

## 2. Deep-dive Probe (Read-Only)

```bash
which -a php
php --version

# Which versions installed on the brew side
brew list --formula 2>/dev/null | grep -E '^php(@[0-9.]+)?$'
brew list --versions php 2>/dev/null

# asdf side (if used)
asdf current php 2>/dev/null
asdf list php 2>/dev/null

composer --version 2>/dev/null
```

## 3. Assessment Rules

| Finding | Verdict | Rationale |
|---|---|---|
| PHP's sole source (brew or asdf), version matches expectation | OK | Meets requirement |
| brew has multiple `php@x.y` installed but none is manually linked | WARN | All versions are keg-only; the `php` command may not resolve to the expected version or may not be found at all. Need to explicitly `brew link php@x.y` |
| asdf php and brew php are both treated as authoritative | WARN | They can coexist without conflict (later-installed keg-only `php@x.y` won’t grab PATH), but it’s easy to lose track of which one is actually in effect. It’s recommended to unify. |
| Composer missing, project has `composer.json` | WARN | Dependency management not running, install Composer |

## 4. Migration Plan (Five-Step Method)

1. **Inspect current state** — complete §2.
2. **Install authoritative manager**:
   ```bash
   # Single version / need specific versions coexist
   brew install php@8.3
   brew link --force php@8.3   # execute when you want it to be the default php command

   # Multi-language full-stack unification
   asdf plugin add php
   asdf install php <version>
   asdf set -u php <version>    # -u/--home writes to home directory .tool-versions; for asdf ≤0.15 the old syntax is asdf global php <version>
   ```
   Composer (needed for both paths):
   ```bash
   brew install composer          # Preferred: no sudo, upgrades unified via brew
   # Or the official installer (if you don't want to go through brew):
   # curl -sS https://getcomposer.org/installer | php
   # mkdir -p ~/.local/bin && mv composer.phar ~/.local/bin/composer   # place in user directory, avoid sudo
   ```
3. **Handle old versions**: `brew unlink php@<old version>` for redundant brew PHP versions, no need to uninstall (unless you confirm they are no longer needed).
4. **[Optional] External storage**: Composer’s global cache can be relocated:
   ```bash
   export COMPOSER_CACHE_DIR="/Volumes/<disk>/dev-cache/composer-cache"
   ```
5. **Verify**:
   ```bash
   php --version; which php
   composer --version
   ```

## 5. Known Pitfalls

- **All versioned `php@x.y` formulas are keg-only**: they don’t automatically appear on PATH after installation; you must `brew link` to get the `php` command. This is by design (to prevent multiple PHP versions from overwriting each other), not a bug.
- **After switching PHP versions, extensions must be reinstalled**: PHP extensions like xdebug are compiled per version. After switching the default version via `brew link`, previously installed extensions may not work with the new version; you need to reinstall them for the new version.
- **Keep Composer global dependencies separate from project dependencies**: `composer global require` installs global tools; they are different from the dependencies in your project’s `composer.json`. Don’t mix them up when debugging.
