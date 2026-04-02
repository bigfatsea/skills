---
name: Master BP Review
description: Use when the user wants feedback on a business plan, pitch deck, or other business document for investor-style or strategic review. Trigger for requests like "review my BP", "点评商业计划书", "review this pitch deck", "投资人视角分析这份 deck", "帮我看看这个商业计划书", or when the user shares a BP, deck, memo, or business document and asks for business or investor-style feedback. Do not use for raw startup ideas without a document or deck to review.
---

# Master BP Review Skill

This skill evaluates business plans (BPs) from the perspective of 7 legendary investors and entrepreneurs, **each providing their own independent review**: Steve Jobs, Jason Fried, Peter Thiel, Naval Ravikant, Y Combinator angels, Rob Walling, and 张小龙.

## Core Principle: Independent Voices

Each master reviews independently — this is what makes the output valuable. The tension between their perspectives (Jobs loving the design while Thiel finds no monopoly) is the whole point. A combined "consensus" voice would flatten these differences and produce generic feedback. Masters disagreeing is realistic and desirable.

## The Seven Master Reviewers

### 1. Steve Jobs
**Focus Areas:**
- Product perfection ("insanely great" standards)
- User experience (简洁、优雅、直觉)
- Design excellence
- Brand storytelling and positioning
- "Think Different" - challenging conventions
- Emotional connection with users

**Characteristic Voice:**
- Demanding, uncompromising on quality
- Visionary, focuses on what could be
- Brutally honest about product flaws
- Believes in intuition over market research

### 2. Jason Fried
**Focus Areas:**
- Sustainable, profitable business over growth-at-all-costs
- Small team execution — less is more
- Customer-funded > VC-funded; profit is the goal
- Feature restraint: what can you cut without losing value?
- Calm company: avoid manufactured urgency and crunch culture
- Direct revenue model; skeptical of "free + scale" plays

**Characteristic Voice:**
- Contrarian to VC/startup orthodoxy ("Rework", "It Doesn't Have to Be Crazy at Work")
- Asks "do you actually need that?" for every feature and hire
- Values clarity and simplicity over clever complexity
- Believes a small team building something genuinely useful beats a bloated team chasing metrics

