#!/usr/bin/env zsh
# Ver 2026-07-18 10:00, by Claude Sonnet 5
# scan.sh — Phase 1 粗扫：本机语言/版本管理器/包管理器存在性清单。
# 纯清单，不做判断（判断规则在 references/<lang>.md）。只读，不修改任何东西。
# 用法: zsh scan.sh
# 退出码: 恒为 0（清单无对错）。

emulate -L zsh
setopt no_nomatch

row() { printf '%-10s %-58s %s\n' "$1" "$2" "$3"; }

# probe_cmd <name> <version command...>
probe_cmd() {
  local name=$1; shift
  local p v
  p=$(command -v "$name" 2>/dev/null)
  if [[ -n "$p" ]]; then
    # 非路径结果 = shell 函数/别名(通常来自 ~/.zshenv 里的管理器 init)，标注出来
    [[ "$p" != /* ]] && p="$p (shell function/alias, likely init'ed in ~/.zshenv)"
    v=$("$@" 2>&1 | sed '/^[[:space:]]*$/d' | head -1)
    row "$name" "$p" "$v"
    return 0
  else
    row "$name" "(not found)" ""
    return 1
  fi
}

# dir_hint <name> <dir> — 命令不在 PATH 但特征目录存在时的重要信号
dir_hint() {
  local name=$1 dir=$2
  if ! command -v "$name" >/dev/null 2>&1 && [[ -d "$dir" ]]; then
    row "$name" "$dir" "(dir found, command not on PATH)"
  fi
}

print "# dev-env-audit scan  ($(date '+%Y-%m-%d %H:%M %Z'))"
print "# env snapshot = this process's inherited environment"
print ""

print "== shell config source chain =="
print -r -- "# 集中式 dotfiles 框架(如 ~/myenv 这类自定义目录)会把真正的 PATH/init 逻辑"
print -r -- "# 藏在被 source 的文件里——Phase 2 各 reference 的 grep 不要只认 ~/.zshrc/"
print -r -- "# ~/.zprofile/~/.zshenv 字面文件名，要连着下面列出的目标文件一起查。"
_scan_sources() {
  local file=$1 depth=$2
  (( depth > 2 )) && return
  [[ -f "$file" ]] || return
  local line target
  grep -E '^[[:space:]]*(source|\.)[[:space:]]+' "$file" 2>/dev/null | while IFS= read -r line; do
    target=$(print -r -- "$line" | sed -E 's/^[[:space:]]*(source|\.)[[:space:]]+//; s/[[:space:]]*(#.*)?$//; s/^"(.*)"$/\1/')
    target=${target//\$HOME/$HOME}
    target=${target/#\~/$HOME}
    [[ -f "$target" ]] && { print "  $file -> $target"; _scan_sources "$target" $(( depth + 1 )); }
  done
}
local _src_found=0
for rc in ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile ~/.bashrc; do
  [[ -f "$rc" ]] || continue
  _src_found=1
  _scan_sources "$rc" 0
done
(( _src_found == 0 )) && print "  (无任何 rc 文件)"

print ""
print "== languages =="
probe_cmd python3 python3 --version
probe_cmd node    node -v
if command -v java >/dev/null 2>&1; then
  row java "$(command -v java)" "$(java -version 2>&1 | head -1)"
else
  row java "(not found)" ""
fi
probe_cmd go      go version
probe_cmd rustc   rustc --version
probe_cmd cargo   cargo --version
probe_cmd ruby    ruby -v
probe_cmd bun     bun -v
probe_cmd deno    deno --version
probe_cmd git     git --version

print ""
print "== extended languages (C/C++, C#, Swift, PHP, Lua, Zig, Julia, Dart/Flutter, Erlang/Elixir) =="
probe_cmd dotnet  dotnet --version
probe_cmd swift   swift --version
probe_cmd php     php --version
probe_cmd lua     lua -v
probe_cmd zig     zig version
probe_cmd julia   julia --version
probe_cmd dart    dart --version
if command -v flutter >/dev/null 2>&1; then
  # flutter --version 有时会先打印一个"有新版本"的装饰性提示框，真正版本行以 Flutter 开头
  row flutter "$(command -v flutter)" "$(flutter --version 2>&1 | grep -m1 '^Flutter ')"
else
  row flutter "(not found)" ""
fi
probe_cmd elixir  elixir --version
if command -v erl >/dev/null 2>&1; then
  row erl "$(command -v erl)" "OTP $(erl -noshell -eval 'io:format("~s",[erlang:system_info(otp_release)]), halt().' 2>&1 | tail -1)"
else
  row erl "(not found)" ""
fi
probe_cmd clang   clang --version
probe_cmd gcc     gcc --version
probe_cmd cmake   cmake --version

# macOS: 列出系统登记过的全部 JDK（任何渠道装的都会出现）
# 注意：SDKMAN 装的 JDK 不注册进系统目录，这里为空且 SDKMAN 正常是常态(见 references/java.md §3)
if [[ -x /usr/libexec/java_home ]]; then
  print ""
  print "== registered JDKs (/usr/libexec/java_home -V) =="
  local jdks
  jdks=$(/usr/libexec/java_home -V 2>&1)
  if print -r -- "$jdks" | grep -qi 'unable to locate'; then
    print "  (none registered in /Library/Java/JavaVirtualMachines — normal if JDKs are SDKMAN-managed)"
  else
    print -r -- "$jdks" | sed 's/^/  /'
  fi
fi

print ""
print "== version managers =="
probe_cmd uv     uv --version
probe_cmd pyenv  pyenv --version
probe_cmd conda  conda --version
probe_cmd pipx   pipx --version
probe_cmd fnm    fnm --version
probe_cmd volta  volta --version
probe_cmd n      n --version
probe_cmd jenv   jenv --version
probe_cmd asdf   asdf version
probe_cmd rbenv  rbenv -v
probe_cmd rustup rustup --version
probe_cmd mise   mise --version
probe_cmd fvm      fvm --version
probe_cmd juliaup  juliaup --version
probe_cmd zigup    zigup --version

# 函数/脚本型管理器：不以独立二进制存在，靠特征目录探测
local sdk_dir="${SDKMAN_DIR:-$HOME/.sdkman}"
if [[ -d "$sdk_dir" ]]; then
  local sdk_ver=""
  [[ -f "$sdk_dir/var/version" ]] && sdk_ver="$(cat "$sdk_dir/var/version" 2>/dev/null)"
  row sdkman "$sdk_dir" "${sdk_ver:-(version file not found)}"
else
  row sdkman "(not found)" ""
fi
if [[ -d "$HOME/.nvm" ]]; then row nvm "$HOME/.nvm" "(dir found; nvm is a shell function)"; else row nvm "(not found)" ""; fi
if [[ -d "$HOME/.rvm" ]]; then row rvm "$HOME/.rvm" "(dir found; rvm conflicts with rbenv)"; else row rvm "(not found)" ""; fi
if [[ -d "$HOME/.gvm" ]]; then row gvm "$HOME/.gvm" "(dir found)"; else row gvm "(not found)" ""; fi

# 命令不在 PATH 但目录残留（"装过但没启用/没删干净"的信号）
print ""
print "== residual dirs (installed but command not on PATH) =="
dir_hint pyenv  "$HOME/.pyenv"
dir_hint conda  "$HOME/miniconda3"
dir_hint conda  "$HOME/anaconda3"
dir_hint conda  "$HOME/miniforge3"
dir_hint volta  "$HOME/.volta"
dir_hint n      "/usr/local/n"
dir_hint jenv   "$HOME/.jenv"
dir_hint asdf   "${ASDF_DATA_DIR:-$HOME/.asdf}"
dir_hint rbenv  "$HOME/.rbenv"
dir_hint rustup "${RUSTUP_HOME:-$HOME/.rustup}"
dir_hint fnm    "${FNM_DIR:-$HOME/.fnm}"
print "  (nothing above this line means: no residue detected)"

print ""
print "== package managers =="
probe_cmd pip3     pip3 --version
probe_cmd poetry   poetry --version
probe_cmd npm      npm -v
probe_cmd pnpm     pnpm -v
probe_cmd yarn     yarn -v
probe_cmd corepack corepack -v
if command -v gradle >/dev/null 2>&1; then
  row gradle "$(command -v gradle)" "$(gradle --version 2>&1 | grep -m1 -i '^Gradle' )"
else
  row gradle "(not found)" ""
fi
probe_cmd mvn      mvn -v
probe_cmd composer composer --version
probe_cmd luarocks luarocks --version
probe_cmd vcpkg    vcpkg version

print ""
print "== homebrew =="
if command -v brew >/dev/null 2>&1; then
  row brew "$(command -v brew)" "$(brew --version 2>/dev/null | head -1)"
  # 注意口径：管理器走 brew 装(fnm/rbenv/asdf/uv)是推荐路线；
  # 语言运行时本体走 brew 装(node/go/rust/python@x)才是常见冲突源——判定交给 references
  print -r -- "-- brew-installed language/manager formulas (judge via references) --"
  local hits
  hits=$(brew list --formula 2>/dev/null | grep -E '^(python@[0-9.]+|python3?|node(@[0-9]+)?|go|golang|rust|openjdk(@[0-9]+)?|ruby|git|uv|fnm|pyenv|nvm|asdf|rbenv|deno|php(@[0-9.]+)?|lua|gcc(@[0-9]+)?|dotnet|dart|flutter|erlang|elixir|zig|julia)$')
  if [[ -n "$hits" ]]; then print -r -- "$hits" | sed 's/^/  /'; else print "  (none)"; fi
else
  row brew "(not found)" ""
fi

print ""
print "== duplicate resolutions on PATH (which -a) =="
local c all n_uniq
local found_dup=0
for c in python3 node java go rustc ruby git uv pnpm php dotnet; do
  all=$(which -a "$c" 2>/dev/null | sort -u)
  n_uniq=$(print -r -- "$all" | grep -c . 2>/dev/null)
  if (( n_uniq > 1 )); then
    found_dup=1
    print "$c:"
    print -r -- "$all" | sed 's/^/  /'
  fi
done
(( found_dup == 0 )) && print "  (none)"

exit 0
