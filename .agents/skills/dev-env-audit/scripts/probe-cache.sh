#!/usr/bin/env zsh
# Ver 2026-07-18 20:00, by Claude Fable 5
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
# 只读,不修改任何东西。
# 用法: zsh probe-cache.sh
# 退出码: 0 = 无异常; 1 = 存在 WARN/FAIL。

emulate -L zsh

print "# dev-env-audit probe-cache"
print "# env snapshot = this process's inherited environment (cross-scenario check at the end)"
print ""

local n_external=0 n_unset=0 n_local=0 n_bad=0 n_scen=0

# vol_state <path>: 0=外置且已挂载 1=外置但未挂载 2=非外置
vol_state() {
  local val=$1
  [[ "$val" == /Volumes/* ]] || return 2
  local vol="${val#/Volumes/}"; vol="/Volumes/${vol%%/*}"
  [[ -d "$vol" ]] && return 0 || return 1
}

# classify <VAR_NAME> <tool> [optional] — 环境变量口径。tool 不存在时跳过该变量(不计入统计)。
# optional: 本体安装目录类变量(如 RBENV_ROOT),reference 认可"不外置是常态"——
# unset 时只报状态不计入漂移分母,否则每台正常机器都会被这类变量拖成 WARN。
classify() {
  local var=$1 tool=$2 optional=${3:-}
  if [[ -n "$tool" ]] && ! command -v "$tool" >/dev/null 2>&1; then
    return
  fi
  local val="${(P)var}"
  if [[ -z "$val" ]]; then
    if [[ "$optional" == optional ]]; then
      print "INFO: $var unset (default location; relocation optional, not counted toward drift)"
    else
      print "INFO: $var unset (tool uses its default location)"
      (( n_unset++ ))
    fi
    return
  fi
  vol_state "$val"
  case $? in
    0) print "OK: $var = $val (external volume, mounted)"; (( n_external++ )) ;;
    1) print "FAIL: $var = $val (volume NOT mounted)"; (( n_bad++ )) ;;
    2) print "INFO: $var = $val (custom local path — explicit choice, not counted as drift)"; (( n_local++ )) ;;
  esac
}

# classify_eff <label> <effective-value> <deliberate 0|1> — 生效值口径。
# deliberate=1 表示该落位来自显式配置(env var 已设 / go env -w / pnpm config set /
# settings.xml),非外置时算"刻意本地"不算漂移;deliberate=0 的非外置 = 没外置,计入漂移。
classify_eff() {
  local label=$1 val=$2 deliberate=$3
  if [[ -z "$val" ]]; then
    print "INFO: $label — effective value unavailable"
    return
  fi
  vol_state "$val"
  case $? in
    0) print "OK: $label -> $val (external volume, mounted)"; (( n_external++ )) ;;
    1) print "FAIL: $label -> $val (volume NOT mounted)"; (( n_bad++ )) ;;
    2) if (( deliberate )); then
         print "INFO: $label -> $val (custom local path — explicit choice, not counted as drift)"
         (( n_local++ ))
       else
         print "INFO: $label -> $val (default location, not relocated)"
         (( n_unset++ ))
       fi ;;
  esac
}

is_set() { [[ -n "${(P)1}" ]] && print 1 || print 0 }

print "== uv (judged by uv's own effective dirs) =="
if command -v uv >/dev/null 2>&1; then
  classify_eff "uv cache dir"  "$(uv cache dir 2>/dev/null)"  "$(is_set UV_CACHE_DIR)"
  classify_eff "uv python dir" "$(uv python dir 2>/dev/null)" "$(is_set UV_PYTHON_INSTALL_DIR)"
  classify_eff "uv tool dir"   "$(uv tool dir 2>/dev/null)"   "$(is_set UV_TOOL_DIR)"
else
  print "  (uv not installed — skipped)"
fi
# 注意: UV_VIRTUALENV_DIR 不是 uv 的环境变量(uv 无全局 venv 目录概念)——设了也静默无效,勿加

print ""
print "== node toolchain =="
classify FNM_DIR fnm
classify PNPM_HOME pnpm
classify NPM_CONFIG_CACHE npm
# NPM_CONFIG_PREFIX 与版本管理器相克(见 node.md §5)——这里只报状态,报告里要提示移除
classify NPM_CONFIG_PREFIX npm
if command -v pnpm >/dev/null 2>&1; then
  # pnpm 的 store 只认自己的配置,环境变量与 mv 目录都不生效——必须问它本身
  local _store
  _store=$(pnpm config get store-dir 2>/dev/null)
  [[ "$_store" == "undefined" ]] && _store=""
  if [[ -n "$_store" ]]; then
    classify_eff "pnpm store-dir" "$_store" 1
  else
    print "INFO: pnpm store-dir not configured (default location, not relocated)"
    (( n_unset++ ))
  fi
fi

print ""
print "== jvm toolchain =="
# SDKMAN 是 shell 函数,command -v 探测不到,靠"变量已设或默认目录存在"判断是否在用;
# 变量已设但指向未挂载卷时目录不存在,所以不能只看目录——否则会漏掉 FAIL
if [[ -n "$SDKMAN_DIR" || -d "$HOME/.sdkman" ]]; then
  classify SDKMAN_DIR ""
fi
classify GRADLE_USER_HOME gradle
# Maven 不认任何环境变量,只认 ~/.m2/settings.xml 的 <localRepository>
if command -v mvn >/dev/null 2>&1; then
  if [[ -f "$HOME/.m2/settings.xml" ]]; then
    local repo
    repo=$(grep -o '<localRepository>[^<]*</localRepository>' "$HOME/.m2/settings.xml" 2>/dev/null \
           | sed -e 's/<localRepository>//' -e 's#</localRepository>##' | head -1)
    if [[ -n "$repo" ]]; then
      # settings.xml 里写了就是显式配置(deliberate=1);外置路径同样要过挂载检查
      classify_eff "maven localRepository (~/.m2/settings.xml)" "$repo" 1
    else
      print "INFO: ~/.m2/settings.xml exists but no <localRepository> (default ~/.m2/repository)"
      (( n_unset++ ))
    fi
  else
    print "INFO: no ~/.m2/settings.xml (maven uses default ~/.m2/repository)"
    (( n_unset++ ))
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
  classify_eff "go env GOCACHE"    "$(go env GOCACHE 2>/dev/null)"    $_del_gocache
  classify_eff "go env GOMODCACHE" "$(go env GOMODCACHE 2>/dev/null)" $_del_gomod
fi

print ""
print "== rust / asdf =="
classify ASDF_DATA_DIR asdf
classify RUSTUP_HOME rustup
classify CARGO_HOME cargo

print ""
print "== python misc =="
classify POETRY_CACHE_DIR poetry
classify POETRY_DATA_DIR poetry

print ""
print "== other toolchains (对应各语言 reference §4 的外置变量) =="
classify COMPOSER_CACHE_DIR composer
classify RBENV_ROOT rbenv optional   # ruby.md §4:rbenv 版本体积小,一般不外置
classify FVM_HOME fvm
classify JULIAUP_DEPOT_PATH juliaup
classify JULIA_DEPOT_PATH julia
classify VCPKG_DOWNLOADS vcpkg
classify VCPKG_DEFAULT_BINARY_CACHE vcpkg
classify DOTNET_ROOT dotnet optional # 安装根而非缓存,默认 ~/.dotnet 是常态
classify BUN_INSTALL bun optional    # 安装根,默认 ~/.bun 是常态
classify DENO_DIR deno
classify LUAROCKS_CONFIG luarocks optional # 指向 config 文件,rocks_trees 外置写在文件里(lua.md §4)

print ""
print "== cross-scenario consistency (A=zsh -c  B=zsh -l -c  C=zsh -l -i -c) =="
# 外置变量若只写在 ~/.zshrc(交互档),B 档(GUI App / launchd)看不到 → 工具在那些
# 场景静默落回默认目录,同一台机器长出两套缓存。只比对清单内变量,不 dump 全部 env
# (全量 env 会把 secrets 带进审计报告)。
local _vars=(UV_CACHE_DIR UV_PYTHON_INSTALL_DIR UV_TOOL_DIR FNM_DIR PNPM_HOME
  NPM_CONFIG_CACHE NPM_CONFIG_PREFIX SDKMAN_DIR GRADLE_USER_HOME ASDF_DATA_DIR
  RUSTUP_HOME CARGO_HOME GOCACHE GOMODCACHE GOPATH POETRY_CACHE_DIR POETRY_DATA_DIR
  COMPOSER_CACHE_DIR RBENV_ROOT FVM_HOME JULIAUP_DEPOT_PATH JULIA_DEPOT_PATH
  VCPKG_DOWNLOADS VCPKG_DEFAULT_BINARY_CACHE DOTNET_ROOT BUN_INSTALL DENO_DIR
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

print ""
print "== summary =="
print "external=$n_external  not-relocated(default)=$n_unset  local-custom=$n_local  broken=$n_bad  scenario-drift=$n_scen"
if (( n_bad > 0 )); then
  print "RESULT: FAIL — some paths point to an unmounted volume (mount it, or the tools"
  print "        silently fall back / error depending on the tool)"
  exit 1
elif (( n_external > 0 && n_unset > 0 )); then
  print "RESULT: WARN — drift: some caches external while others are not relocated."
  print "        Most dangerous state: usually a later-installed tool missed its config."
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
