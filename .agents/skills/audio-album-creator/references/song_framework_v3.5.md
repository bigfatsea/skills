<!-- Ver 2026-06-17 00:45, by Claude Opus 4.8 -->

# AI 音乐分析与创作综合指南 v3.5

> **这是什么**：从 v3.1–v3.3 的"歌曲描述框架"彻底重组而成的**综合指南**。它把分散的内容整合为一套连贯的方法论——涵盖**词的分析与创作、曲的分析与创作、词曲要素关系、AI 创作最佳实践**，以及**基于 Suno 规范的提示词撰写框架与实例**。
>
> **服务对象**：Amber Ark 式原创情感定制（中文为主、一专一代表作、专辑级一致性、一个人可规模化 QC），同时可作为通用的 AI 音乐创作教材。
>
> **v3.4 相对 v3.3 的最大新增**：①补齐了过去最大的空洞——**歌词创作的理论框架与最佳实践**（Part II）；②把"曲"扩成**自包含的要素词汇库**（Part III：曲风/时代锚/速度术语/节奏型/乐器族/人声技法/和声调式/和弦进行/制作质感/动态/环境音）；据此重排全书为"理论 → 词 → 曲 → AI → 提示词 → 质控"的完整链路。
>
> **v3.5 相对 v3.4 的最大新增**：在 Prosody 之外补齐两条贯穿全书的**底层原则**——**信号优先于噪声（§2.1）**与**控制分层（§2.2）**，多数实操细则由它们派生；据 2026-06 对 Suno v5.x 的复调研，重写了**人声控制（人声三层：音色/唱法/制作，艺人名=安慰剂 §15.4/§21）**、**调性与和弦（调性入 Style 提升一致性，和弦进行不可靠且禁入歌词 §15.5）**、**歌词标点即节奏（裸空格不可靠，§22）**，并强调**副歌=最强信号位（§11）**与**段落按职能增删、勿套满公式（§7）**。
>
> **自包含声明**：本版**不依赖任何旧版本即可独立使用**——v3.1/v3.2/v3.3 的关键内容已全部抽取整合进来。可安全删除旧版本（示范专辑 `song_examples` 作为配套案例可另行保留）。
>
> **依据**：综合公认词曲理论（Pat Pattison《Writing Better Lyrics》/ Berklee 词曲课程的 prosody、押韵分类、object writing、视角理论）与 2026-06 对 Suno 官方文档及社区最佳实践的调研。**平台能力随版本变化，§Part IV 实操前以当前 Suno 版本为准。**

---

## 目录

- **Part I 理论基础**：一首歌的解剖 · Prosody 总纲 · 情感→杠杆 · 要素关系图
- **Part II 词（歌词创作）**：取材立意 · 视角 · 结构职能 · 格律节奏 · 押韵体系 · 稳定/不稳定 · Hook · 修辞 · 中文专题 · 重写
- **Part III 曲（作曲编配）**：七维音乐模型 · 影响力 Tier · 曲式动态弧 · 情感杠杆细则
- **Part IV AI 创作（Suno 最佳实践）**：创作心智 · 三字段三系统 · Style · Lyrics+Metatags · Sliders/Exclude/Helper · Voices/Custom Models · Song Editor · 流派置信度 · 版权
- **Part V 提示词撰写框架与实例**：端到端框架 · 模板 v3.4 · 代表作完整走查
- **Part VI 质量控制与工作流**：双 SOP · QC 量规 · 诊断表 · 专辑统筹 · 交付
- **Part VII 局限 · 置信度 · 来源**

---

# Part I 理论基础

## 1. 一首歌的解剖：四层与它们的关系

一首歌是**四层叠合**的产物，每层都在传递同一个情感意图：

```
        词（歌词/叙事）  ── 说什么
         │
        曲（旋律/和声/节奏/曲式） ── 怎么走
         │
        声（人声音色/唱法 + 配器音色） ── 谁在说、用什么说
         │
        制作（动态/空间/质感/响度） ── 在什么空间里说
```

**关系总则**：四层不是并列，而是**互相支撑、服务同一情感**。词定了"苦尽释然"，曲就该小调转大调、动态由弱到强，人声就该由气声到放开，制作就该由干到宽。任何一层与意图相悖，整首就"散"。

## 2. Prosody（形义一致）—— 贯穿全书的第一原则

> **Prosody = 形式与内容的正确关系**（源自亚里士多德的诗学观察，Pattison 奉为词曲第一原则）：**你想表达什么，所有元素都应为它服务。**

- 反例（Pattison 的经典批评）：唱"我心碎了"，却用四行等长、AABB 工整押韵——"听起来你只是在陈述事实，心一点都不碎"。
- 正解：要表达"不稳定/思念/破碎"，就用**不稳定的工具**（奇数行、长短不齐、ABBA 或远韵、乐句不落在强拍上）；要表达"稳定/笃定",就用稳定工具（偶数行、ABAB、落强拍）。
- **没有规则，只有工具**（"there are no rules, just tools"）。本指南给的是工具箱，不是教条。

Prosody 是后面所有 Part 的"为什么"。每做一个词曲/AI 决策，都回问一句：**它支撑这首歌的意图吗？**

## 2.1 第二原则：信号优先于噪声（Signal over Noise）

> Prosody 管"为哪个情感服务"；本原则管"怎么把它真正传达给 AI"。二者是创作的两条腿。

你写进 Style 和 Lyrics 的每个字符，对模型只有两种命运：**被解析成声音（信号）**，或**不被解析（噪声）**。噪声不只是无用——它**稀释、扰乱**信号，让本可生效的描述也失准。两条铁律：

1. **只写模型能解析的东西。** 模型不解析的（具体艺人名、`[Reverb:30%]` 这类数值参数、行内裸空格、华丽辞藻与生僻隐喻、为凑结构而塞满的段落）一律删去，或改写成模型能解析的形式。
2. **把最强的信号放在最显著、重复最多的位置。** 副歌重复次数最多 → 最锚定、最有冲击的意象与字句必须落在副歌；Style 里最该被听见的特征（通常是人声）放最前。

> 这条原则一出，许多细则都成了它的推论：艺人名 → 翻成描述符（§15.4/§21）；裸空格 → 用标点与换行（§22）；段落 → 按需增删、勿套满（§7）；歌词 → 宁简勿满、密度服务可唱性（§8/§22）；副歌 → 放最强锚点（§11）。**遇到拿不准的细节，先回到这条原则，往往不必新增规则。**

## 2.2 第三原则：控制分层（Right Control, Right Layer）

同一个意图，要放在**它最可靠的那一层**去控制，放错层就失效：

