<!-- Ver 2026-07-17 13:00, by Claude Fable 5 -->

# Go —— 权威管理器: asdf（或官方安装器，二选一）

## 1. 基线

- 推荐工具：**asdf + golang 插件**；不想引入 asdf 的单语言用户用 **Go 官方安装包** 也合规。**二者不要同时装。**（Go 1.21+ 内置 toolchain 切换，官方安装器路线因此足够好——连 mise 作者都建议这个领域用原生方案。）
- 达标最小特征集：
  - `which -a go` 只有一份，来源是 asdf shim 或官方安装位置
  - 没有 brew go / gvm 与之并存

## 2. 深挖探测（只读）

```bash
which -a go
go version
go env GOROOT GOPATH GOMODCACHE GOCACHE

# 并存渠道
brew list --formula 2>/dev/null | grep -E '^go(lang)?$'
ls -d ~/.gvm 2>/dev/null
grep -n 'gvm' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null

# asdf 状态（如果在用）
asdf current golang 2>/dev/null
asdf list golang 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| go 唯一，asdf 或官方安装器其一 | OK | 达标 |
| asdf golang 与官方安装 go 并存 | FAIL | 二选一原则，PATH 顺序决定谁生效 |
| brew go 与管理器并存 | FAIL | 抢 PATH，卸载 brew go |
| gvm init 仍生效 | FAIL | 与现管理器冲突 |
| 只有 brew go、无管理器 | WARN | 单版本可用；多版本需求出现时迁移 |
| GOCACHE/GOMODCACHE 一个外置一个默认 | WARN | 两者是独立概念（§5），漂移说明配置不完整 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 asdf + golang 插件**（外置者第 4 步的 `ASDF_DATA_DIR` 必须先设）：
   ```bash
   brew install asdf
   asdf plugin add golang
   asdf install golang latest
   asdf set --global golang latest
   ```
   或走官方安装包路线（不装 asdf）：从 go.dev/dl 下载 .pkg 安装。
3. **处理旧的**：
   ```bash
   brew uninstall go        # 之前 brew 装的
   ```
   gvm：删掉 shell 配置里的初始化代码。
4. **【可选】外置存储**：
   ```bash
   export ASDF_DATA_DIR="/Volumes/<盘>/dev-cache/asdf"    # 必须在装插件之前设好
   export GOCACHE="/Volumes/<盘>/dev-cache/go-build"      # 编译缓存
   # GOMODCACHE 默认在 $GOPATH/pkg/mod，随 GOPATH 走，也可单独 export
   ```
5. **验证**：
   ```bash
   go version; which go
   go env GOPATH GOMODCACHE GOCACHE
   ```

## 5. 已知坑

- **GOCACHE ≠ GOMODCACHE**：编译缓存和模块缓存是两个独立概念、两个独立变量，外置要分别处理，只设一个就是漂移。
- **asdf 与官方安装器并存**：都能工作导致问题隐蔽——shim 和真实二进制看 PATH 顺序谁在前，某次 PATH 变动后 `go version` 悄悄换人。
- **ASDF_DATA_DIR 装前生效**：插件和版本装进这个目录，装完再改不会搬家。
