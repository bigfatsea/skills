#!/usr/bin/env zsh
# Ver 2026-07-17 13:00, by Claude Fable 5
# probe-cache.sh — Phase 3 横切检查②：开发缓存外置核查。
# 对照环境变量清单，输出每项: 当前值 / 是否指向已挂载的外置卷 / 工具自身报告的生效值。
# 外置是可选项：全部未设置(默认位置)是合法状态(INFO)；
# "部分外置部分未设置"(漂移)才是最危险的状态(WARN)；指向未挂载卷 = FAIL。
# 判定标准不 hardcode 具体盘符：/Volumes/<已挂载卷>/ 下即视为外置。
# 只读，不修改任何东西。读取的是本进程继承的环境。
# 用法: zsh probe-cache.sh
# 退出码: 0 = 无异常; 1 = 存在 WARN/FAIL。

emulate -L zsh

print "# dev-env-audit probe-cache"
print "# env snapshot = this process's inherited environment"
print ""

local n_external=0 n_unset=0 n_local=0 n_bad=0

# classify <VAR_NAME> <tool> — tool 不存在时跳过该变量(不计入统计)
# 三种状态: 外置(external) / 显式本地自定义(local, 刻意选择不算漂移) / 未设置(unset)
# 漂移 = 别的变量外置了、这个却完全没设——通常是后装的工具漏配了
classify() {
  local var=$1 tool=$2
  if [[ -n "$tool" ]] && ! command -v "$tool" >/dev/null 2>&1; then
    return
  fi
  local val="${(P)var}"
  if [[ -z "$val" ]]; then
    print "INFO: $var unset (tool uses its default location)"
    (( n_unset++ ))
  elif [[ "$val" == /Volumes/* ]]; then
    # 卷已挂载？取 /Volumes/<vol> 这一层判断
    local vol="${val#/Volumes/}"; vol="/Volumes/${vol%%/*}"
    if [[ -d "$vol" ]]; then
      print "OK: $var = $val (external volume, mounted)"
      (( n_external++ ))
    else
      print "FAIL: $var = $val (volume $vol NOT mounted)"
      (( n_bad++ ))
    fi
  else
    print "INFO: $var = $val (custom local path — explicit choice, not counted as drift)"
    (( n_local++ ))
  fi
}

print "== uv =="
classify UV_CACHE_DIR uv
classify UV_PYTHON_INSTALL_DIR uv
classify UV_TOOL_DIR uv
classify UV_VIRTUALENV_DIR uv
if command -v uv >/dev/null 2>&1; then
  print "  effective: uv cache dir -> $(uv cache dir 2>/dev/null || print '?')"
fi

print ""
print "== node toolchain =="
classify FNM_DIR fnm
classify PNPM_HOME pnpm
classify NPM_CONFIG_CACHE npm
classify NPM_CONFIG_PREFIX npm
if command -v pnpm >/dev/null 2>&1; then
  # pnpm 的 store 位置只认自己的配置，环境变量与 mv 目录都不生效——必须问它本身
  print "  effective: pnpm store-dir -> $(pnpm config get store-dir 2>/dev/null || print '?')"
fi

print ""
print "== jvm toolchain =="
classify SDKMAN_DIR ""
classify GRADLE_USER_HOME gradle
# Maven 不认任何环境变量，只认 ~/.m2/settings.xml 的 <localRepository>
if command -v mvn >/dev/null 2>&1; then
  if [[ -f "$HOME/.m2/settings.xml" ]]; then
    local repo
    repo=$(grep -o '<localRepository>[^<]*</localRepository>' "$HOME/.m2/settings.xml" 2>/dev/null \
           | sed -e 's/<localRepository>//' -e 's#</localRepository>##' | head -1)
    if [[ -n "$repo" ]]; then
      print "INFO: maven localRepository = $repo (from ~/.m2/settings.xml)"
      if [[ "$repo" == /Volumes/* ]]; then (( n_external++ )); else (( n_local++ )); fi
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
print "== go / rust / asdf =="
classify ASDF_DATA_DIR asdf
classify RUSTUP_HOME rustup
classify CARGO_HOME cargo
classify GOCACHE go
if command -v go >/dev/null 2>&1; then
  print "  effective: go env GOCACHE   -> $(go env GOCACHE 2>/dev/null)"
  print "  effective: go env GOMODCACHE -> $(go env GOMODCACHE 2>/dev/null)"
fi

print ""
print "== python misc =="
classify POETRY_CACHE_DIR poetry
classify POETRY_DATA_DIR poetry

print ""
print "== summary =="
print "external=$n_external  unset(default)=$n_unset  local-custom=$n_local  broken=$n_bad"
if (( n_bad > 0 )); then
  print "RESULT: FAIL — some vars point to an unmounted volume (mount it, or the tools"
  print "        silently fall back / error depending on the tool)"
  exit 1
elif (( n_external > 0 && n_unset > 0 )); then
  print "RESULT: WARN — drift: some caches external while others are unset (default)."
  print "        Most dangerous state: usually a later-installed tool missed its env var."
  exit 1
elif (( n_external > 0 )); then
  print "RESULT: OK — relocation enabled and consistent"
  exit 0
else
  print "RESULT: OK — no relocation configured (default locations; that is a legal choice)"
  exit 0
fi
