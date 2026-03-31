<!-- // Ver 2026-03-31 21:43, by GPT-5 -->

# Skills 评估报告

本报告基于 `skill-creator` 的原则，对以下两个 skill 做静态评估：

- `master-bp-review/`
- `startup-idea-evaluator/`

本轮只做分析，不做修复。

## 一句话结论

- `master-bp-review/` 的主要问题不是“写得少”，而是“角色设定过重、分析约束过弱、输出负担过大”，容易产出华丽但不够可靠的内容。
- `startup-idea-evaluator/` 整体方向明显更成熟，框架也更强，但存在“触发过宽、上下文过重、外部依赖未封装、分发文档冗余、可移植性隐患”等工程化问题。

## 评估方法

主要依据：

- `skill-creator` 对 skill 的要求：触发描述清晰、SKILL.md 精简、渐进披露、避免冗余文档、references 一层直达、验证路径可信。
- 对两个 skill 的 `SKILL.md/skill.md`、`references/`、`evals/` 做逐项审查。
- 额外运行了 `quick_validate.py`，用于判断基础格式是否通过；但该校验只能说明“最低限度格式可读”，不能说明 skill 设计合理。

## 共性问题

### 1. 都偏重“输出样式”，对“失败模式约束”覆盖不足

两个 skill 都比较擅长告诉模型“应该输出什么”，但不够擅长约束“什么时候不要硬编”“信息不足时如何降级”“哪些结论必须标记为假设”。

影响：

- 输出容易看起来完整，但证据密度不稳定。
- 模型在缺少事实输入时，可能用推断填空，尤其在市场规模、竞争、长期远景、投资判断上。

### 2. evals 更像示例，不像真正的 failure-driven 评测

两个 skill 的 `evals/evals.json` 都主要在验证“能不能触发、会不会按模板输出”，但很少覆盖真正容易出错的场景。

例如缺失的 eval 类型：

- 输入信息极度不足，但模型仍被诱导输出很长分析。
- 用户明确不想保存文件，但 skill 有默认保存动作。
- 用户输入与 skill 边界相邻，应该不触发或只触发简化模式。
- 用户提供错误数字或自相矛盾信息，skill 是否会指出矛盾。

## 对 `master-bp-review/` 的评估

### 总体判断

这是一个“有强烈风格、但可靠性不足”的 skill。它很容易产出有戏剧张力的内容，但不够像一个稳健的分析工具，更像一个高配 prompt 模板。

### 主要问题

#### 1. 触发边界过宽，容易抢占其他更合适的 skill

`description` 里把 “startup idea”“any business document”“给我创业建议” 都纳入触发范围，边界明显过宽，见 `master-bp-review/SKILL.md:2-3`。

问题在于：

- “创业建议” 并不等于 “七位大师评审 + 创始人重写 BP”。
- “startup idea” 更像 `startup-idea-evaluator/` 的地盘。
- “any business document” 几乎会吞掉很多通用分析场景。

结果是：

- skill 触发会偏激进。
- 真正需要简洁评估的请求，也可能被拉进一个很重的多角色输出流程。

#### 2. 大量篇幅花在人物设定，真正的分析方法论不足

从 `master-bp-review/SKILL.md:14-120` 看，主体内容绝大部分在定义 7 位“评审人”的风格、关注点、语气。这能帮助模型模仿口吻，但对提高判断质量帮助有限。

缺失的关键约束反而是：

- 没有明确规定信息不足时如何处理。
- 没有要求区分“事实 / 推断 / 假设”。
- 没有要求先做 business framing，再进入角色视角。
- 没有定义哪些内容必须引用 BP 原文，哪些可以合理推断。

也就是说，这个 skill 更擅长制造“视角差异”，不擅长控制“分析可信度”。

#### 3. 输出负担过重，默认要求过高

这个 skill 默认要求：

