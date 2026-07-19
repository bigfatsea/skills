<!-- Ver 2026-07-17 17:30, by Claude Sonnet 5 -->

# Git —— 推荐: brew git（避开 Apple 冻结版）

## 1. 基线

- 推荐：**brew 安装的 git** 且在 PATH 上优先于 `/usr/bin/git`。
- 背景：Apple 出于规避 GPLv3 的政策，把 Xcode CLT 自带的 git **长期冻结在旧版本**（长期停留在 2.39.x 附近，只打安全补丁不升版本）。什么都不做的话 `/usr/bin/git` 永远是老版本。
- Git 不需要多版本管理，这里只有"用哪份 + PATH 顺序"两个问题。

## 2. 深挖探测（只读）

```bash
which -a git
git --version

brew list --versions git 2>/dev/null    # brew 装过没有

# 三场景解析（git 是 path_helper 坑最常见的受害者）：不要手工跑，
# 由 probe-path.sh 统一覆盖（交互档手工跑会触发 prompt 插件 stderr 噪音）:
#   zsh scripts/probe-path.sh git

# PATH 夺回逻辑是否两处都有——注意：不要只 grep 字面 ~/.zshrc/~/.zprofile。
# 先看 scan.sh 输出的"shell config source chain"：如果 .zshrc/.zprofile 只是
# source 了别的文件（集中式 dotfiles 框架，如 ~/myenv/pathorder.zsh 这类），
# 真正的夺回逻辑在那些被 source 的文件里，把它们也加进 grep 目标。
grep -n 'homebrew/bin' ~/.zshrc ~/.zprofile 2>/dev/null | tail -5
# 例：若 source chain 显示 ~/.zprofile -> ~/myenv/pathorder.zsh，改成：
#   grep -n 'homebrew/bin' ~/.zshrc ~/.zprofile ~/myenv/pathorder.zsh 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| brew git 存在且三场景都解析到它 | OK | 达标 |
| 只有 /usr/bin/git（2.39.x 附近） | WARN | 能用，但版本被 Apple 冻结，建议装 brew git |
| brew git 装了但某场景解析到 /usr/bin/git | WARN | path_helper 反超（尤其"登录非交互"档），补 .zprofile 的 PATH 逻辑 |
| 交互终端正常、`zsh -l -c` 落到 /usr/bin/git | WARN | 典型的"只配了 .zshrc 漏了 .zprofile"，GUI App/launchd 场景会用到旧 git |
| 顶层 rc 文件 grep 落空，但 source chain 上的文件里能 grep 到夺回逻辑，且三场景解析一致 | OK | 逻辑存在且生效，只是放在集中管理的文件里，不是缺失 |
| 顶层 rc 文件 grep 落空，追到 source chain 尽头仍然没找到，且某场景解析到 /usr/bin/git | WARN | 才是真的缺夺回逻辑，按 §4 补 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 brew git**：
   ```bash
   brew install git
   ```
3. **处理旧的**：`/usr/bin/git` 是系统文件，**不删也删不了**；要做的是让 brew 的排前面。
4. **【可选】外置存储**：不适用（git 本体无缓存外置需求）。
5. **验证 + PATH 夺回**：装完大概率 `which git` 还是 `/usr/bin/git`（brew 目录被 path_helper 排后了）。在 `~/.zshrc` **最末尾**和 `~/.zprofile` 各加一份：
   ```bash
   for d in "/opt/homebrew/bin"; do
     [[ -d "$d" ]] && path=("$d" "${path[@]:#$d}")
   done
   ```
   （Intel Mac 是 `/usr/local/bin`。）然后验证（`zsh scripts/probe-path.sh git` 覆盖三场景）：
   ```bash
   which git; git --version                 # 应指向 /opt/homebrew/bin/git
   ```

## 5. 已知坑

- **path_helper 双层坑**：登录 shell 里系统在用户配置之后把 `/usr/bin` 重新提前。第一层：只在 `~/.zshrc` 开头设 PATH 顺序没用，要在**最末尾**夺回。第二层（更隐蔽）：`~/.zshrc` 只在交互 shell 加载，"登录非交互"（`zsh -l -c`，GUI App / launchd / IDE 解析环境时常用）不读它——同一段夺回逻辑必须在 `~/.zprofile` 再放一份。定位方法：`zsh -c` / `zsh -l -c` / `zsh -l -i -c` 三个都测（probe-path.sh 自动做了）。
- **`softwareupdate --list` 救不了 git 版本**：CLT 更新很勤但里面 git 版本号不涨，等系统更新没有意义。