| 想控制的东西 | 放哪一层（最可靠） | 不要放哪 |
|---|---|---|
| 全局声音身份：性别 / 音色质感 / 唱法基调 / 制作 / 流派 / 调性 / BPM | **Style 字段** | 别指望靠歌词带出来 |
| 段落级变化：唱法切换、动态、配器进出 | **歌词里的 metatag**（`[Chorus: full band, belted]`） | 别改全局 Style |
| 句内节奏：气口、停顿、拖字、断句 | **歌词的标点与换行**（§22） | **别用行内裸空格**（常被连读吞掉） |
| 不可靠项：精确数值、复杂和弦进行、艺人名 | **不写，或降级为方向性描述**（"小调、暖、慢"而非和弦谱） | 别写进任何字段当硬指令 |

> 配合 §16 影响力分层使用：先用 Tier 判断"值不值得控"，再用本表判断"该在哪一层控"。

## 3. 情感 → 音乐杠杆映射（情感如何被承载）

定好"要什么情感"，用这张表把它翻成"动哪些杠杆"。这是情感定制的核心 know-how。

| 情感意图 | 调式 | 速度/拍号 | 配器 | 动态 | 人声处理 | 歌词工具（呼应 Part II） |
|---|---|---|---|---|---|---|
| 温暖怀旧 | 大调 | 70–85 / 4/4 | 木吉他+钢琴+弱弦乐 | 轻 verse 重 chorus | warm breathy 克制 | 具体感官细节、第一/二人称 |
| 安静哀伤 | 小调 | 60–72 / 4/4 或 6/8 | 钢琴+大提琴 | 全程压抑 | 近耳语、气声 | 不稳定结构（奇数行/远韵） |
| 自豪激励 | 大调 | 90–120 / 4/4 | 全编+鼓+弦乐 | 渐强爆发 | belt 力量 | 稳定结构、动词高瓦数 |
| 慈爱摇篮 | 大调 | 60–75 / **6/8** | 钢琴/竖琴/八音盒 | 极轻稳 | 柔、低音区 | 短句、重复、轻韵 |
| 释怀告别 | 小调→大调 | 70–85 / 4/4 | 木吉他+渐入弦乐 | 压抑→释放 | 由收到放 | 转折结构、bridge 揭示 |
| 庄重纪念 | 大调/多利亚 | 60–80 / 4/4 | 钢琴+弦乐+合唱垫 | 宽广留白 | 宏大、和声 | 第三人称、留白 |

> 大调=明/喜、小调=暗/悲（Suno 官方术语表亦确认）。情感弧（"压抑→释放"）= 调式/动态两列发生变化。

## 4. 词曲要素关系图（element relationships）

谁约束谁，是创作决策的依据：

| 当你定了… | 它强约束… | 它弱影响… |
|---|---|---|
| **歌词字数/断句** | 旋律节奏、乐句长度、可唱性 | 配器密度 |
| **歌词声调（中文）** | 旋律走向（倒字约束） | — |
| **情感意图** | 调式、速度、动态、人声 | 流派 |
| **调式（大小调）** | 整体明暗 | 配器选择 |
| **曲式/动态弧** | 各段配器与能量 | 歌词段落职能分配 |
| **人声音色/唱法** | 辨识度、情感距离 | 制作风格 |
| **流派** | 配器惯例、节奏型、制作质感 | 押韵风格（如说唱多音节内韵） |

**最强的两条耦合**（中文情感歌必须时刻盯住）：
1. **歌词声调 ↔ 旋律走向**（倒字）—— 见 §13、§22。
2. **情感意图 ↔ 调式+动态** —— 见 §3。

---

# Part II 词：歌词创作的理论框架与最佳实践（v3.4 核心新增）

> 原创情感定制里，**歌词是"为某个具体的人"的主要落点，是 50%+ 的情感载荷**。本 Part 把公认词曲理论提炼为可操作的框架。

## 5. 取材与立意：让歌"是关于听者的"

**核心机制（Pattison）**：越**具体、越感官（sense-bound）**，越能激活听者自己的感官记忆，于是"这首歌是关于我的"——听者从旁观者变成参与者。

- 例："Turn down the lights, turn down the bed, turn down these voices inside my head"——具体到能看见那张床的颜色，听者被拉进歌里。
- **Object Writing（对象写作）**：每天花 10–20 分钟，围绕一个物件用**七感**（看/听/闻/尝/触/体感/动觉）自由写。这是积累"具体感官素材"的基本功，也是定制取材的方法——**从客户访谈里抓物件、气味、口头禅、场景**，而非抽象抒情。
- **避免陈词**（cliché 的意象/韵脚/短语是最大杀手）：语言可以简单清新，但不能是被反复拼装的预制件。
- **Amber Ark 落法**：访谈时专门采集"专属锚点"——顶针、煤油灯、菜园的番茄、那句"做人要实在"。这些进歌 = 独一无二。

## 6. 视角（Point of View）：选对人称，好点子变好歌

四种视角（Pattison）：

| 视角 | 谁在说 | 适用 | 例/Amber Ark 用法 |
|---|---|---|---|
| **第一人称（I/me）** | 叙述者讲自己 | 自传、回望——但"必须对世界有意义，否则是自我放纵" | 替外婆说"我这一生……"（最亲密） |
| **第二人称（you，叙述者在世界外）** | 告诉"你"一件你不知道的事 | 旁观提醒 | 子女对父母"你为我……" |
| **第三人称（he/she/they）** | 全知视角（"叙述者是上帝"） | 史诗、克制纪念 | 讲述一个人的故事 |
| **直接对话（I/you）** | 我对你 | 情歌、"我恨你"、"我想你"——流行乐"主菜",但易静态、用多了腻 | 表白/思念 |

> 选择依据：你要的情感距离。一专之内可用视角变化制造"呼吸"（全是 I/you 会发腻）。

## 7. 结构与曲式：每段一个职能

段落不是容器，是**职能**（Suno 实操与词曲理论一致）：

| 段落 | 职能 | 写作要点 |
|---|---|---|
| Verse 主歌 | setup（铺陈、讲故事） | **信息密度高**、具体细节、私密锚点 |
| Pre-Chorus 预副歌 | lift（抬升、制造张力） | 转折、提问、能量上抬 |
| Chorus 副歌 | payoff（兑现、点题） | **信息密度低、情感大**、hook、可重复 |
| Bridge 桥段 | contrast（对比、揭示转折） | 一个新意象/新角度，然后回到副歌赋予新意 |
| Outro 尾声 | resolve（收束） | 释然/留白，别再加料 |

**密度控制（受控强度）**：Verse 多词多细节 → Chorus 少词大情感 → Bridge 一个新意象再回 hook。**副歌比主歌简单，不是更密。**

> **段落是职能，不是清单（v3.5）**：上表是工具箱，不是"每首都要凑齐"的填空题。`Intro→V1→PreC→Chorus→Interlude→V2→PreC→Chorus→Bridge→Chorus→Outro` 只是经典模板，应**按情感需要增删**——能用 3 段说清就不写 5 段，没有"抬升张力"的需求就不写 pre-chorus。**形式服从情感（§2）+ 删噪声（§2.1）**：每多一个段落都回问"它为这首歌做了什么"，答不上来就删。把所有段落都写满、写长，是稀释而非丰富。