- 7 位角色分别评审，见 `master-bp-review/SKILL.md:131-152`
- 创始人汇总并做判断，见 `master-bp-review/SKILL.md:154-179`
- 完整重写商业计划书，见 `master-bp-review/SKILL.md:176-178`
- 保存 markdown 文件，见 `master-bp-review/SKILL.md:189-201`

这对很多真实请求来说过重。尤其当用户只是说“帮我看看这个想法”时，这会导致：

- 分析时间和 token 成本飙升
- 重点被格式淹没
- 创始人“完全重写 BP”在信息不足时高度依赖模型脑补

这是这个 skill 最大的结构性问题之一。

#### 4. 缺少分级模式，无法根据输入质量降级

与 `startup-idea-evaluator/` 的 Mode A / Mode B 不同，`master-bp-review/` 没有输入复杂度分级，所有请求都默认进入最重流程。

这意味着：

- 一句话 idea 和完整 BP 文档，都会被同样处理。
- 没有“轻量点评”“先问关键问题”“只输出投资判断”的降级路线。

#### 5. “创始人回应 + 重写 BP” 的设计存在角色冲突

`master-bp-review/SKILL.md:158-178` 要求模型先扮演多位评审人，再扮演“真实创始人”，最后重写整个 BP。

问题在于：

- 模型并不真的拥有创始人的上下文。
- 这种“再扮演真实创始人”的动作，本质上仍是模型继续生成，不是真正的 founder reasoning。
- 很容易制造一种“已经完成战略收敛”的错觉。

这会降低输出的诚实度。更好的做法通常是：明确标记为“模拟 founder response”或“recommended revised narrative”，而不是暗示这是“actual founder”。

#### 6. references 的价值偏低，几乎只有输出模板，没有分析支撑

`references/review-template.md` 基本是大纲模板，见 `master-bp-review/references/review-template.md`。它对格式统一有帮助，但对分析质量没有提供外部支撑，例如：

- BP 评审该先看什么
- 常见商业计划缺陷清单
- 何时应该质疑 market size / GTM / moat / unit economics
- 何时需要要求更多信息而不是继续输出

所以这个 skill 的 reference 体系太薄，几乎无法承担“渐进披露”的作用。

#### 7. evals 存在明显不一致，说明维护不够扎实

skill 本体明确是 7 位评审人，见 `master-bp-review/SKILL.md:8`，但 `evals/evals.json` 中多个 expected output 仍写成“5 separate master reviews / 5位评审人”，见：

- `master-bp-review/evals/evals.json:13`
- `master-bp-review/evals/evals.json:19`
- `master-bp-review/evals/evals.json:25`

这是一个直接的维护信号问题：

- 说明设计从 5 人扩到 7 人后，评测没有同步更新。
- 评测不能稳定约束行为。
- 后续迭代时容易出现“skill 写的是一套，eval 盯的是另一套”。

### 这个 skill 最值得优先改进的方向

如果后续要改，我认为优先级应是：

1. 缩窄触发边界，避免与 idea-evaluation 类 skill 重叠。
2. 加轻重两档或三档模式，不要默认 7 角色 + 重写 BP。
3. 把人物设定压缩到更短，把“事实、假设、证据、缺失信息处理”写清楚。
4. 补强 references，不只给模板，还要给分析框架与降级规则。
5. 重写 evals，重点测边界与失败模式，而不是只测“像不像这个格式”。

## 对 `startup-idea-evaluator/` 的评估

### 总体判断

这是两个 skill 里明显更成熟的一个。它已经有比较清晰的 worldview、输出分级、分析链路和参考资料。但它的主要问题不是“不会分析”，而是“太想包办一切”，导致触发、上下文、依赖和分发方式都变重。

### 主要问题

#### 1. 触发描述过宽，而且带有明显的过触发倾向

前言描述已经很宽，最后还写了 `When in doubt, use it.`，见 `startup-idea-evaluator/skill.md:3-12`。

这会带来两个问题：

