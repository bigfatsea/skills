<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Java / Gradle / Maven / Kotlin / Groovy / Scala —— 权威管理器: SDKMAN

## 1. 基线

- 推荐工具：**SDKMAN**（JVM 生态事实标准，不止管 Java——Gradle、Maven、Kotlin、Groovy、Scala、sbt 都由它统一管版本，是 JVM 全栈唯一一体化工具，无同级竞品）。
- `sdk list` 能看到的 candidate 里，`kotlin`/`scala`/`sbt`/`groovy` 判定规则和 java/gradle/maven 完全一致——发现其中任一独立于 SDKMAN 之外安装（比如 brew kotlin），按本文件 §3 的判定套用，不用单独写一份。
- 达标最小特征集：
  - `java -version` 显示 SDKMAN 装的版本（`which java` 显示 `/usr/bin/java` 是正常的，见 §5）
  - `JAVA_HOME` 派生自 `$SDKMAN_DIR/candidates/java/current`，不手动指向具体 JDK 路径
  - jenv 初始化代码不在 shell 配置里生效

## 2. 深挖探测（只读）

```bash
# 系统登记的全部 JDK（任何渠道装的都列出来）
/usr/libexec/java_home -V

which -a java
java -version
echo $JAVA_HOME

# SDKMAN（shell 函数，不是二进制——看目录和版本文件）
ls -d "${SDKMAN_DIR:-$HOME/.sdkman}" 2>/dev/null
cat "${SDKMAN_DIR:-$HOME/.sdkman}/var/version" 2>/dev/null
ls "${SDKMAN_DIR:-$HOME/.sdkman}/candidates" 2>/dev/null

# 旧管理器 / 其他渠道
command -v jenv; grep -n 'jenv' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null
brew list --formula 2>/dev/null | grep -i openjdk
ls /Library/Java/JavaVirtualMachines/ 2>/dev/null   # 手动 .pkg 装的 JDK 在这

# Gradle / Maven
gradle --version 2>/dev/null | head -5
mvn -v 2>/dev/null | head -3
grep -o '<localRepository>[^<]*</localRepository>' ~/.m2/settings.xml 2>/dev/null
```

## 3. 判定规则

| 发现 | 判定 | 理由 |
|---|---|---|
| SDKMAN 在管 java/gradle/maven，JAVA_HOME 派生自 SDKMAN | OK | 达标 |
| `which java` = /usr/bin/java 但 `java -version` 是 SDKMAN 版本 | OK | /usr/bin/java 是读 JAVA_HOME 的转发器，不是错误（§5） |
| `java_home -V` 枚举不到 JDK 但 SDKMAN java 正常 | INFO | SDKMAN 的 JDK 不注册进系统目录，属常态；仅影响不继承 shell 环境、靠 java_home 探测 JDK 的 GUI 应用 |
| jenv init 仍生效 | FAIL | 与 SDKMAN 的 current 符号链接机制打架 |
| JAVA_HOME 手动指向 /Library/Java/... 具体路径 | WARN | 切版本时会漂移，应改为派生自 SDKMAN |
| 手动装的 JDK 残留在 /Library/Java/JavaVirtualMachines/ | INFO | 占地方但不冲突，可留可删 |
| brew openjdk 存在且不在 PATH 顶层 | OK | 留给依赖它的 formula，不动 |
| settings.xml 无 <localRepository> 但用户以为已外置（设了 M2_REPO 类变量） | FAIL | Maven 根本不认那些变量，见 §5，配置静默未生效 |
| gradle/maven 不是 SDKMAN 装的 | WARN | 建议统一进 SDKMAN 管版本 |

## 4. 迁移方案（五步法）

1. **检测现状** —— §2 全套。
2. **装 SDKMAN**（若要外置，`SDKMAN_DIR` **必须先设好再装**，见第 4 步）：
   ```bash
   curl -s "https://get.sdkman.io" | bash
   # 新开终端
   sdk version
   sdk install java <version>-tem    # Temurin 发行版，也可选其他
   sdk install gradle
   sdk install maven
   ```
3. **处理旧的**：
   - jenv：删掉 shell 配置里的初始化代码。
   - 手动装的 JDK（/Library/Java/JavaVirtualMachines/）：不强制删；但 `JAVA_HOME` 统一改为：
     ```bash
     export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
     ```
   - brew openjdk：留着当依赖，不进 PATH 顶层即可。
4. **【可选】外置存储**：
   ```bash
   export SDKMAN_DIR="/Volumes/<盘>/dev-cache/sdkman"   # 必须在装 SDKMAN 之前设好！装时读一次
   export GRADLE_USER_HOME="/Volumes/<盘>/dev-cache/gradle"
   ```
   Maven 仓库外置**只能**改 `~/.m2/settings.xml`：
   ```xml
   <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">
     <localRepository>/Volumes/<盘>/dev-cache/m2-repository</localRepository>
   </settings>
   ```
   已用默认位置装过 SDKMAN 又想外置：卸载重装最省心，别手动搬目录（内部索引绑定绝对路径）。
5. **验证**：
   ```bash
   java -version; echo $JAVA_HOME
   gradle --version
   mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout
   ```
   最后一条要问 Maven 本人，别只看你设了什么（注意：首次运行可能联网下载 help 插件）。

## 5. 已知坑

- **/usr/bin/java 是转发器**：macOS 自带的 `/usr/bin/java` 自己读 `JAVA_HOME` 找真正的 JDK。`which java` 显示它不代表没装好——看 `java -version` 的实际输出。
- **Maven 假变量坑（人人都踩）**：`M2_REPO` 之类的环境变量 Maven **根本不认识**。它只认 `~/.m2/settings.xml` 的 `<localRepository>`（持久）和命令行 `-Dmaven.repo.local=`（单次）。不配 settings.xml 时 mvn 照常跑、照常下载——只是静默落到默认 `~/.m2/repository`，没有任何报错提示配置没生效。
- **SDKMAN_DIR 装前生效**：安装脚本装的时候读一次这个变量决定装哪。装完再改，目录不会跟着搬。
- **JAVA_HOME 别写死**：写死到某个 JDK 绝对路径，`sdk use java` 切版本时 JAVA_HOME 不会跟着变；派生自 `candidates/java/current`（SDKMAN 维护的符号链接）才会联动。