## 8. 格律与节奏：词的"da-DUM"

歌词有自己的节奏骨架，必须与旋律的节拍咬合（否则 AI 会唱得赶/拖/倒）。

- **重音音节（stressed syllables）**：英文靠 stress，中文靠**字调与停顿**。把重要的字放在节拍重音上。
- **行长与字数**：同一段各行**字数/音节相近**（"in pocket"），AI 才唱得稳；长短不齐 = 不稳定（可作情感工具，但要有意为之）。
- **留白让听者呼吸**：把最重要的一句放在"后面有空间"的位置（如一句之后接两小节过门），别让重要意象和次要意象抢空间。
- **乐句 vs 语法单位要对齐**：旋律乐句的断点若把一个语法/意义单位切断，"意义会蒸发"（Pattison）。断句要落在意义的接缝处。

## 9. 押韵体系：从"闭合"到"开放"的连续谱

押韵不是"押/不押"的开关，而是**稳定度连续谱**（Pattison 的分类）：

| 韵型 | 闭合/稳定度 | 例（英文） | 情感作用 |
|---|---|---|---|
| **Perfect 完全韵** | 最闭合、最稳 | time / rhyme | 笃定、完成、解决感 |
| **Family 家族韵**（同类辅音） | 次稳 | bed / step（d/t 同为塞音） | 似押非押，柔和 |
| **Additive 加法韵 / Subtractive 减法韵** | 中 | wing / sing-ing | 轻微未完成感 |
| **Assonance 元音韵**（元音同、辅音异） | 开放 | lone / cold | 悬而未决、思念 |
| **Consonance 辅音韵**（辅音同、元音异） | 最开放、最不稳 | mill / ball | 强烈未完成、不安 |

**韵式（rhyme scheme）**：ABAB（稳定）vs ABBA / 奇数行（不稳定）。
**用法（prosody）**：要"笃定/团圆"用完全韵 + ABAB；要"思念/破碎/悬"用远韵 + ABBA 或奇数行。**韵型和韵式都是情感工具。**

## 10. 稳定与不稳定（Balancing / Unbalancing）

Pattison 的核心技法——用**行数**与**行长**制造稳定或不稳定，以匹配情感：

- **行数**：偶数行 = 稳定（成对、完成）；奇数行 = 不稳定（悬空）。
- **行长**：等长 = 稳定；缩短/拉长某一行 = 不稳定（如把第 4 行缩短，制造意犹未尽）。
- **组合**：稳定内容用稳定结构；不稳定情感（"我好想你"）就用不稳定结构去"让它听起来像它说的那样"。

## 11. Hook 与记忆点

副歌 hook 是代表作的命门（也最影响 AI 可唱性）：

- **副歌 = 最强信号位（§2.1，第一要务）**：副歌重复次数最多，是全曲被听见最多的地方——**把最锚定（sense-bound 的专属意象）、最有冲击力的字句放进副歌**，而不是埋在只唱一次的主歌里。主歌负责"为什么/铺陈"，副歌负责"让人记住这一句"。写完一首，回头看一眼：最戳人的那个意象，在副歌里吗？
- **三种 hook 公式**（社区实证好用）：①**重复 hook**（一句重复两次 + 一句点意）；②**呼应式**（一短问 + 一短答，gospel/anthem 好用）；③**标志句 hook**（一个反复的标志短语 + 一句情感）。
- hook 要**短、可重复、好唱**；副歌越长越密，AI 越容易"每次唱得不一样、发robotic"。
- 结合"专属意象 + 普世情感"（"带我回去，乡间小路"）。

## 12. 修辞与意象

- **动词是语言的"功放"**（Pattison）：用高瓦数动作动词（"shouldering its way"），少用低瓦数的 be 动词（是/在/将）。但别全篇高强度，会"炸喇叭"。
- **隐喻/意象**：以具体喻抽象；"意外的碰撞"（让两个不相干的意象相遇）能生出新鲜表达。
- **节制**：留呼吸，别把歌塞满。

## 13. 中文歌词专题（业务命门）

英文理论要落到中文，有几条中文特有的硬约束：

- **倒字（最致命）**：字调（声调）走向与旋律走向相反 → "听成别的字"（"想你"→"向你"）。**副歌关键词与人名必须零倒字**：把上声/去声字放在旋律平稳或匹配走向处，或换近义词。这是中文歌词作曲的第一纪律。
- **押韵**：用**中华新韵（十三辙）**思路即可（不必严守古韵）；同辙即可押，副歌押韵要顺口。
- **平仄与字数**：不必写成格律诗，但**每行字数相近、读起来顺**就好；关键句平仄起伏服务于旋律。
- **咬字与气口**：长句留气口；避免成串闭口音/卷舌叠加；戏曲/拖腔题材标注元音延展。
- **意象传统与"起承转合"**：中文抒情擅长以景写情、以物寄情（菜园、针线、煤油灯）；段落可用"起（铺景）承（叙事）转（折/揭示）合（释然）"，与 §7 段落职能同构。
- **多音字/生僻字/英数混排**：换词、注音化、数字写成汉字（见 §22 的 AI 发音处理）。

## 14. 重写：rewriting 是金标准

- "写下来的目的，是为了有东西可改"；**写作是关键，重写是金标准**（Pattison）。
- 不信"灵感至上"，也不信"写作障碍"——"那只是说我写不出好的；那就先写烂的"。**烂稿是最好的肥料。**
- 方法：第一稿写出来后，问"这句能更具体吗？这个韵能更贴情感吗？这行能更短吗？" 每天少量、持续地写。
- **AI 时代的重写**=改 brief/七维/歌词 + 抽卡 + 局部精修（见 Part IV/VI），不是反复重生成同一条。

---

# Part III 曲：作曲与编配的分析与创作

> 把"曲"用一套可描述、可复现的词汇与模型完整表达。本 Part 是一个**自包含的"曲"参考库**——分析一首已知曲、或为一首新曲写描述，都从这里取词。

## 15. 七维音乐描述模型 + 曲的要素词汇库

一首歌的"曲+声"由七维定义。维度 1（歌词与叙事）见 Part II，维度 2（情感→杠杆）见 §3、§18；本节给出维度 3–7 的**完整描述词汇**。

| 维度 | 子项 | 怎么填 |
|---|---|---|
| 3 曲风 | 主曲风 / 子曲风 / 时代 / 地域 | "Mandopop folk / 2000s / 台湾" |
| 4 曲式与动态弧 | 结构序列 / 能量曲线 / 时长 | 详见 §17 |
| 5 节奏 | BPM / 拍号 / 律动·细分 / 律动·groove | "76 BPM / 4/4 / Straight / Laid-back" |
| 6 人声 | 性别+音区 / 音色 / 情感唱法 / 角色 | "baritone / warm breathy / belt in chorus / lead" |
| 7 乐器/配器 | 核心 3–4 件 / 段落变化 | "木吉他+钢琴+弦乐 / 轻 verse 重 chorus" |