- 触发时宁滥勿缺，容易侵入其他 strategy / market research / pricing / GTM skill 的职责。
- 模型在边界模糊时，会默认套用这个框架，导致输出过重。

一个好的 description 应该帮助“正确触发”，而不是鼓励“有点像就触发”。

#### 2. 默认上下文假设写得很完整，但也较强势

`startup-idea-evaluator/skill.md:17-29` 预设了团队规模、市场、营销能力、技术栈、融资路径和语言。

优点是世界观统一。

缺点是：

- 它容易把分析默认推向“3 人团队 + 中国/全球 + bootstrap-first”的框架。
- 虽然文中说可以 override，但很多用户不会主动覆盖。
- 当请求本来不符合这些默认值时，输出可能被“温柔地带偏”。

这个问题不算致命，但需要更强的“先判断是否适用默认上下文”的机制。

#### 3. SKILL 主体已经接近“重框架 prompt”，上下文成本偏高

`startup-idea-evaluator/skill.md` 共 288 行，包含大量流程、解释、风格、反模式、引用说明。它本身质量不差，但已经开始逼近“过载”边缘。

具体表现：

- Step 2 到 Step 7 非常完整，见 `startup-idea-evaluator/skill.md:74-248`
- 风格与 anti-pattern 又额外占了大量篇幅，见 `startup-idea-evaluator/skill.md:258-280`
- 再加三个 references，整体上下文开销不小

对一个高频 skill 来说，这会影响：

- 触发后的响应效率
- 模型对真正关键规则的关注度
- 多 skill 共存时的上下文预算

#### 4. references 对外部 skill 存在硬依赖，但没有真正封装

最明显的问题在 `startup-idea-evaluator/references/market-analysis.md:3,26,65,97`，它多次要求调用 `everything-claude-code:market-research`。

这意味着：

- 当前 skill 并不自洽。
- 如果环境里没有那个 skill，市场分析这一步会退化。
- 就算有该 skill，依赖关系也没有被正式声明或封装成清晰的 fallback。

这是一个实打实的工程问题，不是文风问题。

更直接地说：你这里不是“参考另一套方法”，而是“把关键能力外包出去了”，但没有处理依赖不存在时怎么办。

#### 5. README.md 属于 skill-creator 明确不推荐的冗余文档

`startup-idea-evaluator/README.md` 很完整，但从 `skill-creator` 的原则看，README 属于不应放进 skill 的额外文档。

而且这个 README 不只是多余，还带来几个次生问题：

- 文档维护成本翻倍
- 可能与主 skill 演化不同步
- 鼓励“复制成别的平台 prompt”，削弱 skill 作为模块化资产的定位

证据见 `startup-idea-evaluator/README.md:26-155`，它主要在讲跨平台复制、拼接、粘贴的使用方式，而不是给 Codex 提供执行知识。

#### 6. 文件命名在大小写不敏感文件系统上“看起来没问题”，但可移植性差

该目录里实际文件名是 `skill.md`，不是 `SKILL.md`。当前环境因为文件系统大小写不敏感，所以验证脚本仍能通过，但这会在大小写敏感环境里变成真实问题。

这不是理论风险：

- `quick_validate.py` 要求 `SKILL.md`
- 当前目录 listing 显示的是 `skill.md`
- 但 Python `Path('startup-idea-evaluator/SKILL.md').exists()` 在当前盘上返回 true，本质上是文件系统帮你兜底

因此现在是“碰巧没炸”，不是“设计正确”。

#### 7. reference 文件整体有价值，但仍存在重复和可压缩空间

`gtm-playbooks.md` 和 `market-analysis.md` 是有用的，确实承担了渐进披露的一部分。

但仍有几个问题：

- `market-analysis.md` 中不少内容本身就像另一份 skill 的调用说明，不像自包含 reference。
- `example-output.md` 较长，更多是在校准风格与深度；如果经常读取，会带来较高 token 成本。
- SKILL 主体里已经对很多输出要求写得很细，references 又重复了一部分结构。

