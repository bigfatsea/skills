#!/usr/bin/env zsh
# Ver 2026-07-17 13:00, by Claude Fable 5
# probe-path.sh — Phase 3 横切检查①：PATH 三场景一致性。
# macOS 的 path_helper 会在登录 shell 里把 /usr/bin 等系统路径重新提前；
# 而 ~/.zshrc 只在交互式 shell 被读取。三种场景要分别验证：
#   A 非登录非交互  zsh -c        （脚本 / cron）
#   B 登录非交互    zsh -l -c     （GUI App / launchd —— 最容易漏配的一档）
#   C 登录交互      zsh -l -i -c  （平时开的终端窗口）
# 只读，不修改任何东西。
# 用法: zsh probe-path.sh [cmd ...]   默认检查一组关键命令
# 退出码: 0 = 全一致; 1 = 存在不一致(WARN)。

emulate -L zsh

local cmds
if (( $# > 0 )); then
  cmds=("$@")
else
  cmds=(git python3 node java go rustc ruby pnpm uv)
fi

print "# dev-env-audit probe-path"
print "# A=zsh -c (non-login)  B=zsh -l -c (login,non-interactive)  C=zsh -l -i -c (login,interactive)"
print ""

local warn=0
local c a b ci
for c in $cmds; do
  # 交互 shell 可能输出问候语等噪音，取最后一行才是 command -v 的结果
  a=$(zsh -c "command -v $c" 2>/dev/null | tail -1)
  b=$(zsh -l -c "command -v $c" 2>/dev/null | tail -1)
  ci=$(zsh -l -i -c "command -v $c" 2>/dev/null | tail -1)
  if [[ "$a" == "$b" && "$b" == "$ci" ]]; then
    if [[ -n "$a" ]]; then
      print "OK: $c -> $a (identical in A/B/C)"
    else
      print "INFO: $c not found in any scenario"
    fi
  elif [[ "$a" == "$b" && -n "$a" && "$ci" == alias\ * ]]; then
    # 交互 shell 用 alias 接管、非交互两档一致——常见的刻意设计(如 alias python3='uv run python')
    # 不算漂移；alias 覆盖不了脚本/cron 场景这一点由 references 里的判定规则处理
    print "INFO: $c -> $a (A/B identical; C overridden by ${ci})"
  else
    warn=1
    print "WARN: $c resolves differently across shell scenarios:"
    print "  A(non-login):          ${a:-(not found)}"
    print "  B(login,non-interact): ${b:-(not found)}"
    print "  C(login,interactive):  ${ci:-(not found)}"
    if [[ "$b" == /usr/bin/* && "$ci" != /usr/bin/* && -n "$ci" ]]; then
      print "  ^ B falls back to system binary: path_helper reordered PATH and ~/.zshrc"
      print "    was not loaded. Fix = re-assert PATH priority in ~/.zprofile as well"
      print "    (see references/git.md §5 and references/ruby.md §5)."
    fi
  fi
done

print ""
if (( warn )); then
  print "RESULT: WARN — at least one command drifts across scenarios"
  exit 1
else
  print "RESULT: OK — all checked commands resolve identically in A/B/C"
  exit 0
fi
