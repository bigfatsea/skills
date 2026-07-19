<!-- Ver 2026-07-18 17:40, by Claude Fable 5 -->

# Go — Homebrew for Single Version (Undisputed); Extra Tools Only for Global Multi‑Version

## 1. Baseline

- **Single‑version scenario (vast majority of users)**: simply `brew install go` — uncontroversial. Go 1.21+ ships with the built‑in `GOTOOLCHAIN` mechanism; `go build`/`go run`/`go test` will automatically download, cache and switch to the matching toolchain declared by the `go` directive in each project’s `go.mod`. Project‑level multi‑version requirements are already handled by the language itself; no external version manager is needed.
- **Global multi‑version scenario** (e.g., you need to explicitly run an older version in a context without a `go.mod`, or in an offline environment where `GOTOOLCHAIN` cannot auto‑download): prefer the official native parallel‑install mechanism —
  ```bash
  go install golang.org/dl/go1.21.5@latest && go1.21.5 download
  ```
  This produces an independently‑named `go1.21.5` command that coexists with the default `go`, using zero third‑party tools — consistent with the general principle of “official before third‑party”. Only when you need directory‑aware automatic switching (like `.tool‑versions`) and you are not satisfied with typing version‑specific commands should you reach for **asdf + the golang plugin**.
- **Do not install both** the asdf golang plugin and the official/brew Go installation side‑by‑side — they will fight over `PATH`.
- Minimum acceptable feature set:
  - `which -a go` returns exactly one, coming from either brew, asdf shims, or an official install location.
  - No gvm coexistence.

## 2. Deep‑dive Probe (read‑only)

```bash
which -a go
go version
go env GOROOT GOPATH GOMODCACHE GOCACHE

# coexistence channels
brew list --formula 2>/dev/null | grep -E '^go(lang)?$'
ls -d ~/.gvm 2>/dev/null
grep -n 'gvm' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null

# asdf status (if in use)
asdf current golang 2>/dev/null
asdf list golang 2>/dev/null
```

## 3. Decision Rules

| Finding | Verdict | Rationale |
|---|---|---|
| Single Go, from either brew, asdf, or the official installer | OK | Meets criteria — using brew for a single version is the undisputed recommendation, not a compromise |
| asdf golang coexisting with brew go / official go | FAIL | Only one should be present; PATH order determines which wins |
| gvm init still active | FAIL | Conflicts with the current manager |
| Only brew go, no asdf | OK | The recommended state for single‑version scenarios itself, not merely “it works” |
| Global multi‑version needed but only a single brew go exists, and GOTOOLCHAIN/golang.org/dl is unknown | INFO | Hint about the official side‑install method (§1); not necessarily to push asdf |
| One of GOCACHE/GOMODCACHE is external while the other is default | WARN | They are independent concepts (§5); drift indicates incomplete configuration |

## 4. Migration Plan (Five‑Step Method)

1. **Examine the current state** — full §2.
2. **Single‑version scenario**: `brew install go` is the destination; nothing else is needed.
   **Global multi‑version scenario**: prefer the official side‑install (§1’s `golang.org/dl/goX.Y.Z`); only install asdf when directory‑aware automatic switching is required:
   ```bash
   brew install asdf
   asdf plugin add golang
   asdf install golang latest
   asdf set -u golang latest    # -u/--home writes to home directory .tool-versions; asdf ≤0.15 uses asdf global golang latest
   ```
3. **Handle old installations**:
   - Keep only asdf **or** brew go; uninstall the extra one with `brew uninstall go`.
   - gvm: delete the initialization code from shell configuration files.
4. **[Optional] External Storage**:
   ```bash
   export ASDF_DATA_DIR="/Volumes/<disk>/dev-cache/asdf"     # must be set before installing plugins
   export GOCACHE="/Volumes/<disk>/dev-cache/go-build"      # build cache
   # GOMODCACHE defaults to $GOPATH/pkg/mod, follows GOPATH; can also be exported separately
   ```
5. **Verify**:
   ```bash
   go version; which go
   go env GOPATH GOMODCACHE GOCACHE
   ```

## 5. Known Pitfalls

- **GOCACHE ≠ GOMODCACHE**: Build cache and module cache are two separate concepts and two separate variables; when placing them externally they must be handled separately — setting only one leads to drift.
- **Coexistence of asdf and the official installer**: Both can work, making the problem subtle — the shim and the real binary depend on PATH order; after a PATH change, `go version` silently switches.
- **ASDF_DATA_DIR must be set before installation**: Plugins and versions are installed into that directory; changing it afterwards will not move existing data.
