<!-- Ver 2026-07-18 17:40, by Claude Fable 5 -->

# Erlang / Elixir — Authoritative Manager: ASDF (asdf-erlang + asdf-elixir, recommended for both single and multiple versions)

## 1. Baseline

- Recommended tool: **ASDF** (using the `asdf-erlang` and `asdf-elixir` plugins together), **even if you need only a single version**. This is not a “only needed for multiple versions” scenario.
- Why Homebrew is not recommended even for a single version: OTP (the Erlang virtual machine) and Elixir have a strict version compatibility matrix (see the Compatibility and Deprecations page on hexdocs.pm/elixir). The system OTP version installed by Homebrew often falls outside the range required by the target Elixir version, resulting in obscure runtime/compile errors instead of clear “incompatible version” messages. ASDF can explicitly pin a matching pairing of the two, with significantly better fault tolerance.
- Minimum acceptable feature set:
  - A probe like `erl -eval 'halt().' -noshell` confirms the OTP version.
  - The Elixir/OTP pairing shown by `elixir --version` falls within the official compatibility matrix.
  - The `erlang` and `elixir` version lines in `.tool-versions` correspond to a matching pair.

## 2. Deep diagnostic (read-only)

```bash
which -a erl elixir mix

elixir --version 2>&1
erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().' 2>/dev/null

asdf current erlang 2>/dev/null
asdf current elixir 2>/dev/null

brew list --formula 2>/dev/null | grep -E '^(erlang|elixir)$'

# Project‑locked version pairing
cat .tool-versions 2>/dev/null | grep -E 'erlang|elixir'
```

## 3. Decision rules

| Observation | Verdict | Reason |
|---|---|---|
| ASDF manages erlang+elixir as a pairing that falls inside the official compatibility matrix | OK | Meets requirements |
| Brew-installed erlang/elixir pairing does **not** fall inside the official compatibility matrix | FAIL | Very likely to trigger obscure runtime errors; must reinstall a matching pair according to the matrix |
| `.tool-versions` specifies elixir but not erlang (or vice‑versa) | WARN | Both must be pinned together; specifying only one lets ASDF follow the global/system default, which invites drift |
| Both ASDF- and brew‑managed erlang/elixir are present | WARN | Which one takes effect depends on PATH order; it’s recommended to unify under ASDF |

## 4. Migration plan (five steps)

1. **Inspect the current state** – run the full §2 diagnostic; **be sure to check the official compatibility matrix first to confirm the target version pairing** (hexdocs.pm/elixir/compatibility-and-deprecations.html).
2. **Install ASDF plugins**:
   ```bash
   asdf plugin add erlang
   asdf plugin add elixir
   asdf install erlang <version>
   asdf install elixir <version>
   asdf set -u erlang <version>   # -u/--home writes to the home-directory .tool-versions; for asdf ≤0.15 the old syntax was asdf global <name> <version>
   asdf set -u elixir <version>
   ```
3. **Remove the old**:
   ```bash
   brew uninstall erlang elixir   # previously installed via brew
   ```
4. **[Optional] External storage**:
   ```bash
   export ASDF_DATA_DIR="/Volumes/<drive>/dev-cache/asdf"   # must be set before adding plugins; erlang/elixir will be installed under this path
   ```
5. **Verify**:
   ```bash
   elixir --version
   erl -noshell -eval 'io:format("~s~n", [erlang:system_info(otp_release)]), halt().'
   asdf current erlang; asdf current elixir
   ```

## 5. Known pitfalls

- **OTP and Elixir versions must be paired – they cannot be chosen independently**: There is a clear official compatibility matrix. A mismatched pairing will not be caught during installation; the problem surfaces only when compiling or running a project, making diagnosis costly. Checking the matrix before installing saves far more time than debugging afterward.
- **Rebar3 (the Erlang build tool) sometimes requires separate installation**: Not every `asdf-erlang` installation automatically includes Rebar3. If it’s missing, use `mix local.rebar` or refer to the official Rebar3 installation guide to install it separately.