### 15.1 曲风（Genre）：分类、融合、时代锚

**写法**：主曲风（1 个）+ 子曲风/融合（可选）+ 时代（10 年精度）+ 地域（可选）。

**常用曲风族**：流行(Pop/synth-pop/indie pop/dream pop) · 摇滚(rock/indie/alt/punk/garage) · 嘻哈(hip-hop/trap/boom bap/lo-fi) · 电子(house/techno/trance/DnB) · R&B/灵魂(neo-soul/motown) · 乡村/民谣(country/bluegrass/folk/Americana) · 爵士(swing/bebop/smooth/fusion) · 拉丁(bossa nova/reggaeton/salsa) · 古典/管弦 · 国风新民乐 · 戏曲(低置信，见 §26)。

**跨流派融合公式**：`[主风格], [主风格核心元素], [副风格], [副风格特征元素]`，主副须在**元素层呼应**，不能生硬拼贴。
- 有效：Mandopop+Hip-Hop(周杰伦式) · Jazz+Hip-Hop(Neo-Soul) · Folk+Electronic(Folktronica) · Classical+Trap · K-pop+R&B。
- 无效：Opera+Trap(声乐不可调和) · Gregorian Chant+Dubstep(节拍不可调和)。

**时代关键词锚**（比单写年代更准，叠 1–2 个）：
| 时代 | 关键词 |
|---|---|
| 60s | tape saturation, analog warmth, mono mix, surf guitar |
| 70s | phaser, wah-wah, string/disco strings, funky bass |
| 80s | gated reverb, LinnDrum, DX7, chorus effect, synth brass |
| 90s | TR-909, MPC, lo-fi vinyl, grunge distortion, Britpop |
| 2000s | Auto-Tune, crunk, snap, Neptunes production, emo |
| 2010s | lo-fi hip hop, bedroom pop, vintage synth, tropical house |
| 2020s | hyperpop, glitch, drill, AI-vocal processing |

### 15.2 节奏（Rhythm）：速度、拍号、律动、节奏型

- **BPM（整数；Suno 当近似）**：抒情 60–85；中速 90–120；快 120–168。
- **速度术语（Suno 官方术语表，可直接入 prompt）**：Adagio(慢 66–76) · Andante(行板 76–108) · Allegro(快 120–168) · Presto(极快 168–200) · **Rubato(自由速度，戏曲/抒情常用)**。
- **拍号（核心情感变量）**：4/4(方正/主流) · **3/4(圆舞曲)** · **6/8(摇篮曲/抒情摇曳)** · 2/4(进行/明快)。6/8 与 3/4 对情感歌是大变量，不可省。
- **律动·细分（拍的分法）**：Straight / Swing / Shuffle。
- **律动·groove（微观时值感）**：Laid-back(靠后/慵懒) / Pushed(靠前/急切) / Bouncy(弹跳)。**两层分开填，勿混**（"Straight + Laid-back" 是两个维度）。
- **节奏型**：four-on-the-floor(Disco/House) · boom bap(经典 Hip-Hop) · trap hi-hat rolls(32 分快连) · shuffle(Blues/慢摇) · bossa nova clave · waltz(3/4) · dembow(雷鬼/Latin) · breakbeat(DnB) · straight 16ths。

### 15.3 乐器与配器（Instrumentation）

**写法**：核心 3–4 件（多则糊）+ 一句段落变化。

**乐器族**：
- 弦/拨弦：electric/acoustic guitar、12-string、bass、violin、cello、双贝斯。
- 键盘/合成：piano、electric piano、synth、organ、strings section(弦乐组)。
- 管乐：saxophone、trumpet、flute、clarinet、French horn。
- 打击：drums(全套)、brushed drums(鼓刷)、808 sub-bass、TR-909、hand percussion、timpani。
- **民乐（情感/国风题材）**：二胡、京胡、越胡、古筝、琵琶、笛子/曲笛、古琴、扬琴、月琴、三弦、笙、唢呐、板鼓/锣。
- 注：民乐属低置信流派，能出"味道近似"，见 §26。

**段落变化（Build 方式，一句话）**：全曲统一 / 轻 verse 重 chorus / 渐进 build / 桥段退出器乐 / 双段对比 / 末副歌加弦乐或合唱。

**织体（texture）**：sparse(稀疏，留白) ↔ dense(满编)；monophonic(单旋律) / homophonic(旋律+和声伴奏) / polyphonic(多独立旋律)；layering(叠层)。

### 15.4 人声（Vocal）

> 人声是听者第一辨识点，应在 Style 字段**最前**给足。研究与社区实践（2026-06 Suno v5.x 调研）一致指向"人声三层"模型。

**控制模型——人声三层（按此顺序写，放 Style 最前）**：
1. **Character 音色质感**（声音"是什么做的"）：warm / breathy / raspy / smoky / husky / velvety / bright / dark / thin / clear / nasal …
2. **Delivery 唱法**（"怎么唱"）：intimate / belted / whispered / conversational / soaring / crooning / laid-back / declarative …
3. **Effects 制作**（"在什么处理下"）：close-mic / dry / reverb-drenched / compressed / tape-saturated / lo-fi …

再叠上 **性别 + 音区 + 年龄感**，组成一句，如 `warm aged mezzo, breathy and intimate, close-mic`。

**可靠度分层（2026-06）**：性别、唱法 tag（`[Whispered][Belting][Rap]`）、texture（raspy/breathy）、BPM **最稳**；character 形容词、年龄、段中换嗓 **中等**（需 Style 兜底/反复强化）；**`[Reverb:30%]` 这类数值参数 = 安慰剂、不解析**（§2.1 噪声）。

**艺人名 = 安慰剂，必须翻译。** 写 "王菲/Adele vocals" 只会得到泛化结果（且可能被过滤）。**正确用法：把目标歌手当"内部参照"，拆成上面三层描述符再写进 Style——歌手名本身永不入 prompt。** 例：要"蔡琴感"→ `warm low contralto, smooth and unhurried, close-mic, vintage analog`；要"王菲感"→ `airy ethereal soprano, breathy detached delivery, spacious reverb`；要"韩红感"→ `powerful bright mezzo, soaring belt, big open dynamics`。既精准，又不踩平台红线（§27）。

**段落差异**仍下放到 metatag（"breathy in verse, belted in chorus"，§22）——这是控制分层（§2.2）。