也就是说，这个 skill 的问题不是“没有 references”，而是“references 已经有了，但边界还不够干净”。

#### 8. 部分要求过于理想化，容易诱导模型给出假精确

例如：

- 市场规模要求“≥2 methods triangulated”，见 `startup-idea-evaluator/skill.md:141`
- 定价、ARPU、12 个月客户数、break-even、LTV:CAC、runway 等一整套估算，见 `startup-idea-evaluator/skill.md:152-182`

这些要求本身没错，但如果用户只给了轻量输入，又没有真实 research 支撑，模型就容易：

- 为了满足格式而硬填数字
- 给出看起来专业、实则证据不足的测算

好消息是你已经加了 Missing Data Protocol，见 `startup-idea-evaluator/skill.md:252-255`。坏消息是它在文档末尾，力度不够，常常会被前面的大量“必做分析”压过去。

#### 9. evals 质量还不错，但覆盖面仍偏窄

`startup-idea-evaluator/evals/evals.json` 至少覆盖了：

- Mode A / Mode B 分流
- 中国语境
- GTM 与市场 sizing 预期

这比另一个 skill 要成熟。

但仍缺少关键场景：

- 明显不该触发的 case
- 美国-only 团队 / 有融资 / 有营销团队等 override case
- 数据明显冲突的 case
- 用户只要简短 verdict，不要完整 memo 的 case
- 外部 `market-research` skill 不存在时的退化表现

### 这个 skill 最值得优先改进的方向

如果后续要改，我认为优先级应是：

1. 收窄触发 description，删掉 `When in doubt, use it.` 这种过触发信号。
2. 处理外部依赖，把 `market-research` 依赖改成“可选增强”，不是“隐性必需”。
3. 精简 SKILL 主体，把风格说明和一部分格式约束进一步压缩。
4. 移除或外迁 README 这类分发文档，避免 skill 包膨胀。
5. 把 Missing Data / Assumption-first 规则前置，避免模型为了满足结构硬编数字。
6. 处理 `skill.md`/`SKILL.md` 的可移植性问题。

## 横向比较

### 哪个更好？

如果只看当前质量，`startup-idea-evaluator/` 明显更好。

原因不是它“更长”，而是它至少已经具备：

- 输入复杂度分流
- 分析链路
- validation-first 倾向
- 一定程度的渐进披露
- 明确的默认 worldview

而 `master-bp-review/` 目前更像一个高戏剧性输出器，不够像一个稳健的 business-analysis skill。

### 哪个问题更严重？

- `master-bp-review/` 的问题更偏“产品定义问题”。
  也就是：到底要做一个娱乐性强的多视角评审器，还是一个可靠的 BP 分析 skill？现在这两者混在一起。
- `startup-idea-evaluator/` 的问题更偏“工程化问题”。
  也就是：框架已经不错，但触发、依赖、文档组织和上下文成本还没有收干净。

## 优先级建议

如果你后续只投入有限时间，我建议优先顺序是：

1. 先修 `startup-idea-evaluator/`
原因：底子已经好，修完收益高，而且更接近可复用的核心策略 skill。

2. 再决定 `master-bp-review/` 要走哪条路
方向 A：保留“七位大师”的产品化特色，但降重、加模式、加事实约束。
方向 B：把它收缩成 `bp-review` 类 skill，不再强调强角色扮演，而强调 BP 审查框架。

## 最后的判断

这两个 skill 里，`startup-idea-evaluator/` 已经接近“值得继续打磨”的状态；`master-bp-review/` 还处在“概念很抓人，但设计重心还没站稳”的阶段。

如果后续进入修订轮，最关键的不是继续加内容，而是做三件事：

1. 收窄触发边界
2. 前置缺失信息与降级规则
3. 用 failure-driven evals 替代“格式正确即可”的 evals