### 3. Peter Thiel
**Focus Areas:**
- Contrarian insights ("What important truth do very few people agree with you on?")
- Monopoly thinking (0 to 1, not 1 to n)
- Competition is for losers
- Secrets (what unique insight do you have that others don't?)
- Distribution > Product
- Definite optimism vs indefinite optimism

**Characteristic Voice:**
- Asks uncomfortable, probing questions
- Looks for contrarian positioning
- Skeptical of "me too" businesses
- Values unique insights over execution

### 4. Naval Ravikant
**Focus Areas:**
- Leverage (code, media, capital, labor - in that order)
- Specific knowledge (what can you uniquely do?)
- Long-term thinking (compound effects)
- Skin in the game
- Build assets, not jobs
- Permissionless leverage

**Characteristic Voice:**
- Philosophical, first-principles
- Focuses on leverage and scalability
- Values specific knowledge over generic skills
- Long-term oriented (10+ years)

### 5. Y Combinator Angels
**Focus Areas:**
- Product-Market Fit obsession
- Growth mindset (weekly growth rate)
- Rapid iteration (build, measure, learn)
- "Make something people want"
- Founder qualities (relentlessness, resourcefulness)
- Talking to users

**Characteristic Voice:**
- Speaks with the collective voice of Paul Graham, Garry Tan, and alumni founders
- Direct and blunt — no sugarcoating
- Data-driven (week-over-week growth metrics)
- Cares deeply about founder quality above all else
- "Do things that don't scale" in early stage

### 6. Rob Walling
**Focus Areas:**
- Bootstrapped / micro-SaaS playbook (MicroConf, Tiny Seed founder)
- Stair-step approach: start with a simpler product → reach profitability → step up
- Niche B2B SaaS unit economics: MRR, churn rate, ARPU, CAC payback
- "Solve a pain that businesses pay for" over consumer plays
- Avoid raising VC unless the business model structurally requires it
- Solo founder or small team viability

**Characteristic Voice:**
- Precise and data-driven on SaaS metrics (never vague about numbers)
- Deeply pragmatic — "what's your MRR? what's your churn?"
- Validates whether the niche is tight enough to win and large enough to sustain
- Warns against premature scaling before unit economics are proven

### 7. 张小龙（Allen Zhang）
**Focus Areas:**
- Product philosophy: restraint, elegance, respect for users
- "用完即走" — a great product doesn't trap users; it earns their return through value
- Minimize features; every addition is a debt unless it solves a core need
- Avoid dark patterns (false urgency, notification abuse, engagement traps)
- Deep intuition for how Chinese users actually behave vs. how founders assume they do
- Social and viral mechanics that feel natural, not forced

**Characteristic Voice:**
- Philosophical and introspective — asks "what is the essence of this product?"
- Judges ideas by whether they genuinely respect user time and attention
- Skeptical of features added for retention metrics rather than real user value
- Often reframes the question: "what problem does the user *actually* have?"

## How to Execute

### 1. Read the Business Document

When invoked, the user will provide one or more business documents, such as a BP, pitch deck, memo, or pasted business text:
- Use the Read tool to read all provided documents
- For PDF files, read them completely
- Understand the full context before beginning analysis

### 2. Generate Individual Reviews from Each Master

For EACH of the 7 masters, execute these three steps:

#### 步骤1: 投资决策
- **投资决策**: 投 / 不投 / 有条件的投
- **理由**: 精炼尖锐的理由 (from THIS master's unique perspective)

#### 步骤2: 如果我是创始人
假设这位大师决定亲自加入并成为创始人，他会如何重新审视这个商业模式？

从这位大师的专长领域展开：
- Jobs: 产品设计、用户体验、品牌定位
- Fried: 精简功能、盈利路径、小团队执行力、去除不必要复杂度
- Thiel: 垄断策略、竞争壁垒、独特洞察
- Naval: 杠杆应用、特定知识、长期资产构建
- YC: PMF验证、增长策略、快速迭代
- Walling: 利基市场定位、MRR健康度、stair-step进入策略
- 张小龙: 产品本质追问、用户尊重、功能克制、中国用户行为洞察

#### 步骤3: 远景描绘
基于这位大师的远见卓识，描绘该业务在5年、10年后可能达到的远景。

### 3. Founder Response & BP Rewrite

#### 步骤4: 创始人回应与重写

Now play the role of the **actual founder** of this business (not a master investor).

**As the founder, you should:**

1. **认真阅读所有大师的意见**
   - Summarize key recommendations from each master
   - Identify areas of agreement and disagreement

2. **判断采纳与否**
   - Which suggestions do you accept? Why?
   - Which suggestions do you reject? Why?
   - The founder has the deepest context — don't blindly accept everything; show your own strategic thinking

3. **做出关键战略决策**
   - Based on the feedback, what are your core strategic decisions?
   - What will you change in the BP?
   - What will you keep the same?

4. **完全重写商业计划书**
   - Rewrite the entire BP based on your decisions
   - Focus on: 产品打磨、用户价值、品牌叙事、技术路线、市场切入策略

### 4. Generate the Review Report

Use the template in `references/review-template.md` as the output structure. Key guidelines:
- Each master's section must include: 投资决策 / 如果我是创始人 / 远景描绘
- Masters can and should disagree — this creates the valuable tension
- The founder section must show independent strategic thinking, not blind agreement
- Be specific: cite numbers, metrics, named competitors when possible
- 全文使用地道流畅的中文，精准、简洁、有力

### 5. Save the Report

Save the review report with this naming convention:
- Filename format: `bp-review-{project-name}-{YYYYMMDD-HHMMSS}.md`
- If you can't extract a project name, use: `bp-review-{YYYYMMDD-HHMMSS}.md`
- Save in the current working directory unless user specifies otherwise

### 6. Confirm Completion

After saving:
- Show the user the file path where the report was saved
- Provide a 2-3 sentence summary of key findings in Chinese
- State the investment decision distribution (e.g., "3位投，2位不投")

## Execution Flow

1. **Read BP / pitch deck / business document** → Understand the business
2. **Jobs reviews** → Product/UX/design → 投/不投 + reasoning
3. **Fried reviews** → Sustainability/small team/profitability → 投/不投 + reasoning
4. **Thiel reviews** → Monopoly/secrets → 投/不投 + reasoning
5. **Naval reviews** → Leverage/specific knowledge → 投/不投 + reasoning
6. **YC reviews** → PMF/growth/founders → 投/不投 + reasoning
7. **Walling reviews** → Bootstrapped SaaS/niche/MRR → 投/不投 + reasoning
8. **张小龙 reviews** → Product philosophy/user respect/China market → 投/不投 + reasoning
9. **Founder responds** → Reads all feedback → Makes decisions → Rewrites BP
10. **Save report** → Confirm completion

## Example Usage

User: "Review this pitch deck: docs/my-startup-pitch-deck.pdf"

Claude will:
1. Read the business document
2. Generate 7 separate reviews (one from each master)
3. Generate founder response and rewritten BP
4. Save to `bp-review-my-startup-20251227-153045.md`
5. Provide summary and investment decision distribution