**要素词库（从这里取词）**：
- **性别+音区**：baritone/tenor male、mezzo/soprano/alto female、androgynous。
- **音色**：warm / bright / dark / rich / thin / breathy / smoky / velvety / clear。
- **情感唱法（技法）**：breathy(气声) · belt(强声高位) · falsetto(假声) · melisma(一字多音/拖腔) · vibrato/tremolo · raspy(沙) · smooth · crooning(轻吟) · rapping · spoken word(念白) · whisper(耳语)。可写段落差异："breathy in verse, belted in chorus"。
- **角色**：lead only / lead + harmony / duet(对唱) / rap lead + sung chorus。
- **和声与和音**：choir(合唱团) · gospel harmonies · stack harmonies(叠加) · backing vocals · call and response(呼应) · counter melody(副旋律) · barbershop。
- **吟唱/装饰（无歌词人声）**：ooh / aah / humming(哼鸣) · ad-libs(即兴装饰) · crowd chant(齐唱) · vocal riff。

### 15.5 和声与调式（Harmony）

- **调式（最强情感杠杆之一）**：**大调=明亮/喜；小调=暗/悲**（Suno 官方术语表确认）。情感弧（"压抑→释放"）可用**小调主歌 → 大调副歌**或 Key Change 实现。
- **具体调性（KEY，如 `in A minor`）→ 建议写进 Style**：2026-06 调研显示，给出调性能把 Suno **锁在该调的和声邻域、显著降低随机**，是性价比最高的"一致性"乐理项之一——尤其做"专辑各曲像一家人"时，给全专定 1–2 个调性能明显收束漂移。写法：Style 里直接加一项 `in A minor` / `key of C major`。注意它是**方向性约束、非精确执行**，仍需抽卡。
- **和弦进行（如 `Am–F–G–Em`）= 不可靠，且禁入歌词正文**：Suno 对显式和弦响应弱；更糟的是——**写在 Lyrics 里的和弦名会被当歌词唱出来**。要影响和声，优先用"调式 + 调性 + 情绪 + 流派"，而非和弦谱。它对"节奏/一致性"的提升远不如 BPM+拍号+调性+行长+标点来得实在。和弦进行仅作 Tier 3 锦上添花、写在 Style 末尾且别抱预期：
  | 流派 | 进行 |
  |---|---|
  | 流行 | I–V–vi–IV（4536251）/ vi–IV–I–V |
  | 爵士 | ii–V–I |
  | R&B | I–vi–IV–V |
  | 民谣 | I–V–IV |
  | 摇滚 | I–♭VII–IV |
  | 拉丁(小调) | i–♭VII–♭VI–V |
  | 韩式抒情 | vi–iii–IV–V |
- **转调（Modulation/Key Change）**：升 key 推情绪，副歌或末副歌常用。

### 15.6 制作与音色质感（Production）

- **整体质感**：lo-fi / polished / raw / **warm analog** / digital clean / tape saturation / vinyl crackle / 8-bit。
- **空间**：reverb-heavy / dry / wide stereo / mono mix。
- **失真/调制**：overdrive / distortion / fuzz / phaser / chorus / flanger。
- 注：专业混音术语（如 sidechain）Suno 不解析；要"去掉某乐器"用 Exclude 字段（§23）。

### 15.7 环境音（Ambience，Tier 3，按需）

rain / thunder / wind / ocean waves / birds chirping / forest / city traffic / cafe chatter / fire crackling / wind chimes / temple bell / church bell。与流派匹配（ambient folk + birds；影视配乐 + rain/thunder）。

## 16. 影响力分层（Tier，决定先抓什么）

> 分层基于实践直觉，非测量值，随平台/版本变化。**不给伪百分比。**

- **Tier 1 决定成败**：歌词与 hook、人声（性别+音色+情感唱法）、调式（大/小调）、主曲风、整体情感意图。
- **Tier 2 决定质感**：BPM、拍号、**调性(key)**、核心配器、曲式/动态弧、时代、制作风格。
- **Tier 3 锦上添花（AI 响应不稳）**：和弦进行、旋律线、环境音、特殊效果。

（与 Suno 各流派"置信度"现象一致，见 §26。）

## 17. 曲式与动态弧（曲的骨架）

### 17.1 段落职能（与 Part II §7 同构，此处看"曲/编配"侧）

| 段落 | 编配/能量职能 | 常见做法 |
|---|---|---|
| Intro 前奏 | 立调性/动机，通常稀疏或纯器乐 | 单乐器起，定速度与情绪 |
| Verse 主歌 | 中等能量、稳定 pocket、给歌词空间 | 配器克制，节奏稳 |
| Pre-Chorus 预副歌 | 抬升、制造张力 | 加打击/和声/能量上行 |
| Chorus 副歌 | 峰值能量、记忆点、满编 | hook、全编、能量最高、重复 |
| Post-Chorus 后副歌 | 维持能量再回落 | chant / 器乐 hook |
| Bridge 桥段 | 对比/重置 | 换和声、退鼓、换人声织体或新视角 |
| Breakdown 退场 | 抽走能量 | 暂去鼓/贝斯，聚焦人声或动机 |
| Build 蓄势 → Drop 释放 | EDM 张力—爆发 | riser/snare roll → kick+bass 满编 |
| Solo/Interlude | 器乐高光/过渡 | 短而有目的 |
| Outro/End 尾声 | 收束 | 渐弱/最后 hook；`[End]` 硬收防拖尾 |

### 17.2 段落 Build 方式（一句话定能量曲线）

全曲统一 / 轻 verse 重 chorus / 渐进 build / 桥段退出 / 双段对比。

### 17.3 动态弧（代表作的决定因素）

用一句话写整曲能量曲线，例："稀疏木吉他起 → 弦乐渐入 → 副歌全编爆发 → bridge 退到人声+钢琴 → 末副歌最满 + 二胡点睛 → 渐弱"。这是"代表作经得起全家安静听完"的关键。
- 情绪曲线词：building intensity(渐强) · fading out(渐弱) · sudden drop(爆发) · sustained(保持) · dynamic contrast(起伏对比)。
- 力度（Suno 术语表）：crescendo/decrescendo · forte/piano · fortissimo(ff)/pianissimo(pp) · staccato(断)/legato(连) · 整句区间 "pp to ff" / "whisper to belt"。

### 17.4 拍号的情感色彩 & 时长

- 4/4 方正笃定；3/4 圆舞曲回旋；**6/8 摇篮/抒情摇曳**；2/4 明快进行。
- 情感歌时长甜区约 **2:30–3:30**；专辑总时长（8 首）约 26–30 分钟。

## 18. 情感 → 曲的杠杆（§3 映射的展开与操作）

把"要什么情感"翻成"动哪些曲的杠杆"。**两个最强杠杆：调式（明暗总开关）+ 动态弧（情感起伏）。** 其余杠杆的情感取向：

