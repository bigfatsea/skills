<!-- Ver 2026-07-18 10:00, by Claude Sonnet 5 -->

# Java / Gradle / Maven / Kotlin / Groovy / Scala — The Authoritative Manager: SDKMAN

## 1. Baseline

- Recommended tool: **SDKMAN** (de facto standard for the JVM ecosystem; it manages not just Java — Gradle, Maven, Kotlin, Groovy, Scala, sbt are all version-managed by it in a unified manner, making it the sole integrated tool for the entire JVM stack; there are no comparable competitors).
- Among the candidates visible via `sdk list`, the judgment rules for `kotlin`/`scala`/`sbt`/`groovy` are exactly the same as for java/gradle/maven — if any of them is found installed independently of SDKMAN (e.g., `brew kotlin`), apply the judgment in §3 of this document, without needing a separate write-up.
- Minimal success criteria:
  - `java -version` shows the version installed by SDKMAN (`which java` showing `/usr/bin/java` is normal, see §5)
  - `JAVA_HOME` derived from `$SDKMAN_DIR/candidates/java/current`, never manually pointed to a specific JDK path
  - jenv initialization code is not active in shell configuration

## 2. Deep Probe (Read-Only)

```bash
# All JDKs registered in the system (lists any installed from any source)
/usr/libexec/java_home -V

which -a java
java -version
echo $JAVA_HOME

# SDKMAN (shell function, not a binary — check directory and version file)
ls -d "${SDKMAN_DIR:-$HOME/.sdkman}" 2>/dev/null
cat "${SDKMAN_DIR:-$HOME/.sdkman}/var/version" 2>/dev/null
ls "${SDKMAN_DIR:-$HOME/.sdkman}/candidates" 2>/dev/null

# Old managers / other channels
command -v jenv; grep -n 'jenv' ~/.zshrc ~/.zprofile ~/.zshenv 2>/dev/null
brew list --formula 2>/dev/null | grep -i openjdk
ls /Library/Java/JavaVirtualMachines/ 2>/dev/null   # JDKs installed manually via .pkg are here

# Gradle / Maven
gradle --version 2>/dev/null | head -5
mvn -v 2>/dev/null | head -3
grep -o '<localRepository>[^<]*</localRepository>' ~/.m2/settings.xml 2>/dev/null
```

## 3. Judgment Rules

| Discovery | Verdict | Rationale |
|---|---|---|
| SDKMAN managing java/gradle/maven, JAVA_HOME derived from SDKMAN | OK | Meets criteria |
| `which java` = /usr/bin/java but `java -version` shows SDKMAN version | OK | /usr/bin/java is a dispatcher that reads JAVA_HOME, not an error (§5) |
| `java_home -V` does not list any JDK but SDKMAN java works | INFO | SDKMAN JDKs are not registered in system directories, which is normal; only affects GUI apps that do not inherit the shell environment and rely on java_home to detect JDKs |
| jenv init still active | FAIL | Conflicts with SDKMAN's current symlink mechanism |
| JAVA_HOME manually pointed to a specific /Library/Java/... path | WARN | Will drift when switching versions; should be changed to derive from SDKMAN |
| Manually installed JDKs leftover in /Library/Java/JavaVirtualMachines/ | INFO | Takes up space but does not conflict; may be kept or removed |
| brew openjdk present and not at the top of PATH | OK | Leave it for formulas that depend on it; do not touch |
| settings.xml has no <localRepository> but user believes it has been externalized (set variables like M2_REPO) | FAIL | Maven does not recognize those variables at all, see §5; the configuration silently fails to take effect |
| gradle/maven not installed via SDKMAN | WARN | Recommend consolidating them under SDKMAN for version management |

## 4. Migration Plan (Five-Step Method)

1. **Assess current state** — complete §2 procedure.
2. **Install SDKMAN** (if externalizing, `SDKMAN_DIR` **must be set before installation**, see step 4):
   ```bash
   curl -s "https://get.sdkman.io" | bash
   # Open a new terminal
   sdk version
   sdk install java <version>-tem    # Temurin distribution, other choices available
   sdk install gradle
   sdk install maven
   ```
3. **Handle old artifacts**:
   - jenv: delete the initialization code in shell configuration files.
   - Manually installed JDKs (/Library/Java/JavaVirtualMachines/): not mandatory to delete; but `JAVA_HOME` must be uniformly changed to:
     ```bash
     export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
     ```
   - brew openjdk: keep as dependency, as long as it’s not at the top of PATH.
4. **[Optional] Externalize storage**:
   ```bash
   export SDKMAN_DIR="/Volumes/<volume>/dev-cache/sdkman"   # MUST be set before installing SDKMAN! Read once during installation.
   export GRADLE_USER_HOME="/Volumes/<volume>/dev-cache/gradle"
   ```
   Externalizing Maven repository **can only** be done by modifying `~/.m2/settings.xml`:
   ```xml
   <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">
     <localRepository>/Volumes/<volume>/dev-cache/m2-repository</localRepository>
   </settings>
   ```
   If SDKMAN was already installed at the default location and you want to externalize: uninstalling and reinstalling is easiest; do not manually move directories (internal indices are tied to absolute paths).
5. **Verify**:
   ```bash
   java -version; echo $JAVA_HOME
   gradle --version
   mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout
   ```
   The last command asks Maven itself, don't just look at what you set (note: the first run may download the help plugin from the network).

## 5. Known Pitfalls

- **/usr/bin/java is a dispatcher**: macOS' built-in `/usr/bin/java` reads `JAVA_HOME` to locate the actual JDK. Seeing it via `which java` does not mean installation failed — check the real output of `java -version`.
- **Maven fake variable trap (everyone steps in it)**: Maven **does not recognize** environment variables like `M2_REPO`. It only respects `<localRepository>` in `~/.m2/settings.xml` (persistent) and the command-line `-Dmaven.repo.local=` (one-time). Without a settings.xml, mvn runs and downloads normally — it just silently falls back to the default `~/.m2/repository`, with no error indicating that the configuration didn't take effect.
- **SDKMAN_DIR takes effect before installation**: The installation script reads this variable once during installation to determine where to install. If you change it afterwards, the directory won’t move with it.
- **Don't hardcode JAVA_HOME**: Hardcoding it to a specific JDK absolute path will prevent `sdk use java` from updating JAVA_HOME when switching versions; only deriving it from `candidates/java/current` (the symlink maintained by SDKMAN) will keep them in sync.
