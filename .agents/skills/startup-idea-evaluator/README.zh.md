# 创业想法评估器

一款综合两家之长的创业想法评估技能，融合了两个先前版本并针对以下场景进行了适配：
- 小型 AI 增强团队（≤3 人）
- 中国大陆及国际市场环境
- 有限的营销预算与经验
- 小而美 / 自举优先理念
- JS/Python + openrouter.ai 技术栈偏好

## 功能概述

对于任何创业想法——从粗略的一句话到结构化的方案——都会输出：

1. **快速定位**：四行结构（核心论点 + 阶段 + 原型 + 致命开关）
2. **自适应视角分析**：针对项目最相关的 4–6 个视角
3. **假设映射**：排名前 3–5 个风险最高的假设，每个都配有成本最低的验证实验
4. **市场分析**：规模测算（≥2 种方法）、竞争格局、定价模型（含小而美校准）和双市场逻辑
5. **单位经济学健康检查**：收入算术、成本结构、毛利率、盈亏平衡点、自举生存检查
6. **MV-GTM**：为小团队有限营销优化的分阶段市场进入计划
7. **事前验尸 + 投资裁决**：3 个失败场景及早期预警信号 + 转型扫描 + 直接裁决

输出默认为**简体中文**，保留英文商业术语（CAC、LTV、GTM 等）。

---

## 文件结构

```
startup-idea-evaluator/
├── SKILL.zh.md                     # 主技能（7 步工作流，约 300 行）
├── references/
│   ├── gtm-playbooks.zh.md         # 7 种原型 + 团队背景说明 + 双市场策略
│   ├── market-analysis.zh.md       # 市场测算、竞争、定价叠加；委托给市场研究技能
│   └── example-output.zh.md        # 完整的 Mode B 示例（针对中国律所的 AI 合同审查 SaaS）
└── README.zh.md                    # 本文件
```

---

## 各平台使用方法

### Claude Code

**项目级**（与协作者共享）：
```bash
mkdir -p .claude/skills/references
cp SKILL.zh.md .claude/skills/startup-idea-evaluator.md
cp references/*.zh.md .claude/skills/references/
```
然后调用：
```
/startup-idea-evaluator [描述你的想法]
```

**个人技能**（所有项目）：
```bash
mkdir -p ~/.claude/skills/references
cp SKILL.zh.md ~/.claude/skills/startup-idea-evaluator.md
cp references/*.zh.md ~/.claude/skills/references/
```

**一次性内联使用**：将 `SKILL.zh.md` 的内容（去掉 YAML 前置元数据）直接粘贴到对话开头。

---

### Gemini CLI

Gemini CLI 从项目根目录读取 `GEMINI.md` 作为系统提示扩展。

```bash
# 去除 YAML 前置元数据并写入 GEMINI.md
tail -n +8 SKILL.zh.md > GEMINI.md
echo -e "\n---\n" >> GEMINI.md
cat references/gtm-playbooks.zh.md >> GEMINI.md
echo -e "\n---\n" >> GEMINI.md
cat references/market-analysis.zh.md >> GEMINI.md
```

或者在 `~/.gemini/settings.json` 中设置全局系统提示：
```json
{
  "systemPrompt": "<在此粘贴 SKILL.zh.md 内容（不含前置元数据）>"
}
```

然后：
```bash
gemini
> 我有个创业想法：[描述]
```

---

### OpenAI API / Codex / ChatGPT

**ChatGPT 自定义指令：**
1. 复制 `SKILL.zh.md` 的内容（跳过 `---` YAML 前置元数据块）
2. 设置 → 个性化 → 自定义指令 → 粘贴到“你希望 ChatGPT 如何回复？”

**API 使用：**
```python
import openai

with open("SKILL.zh.md") as f:
    raw = f.read()

# 去除 YAML 前置元数据（第一个 --- 到第二个 --- 之间的内容）
skill_body = raw.split("---", 2)[-1].strip()

# 可选：附加参考文件以丰富上下文
with open("references/gtm-playbooks.zh.md") as f:
    gtm = f.read()
with open("references/market-analysis.zh.md") as f:
    mkt = f.read()

system_prompt = f"{skill_body}\n\n---\n\n{gtm}\n\n---\n\n{mkt}"

response = openai.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": "评估这个想法：[你的想法]"}
    ]
)
```

**JS/Node.js：**
```javascript
import OpenAI from 'openai';
import { readFileSync } from 'fs';

const client = new OpenAI();

const skillBody = readFileSync('SKILL.zh.md', 'utf8').split('---').slice(2).join('---').trim();
const gtm = readFileSync('references/gtm-playbooks.zh.md', 'utf8');
const mkt = readFileSync('references/market-analysis.zh.md', 'utf8');
const systemPrompt = `${skillBody}\n\n---\n\n${gtm}\n\n---\n\n${mkt}`;

const response = await client.chat.completions.create({
  model: 'gpt-4o',
  messages: [
    { role: 'system', content: systemPrompt },
    { role: 'user', content: '评估这个想法：[你的想法]' }
  ]
});
```

---

### 任意 LLM（通用）

1. 复制 `SKILL.zh.md`（跳过 YAML 前置元数据）
2. 可选：附加两个参考文件
3. 在任何能力足够的 LLM（Claude、GPT-4、Gemini 1.5 Pro、Qwen-Max 等）中设置为系统提示
4. 包含参考资料时，最佳效果需要 32K+ 上下文窗口

---

## 覆盖默认假设

本技能默认假设：小团队（≤3 人）、中国+全球市场、有限营销、小而美偏好、JS/Python、openrouter.ai、中文输出。你可以在提示中明确覆盖这些假设：

```
# 提示中覆盖示例：
"这个团队有10人，已有B轮融资，主要面向美国市场，请用英文分析。"
"Team is 8 people, Series A funded, US market only, please analyze in English."
"我们有专职市场团队和付费广告预算。"
"We're okay with VC-scale ambition — don't default to 小而美."
```

---

## 关键设计决策

| 特性 | 设计理由 |
|------|----------|
| 致命开关优先 | 避免评估空转 —— 在其他分析之前，先找出根本性的致命风险 |
| 输出模式（快速扫描 / 投资备忘录） | 避免对输入信息不足的想法过度分析；A 模式快速给出信号，B 模式深入剖析 |
| 假设映射在市场规模之前 | 多数创始人跳过验证直接构建；这一步迫使采用最低成本测试思维 |
| 小而美校准内置于规模测算 | 对 3 人自举团队而言，VC 规模的惯性思维是错误的默认假设 |
| 双市场（中国+国际）模板 | 对每个市场单独测算，防止混淆差异巨大的机会 |
| GTM“针对本团队”的说明（每种原型） | 通用的 GTM 建议毫无用处；说明均针对 ≤3 人、无营销预算的团队定制 |
| 反模式清单 | 编码了在为小团队评估想法时最常见的错误 |