| 杠杆 | 偏暖/亲密/悲 | 偏亮/宏大/喜 |
|---|---|---|
| 调式 | 小调 | 大调 |
| 速度 | 慢(60–76, Adagio) | 中快(90–168, Andante/Allegro) |
| 拍号 | 6/8、3/4（摇曳/回旋） | 4/4（方正笃定） |
| 配器 | 木吉他/钢琴/大提琴/二胡，少而暖 | 全编+鼓+弦乐+合唱，多而亮 |
| 织体 | sparse、留白 | dense、满编 |
| 动态 | 全程压抑/轻 | 渐强爆发 |
| 人声 | breathy、近耳语、低音区 | belt、放开、和声叠加 |
| 制作 | warm analog、dry/近 | polished、wide/宽 |

> 操作：从 §3 主导情感查方向 → 在本表逐杠杆取值 → 回填到 §15 各维度的具体词。情感弧（如"释怀告别"=小调→大调）对应"调式+动态"两行的**段内变化**。

---

# Part IV AI 创作：基于 Suno 的最佳实践

> 平台能力随版本变化，本 Part 基于 2026-06 官方+社区调研（Suno V5.5 时代）。实操前以当前版本为准，每 3–6 个月复核。

## 19. AI 创作心智：作曲不是复现

- **任务是 composition（原创），不是 reproduction（复刻）**：没有原曲可逼近，只有"是否打动这个人"。且平台**禁止复刻名曲**（用原词或照搬结构会被拦 prompt 甚至封号），只能"神似 + 原创词"。
- **生成是随机的**：同一 prompt 每次不同。**好歌 = 好输入 × 抽卡 × 精修**，不是一条神 prompt 一次到位。
- 循环：**七维+词 → 写输入 → 批量抽卡 → QC 筛选 → 局部精修 → 不达标改维度再抽**（详见 Part VI）。

## 20. Suno 架构：三字段 + 三系统

**三字段**（Custom/自定义模式）：**Style（曲风）** = 音乐世界观；**Lyrics（歌词）** = 要唱的字 + 结构标签 + 局部提示；**Title** = 命名（对音乐几乎无影响）。
**三系统**：①Prompt 文本 ②Metatags（歌词里的方括号标签）③Creative Sliders。三者齐用，才是"能用"而非"随机"。

## 21. Style 字段：4–7 描述符黄金公式

**公式（v3.5：人声放最前、可加调性）**：`[人声三层：音色+唱法+制作], [流派][子流派], [速度/能量], [核心乐器], [情绪], (可选 in X major/minor)`
**数量铁律**：**4–7 个描述符**最佳。<4 太泛（十次生成各不相干）；>7 互相竞争产出"糊"（如"1960s Detroit"撞"145 BPM"、"reverb-heavy"撞"lo-fi"）。**少而精 > 多而杂。**
- 该放：**人声三层（§15.4，放最前、最该被听见）**、流派/子流派、速度（BPM 仅近似）、核心乐器（民乐**点名**：erhu/guzheng/pipa/dizi 比"传统乐器"准）、制作（lo-fi/polished/raw/warm analog）、情绪、时代、**调性（key，提升一致性 §15.5）**。
- 无效/别放：**具体艺人名（安慰剂+被过滤）→ 翻成人声三层描述符（§15.4）**；`[Reverb:30%]` 类数值参数；和弦进行（§15.5）；专业混音术语；精确 BPM；否定式（"no drums" 用 Exclude 字段，见 §23）。

## 22. Lyrics 字段 + Metatags + AI 可唱性

**A. 永远用结构标签**：`[Intro][Verse]/[Verse 1][Pre-Chorus][Chorus][Post-Chorus][Bridge][Breakdown][Build][Drop][Hook][Interlude][Outro][End]`。标签大小写不敏感；`[End]` 防拖尾烂尾；`[Verse 1][Verse 2]` 让 AI 懂"主歌旋律各异、副歌旋律重复"。

**B. 参数化 metatag（最强功能）**：冒号语法逐段控制，无需改全局 Style：
```
[Verse: whispered vocals, acoustic guitar only]
[Chorus: full band, erhu accent, powerful vocals]
[Bridge: piano only, vulnerable vocals]
[Outro: fade out]
```

**C. 人声/动态标签**：`[Whisper][Humming][Spoken Word][Duet][Choir][Harmony][Ad-lib]`、`[Fade In/Out][Crescendo][Key Change]`。**局部提示点到为止，一段最多一个 cue**，堆多了失焦。

**D. AI 歌词可唱性（把 Part II 的格律落到 Suno）**——"把歌词当人声引擎的乐谱写"：
- **标点即节奏，行内裸空格不可靠（v3.5 重点）**：Suno 把标点和换行当**演唱/呼吸指令**读——
  - **句号 .** = 完整停顿、换气、音高复位；**逗号 ,** = 句内短停；**省略号 …** = 飘远的延留（情绪句）；**连字符 -** = 拖长某字（英文 `Lo-o-ove`，中文可写"暖——"或重复字）；**换行** = 较长停顿；**空行** = 器乐继续、人声停一拍；**叹号 !** = 加能量（勿滥用，整首会发冲）。
  - **行内裸空格不是可靠的气口**——没有证据表明 Suno 把句中空格当停顿，它**常被连读吞掉**。要在句中切气口/停顿，**用标点或换行，不要只靠空格**。
  - **行宜短**：每行约 ≤10–12 字/词，过长会被唱"赶"。长句**拆成多行**，比塞进一行靠空格断开可靠得多。
  - 把歌词排成**像歌词单**（清晰分段、段间空行），不是一堵文字墙。
- **行长一致（syllable pocket）**：同段各行音节/字数相近；读出声若喘不过气=太长；空=加重复词或衬词。
- **重复有意**：短 hook 比长而新的副歌更好唱；**副歌每次唱得不一样 = 太长/太密/太新 → 缩短、重复、让 cadence 可预测**。
- **锚句技巧**：每段末放同一句"锚句"，像把手一样稳住人声引擎。
- **密度**：密写放主歌，副歌留白。
- **发音纠正 = 中文倒字/多音字的对应手段**：英文用改拼写（read→reed/red、bass→bahss）；**中文用换字/调整断句/把数字写成汉字/避生僻**。**一个词连续失败别死磕 20 次，换同义词重写。**

**E. 二重唱**：`[male vocal]…[female vocal]…[both]…`，且该段保持简单。

## 23. Creative Sliders / Exclude / Prompt Helper

- **Creative Sliders**（V4.5+）：**Weirdness（怪异度）**——情感歌偏 Safe（要正常、连贯）；**Style Influence（风格强度）**——Style 写精准时偏 Strong（严格照做）；**Audio Influence**——仅在上传参考音频时用。
- **Exclude 字段**（Advanced Options）：要"没有某乐器"用它，别在 Style 写否定。
- **Prompt Enhancement Helper**：自动扩写你的 Style（非确定性）。**当学习工具用**（读它的扩写、抄走有用描述符），**生产/要一致时关掉**。

