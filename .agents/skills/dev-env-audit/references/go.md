<!-- Ver 2026-07-18 17:40, by Claude Fable 5 -->

# Go —— 单版本用 Homebrew 无争议；全局多版本才需要额外工具

## 1. 基线

- **单版本场景（绝大多数用户）**：直接 `brew install go` 即可，无争议——Go 1.21+ 内置 `GOTOOLCHAIN` 机制，`go build`/`go run`/`go test` 会按各项目 `go.mod` 里 pin 的 `go` 指令自动下载、缓存、切换匹配的工具链，项目级的多版本需求已经被语言本身解决了，不需要外部版本管理器介入。
- **全局多版本场景**（例如需要在没有 go.mod 的上下文里显式跑某个旧版本、或离线环境无法让 GOTOOLCHAIN 自动下载）：优先官方原生的并行安装机制——
  ```bash
  go install golang.org/dl/go1.21.5@latest && go1.21.5 download
  ```
  这会生成一个独立命名的 `go1.21.5` 命令，与默认 `go` 并存，零第三方工具，符合"官方优先于第三方"的一般原则。只有需要 `.tool-versions` 那种按目录自动切换、且不满足于显式敲版本号命令时，才上 **asdf + golang 插件**。
- **二者(asdf golang 插件 与官方安装包/brew go)不要同时装**，会抢 PATH。
- 达标最小特征集：
  - `which -a go` 只有一份，来源是 brew / asdf shim / 官方安装位置之一
  - 没有 gvm 与之并存

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
| go 唯一，brew / asdf / 官方安装器其一 | OK | 达标——单版本用 brew 本来就是无争议推荐，不是将就 |
| asdf golang 与 brew go/官方安装 go 并存 | FAIL | 二选一原则，PATH 顺序决定谁生效 |
| gvm init 仍生效 | FAIL | 与现管理器冲突 |
| 只有 brew go、无 asdf | OK | 单版本场景的推荐状态本身，不是"凑合能用" |
| 需要全局多版本却只有单一 brew go，且不知道 GOTOOLCHAIN/golang.org/dl | INFO | 提示官方侧装方案（§1），不必然要推荐上 asdf |
| GOCACHE/GOMODCACHE 一个外置一个默认 | WARN | 两者是独立概念（§5），漂移说明配置不完整 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **单版本场景**：`brew install go` 就是终点，不需要再装别的。
   **全局多版本场景**优先官方侧装（§1 的 `golang.org/dl/goX.Y.Z`）；只有需要按目录自动切换才装 asdf：
   ```bash
   brew install asdf
   asdf plugin add golang
   asdf install golang latest
   asdf set -u golang latest    # -u/--home 写入家目录 .tool-versions;asdf ≤0.15 旧语法是 asdf global golang latest
   ```
3. **处理旧的**：
   - asdf 和 brew go 只能留一个，多出来的 `brew uninstall go` 卸载。
   - gvm：删掉 shell 配置里的初始化代码。
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
