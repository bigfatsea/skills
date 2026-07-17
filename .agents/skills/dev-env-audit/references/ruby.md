<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Ruby —— 权威管理器: rbenv

## 1. 基线

- 推荐工具：**rbenv**。多数人 Ruby 使用频率低——系统自带 ruby + 无任何管理器也是可接受状态（报告标注"未治理，按需迁移"即可，不算 FAIL）。
- 达标最小特征集：
  - `which ruby` 解析到 rbenv shims；`rbenv versions` 有明确 global 版本
  - ~/.rvm 不存在（rvm 与 rbenv 冲突且必须卸干净，见 §5）

## 2. 深挖探测（只读）

```bash
which -a ruby
ruby -v

# rbenv 状态
rbenv versions 2>/dev/null
rbenv global 2>/dev/null

# rvm（唯一"必须真卸载"的管理器）
ls -d ~/.rvm 2>/dev/null
grep -n 'rvm' ~/.zshrc ~/.zprofile ~/.zshenv ~/.bash_profile 2>/dev/null

# shim 是否被 path_helper 反超：不要在这手工跑三场景命令
# （交互档会触发用户 prompt 插件的 stderr 噪音）——由 probe-path.sh 统一覆盖:
#   zsh scripts/probe-path.sh ruby
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| rbenv 管理、shim 优先级正确 | OK | 达标 |
| rvm 存在（目录或 init 任一） | FAIL | 与 rbenv 根本冲突，必须 `rvm implode` 卸干净 |
| rbenv 装了但登录 shell 解析到 /usr/bin/ruby | WARN | path_helper 反超 shim（见 §5），要在 .zprofile 补 PATH 夺回逻辑 |
| 只有系统 ruby、无管理器、用户不写 Ruby | INFO | 合法状态，不用动 |
| brew ruby 在 PATH 顶层 | WARN | 建议统一到 rbenv |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 rbenv**：
   ```bash
   brew install rbenv
   rbenv install <version>
   rbenv global <version>
   ```
3. **处理旧的**——RVM 是特例，**必须真的卸载干净**，不能只停用：
   ```bash
   rvm implode          # RVM 自带的卸载命令
   # 再把 ~/.zshrc 等文件里 RVM 相关的 PATH/初始化代码全删掉
   ```
4. **【可选】外置存储**：rbenv 的版本装在 `~/.rbenv/versions`，体积通常不大，一般不外置；确有需要可用 `RBENV_ROOT` 指向外置盘（装版本之前设好）。
5. **验证**（三种 shell 场景都要验，Ruby 是 path_helper 坑的重灾区，用 `zsh scripts/probe-path.sh ruby`）：
   ```bash
   ruby -v; which ruby
   rbenv versions
   ```

## 5. 已知坑

- **rvm implode 是唯一正解**：rvm 深度改写 shell 环境（函数、PATH、gem 路径），"装着不用"也会持续制造冲突，是所有旧管理器里唯一必须彻底卸载的。
- **path_helper 反超 shim**：macOS 登录 shell 里 `path_helper` 在用户配置之后把 `/usr/bin` 等重新提前，rbenv shims 被反超 → 新终端里 ruby 解析到系统旧版，手动 `source ~/.zshrc` 又正常，极易误判为"随机出问题"。根治：在 `~/.zshrc` **最后一行**和 `~/.zprofile` 各放一份"夺回 PATH"逻辑：
  ```bash
  for d in "$HOME/.rbenv/shims" "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" "/opt/homebrew/bin"; do
    [[ -d "$d" ]] && path=("$d" "${path[@]:#$d}")
  done
  ```
  只放 .zshrc 会漏掉"登录非交互"档（GUI App / launchd 用 `zsh -l -c`，不读 .zshrc）——probe-path.sh 的 B 场景专门抓这个。