## 24. Voices / Custom Models / My Taste（专辑一致性）

> 这是"一专 8 首像一个人"的技术底座（V5.5 的 Voices 按钮已取代旧 Personas；Style Personas 在 Voices 菜单内）。

- **Persona Voice（锁音色）**：用一条满意人声"Create Persona"→ 命名 → 复用。**保留音色与基本演唱风格，不保留具体旋律/咬字**。做**流派专属** persona；别用重处理（auto-tune/失真）的歌建 persona。
- **Custom Models（V5.5，最多 3 个）**：用 **≥6 首风格一致**的歌训练"你的声音指纹"模型——可作整专甚至跨同类专辑的统一底模。**素材必须风格统一**，混流派会教糊。
- **Voice Cloning（V5.5）**：克隆真人嗓，需身份验证与授权。对"用亲人原声"有价值，但**授权与伦理是硬约束**，谨慎。
- **My Taste**：自适应偏置；**显式 Style 描述符仍覆盖它**，生产以显式 prompt 为准。
- 一致性技术栈叠用：**Custom Model（底模）> Persona（嗓）> 风格家族三件套（时代+流派+制作风格）**。

## 25. Song Editor（精修工具）

| 操作 | 作用 | 何时用 |
|---|---|---|
| **Inpainting / Replace Section** | 重做某段 | 副歌弱、主歌好；bridge 调性不对 |
| **Extend** | 续写 30–60 秒（开头放结构标签引导） | 太短/加段 |
| **Crop** | 裁拖尾 | 去尾杂音 |
| **Fade In/Out** | 头尾渐变 | 专业收尾 |

> Inpainting 是迭代的，**预算 2–5 次**接缝才自然。这是"代表作多轮精修"的官方实现。

## 26. 流派置信度地图（诚实警告）

Suno 训练数据 ~86% 来自 Global North、地方乐器 <3%，故：

- **高置信（稳）**：Pop / Rock / Hip-Hop / EDM / R&B-Soul / Country / Folk / Jazz。
- **中置信（需引导）**：Metal / Classical / Latin / Afrobeats / K-Pop-J-Pop。
- **低置信（需反复抽卡，只是"近似"）**：先锋实验、**非西方传统（中国戏曲/民乐、甘美兰、拉格、呼麦…）**、纯音效。
  - **民乐的细化（v3.5）**：Suno **认得具体乐器名**——`erhu / guzheng / pipa / dizi / guqin` 比泛写"传统乐器/Chinese instruments"准得多，**点名就用名**；子流派用 `Chinese folk ballad / Mandopop / C-pop` 而非泛"Chinese music"。能出"味道"，但**地道度与音准仍需多抽卡**；正统戏曲与方言演唱仍属最低置信。
- **语言**：Mandarin 属 Suno 最佳支持语言之一（可放心做中文歌）；**方言（粤/苏白）弱**。
- **业务含义**：主力题材走**流行/民谣/抒情/灵魂**（高置信）出片稳；**戏曲/民乐属低置信**，只承诺"味道近似"，多抽卡、降预期，或用"普通话+民乐点缀"的国风代替正统戏曲。

## 27. 版权与合规

- **不可复刻名曲**（用原词/照搬结构会被拦甚至封号）→ 只做"神似 + 原创词"。
- **艺人名被过滤** → 用描述替代。
- **商用权**：Pro 档（约 $10/月）启用 V5.5 + 商用权；免费档非商用；credits 不结转。**Amber Ark 用 Pro+ 并核对当期条款。**

---

# Part V 提示词撰写框架与实例

## 28. 端到端框架（从 brief 到成品）

```
① Brief：为谁、什么场合、什么情感、参考偏好
② 情感→杠杆（§3）：定调式/速度/配器/动态/人声 的方向
③ 写词（Part II）：取材 object writing → 视角 → 结构职能 → 格律/押韵/稳定度 → hook → 中文倒字自检
④ 写 Style（§21）：4–7 描述符黄金公式
⑤ 写 Lyrics + Metatags（§22）：结构标签 + 参数化 + 可唱性（行长一致/简标点/留白/锚句）
⑥ 设 Sliders（§23）：情感歌 = 低 Weirdness + 强 Style Influence；Helper 关
⑦ 抽卡 N → QC 量规筛（§32）
⑧ 局部精修（§25）：Replace Section / Inpainting 2–5 次 / Extend
⑨ 一致性（§24）：锁 Persona 或训 Custom Model
⑩ 交付（§35）：WAV+MP3、-14 LUFS、实物核验
```

## 29. 提示词模板 v3.4

**Style 字段（≤7 描述符；v3.5：人声三层放最前，可加调性）**
```
[人声: 音色+唱法+制作], [流派][子流派], [速度/能量], [核心乐器], [情绪], (可选 in X major/minor)
```

**Lyrics 字段（结构 + 参数化 + 可唱性）**
```
[Intro: piano only]
[Verse 1: breathy intimate, sparse]
（私密细节，行长一致，每行 8–12 字，末行=锚句）
[Pre-Chorus: strings enter, rising]
[Chorus: full band, opened-up vocals]
（短 hook，可重复，零倒字）
[Bridge: piano only, vulnerable]
（一个新意象，然后回 hook）
[Final Chorus: biggest, harmonies]
[Outro: fade out]
[End]
```

**Sliders**：Weirdness 偏 Safe；Style Influence 偏 Strong；Prompt Helper 关。

## 30. 实例：一首代表作的完整走查（中文）

**Brief**：为父亲八十大寿做代表作；情感=苦中带暖的释然、深沉父爱；子女买单。

**②情感→杠杆**：小调主歌→大调副歌；66 BPM；6/8 主歌→4/4 副歌；钢琴起→弦乐渐入→副歌全编+二胡；动态弱起爆发退桥；人声 warm mezzo，主歌气声、副歌放开带哽。

**③词**（节选，应用 Part II）：
- 取材（§5）：顶针、煤油灯、补丁、四个孩子、"做人要实在"。
- 视角（§6）：第一人称（替父亲说）。
- 结构（§7）：主歌密写细节 / 副歌点题留白。
- hook（§11，重复式 + 专属意象）：**"一针一线，把苦日子，缝成了你们的衣裳"**。
- 中文倒字自检（§13/§22）："缝"(féng,阳平)放上行/持续处，避免听成"风"；"光阴""衣裳"放平稳长音。

**④Style（7 描述符；人声三层放最前 + 调性）**：
```
warm aged mezzo, breathy to opened-up, Mandarin emotional folk ballad, slow piano with erhu and strings, warm analog close-mic, deeply nostalgic, in A minor
```
（人声"warm aged mezzo, breathy to opened-up"放最前；末尾 `in A minor` 锁一致性；歌词正文用标点/换行控制气口、不用裸空格。）

