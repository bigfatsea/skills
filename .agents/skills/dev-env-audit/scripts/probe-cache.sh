#!/usr/bin/env zsh
# Ver 2026-07-19 05:30, by Claude Sonnet 5
# probe-cache.sh — Phase 3 横切检查②：开发缓存外置核查。
# 判定口径分两层:
#   1) 生效值优先——能问工具本身的(uv / pnpm / go / maven),按工具报告的实际落位判定。
#      环境变量会骗人:unset 但已用 go env -w / pnpm config set 完成外置(假漂移),
#      或 set 了却被工具忽略(假外置)。
#   2) 其余条目按本进程继承的环境变量判定(与 env 命令同源 = 覆盖后的最终落地值)。
# 三种状态: 外置(external) / 显式本地自定义(local, 刻意选择不算漂移) / 未外置(default)。
# 漂移 = 部分外置部分默认——通常是后装的工具漏配了(WARN);指向未挂载卷 = FAIL。
# 另做三场景一致性检查:外置变量只写进 ~/.zshrc(交互档)时,GUI App / launchd
# (登录非交互档)看不到,工具在那些场景静默落回默认目录 = 隐性漂移(WARN)。
# 判定标准不 hardcode 具体盘符:/Volumes/<已挂载卷>/ 下即视为外置。
# 漂移统计按"工具分组"而不是全局计数:同一个工具内部部分外置部分默认才算漂移
# (如 uv 的 PYTHON_INSTALL_DIR 外置了但 CACHE_DIR 没有);不同工具之间进度不一
# (uv 已外置、Maven 还没顾得上)是正常状态,不算漂移——外置本来就是可选项,
# 不该因为"你还没把所有工具都搬完"就报警(2026-07-19 复核修正:此前用全局计数器,
# 任何"有的工具外置了+有的工具没外置"都会被误判成 WARN,而这在几乎每台机器上
# 都会发生,是过度敏感的假阳性)。
# 只读,不修改任何东西。
# 用法: zsh probe-cache.sh
# 退出码: 0 = 无异常; 1 = 存在 WARN/FAIL。

# Portable guard (plain POSIX syntax, parses fine under bash/sh too): if this
# ever gets run with the wrong interpreter, fail with one clear line instead
# of a cascade of zsh-syntax parse errors further down.
if [ -z "$ZSH_VERSION" ]; then
  echo "error: this script requires zsh — run: zsh scripts/probe-cache.sh" >&2
  exit 1
fi
if [ "$(uname -s)" != "Darwin" ]; then
  echo "error: dev-env-audit only supports macOS (relies on Homebrew/Xcode/path_helper conventions); detected: $(uname -s)" >&2
  exit 1
fi

emulate -L zsh

print "# dev-env-audit probe-cache"
print "# env snapshot = this process's inherited environment (cross-scenario check at the end)"
print ""

local n_external=0 n_unset=0 n_local=0 n_bad=0 n_scen=0
# 按工具分组的漂移统计(组内 external>0 且 unset>0 才算漂移,组间不比较)。
typeset -A n_ext_g n_unset_g
typeset -a _groups_seen
_groups_seen=()
_note_group() {
  local g=$1
  (( ${_groups_seen[(Ie)$g]} )) || _groups_seen+=("$g")
}

