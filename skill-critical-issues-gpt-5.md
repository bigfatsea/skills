<!-- Ver 2026-03-31 21:50, by GPT-5 -->

# Skill 关键问题与建议方案

基于上一轮完整评估，这里只保留两个 skill 最关键、最值得优先处理的问题，以及对应的建议方案。

## 总结判断

- `startup-idea-evaluator/` 更值得优先修，因为底子更好，改动收益更高。
- `master-bp-review/` 的核心问题更偏产品定义不清；如果不先收窄定位，继续加内容只会更重。

## 共性关键问题

### 问题 1：偏重输出样式，缺少失败约束

两个 skill 都很强调“输出应该长什么样”，但对以下问题约束不够：

- 信息不足时如何降级
- 哪些结论必须标为假设
- 什么时候应该停止扩写，而不是继续补全

### 建议方案

- 在主流程前面加入统一的 `Evidence / Assumption / Unknown` 规则。
- 把 “缺信息时先降级输出” 提升为前置规则，而不是放在文档末尾。
- 明确要求模型避免对 market size、竞品、长期远景、财务测算做无依据硬填。

### 问题 2：evals 更像示例，不像 failure-driven 测试

当前 evals 更多验证“会不会触发、会不会按模板输出”，不足以约束真实失败模式。

### 建议方案

补充以下类型的 eval：

- 极少信息输入，看是否仍被诱导输出重型分析
- 边界输入，看 skill 是否会误触发
- 用户明确不要保存文件，看是否仍执行保存动作
- 数字自相矛盾输入，看是否能指出矛盾
- 缺少外部依赖时，看是否会合理退化

## `startup-idea-evaluator/` 最关键问题

### 问题 1：触发范围过宽

最核心的风险点是 `description` 过宽，尤其 `When in doubt, use it.` 会明显鼓励过触发。

影响：

- 容易抢占其他 strategy / GTM / market research 类 skill 的边界
- 边界模糊时默认进入重分析流程，导致输出过重

### 建议方案

- 删除 `When in doubt, use it.`
- 把触发范围改成更明确的几类：
  - 创业想法可行性评估
  - early-stage business model / GTM / monetization 评估
  - pitch/deck logic 的早期判断
- 明确排除项：
  - 纯市场调研
  - 纯定价研究
  - 已有成熟业务的运营诊断

### 问题 2：对外部 `market-research` skill 存在隐性硬依赖

这是最需要工程化修复的问题。现在市场分析步骤并不真正自洽，依赖不存在时会退化，但文档没有正式处理 fallback。

### 建议方案

- 把外部 `market-research` 改为“可选增强能力”，不是默认前提。
- 在 `market-analysis.md` 中写清楚两条路径：
  - 有外部 research skill：调用它补真实数据
  - 没有外部 research skill：只做基于已知输入的粗估，并明确标为假设
- 避免 reference 里反复写“follow another skill”，改成直接给最小自包含框架。

### 问题 3：上下文成本偏高

主 skill 本体已经较长，再叠加 3 个 references，长期会影响高频使用效率。

### 建议方案

- 压缩主 skill，只保留：
  - 触发条件
  - 模式分流
  - 核心 workflow
  - 缺失信息处理
- 把风格、anti-pattern、长篇解释继续下沉到 references。
- `example-output.md` 保留为示例，但不要让主 skill 隐含鼓励频繁读取。

### 问题 4：README 属于冗余资产

README 的存在会增加维护负担，也不符合 `skill-creator` 对 skill 包精简化的原则。

### 建议方案

- 如果目标是 Codex / skill 使用，直接删除 README。
- 如果你确实要保留跨平台分发说明，把它移出 skill 目录，放到外部 docs 区域。

### 问题 5：`skill.md` 命名存在可移植性风险

当前能通过，只是因为运行环境大小写不敏感，不代表设计正确。

### 建议方案

- 统一改为 `SKILL.md`
- 用大小写敏感环境或显式校验脚本重新验证一次

## `master-bp-review/` 最关键问题

### 问题 1：定位过宽，和 `startup-idea-evaluator/` 明显重叠

它现在既想处理 BP review，又想处理 startup idea，又想处理一般创业建议，边界太散。

### 建议方案

- 先明确它到底是什么：
  - 如果是“多大师视角的 BP review 产品化 skill”，就只服务 BP / deck / business document review
  - 如果是“创业 idea 评估 skill”，那它应与另一个 skill 合并或重构
- 最现实的方向是收窄到：
  - `BP / pitch deck / business doc review`
  - 不默认处理一句话创业想法

### 问题 2：默认输出过重

7 位角色独立评审 + founder response + 完整重写 BP，这个默认负担太高，是当前最大结构问题。

### 建议方案

- 增加 2-3 档模式：
  - 轻量：只给投资判断 + 核心问题
  - 标准：多角色简评 + 关键分歧
  - 重量：完整报告 + founder response + rewrite
- 默认只走“标准模式”，不要默认 full rewrite。

### 问题 3：人物设定过多，分析方法论过少

当前大量篇幅用于描述七位人物的气质与关注点，但对分析可信度更重要的规则写得不够。

### 建议方案

- 大幅压缩人物介绍，保留每人 3-4 个最关键判断维度即可。
- 把节省出的篇幅用来写：
  - 先做 business framing
  - 区分事实 / 推断 / 假设
  - 哪些判断必须引用用户输入
  - 信息不足时如何降级

### 问题 4：“扮演真实创始人” 这个设定不诚实

模型不可能真的拥有 founder 的上下文，这种写法容易制造虚假的战略确定感。

### 建议方案

- 把“actual founder”改成：
  - `模拟 founder response`
  - `recommended founder decision`
  - `revised narrative based on available information`
- 显式声明这部分是基于已有输入的建议性重构，不是假定掌握真实内部信息。

### 问题 5：evals 与主 skill 设定不一致

主 skill 已经是 7 位评审，但 evals 里仍有多个 case 写成 5 位评审，这是维护质量问题。

### 建议方案

- 先把 evals 与 skill 本体对齐
- 然后再补 failure-driven evals，而不是只校验“像不像这个格式”

## 建议的实际修复顺序

如果你下一轮只想做最少量、最高收益的修改，建议顺序如下：

1. 修 `startup-idea-evaluator/` 的触发范围和外部依赖
2. 修 `startup-idea-evaluator/` 的上下文压缩和 README 清理
3. 统一 `startup-idea-evaluator/` 的 `SKILL.md` 命名
4. 收窄 `master-bp-review/` 的定位
5. 给 `master-bp-review/` 增加模式分级
6. 重写两个 skill 的 evals，改成 failure-driven

## 最后结论

如果目标是做成“长期可维护、可复用、可叠加”的 skill 资产：

- `startup-idea-evaluator/` 应该走“变轻、变稳、去依赖”的路线。
- `master-bp-review/` 应该走“先收定位，再减戏剧化，再补分析约束”的路线。

下一轮最不该做的事，是继续给任一 skill 加更多风格化内容或更多模板段落。现在真正缺的不是内容，而是边界、降级、依赖管理和评测质量。