**⑤Lyrics（结构+参数化+可唱性，节选）**：
```
[Intro: solo piano]
[Verse 1: breathy intimate, sparse, 6/8 feel]
顶针磨亮了我的指头
煤油灯熬短多少个夜
你们睡了 我才开始
把白天扯破的 一针针缝
[Pre-Chorus: strings enter, rising]
我不识几个字
也没说过什么大道理
[Chorus: full band, erhu accent, opened-up vocals, 4/4]
一针一线
把苦日子
缝成了你们的衣裳
我这一生 就缝了这一件
够你们 穿着长大
[Bridge: piano only, vulnerable]
如今我老了 穿不进针了
可我一闭眼 还在缝
[Final Chorus: biggest, light harmonies, erhu]
一针一线 我把一辈子
缝进了光阴里
[Outro: fade out]
[End]
```
（行长大体一致；副歌短、可重复；标点极简；末段动机为后续器乐间奏复现埋点。)

**⑥Sliders**：Weirdness=Safe；Style Influence=Strong；Helper=Off。
**⑦抽卡**：N≥8，挑最贴"敦厚父亲"嗓 → 锁 Persona「父亲嗓」。
**⑧精修**：副歌 Replace Section 2–3 次，确保"转大调那一下"够亮、二胡进得来；逐句校"缝/光阴/衣裳"。
**⑨QC**：目标≥9/10（见 §32）。

---

# Part VI 质量控制与工作流

## 31. 生产工作流（代表作/底座双 SOP）

- **代表作（85+）**：N≥8；先定 Persona/Custom Model；副歌 Inpainting 2–5 次；逐句校倒字；关 Prompt Helper 保一致；可 3 轮迭代。
- **底座（60+）**：N=2–4；复用代表作 Persona + 同风格家族；合格即收，不过度打磨。
- 这正是"质量非均匀投放"——把精力集中在每专那一首代表作。

## 32. 成品 QC 量规（输出侧 10 项·可打勾）

①音准稳 ②中文咬字可懂(无倒字/读错音) ③结构完整(无烂尾/空段) ④无 AI 瑕疵(金属感/电流/节奏漂移) ⑤hook 立得住 ⑥情感与意图一致(明暗/紧弛对得上) ⑦配器清晰 ⑧动态有起伏 ⑨与专辑/Persona 一致 ⑩时长可用。
**代表作 ≥9，底座 ≥7。** 未达标 → 精修或回改维度。

## 33. 症状 → 病因 → 处方

| 症状 | 病因 | 处方 |
|---|---|---|
| 十次生成各不相干 | Style <4 个/太泛 | 补到 4–7 个；调高 Style Influence |
| 产出"糊" | 描述符 >7、冲突 | 砍到 4–7、去冲突项 |
| 副歌没爆 | 缺段落差异 | 参数化 `[Chorus: full band…]`；Replace Section |
| 副歌每次唱得不一样/robotic | 副歌太长/太密/太新 | 缩短、重复、去内韵、加锚句 |
| 歌词被切断/赶 | 行太长/塞太满 | 缩到 4 行、减字、加空行、密写移主歌 |
| 中文听错字 | 倒字/多音字/生僻 | 换字、调断句、汉字写数字；别死磕同一词 |
| 突然结束/拖尾 | 缺结尾标记 | `[Outro] fade out` + `[End]` |
| 专辑各曲不像一家人 | 未锁 Persona/漂移 | 锁 Persona 或训 Custom Model；统一风格家族 |
| 戏曲/民乐不地道 | 低置信流派 | 多抽卡+降预期，或改普通话国风；客户预期管理 |
| 太怪/不连贯 | Weirdness 过高 | 调低 Weirdness；关 Helper |
| 句子被连读/气口消失/赶词 | 行内用裸空格当停顿、或行太长 | 改用标点（逗号/句号/…）或换行；行控制在 ≤10–12 字（§22） |
| 指定的嗓音出不来 | 写了艺人名、或人声描述太泛/放太后 | 翻成人声三层、放 Style 最前（§15.4/§21） |
| 专辑各曲调性飘 | 未给调性 | Style 加 `in X minor/major`（§15.5） |
| "心碎"却不动人 | Prosody 错（工整结构配悲情） | 用不稳定工具：奇数行/缩末行/远韵/ABBA（§9–10） |

## 34. 专辑级统筹

- **一致性技术栈**：Custom Model > Persona > 风格家族三件套。
- **主题动机**：代表作旋律/一句歌词在别曲以变奏或器乐复现（Extend/Interlude）。
- **编排**：情感弧排序；代表作放高潮位；器乐间奏作"呼吸"；`[End]` 收束；总时长约 26–30 分钟（8 首）。
- **视角变化**：全专别都用同一人称，制造呼吸（§6）。

## 35. 交付规格

WAV 母版 + 320k MP3；统一 **-14 LUFS**；实物载体单独核验音量与曲序；附封面/曲目表/手写卡。Pro+ 商用权先核对当期条款。

---

# Part VII 局限 · 置信度 · 来源

| 内容 | 置信度 | 说明 |
|---|---|---|
| 词曲理论（prosody/视角/押韵分类/object writing/稳定度） | 高 | 公认经典，与平台无关 |
| 七维/情感映射/抽卡-精修-QC | 高 | 方法论，与版本无关 |
| 中文倒字/可唱性纪律 | 高（严重度随模型下降） | 仍作定稿纪律 |
| Suno 字段/Metatags/Sliders/Song Editor/4–7 描述符 | 中高（2026-06 调研） | **名称/上限随版本变，实操前核对当前 Suno** |
| 流派置信度地图（民乐/戏曲低置信） | 中高 | 训练数据结构 + 社区共识；随迭代或改善 |
| Voice Cloning 用于亲人原声 | 中（伦理/授权强约束） | 技术可行，谨慎 |

**来源**：
- 词曲理论：Pat Pattison《Writing Better Lyrics》（Sound on Sound 专访）、patpattison.com、Berklee Online《Lyric Writing: Tools and Strategies》、songwriting.net（Prosody）。
- Suno：help.suno.com（Music Glossary；Better Prompts in Lyrics V4.5）、blakecrosley.com《Suno V5.5 Reference》（2026-03-26）、jackrighteous.com（Custom Lyrics in Suno V5 / Prompt Placement / Song Structure Meta Tags）。
- **Suno 迭代快，Part IV 建议每 3–6 个月复核。**

---

*AI 音乐分析与创作综合指南 v3.5 · 词曲分析与创作 + 要素关系 + AI 最佳实践 + 提示词框架*
*2026-06-17 · by Claude Opus 4.8*
*配套：song_examples_v3.2（示范专辑《一针一线》）、Amber-Ark 商业计划书 v1.1*
*取代：v3.1/v3.2/v3.3/v3.4（其内容已整合重组入本版）*
