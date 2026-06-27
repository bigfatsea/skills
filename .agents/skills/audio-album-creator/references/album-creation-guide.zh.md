<!-- Ver 2026-06-26 17:36, by Claude Opus 4.8 -->

# Album Creation Guide · 专辑创作指南 v3.5（精简版）

> 把任意素材（语音/视频/文字/照片——传记、故事、项目经历、团队成长、感情回忆…）提炼成精华、据此设计制作一张专辑的总体创作指南。覆盖词曲声制作四层、AI 创作最佳实践、Suno 提示词框架。题材不限，中文为主，可"一专一代表作"、专辑级一致性、单人规模化 QC。依据 Pattison《Writing Better Lyrics》/Berklee 词曲理论 + Suno 官方文档与社区实证。**平台能力随版本变，Part IV 实操前以当前 Suno 版本为准（每 3–6 月复核）。**

---

# Part I 理论基础

## 1. 一首歌 = 四层叠合，服务同一情感
**词**（说什么）→ **曲**（旋律/和声/节奏/曲式，怎么走）→ **声**（人声音色唱法+配器，谁在说）→ **制作**（动态/空间/质感/响度，在什么空间说）。四层互相支撑；任一层与意图相悖则"散"。例："苦尽释然"=小调转大调、动态弱到强、人声气声到放开、制作干到宽。

## 2. 三大原则
- **① Prosody 形义一致**（第一原则）：形式服务内容。表"稳定/笃定"用稳定工具（偶数行/ABAB/落强拍）；表"不稳定/思念/破碎"用不稳定工具（奇数行/长短不齐/ABBA 远韵/不落强拍）。**没有规则，只有工具。** 每个决策都回问：它支撑这首歌的意图吗？
- **② 信号优先于噪声**（怎么传达给 AI）：写进 Style/Lyrics 的每个字符要么被解析成声音（信号），要么是噪声——噪声会稀释信号。两条铁律：(a) 只写模型能解析的，删去艺人名/`[Reverb:30%]`数值/行内裸空格/华丽辞藻/凑数段落；(b) 最强信号放最显著、重复最多处（副歌放最锚定意象，Style 把人声放最前）。**拿不准的细节先回到这条，往往不必新增规则。**
- **③ 控制分层**（同一意图放最可靠的层）：

  | 控制对象 | 放哪层（最可靠） | 别放 |
  |---|---|---|
  | 全局声音身份：性别/音色/唱法基调/制作/流派/调性/BPM | **Style 字段** | 别靠歌词带 |
  | 段落级变化：唱法切换/动态/配器进出 | **歌词 metatag** `[Chorus: full band, belted]` | 别改全局 Style |
  | 句内节奏：气口/停顿/拖字/断句 | **歌词标点与换行** | **别用行内裸空格**（常被连读吞） |
  | 不可靠项：精确数值/复杂和弦/艺人名 | **不写，或降级为方向描述**（"小调暖慢"非和弦谱） | 别当硬指令 |

> **贯穿全书：表是工具箱，不是配方。** 全书的映射/词库/公式/Tier/症状表都是起点与默认值，非照搬清单。按素材实情与**专辑整体气质**自由取舍、混搭、偏离——偏离的标准是回到 Prosody："它支撑这首歌/这张专辑的意图吗？" 一张"一致而有个性"的专辑常来自有意打破某几张表去强化统一风格，而非逐格填满。