# vol_state <path>: 0=外置且已挂载 1=外置但未挂载 2=非外置
vol_state() {
  local val=$1
  [[ "$val" == /Volumes/* ]] || return 2
  local vol="${val#/Volumes/}"; vol="/Volumes/${vol%%/*}"
  [[ -d "$vol" ]] && return 0 || return 1
}

# classify <VAR_NAME> <tool> <group> [optional] — 环境变量口径。tool 不存在时跳过该变量(不计入统计)。
# group: 该变量属于哪个"工具组"(如 uv/node/jvm/rust…),漂移判定按组内 external+unset
# 是否同时出现,不同组之间不比较。
# optional: 本体安装目录类变量(如 RBENV_ROOT),reference 认可"不外置是常态"——
# unset 时只报状态不计入漂移分母,否则每台正常机器都会被这类变量拖成 WARN。
classify() {
  local var=$1 tool=$2 group=$3 optional=${4:-}
  if [[ -n "$tool" ]] && ! command -v "$tool" >/dev/null 2>&1; then
    return
  fi
  _note_group "$group"
  local val="${(P)var}"
  if [[ -z "$val" ]]; then
    if [[ "$optional" == optional ]]; then
      print "INFO: $var unset (default location; relocation optional, not counted toward drift)"
    else
      print "INFO: $var unset (tool uses its default location)"
      (( n_unset++ )); (( n_unset_g[$group]++ ))
    fi
    return
  fi
  vol_state "$val"
  case $? in
    0) print "OK: $var = $val (external volume, mounted)"; (( n_external++ )); (( n_ext_g[$group]++ )) ;;
    1) print "FAIL: $var = $val (volume NOT mounted)"; (( n_bad++ )) ;;
    2) print "INFO: $var = $val (custom local path — explicit choice, not counted as drift)"; (( n_local++ )) ;;
  esac
}

# classify_eff <label> <effective-value> <deliberate 0|1> <group> — 生效值口径。
# deliberate=1 表示该落位来自显式配置(env var 已设 / go env -w / pnpm config set /
# settings.xml),非外置时算"刻意本地"不算漂移;deliberate=0 的非外置 = 没外置,计入漂移。
classify_eff() {
  local label=$1 val=$2 deliberate=$3 group=$4
  _note_group "$group"
  if [[ -z "$val" ]]; then
    print "INFO: $label — effective value unavailable"
    return
  fi
  vol_state "$val"
  case $? in
    0) print "OK: $label -> $val (external volume, mounted)"; (( n_external++ )); (( n_ext_g[$group]++ )) ;;
    1) print "FAIL: $label -> $val (volume NOT mounted)"; (( n_bad++ )) ;;
    2) if (( deliberate )); then
         print "INFO: $label -> $val (custom local path — explicit choice, not counted as drift)"
         (( n_local++ ))
       else
         print "INFO: $label -> $val (default location, not relocated)"
         (( n_unset++ )); (( n_unset_g[$group]++ ))
       fi ;;
  esac
}

is_set() { [[ -n "${(P)1}" ]] && print 1 || print 0 }

print "== uv (judged by uv's own effective dirs) =="
if command -v uv >/dev/null 2>&1; then
  classify_eff "uv cache dir"  "$(uv cache dir 2>/dev/null)"  "$(is_set UV_CACHE_DIR)" uv
  classify_eff "uv python dir" "$(uv python dir 2>/dev/null)" "$(is_set UV_PYTHON_INSTALL_DIR)" uv
  classify_eff "uv tool dir"   "$(uv tool dir 2>/dev/null)"   "$(is_set UV_TOOL_DIR)" uv
else
  print "  (uv not installed — skipped)"
fi
# 注意: UV_VIRTUALENV_DIR 不是 uv 的环境变量(uv 无全局 venv 目录概念)——设了也静默无效,勿加

print ""
print "== node toolchain =="
classify FNM_DIR fnm node
classify PNPM_HOME pnpm node
classify NPM_CONFIG_CACHE npm node
# NPM_CONFIG_PREFIX 与版本管理器相克(见 node.md §5)。只查这个 env 变量会有假阴性:
# npm config set prefix 会把同样的值持久化写进 ~/.npmrc 的 prefix= 行,这是独立于 shell
# 变量的第二层配置——env 变量 unset 不代表 npm 的真正生效值也是默认(2026-07-18 真实
# 踩过:删了 env 变量以为解决了,npm 依然读到 ~/.npmrc 的旧值)。两处都查才不会误判。
classify NPM_CONFIG_PREFIX npm node
if [[ -f "$HOME/.npmrc" ]]; then
  local _npmrc_prefix
  _npmrc_prefix=$(grep -m1 '^prefix' "$HOME/.npmrc" 2>/dev/null)
  [[ -n "$_npmrc_prefix" ]] && print "WARN: ~/.npmrc has persisted $_npmrc_prefix — independent of NPM_CONFIG_PREFIX env var, also pins npm -g across all fnm Node versions (native-module ABI risk, see node.md §5). Must remove here too if reverting the env var."
fi
if command -v pnpm >/dev/null 2>&1; then
  # pnpm 的 store 只认自己的配置,环境变量与 mv 目录都不生效——必须问它本身
  local _store
  _store=$(pnpm config get store-dir 2>/dev/null)
  [[ "$_store" == "undefined" ]] && _store=""
  if [[ -n "$_store" ]]; then
    classify_eff "pnpm store-dir" "$_store" 1 node
  else
    _note_group node
    print "INFO: pnpm store-dir not configured (default location, not relocated)"
    (( n_unset++ )); (( n_unset_g[node]++ ))
  fi
fi

print ""
print "== jvm toolchain =="
# SDKMAN 是 shell 函数,command -v 探测不到,靠"变量已设或默认目录存在"判断是否在用;
# 变量已设但指向未挂载卷时目录不存在,所以不能只看目录——否则会漏掉 FAIL
if [[ -n "$SDKMAN_DIR" || -d "$HOME/.sdkman" ]]; then
  classify SDKMAN_DIR "" jvm
fi
classify GRADLE_USER_HOME gradle jvm
# Maven 不认任何环境变量,只认 ~/.m2/settings.xml 的 <localRepository>
if command -v mvn >/dev/null 2>&1; then
  _note_group jvm
  if [[ -f "$HOME/.m2/settings.xml" ]]; then
    local repo
    repo=$(grep -o '<localRepository>[^<]*</localRepository>' "$HOME/.m2/settings.xml" 2>/dev/null \
           | sed -e 's/<localRepository>//' -e 's#</localRepository>##' | head -1)
    if [[ -n "$repo" ]]; then
      # settings.xml 里写了就是显式配置(deliberate=1);外置路径同样要过挂载检查
      classify_eff "maven localRepository (~/.m2/settings.xml)" "$repo" 1 jvm
    else
      print "INFO: ~/.m2/settings.xml exists but no <localRepository> (default ~/.m2/repository)"
      (( n_unset++ )); (( n_unset_g[jvm]++ ))
    fi
  else
    print "INFO: no ~/.m2/settings.xml (maven uses default ~/.m2/repository)"
    (( n_unset++ )); (( n_unset_g[jvm]++ ))
  fi
  print "  note: authoritative check is 'mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout'"
  print "        (not run here: it may download a plugin on first use = network access)"
fi

print ""
print "== go (judged by go env — catches go env -w relocation that shell env misses) =="
if command -v go >/dev/null 2>&1; then
  # go env -w 写进 go 自己的 env 文件,不进 shell 环境;go env -changed 列出偏离默认值的项 = 显式配置
  local _changed _del_gocache=0 _del_gomod=0
  _changed=$(go env -changed 2>/dev/null)
  [[ -n "$GOCACHE"    || "$_changed" == *GOCACHE=*    ]] && _del_gocache=1
  [[ -n "$GOMODCACHE" || "$_changed" == *GOMODCACHE=* || -n "$GOPATH" || "$_changed" == *GOPATH=* ]] && _del_gomod=1
  classify_eff "go env GOCACHE"    "$(go env GOCACHE 2>/dev/null)"    $_del_gocache go
  classify_eff "go env GOMODCACHE" "$(go env GOMODCACHE 2>/dev/null)" $_del_gomod go
fi

print ""
print "== rust / asdf =="
classify ASDF_DATA_DIR asdf asdf
classify RUSTUP_HOME rustup rust
classify CARGO_HOME cargo rust

print ""
print "== python misc =="
classify POETRY_CACHE_DIR poetry poetry
classify POETRY_DATA_DIR poetry poetry

print ""
print "== other toolchains (对应各语言 reference §4 的外置变量) =="
classify COMPOSER_CACHE_DIR composer php
classify RBENV_ROOT rbenv ruby optional   # ruby.md §4:rbenv 版本体积小,一般不外置
classify FVM_HOME fvm dart
classify JULIAUP_DEPOT_PATH juliaup julia
classify JULIA_DEPOT_PATH julia julia
classify VCPKG_DOWNLOADS vcpkg cpp
classify VCPKG_DEFAULT_BINARY_CACHE vcpkg cpp
classify BUN_INSTALL bun bun optional    # 安装根,默认 ~/.bun 是常态
classify DENO_DIR deno deno
classify LUAROCKS_CONFIG luarocks lua optional # 指向 config 文件,rocks_trees 外置写在文件里(lua.md §4)

print ""
print "== cross-scenario consistency (A=zsh -c  B=zsh -l -c  C=zsh -l -i -c) =="
# 外置变量若只写在 ~/.zshrc(交互档),B 档(GUI App / launchd)看不到 → 工具在那些
# 场景静默落回默认目录,同一台机器长出两套缓存。只比对清单内变量,不 dump 全部 env
# (全量 env 会把 secrets 带进审计报告)。
local _vars=(UV_CACHE_DIR UV_PYTHON_INSTALL_DIR UV_TOOL_DIR FNM_DIR PNPM_HOME
  NPM_CONFIG_CACHE NPM_CONFIG_PREFIX SDKMAN_DIR GRADLE_USER_HOME ASDF_DATA_DIR
  RUSTUP_HOME CARGO_HOME GOCACHE GOMODCACHE GOPATH POETRY_CACHE_DIR POETRY_DATA_DIR
  COMPOSER_CACHE_DIR RBENV_ROOT FVM_HOME JULIAUP_DEPOT_PATH JULIA_DEPOT_PATH
  VCPKG_DOWNLOADS VCPKG_DEFAULT_BINARY_CACHE BUN_INSTALL DENO_DIR
  LUAROCKS_CONFIG)
local _script='for v in '"${_vars[*]}"'; do print -r -- "$v=${(P)v}"; done'
local _a _b _c
_a=$(zsh -c "$_script" 2>/dev/null)
_b=$(zsh -l -c "$_script" 2>/dev/null)
_c=$(zsh -l -i -c "$_script" 2>/dev/null)
local v va vb vc
for v in $_vars; do
  # 交互档可能混入问候语等噪音,按 "VAR=" 前缀过滤
  va=$(print -r -- "$_a" | grep -m1 "^$v="); va=${va#*=}
  vb=$(print -r -- "$_b" | grep -m1 "^$v="); vb=${vb#*=}
  vc=$(print -r -- "$_c" | grep -m1 "^$v="); vc=${vc#*=}
  if [[ "$va" != "$vb" || "$vb" != "$vc" ]]; then
    (( n_scen++ ))
    print "WARN: $v differs across shell scenarios (tools see different values per context):"
    print "  A(non-login):          ${va:-(empty)}"
    print "  B(login,non-interact): ${vb:-(empty)}"
    print "  C(login,interactive):  ${vc:-(empty)}"
  fi
done
(( n_scen == 0 )) && print "OK: all relocation vars identical across A/B/C"

# 按工具分组判定组内漂移:同一个工具组里既有 external 又有 unset(非 optional)
# 才算漂移——不同工具组之间进度不一(uv 已外置、maven 还没顾得上)不算,这是
# "外置是可选项"的合法状态,不该被计进警告。
local -a _drifted_groups
_drifted_groups=()
local g
for g in $_groups_seen; do
  if (( ${n_ext_g[$g]:-0} > 0 && ${n_unset_g[$g]:-0} > 0 )); then
    _drifted_groups+=("$g")
  fi
done

print ""
print "== summary =="
print "external=$n_external  not-relocated(default)=$n_unset  local-custom=$n_local  broken=$n_bad  scenario-drift=$n_scen"
if (( ${#_drifted_groups} > 0 )); then
  print "groups with internal drift: ${_drifted_groups[*]}"
fi
if (( n_bad > 0 )); then
  print "RESULT: FAIL — some paths point to an unmounted volume (mount it, or the tools"
  print "        silently fall back / error depending on the tool)"
  exit 1
elif (( ${#_drifted_groups} > 0 )); then
  print "RESULT: WARN — drift within: ${_drifted_groups[*]} (some of that tool's own cache"
  print "        vars are relocated, others aren't — usually a partial migration was left"
  print "        unfinished). Other tools not fully relocated is fine on its own — relocation"
  print "        is optional per-tool, not a global requirement."
  (( n_scen > 0 )) && print "        Plus: some vars differ across shell scenarios (see above)."
  exit 1
elif (( n_scen > 0 )); then
  print "RESULT: WARN — relocation vars differ across shell scenarios (hidden drift:"
  print "        GUI App / launchd contexts fall back to default locations)."
  exit 1
elif (( n_external > 0 )); then
  print "RESULT: OK — relocation enabled and consistent"
  exit 0
else
  print "RESULT: OK — no relocation configured (default locations; that is a legal choice)"
  exit 0
fi