## 3. 情感 → 音乐杠杆映射（核心 know-how）
| 情感 | 调式 | 速度/拍号 | 配器 | 动态 | 人声 | 歌词工具 |
|---|---|---|---|---|---|---|
| 温暖怀旧 | 大调 | 70–85/4/4 | 木吉他+钢琴+弱弦乐 | 轻verse重chorus | warm breathy 克制 | 具体感官、第一/二人称 |
| 安静哀伤 | 小调 | 60–72/4/4或6/8 | 钢琴+大提琴 | 全程压抑 | 近耳语气声 | 不稳定结构 |
| 自豪激励 | 大调 | 90–120/4/4 | 全编+鼓+弦乐 | 渐强爆发 | belt 力量 | 稳定结构、高瓦数动词 |
| 慈爱摇篮 | 大调 | 60–75/**6/8** | 钢琴/竖琴/八音盒 | 极轻稳 | 柔、低音区 | 短句、重复、轻韵 |
| 释怀告别 | 小调→大调 | 70–85/4/4 | 木吉他+渐入弦乐 | 压抑→释放 | 由收到放 | 转折结构、bridge揭示 |
| 庄重纪念 | 大调/多利亚 | 60–80/4/4 | 钢琴+弦乐+合唱垫 | 宽广留白 | 宏大和声 | 第三人称、留白 |
| 思念牵挂 | 小调⇄大调 | 65–80/4/4或6/8 | 钢琴+空灵合成/弱弦 | 中弱不爆 | 气声、句尾拖远 | 远韵/省略号/未完成句、奇数行 |
| 浪漫深情 | 大调(可借小调和弦) | 70–95/4/4或慢swing | 钢琴/电钢+弱鼓+弦乐 | 轻柔渐暖 | crooning sultry、close-mic | 第二人称/对话、感官细节 |
| 欢庆喜悦 | 大调 | 110–130/4/4 | 全编+鼓+brass/合成+掌声 | 全程高能 | bright open、群唱和声 | 短重复hook、呼应式、可齐唱 |
| 希望憧憬 | 大调(挂留/lydian) | 85–110/4/4 | 钢琴+渐层合成/弦乐build | 渐进build(不必爆) | clear、由收到放 | 前瞻意象、上行、"我们" |
| 不甘抗争 | 小调(多利亚/弗里几亚) | 90–140/4/4 | 失真吉他+鼓+bass，raw | 压抑积累→爆发 | raspy belt、咬字有力 | 高瓦数动词、短句冲击、对抗意象 |
| 平静治愈 | 大调/调式性(lydian) | 60–80/4/4或rubato | 钢琴/原声吉他+pad+环境音 | 全程平稳留白 | soft breathy 近耳语 | 当下感官、留白、轻韵 |

> 大调=明/喜，小调=暗/悲。情感弧=调式/动态等列在曲内发生变化。**复杂情感很少是单行**——常是两三行混合（"释然里带不甘"≈释怀×抗争）或曲内迁移（主歌思念→副歌希望）。把每行当调色盘上的一种色按需调和，别套单行（见全书用法说明）。

## 4. 要素关系（谁约束谁）
歌词字数/断句→强约束旋律节奏、可唱性；歌词声调(中文)→旋律走向(倒字)；情感意图→调式/速度/动态/人声；调式→明暗；曲式/动态弧→各段配器能量；人声音色→辨识度/情感距离；流派→配器/节奏/制作惯例。**两条最强耦合（中文情感歌必盯）：① 声调↔旋律走向(倒字)；② 情感意图↔调式+动态。**

---

# Part II 词（50%+ 情感载荷）

> **歌词不是诗**：诗可反复读，歌词是*一遍听过、在时间里展开、要唱出来*的——必须在演唱速度下第一遍就听懂（线性、明白、容忍重复）。下面每条纪律都服务于这一条。且**词为主轴、曲来服侍**(§4)：先写词(其音节/句法约束旋律)，再据词编曲——底座轨词先曲后；只有"抓耳优先"的副主打可破例先曲后词。

## 5. 取材立意：让歌"是关于听者的"
越具体、越感官(sense-bound)，越能激活听者记忆，他从旁观者变参与者。**Object Writing**：每天 10–20 分钟围绕一物件用七感(看/听/闻/尝/触/体感/动觉)自由写。从素材抓专属锚点——具体物件、气味、口头禅、关键场景、标志细节（不可替代）。**避免陈词**：语言可简单清新，但不能是预制件。

> **专辑脊柱 = 主体的弧光(the change)，不是事件清单**：提炼*主体如何改变*(想要 vs 需要、那个转折点)作为 throughline，并画出**情绪曲线**——关键节点的 valence-over-time 一条线。这条曲线是一等产物：它后续驱动排轨与配速(§34)。**金句节制**：口头禅逐字采集，但不必全用——一个故事点可能有五句可引，命中其中最戳的一两句通常就够（按最感官 + 最短可唱 + 最普世选；其余留作质感）。别为用尽而硬堆（机械堆砌是噪声，§2 ②）；只有当更多句确实各得其所时才多留。

## 6. 视角（按要的情感距离选）
- **第一人称(I)**：自传/回望，最亲密，但须对世界有意义。
- **第二人称(you,叙述者在外)**：告诉你不知道的事，旁观提醒。
- **第三人称(he/she)**：全知，史诗/克制纪念。
- **直接对话(I/you)**：流行主菜，但易静态、用多腻。

> 一专内用视角变化制造"呼吸"，别全用同一人称。

## 7. 结构：每段一个职能（按需增删，非填空）
| 段落 | 职能 | 写作要点 |
|---|---|---|
| Verse | setup 铺陈 | 信息密度高、具体细节、私密锚点 |
| Pre-Chorus | lift 抬升张力 | 转折、提问、能量上抬 |
| Chorus | payoff 兑现点题 | 信息密度低情感大、hook、可重复 |
| Bridge | contrast 对比揭示 | 一个新意象/角度，再回副歌 |
| Outro | resolve 收束 | 释然/留白，别加料 |

> **密度**：Verse 多词 → Chorus 少词大情感 → Bridge 一新意象回 hook。副歌比主歌简单，非更密。经典模板 `Intro→V1→PreC→Chorus→V2→PreC→Chorus→Bridge→Chorus→Outro` 仅参考——能 3 段说清不写 5 段，每多一段问"它为这首做了什么"，答不上就删。

## 8. 格律节奏
- 重要字放节拍重音上（中文靠字调+停顿）。
- **行长齐(in pocket)**：同段各行字数/音节相近，AI 才唱得稳；长短不齐=不稳定工具（须有意为之）。
- **留白**：重要句放"后面有空间"处。
- **乐句对齐语法单位**：断句落在意义接缝处，否则"意义蒸发"。

## 9. 押韵=稳定度连续谱
Perfect 完全韵(最稳，笃定/解决) → Family 家族韵(同类辅音,柔和) → Additive/Subtractive(中,轻微未完成) → Assonance 元音韵(开放,悬而未决) → Consonance 辅音韵(最不稳,不安)。**韵式**：ABAB稳定 / ABBA·奇数行不稳定。要笃定团圆用完全韵+ABAB；要思念破碎用远韵+ABBA/奇数行。

## 9.1 中文工整落地：锁辙·对仗·行长齐（默认基调）
> 最致命失败="带换行的口语散文"（行长忽长忽短、副歌不押韵、大白话、无对仗）。三条纪律压成"歌"：
> **但工整是为"上口好听"服务的手段，不是目的**：当锁辙/对仗逼出生硬绕口、或替听者把话说尽时，回到 Prosody——好听本身就是情感载体，此时该松一格、留白优先（尤见代表作的锚点句）。
- **锁辙**：中华新韵十三辙(同辙即押)。**每首副歌锁一辙一韵到底**；主歌偶句押韵；念白/桥段可不押。常用辙：发花(a/ia/ua)·江阳(ang)·一七(i/ü)·由求(ou/iu)·言前(an/ian/uan)·人辰(en/in/un)·中东(eng/ing/ong)·怀来(ai/uai)·灰堆(ei/ui)·遥条(ao/iao)·梭波(o/e/uo)·姑苏(u)·也斜(ie/üe)。
- **对仗**：成对句结构相同、意象相对——中文"像歌"最强工具。每段副歌至少埋一组对句（"锅里有米／灯下有衣"）。
- **行长齐**：同段各行字数相近(多 4+3/4+4)，副歌不留 10 字以上长句；砍口语化的散句（如"你们都知道""我自己扛"），叙事炼成意象。
- **题眼复现**：核心字/意象在多首副歌末复现，串成专辑动机线。

## 10. 稳定/不稳定
行数：偶数=稳定，奇数=悬空。行长：等长=稳，缩/拉某行=不稳。稳定内容配稳定结构，不稳定情感配不稳定结构。

## 11. Hook（代表作命门）
- **副歌=最强信号位**：副歌重复最多，把最锚定(sense-bound)、最有冲击的字句放副歌，别埋在只唱一次的主歌。写完回看：最戳人的意象在副歌吗？
- **三种 hook**：①重复式(一句重复2次+一句点意)；②呼应式(短问+短答)；③标志句式(反复标志短语+一句情感)。
- hook 要短、可重复、好唱；副歌越长越密 AI 越易"每次唱得不一样/robotic"。
- 结合专属意象+普世情感（"带我回去，乡间小路"）。

## 12. 修辞意象
动词是"功放"——用高瓦数动作动词，少用 be 动词（但别全篇高强度会炸喇叭）。以具体喻抽象；"意外碰撞"生新鲜表达。留呼吸别塞满。

## 13. 中文专题（硬约束）
- **倒字(最致命)**：字调走向与旋律相反→听成别的字("想你"→"向你")。**副歌关键词+人名零倒字**：上声/去声字放旋律平稳或匹配处，或换近义词。第一纪律。
- 押韵用中华新韵十三辙(不守古韵)；每行字数相近读着顺；长句留气口，避免成串闭口音/卷舌叠加；戏曲拖腔标元音延展。
- 意象传统：以景写情、起承转合（与§7同构）。
- 多音字/生僻字/英数：换词、注音化、数字写成汉字。

## 13.7 工整 vs 写意（专辑级总把控，非比例规则）
- **基调**：工整(§9.1)是默认，保证像歌上口挂耳。
- **口语化例外**：间奏/念白/Pre-Chorus/Bridge/插入段可口语，用 metatag 标注(`[Pre-Chorus: half-spoken]``[Bridge: spoken word]`)。
- **写意例外(可选)**：一专允许 0–2 首走写意(语言松、结构自由、意境优先)，**可以是 0 首**，创作者按题材判断。若整首下放写意，挑情感最内向/最压抑的一首（委屈、麻木、悼念）最自然。

## 14. 重写=金标准（三阶段打磨协议）
"写下来是为了有东西可改"。不信灵感至上/写作障碍——先写烂稿(最好的肥料)。把重写跑成**三个有序阶段**——别想一次到位，那正是写出僵硬绕口句子的原因：
- **阶段1 — 叙事先行(规则全关)**：像讲故事一样把这首歌的情感真相与场景白描出来，把*故事*讲对。**此阶段彻底无视押韵、格律、工整。**
- **阶段2 — 歌词化(prosodic shaping)**：给散文真相套歌的形——段落职能(主歌=铺陈/show、副歌=记忆点/hook)、锁一个韵辙到句尾、行长齐、需要处埋一对对仗、压缩 hook、每个副歌写满。主歌用不稳定工具把人往副歌拽(§10)。
- **阶段3 — 精修+把关(逐字)**：**先裸读**(当作不知道意图的母语听者冷读——每一行、每对相邻行都要用大白话读得通：问句与答落在同一维度、无句式只开不合、无一词两义打架、无残句悬空；这是*意义*关，先于、也区别于"消绕口"这道*声音*关)；然后高音/长音落开口韵、消绕口、**hook 与人名零倒字**；跑删形容词/留白/跟唱三测试；再用**换一双新鲜的眼睛**(最好是另一个上下文，不是作者本人)确认读得通、可唱、且金句没堆砌(§5)。**任何锁辙/换字都是再创作**——动过哪里就对哪里重过裸读，绝不假设"只动了形式"。

AI 时代每阶段的修订=改 brief/七维/歌词+抽卡+局部精修，非反复重生成同一条。

---

# Part III 曲（自包含词汇库）

## 15. 七维模型
维度1(词)见Part II，维度2(情感→杠杆)见§3/§18，维度3–7：

| 维度 | 怎么填（例） |
|---|---|
| 3 曲风 | 主+子+时代(10年精度)+地域："Mandopop folk/2000s/台湾" |
| 4 曲式动态弧 | 见§17 |
| 5 节奏 | "76 BPM/4/4/Straight/Laid-back" |
| 6 人声 | "baritone/warm breathy/belt in chorus/lead" |
| 7 配器 | 核心3–4件+段落变化 |

**15.1 曲风**：主(1)+子/融合+时代+地域。族：Pop/Rock/Hip-Hop/EDM/R&B-Soul/Country-Folk/Jazz/Latin/古典/国风新民乐/戏曲(低置信)。**融合公式** `[主风格],[主核心元素],[副风格],[副特征元素]`，须元素层呼应。有效：Mandopop+HipHop(周杰伦)、Jazz+HipHop(NeoSoul)、Folk+Electronic、Classical+Trap；无效：Opera+Trap、Gregorian+Dubstep。**时代锚词**(叠1–2；年代只是给某轨标记某个时刻的一种方式——更底层的做法是匹配听者会与该时刻*产生联想*的声音，这种联想可能来自年代、地方、事件、或共同的文化符号，而非硬编码的"年代→曲风"规则)：60s tape saturation/analog warmth；70s phaser/disco strings/funky bass；80s gated reverb/LinnDrum/DX7；90s TR-909/MPC/lo-fi vinyl/grunge；2000s Auto-Tune/snap/emo；2010s lo-fi hip hop/bedroom pop/tropical house；2020s hyperpop/glitch/drill。

**15.2 节奏**：BPM(整数,近似)抒情60–85/中速90–120/快120–168。术语：Adagio(66–76)·Andante(76–108)·Allegro(120–168)·Presto(168–200)·Rubato(自由,戏曲/抒情)。拍号(核心情感变量)：4/4方正·3/4圆舞曲·**6/8摇篮/抒情摇曳**·2/4进行。**细分**(Straight/Swing/Shuffle)与 **groove**(Laid-back靠后/Pushed靠前/Bouncy)两层分开填。节奏型：four-on-the-floor·boom bap·trap hi-hat rolls·shuffle·bossa clave·waltz·dembow·breakbeat·straight 16ths。

**15.3 配器**：核心3–4件(多则糊)+一句段落变化。弦/拨弦：guitar/12-string/bass/violin/cello。键/合成：piano/EP/synth/organ/strings section。管：sax/trumpet/flute/clarinet/French horn。打击：drums/brushed drums/808/TR-909/hand perc/timpani。**民乐**(点名英文比泛写准)：erhu/京胡/古筝guzheng/琵琶pipa/笛子dizi/古琴guqin/扬琴/月琴/三弦/笙/唢呐/板鼓锣。**Build**：统一/轻verse重chorus/渐进/桥段退器乐/双段对比/末副歌加弦乐合唱。**织体**：sparse↔dense；mono/homo/polyphonic；layering。

**15.4 人声（第一辨识点，Style 放最前）——人声三层**：
1. **Character 音色质感**(Tier-1可靠)：warm/breathy/raspy/smoky/husky/velvety/gravelly/sultry/bright/dark/thin/clear/nasal/frayed
2. **Delivery 唱法**：intimate/belted/whispered/conversational/near-spoken/soaring/crooning/laid-back/behind-the-beat/declarative
3. **Effects 制作**：close-mic/dry/reverb-drenched/compressed/tape-saturated/lo-fi

叠 性别+音区+年龄感，如 `warm aged mezzo, breathy and intimate, close-mic`。
**可靠度**：性别/唱法tag`[Whispered][Belting][Rap]`/texture/BPM 最稳；character形容词/年龄/段中换嗓 中等(需Style兜底)；`[Reverb:30%]`数值=安慰剂不解析。
**艺人名=安慰剂必须翻译**：歌手名永不入prompt，拆成三层描述符。"辨识度三角"=音区+质地+唱法+年代。例：烟嗓低音→`warm low contralto, smooth unhurried, slow vibrato, close-mic vintage analog`；空灵→`airy ethereal soprano, breathy detached, spacious reverb`；高亢→`powerful bright mezzo, soaring belt, big open dynamics`。
**段落差异**下放 metatag("breathy in verse, belted in chorus")。角色：lead/lead+harmony/duet对唱/rap lead+sung chorus。和声：choir/gospel/stack harmonies/backing/call and response/counter melody。装饰：ooh/aah/humming/ad-libs/crowd chant/riff。

**15.5 和声调式**：大调=明喜/小调=暗悲(最强杠杆之一)。情感弧=小调主歌→大调副歌或Key Change。**具体调性(`in A minor`)建议写进 Style**——锁和声邻域、降随机，性价比最高的一致性乐理项，尤其全专定1–2个调性收束漂移(方向性约束,仍需抽卡)。**和弦进行=不可靠且禁入歌词正文**(写Lyrics里会被当歌词唱出)，仅Tier3写Style末尾别抱预期：流行I–V–vi–IV/爵士ii–V–I/R&B I–vi–IV–V/民谣I–V–IV/摇滚I–♭VII–IV/拉丁小调i–♭VII–♭VI–V/韩式抒情vi–iii–IV–V。转调升key推情绪(副歌/末副歌)。

**15.6 制作质感**：整体 lo-fi/polished/raw/warm analog/digital clean/tape saturation/vinyl crackle/8-bit；空间 reverb-heavy/dry/wide stereo/mono；失真调制 overdrive/distortion/fuzz/phaser/chorus/flanger。专业混音术语(sidechain)不解析；去乐器用 Exclude 字段。

**15.7 环境音**(Tier3按需)：rain/thunder/wind/ocean/birds/forest/city traffic/cafe/fire/wind chimes/temple bell/church bell。须与流派匹配。

## 16. 影响力 Tier（非测量值）
- **T1 决定成败**：歌词与hook、人声(性别+音色+唱法)、调式、主曲风、情感意图。
- **T2 决定质感**：BPM、拍号、调性、核心配器、曲式动态弧、时代、制作风格。
- **T3 锦上添花(响应不稳)**：和弦进行、旋律线、环境音、特殊效果。

## 17. 曲式与动态弧
段落编配职能：Intro立调性(稀疏/纯器乐)·Verse中能量稳pocket·Pre-Chorus抬升·Chorus峰值满编重复·Post-Chorus维持回落·Bridge对比重置(换和声/退鼓/新视角)·Breakdown抽能量·Build→Drop蓄势爆发·Solo/Interlude器乐高光·Outro收束(`[End]`硬收防拖尾)。
**动态弧(代表作决定因素)**用一句写能量曲线，例："稀疏木吉他起→弦乐渐入→副歌全编爆发→bridge退到人声+钢琴→末副歌最满+二胡点睛→渐弱"。曲线词：building/fading out/sudden drop/sustained/dynamic contrast。力度：crescendo/decrescendo·forte/piano·ff/pp·staccato/legato·区间"pp to ff"/"whisper to belt"。
**拍号情感**：4/4笃定·3/4回旋·6/8摇篮·2/4明快。**时长甜区2:30–3:30**；专辑(8首)约26–30分。

## 18. 情感→曲杠杆（§3展开）
两最强杠杆=调式(明暗总开关)+动态弧。其余：速度(暖慢60–76 / 亮中快90–168)、拍号(6/8·3/4 / 4/4)、配器(少而暖 / 多而亮)、织体(sparse / dense)、动态(压抑 / 渐强)、人声(breathy近耳语低音区 / belt和声叠加)、制作(warm analog干近 / polished宽)。操作：§3查方向→本表逐杠杆取值→回填§15。

---

# Part IV AI 创作（Suno V5.5 时代）

## 19. 创作心智
任务是 **composition 原创非 reproduction 复刻**(平台禁复刻名曲,用原词/照搬结构会被拦甚至封号,只能神似+原创词)。生成随机：**好歌=好输入×抽卡×精修**。循环：七维+词→写输入→批量抽卡→QC筛→局部精修→不达标改维度再抽。

## 20. 架构：三字段+三系统
字段：**Style**(音乐世界观)·**Lyrics**(字+结构标签+局部提示)·**Title**(几乎无影响)。系统：①Prompt文本②Metatags(方括号)③Creative Sliders。三者齐用才"能用"。

## 21. Style：人声前置 + 4–7 描述符黄金公式
`[人声三层:音色+唱法+制作],[流派][子流派],[速度/能量],[核心乐器],[制作],[情绪],(可选 in X major/minor)`
- **人声前置铁律**：人声放句首，否则约30%出"通用AI嗓"(Suno对开头响应最强)。
- **人声三层叠**(Character+Delivery+Effects)缺一即用统计平均填空=AI味。
- **数量铁律 4–7个**：<4太泛，>7竞争出"糊"(如"1960s Detroit"撞"145 BPM"、"reverb"撞"lo-fi")。
- **该放**：人声三层(最前)、流派、速度、核心乐器(民乐点名)、制作、情绪、时代、调性。
- **避坑**：①别写打架描述符(`soft powerful belting`)；②参数/百分比=安慰剂(`[Reverb:30%]`)，用词不用数；③艺人名翻三层；④和弦进行；⑤否定式用 Exclude。

## 22. Lyrics + Metatags + 可唱性
**A. 永远用结构标签**：`[Intro][Verse 1][Pre-Chorus][Chorus][Post-Chorus][Bridge][Breakdown][Build][Drop][Hook][Interlude][Outro][End]`。大小写不敏感；`[End]`防拖尾；`[Verse 1][Verse 2]`让AI懂主歌旋律各异、副歌重复。
**B. 参数化 metatag(最强)**：冒号语法逐段控制无需改全局——`[Verse: whispered, acoustic guitar only]``[Chorus: full band, erhu accent, powerful vocals]``[Bridge: piano only, vulnerable]``[Outro: fade out]`。
**C. 人声/动态标签**：`[Whisper][Humming][Spoken Word][Duet][Choir][Harmony][Ad-lib][Fade In/Out][Crescendo][Key Change]`。一段最多一个cue。**双重锚定**：Style句首人声质地词在段落metatag复述(`[Verse: husky near-spoken]`)，依从度更高。念白用`[…: half-spoken]`/`[Spoken Word]`。
**D. 可唱性(把歌词当人声引擎的乐谱)**：
- **标点即节奏，裸空格不可靠**：句号=完整停顿换气复位；逗号=句内短停；省略号=飘远延留；连字符=拖长(`Lo-o-ove`/中文"暖——")；换行=较长停顿；空行=器乐继续人声停一拍；叹号=加能量(勿滥用)。**行内裸空格常被连读吞，切气口用标点或换行。**
- **行宜短**(≤10–12字/词)，长句拆多行。排成歌词单(分段+段间空行)非文字墙。
- **行长一致**(syllable pocket)：读出声喘不过气=太长；空=加重复词/衬词。
- **重复有意**：短hook比长副歌好唱；副歌每次唱不一样=太长/密/新→缩短重复。
- **锚句**：每段末同一句稳住人声引擎。**密度**：密写放主歌，副歌留白。
- **发音纠正**：英文改拼写(read→reed)；中文换字/调断句/数字写汉字/避生僻；一词连续失败别死磕，换同义词。
**E. 二重唱**：`[male vocal]…[female vocal]…[both]…`，该段保持简单。

## 23. Sliders/Exclude/Helper
- **Sliders**(V4.5+)：Weirdness 情感歌偏Safe；Style Influence Style精准时偏Strong；Audio Influence仅上传参考音频用。
- **Exclude 字段**：要"没有某乐器"用它，别在Style写否定。
- **Prompt Helper**：自动扩写(非确定性)，当学习工具用(抄走有用描述符)，生产/要一致时关掉。

## 24. 专辑一致性技术栈
- **Persona Voice 锁音色**：满意人声 Create Persona→命名→复用(保留音色与基本唱风,不保留旋律/咬字)。做流派专属，别用重处理的歌建。
- **Custom Models**(V5.5最多3个)：≥6首风格一致歌训"声音指纹"，作整专底模。素材须风格统一(混流派教糊)。
- **Voice Cloning**(V5.5)：克隆真人嗓需验证授权，对"亲历者原声"有价值，伦理授权硬约束谨慎。
- **My Taste**：自适应偏置，显式Style仍覆盖它。
- **叠用顺序——把"不变量 binder"和"每轨变量"分开**：专辑的一致性来自**不变量 binder**——Persona(嗓)+主题动机+统一调性——它在每首之间纹丝不动。**流派/时代色/配器是每轨变量**：可随叙事节点切换(转折处用更快更硬的流派；或匹配听者会与某个时刻*产生联想*的声音——经由其年代、地方、事件、或共同的文化符号，§15.1)，而专辑仍是一个整体，因为嗓音与动机从不移动。**诚实说出权衡**：训一个 Custom Model 需 ≥6 首*风格统一*的歌(混流派教糊，见上)——所以大幅每轨流派多样化意味着**靠 Persona(流派宽容)而非 Custom Model**。当你*确实*要一个统一声底时，叠放为：Custom Model(底模)>Persona(嗓)>风格家族三件套(时代+流派+制作)+统一调性。

## 25. Song Editor 精修
**Inpainting/Replace Section** 重做某段(副歌弱/主歌好/bridge调性不对)；**Extend** 续写30–60秒(开头放结构标签)；**Crop** 裁拖尾；**Fade In/Out** 头尾渐变。Inpainting迭代,预算2–5次接缝才自然。

## 26. 流派置信度（诚实警告）
训练数据~86% Global North、地方乐器<3%。**高(稳)**：Pop/Rock/Hip-Hop/EDM/R&B/Country/Folk/Jazz。**中(需引导)**：Metal/Classical/Latin/Afrobeats/K-Pop-J-Pop。**低(反复抽卡,只是近似)**：先锋实验、非西方传统(中国戏曲民乐/甘美兰/拉格/呼麦)、纯音效。**民乐**：Suno认得具体乐器名(erhu/guzheng/pipa/dizi/guqin)比泛写准，子流派用`Chinese folk ballad/Mandopop/C-pop`；正统戏曲方言仍最低置信。**语言**：Mandarin属最佳支持之一(放心做中文)，方言(粤/苏白)弱。**业务**：主力走流行/民谣/抒情/灵魂出片稳；戏曲民乐只承诺"味道近似"，或用"普通话+民乐点缀"国风代正统戏曲。

## 27. 版权与伦理合规
**版权**：不可复刻名曲(只做神似+原创词)；艺人名被过滤(翻人声三层)；商用须 Pro 档(约$10/月,V5.5+商用权)并核对当期条款,免费档非商用,credits不结转。
**伦理与敏感(真实主角)**：主角为真人时须有尊严地处理——敏感内容抽象化或剔除(政治转写为个人感官意象／过暗情节剔除／疾病、逝者、隐私谨慎处理,逝者或需继承人授权)；未经授权不依赖可辨识肖像；成品交付前请家人确认。

---

# Part V 提示词框架与实例

## 28. 端到端框架
①Brief(为谁/何素材/场合/情感/参考)→②情感→杠杆(§3定方向)→③写词(取材object writing→视角→结构→格律押韵工整→hook→倒字自检)→④写Style(人声三层前置+4–7描述符+调性)→⑤Lyrics+Metatags(结构标签+参数化+可唱性)→⑥Sliders(低Weirdness+强Style Influence,Helper关)→⑦抽卡N→QC筛→⑧局部精修(Replace/Inpainting 2–5次/Extend)→⑨一致性(锁Persona/训Custom Model+统一调性)→⑩交付。

## 29. 模板
**Style**：`[人声:年代+音区+音色,唱法+制作],[流派][子流派],[速度/能量],[核心乐器],[情绪],(可选 in X major/minor)`
**Lyrics**：
```
[Intro: piano only]
[Verse 1: breathy intimate, sparse]（私密细节,行长一致8–12字,标点控气口,末行=锚句）
[Pre-Chorus: strings enter, rising]
[Chorus: full band, opened-up vocals]（短hook,可重复,零倒字,锁辙+对仗）
[Bridge: piano only, vulnerable]（一新意象,回hook）
[Final Chorus: biggest, harmonies]
[Outro: fade out]
[End]
```
**Sliders**：Weirdness=Safe；Style Influence=Strong；Helper=Off。

## 30. 实例走查（"人物回望"，工作流通用）
**Brief**：为长辈做代表作；苦中带暖的释然、深沉亲情；纪念场合当众播放。
**②杠杆**：小调主歌→大调副歌；66BPM；6/8主歌→4/4副歌；钢琴起→弦乐渐入→副歌全编+二胡；弱起爆发退桥；warm aged mezzo,主歌气声副歌放开带哽。
**③词**：取材抓物件/动作/口头禅；第一人称；主歌密写细节/副歌点题留白；hook重复式+专属意象+锁辙；副歌题眼人名零倒字。
**④Style**：`warm aged mezzo, breathy to opened-up, close-mic, Mandarin emotional folk ballad, slow piano with erhu and strings, warm analog, deeply nostalgic, in A minor`
**⑤Lyrics**：`[Intro: solo piano]`→`[Verse 1: breathy intimate, sparse, 6/8 feel]`→`[Pre-Chorus: strings enter, rising]`→`[Chorus: full band, erhu accent, opened-up vocals, 4/4]`(短hook:一组对仗+点题,锁辙,零倒字)→`[Bridge: piano only, vulnerable]`→`[Final Chorus: biggest, light harmonies, erhu]`→`[Outro: fade out]`→`[End]`。行长齐、标点极简、末段留动机供间奏复现。
**⑥–⑨**：Weirdness=Safe/Style=Strong/Helper=Off；N≥8挑最贴brief的嗓→Create Persona全专复用；副歌Replace 2–3次保"转大调够亮"+逐句校倒字；QC目标≥9/10。

---

# Part VI 质量控制与工作流

## 31. 双 SOP
- **代表作(85+)**：N≥8；先定Persona/Custom Model；副歌Inpainting 2–5次；逐句校倒字；关Helper；可3轮迭代。
- **底座(60+)**：N=2–4；复用代表作Persona+同风格家族；合格即收不过度打磨。
- 精力集中在每专那一首代表作（质量非均匀投放）。
- **应用层可扩展**：具体项目可在"代表作"之上再设一首"副主打"（旋律/曲风优先、好听先入为主），按多档投放——见调用本指南的 skill。

## 32. 成品 QC 量规（10项打勾）
①音准稳②咬字可懂、字句读得通(无答非其维/句式只开不合/一词两义/残句悬空)、无倒字③结构完整无烂尾④无AI瑕疵(金属感/电流/漂移)⑤hook立得住⑥情感与意图一致⑦配器清晰⑧动态有起伏⑨与专辑/Persona一致⑩时长可用。**代表作≥9，底座≥7。** 未达标→精修或回改维度。

## 33. 症状→病因→处方
| 症状 | 处方 |
|---|---|
| 十次生成各不相干 | Style补到4–7个、调高Style Influence |
| 通用AI嗓/音色每次变 | 人声翻三层放最前、段落metatag复述 |
| 词像散文 | 锁一辙一韵到底、拉齐行长、每段副歌埋对仗、砍口语化的散句 |
| 产出糊 | 砍到4–7、去冲突项 |
| 副歌没爆 | 参数化`[Chorus: full band…]`、Replace Section |
| 副歌每次不同/robotic | 缩短重复、去内韵、加锚句 |
| 歌词被切断/赶 | 缩到4行、减字、加空行、密写移主歌 |
| 句子连读/气口消失 | 改标点或换行、行≤10–12字 |
| 中文听错字 | 换字、调断句、数字写汉字、别死磕同词 |
| 突然结束/拖尾 | `[Outro] fade out`+`[End]` |
| 各曲不像一家人 | 锁Persona/训Custom Model、统一风格家族、Style加`in X minor/major` |
| 戏曲民乐不地道 | 民乐点名英文、多抽卡降预期、或改普通话国风 |
| 太怪不连贯 | 调低Weirdness、关Helper |
| "心碎"却不动人 | Prosody错→用不稳定工具(奇数行/缩末行/远韵/ABBA) |

## 34. 专辑统筹
**一致性来自不变量 binder(Persona+主题动机+统一调性)，而非单一统一流派**(§24)——所以流派/时代色可随叙事节点逐曲变化。主题动机：代表作旋律/一句歌词在别曲变奏或器乐复现；题眼复现串动机线。**编排由主体的情绪曲线驱动**(从素材提炼的 valence-over-time 一条线，§5)：每个节点映一首，再塑曲线——专辑 sequencing 研究发现**速度呈倒 U 型、valence/arousal 反向**，故把代表作放情绪高潮(中后位)、其后留 1–2 首下行/释放、器乐间奏作呼吸、`[End]`收束、总时长26–30分(8首)。工整vs写意基调(§13.7)：先定工整基调，写意余地0–2首由创作者把控。视角变化制造呼吸。

## 35. 交付规格
WAV母版+320k MP3；统一**-14 LUFS**；实物载体单独核验音量曲序；附封面(§36)/曲目表/手写卡。Pro+商用权先核对当期条款。

## 36. 封面设计（视觉层的 Prosody）
**原则**：封面像专辑听起来的样子。视觉四要素(主体/色彩/排版/构图)与词曲声制作**同源**，服从同一情感意图——直接复用蓝图的 throughline 意象 + 最强专属锚点 + 情感基调 + 风格家族 + Persona 气质，不另起炉灶。

- **主体 = throughline 意象 / 最强专属锚点**(具体物件优先、sense-bound)，别用抽象泛图。构图**留出叠标题的负空间**。**throughline 抽象、不可视觉化时**(如"一句没说出口的话")退到**最强专属锚点物件**，别硬画抽象概念。
- **色彩 = 情感基调映射**(同§3明暗逻辑)：暖/明高饱和=大调温暖喜悦；冷/低饱和=小调内省哀伤；高饱和高对比=激励欢庆。呼应情感弧。
- **排版 = Persona/流派气质**：厚重衬线=庄重深沉；轻盈手写/无衬线=温柔活泼。专辑名(+可选主角名)层级清晰。
- **构图**：三分法、明确焦点、留白、高对比；**缩略图可读**(流媒体首图极小→焦点强、信息少、字别小)。对称=安定，非对称=动感，按气质选。**忌**杂乱、平台 logo、价格、URL。
- **三风格并出**(对应§28端到端中"多方案"精神)：具象摄影 / 插画手绘 / 抽象极简或拼贴是**默认原型，按专辑气质可替换**(如高能量专辑换动感拼贴/胶片速度感)；只须三案**真正分叉**(非换皮)，供选。
- **AI 提示词两套写法**：Midjourney 用"主体 + 风格/媒介 + 光线 + 色彩情绪 + 构图"+ `--ar 1:1`(≤约60词)；Nano Banana / GPT Image 用自然语言句(Subject+Action+Scene+mood)。**AI 文字渲染不可靠**(Midjourney 尤甚)：专辑名/主角名优先后期叠字，或用文字强的模型(Nano Banana Pro / GPT Image)；**提示词统一加 `no text`/"do not render any text"**，防模型自己糊假字母占掉留白。
- **规格**：流媒体母版 **3000×3000、1:1、sRGB、JPG/PNG**(Spotify 最低 640、Apple 最低 1400，统一出 3000+)；实体 CD 成品 120×120mm→设计稿 **126×126mm 含 3mm 出血、300 DPI(≥1417px)、CMYK**、文字留安全区。AI 先出最高分辨率方形再放大到 3000²。
- **真人/在世主角**(§27)：**默认不依赖可辨识人脸**——用 throughline 实物、手/背影等局部、或插画(既规避肖像授权，也因 AI 本就画不出特定真人)；确需本人肖像须家人授权。敏感意象抽象化。

---

# Part VII 局限·置信度·来源
- **高置信(与平台无关)**：词曲理论(prosody/视角/押韵/object writing/稳定度/工整基调)、三大原则、七维/情感映射/抽卡-精修-QC方法论。
- **高(严重度随模型下降)**：中文倒字/可唱性纪律(仍作定稿纪律)。
- **中高(近期调研,实操前核对当前Suno)**：Suno字段/Metatags/Sliders/Editor/4–7描述符、人声三层/前置/艺人名翻译、标点即节奏、调性入Style、流派置信度地图。
- **中(伦理授权强约束)**：Voice Cloning亲历者原声。

**来源**：Pattison《Writing Better Lyrics》、Berklee Online、songwriting.net(Prosody)；help.suno.com、blakecrosley.com《Suno V5.5 Reference》、jackrighteous.com；人声控制综合hookgenius.app/sider.ai/musci.io等社区实证。封面规格与设计原则综合 Spotify/Apple 官方 cover art 要求、DIY Musician/LANDR/99designs 设计实践、Google Nano Banana 与 Midjourney 提示词指南。**Suno 与图像模型迭代快，Part IV/§36 每3–6月复核。**

---

*v3.5 精简版 · 词曲声制作+三大原则+要素词汇库+AI最佳实践+提示词框架+封面设计 · 配套 song_examples*
*2026-06-22 · by Claude Opus 4.8*
