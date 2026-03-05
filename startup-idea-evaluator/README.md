# Startup Idea Evaluator

A best-of-both-worlds startup idea evaluation skill, synthesized from two prior versions and adapted for:
- Small AI-augmented teams (≤3 people)
- China mainland + international market context
- Limited marketing budget and experience
- 小而美 / bootstrap-first philosophy
- JS/Python + openrouter.ai tech stack preference

## What It Does

Given any startup idea — from a raw one-liner to a structured pitch — produces:

1. **Rapid Framing**: 4-line structure (thesis + stage + archetype + Kill Switch)
2. **Adaptive Lens Analysis**: 4–6 most relevant lenses, specific to the project
3. **Assumption Mapping**: Top 3–5 riskiest assumptions ranked, each with cheapest validation experiment
4. **Market Analysis**: Sizing (≥2 methods), competitive landscape, pricing model with 小而美 calibration and dual-market logic
5. **Unit Economics Sanity Check**: Revenue math, cost structure, gross margin, break-even, bootstrap survival check
6. **MV-GTM**: Phased go-to-market plan optimized for small team with limited marketing
7. **Pre-mortem + Investment Verdict**: 3 failure scenarios with early warning signals + Pivot scan + Straight Verdict

Output defaults to **Simplified Chinese** with English business terms (CAC, LTV, GTM, etc.).

---

## File Structure

```
startup-idea-evaluator/
├── skill.md                     # Main skill (7-step workflow, ~300 lines)
├── references/
│   ├── gtm-playbooks.md         # 7 archetypes + team context notes + dual-market tactics
│   ├── market-analysis.md       # Market sizing, competition, pricing overlays; delegates to market-research skill
│   └── example-output.md        # Complete Mode B sample (AI contract review SaaS for Chinese law firms)
└── README.md                    # This file
```

---

## How to Use by Platform

### Claude Code

**Project-level** (shared with collaborators):
```bash
mkdir -p .claude/skills/references
cp skill.md .claude/skills/startup-idea-evaluator.md
cp references/*.md .claude/skills/references/
```
Then invoke:
```
/startup-idea-evaluator [describe your idea]
```

**Personal skill** (all your projects):
```bash
mkdir -p ~/.claude/skills/references
cp skill.md ~/.claude/skills/startup-idea-evaluator.md
cp references/*.md ~/.claude/skills/references/
```

**One-off inline**: Paste `skill.md` content (without YAML frontmatter) directly at the start of a conversation.

---

### Gemini CLI

Gemini CLI reads `GEMINI.md` from the project root as a system-prompt extension.

```bash
# Strip YAML frontmatter and write to GEMINI.md
tail -n +8 skill.md > GEMINI.md
echo -e "\n---\n" >> GEMINI.md
cat references/gtm-playbooks.md >> GEMINI.md
echo -e "\n---\n" >> GEMINI.md
cat references/market-analysis.md >> GEMINI.md
```

Or set a global system prompt in `~/.gemini/settings.json`:
```json
{
  "systemPrompt": "<paste skill.md content here (without frontmatter)>"
}
```

Then:
```bash
gemini
> 我有个创业想法：[描述]
```

---

### OpenAI API / Codex / ChatGPT

**Custom Instructions (ChatGPT):**
1. Copy `skill.md` content (skip the `---` YAML frontmatter block)
2. Settings → Personalization → Custom Instructions → paste in "How would you like ChatGPT to respond?"

**API usage:**
```python
import openai

with open("skill.md") as f:
    raw = f.read()

# Strip YAML frontmatter (content between first two --- blocks)
skill_body = raw.split("---", 2)[-1].strip()

# Optionally append reference files for richer context
with open("references/gtm-playbooks.md") as f:
    gtm = f.read()
with open("references/market-analysis.md") as f:
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

**JS/Node.js:**
```javascript
import OpenAI from 'openai';
import { readFileSync } from 'fs';

const client = new OpenAI();

const skillBody = readFileSync('skill.md', 'utf8').split('---').slice(2).join('---').trim();
const gtm = readFileSync('references/gtm-playbooks.md', 'utf8');
const mkt = readFileSync('references/market-analysis.md', 'utf8');
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

### Any LLM (Universal)

1. Copy `skill.md` (skip YAML frontmatter)
2. Optionally append both reference files
3. Set as system prompt in any capable LLM (Claude, GPT-4, Gemini 1.5 Pro, Qwen-Max, etc.)
4. Best results with 32K+ context window when including references

---

## Overriding Default Assumptions

The skill assumes: small team (≤3), China+global context, limited marketing, 小而美 preference, JS/Python, openrouter.ai, Chinese output. Override any of these explicitly:

```
# Example overrides in your prompt:
"这个团队有10人，已有B轮融资，主要面向美国市场，请用英文分析。"
"Team is 8 people, Series A funded, US market only, please analyze in English."
"我们有专职市场团队和付费广告预算。"
"We're okay with VC-scale ambition — don't default to 小而美."
```

---

## Key Design Decisions

| Feature | Rationale |
|---------|-----------|
| Kill Switch First | Prevents analysis theater — forces identifying the existential risk before anything else |
| Output Modes (Quick Scan / Investment Memo) | Avoids over-analyzing thin inputs; Mode A gets quick signal, Mode B goes deep |
| Assumption Mapping before Market Sizing | Most founders skip validation and build first; this step forces cheapest-test thinking |
| 小而美 calibration built into sizing | VC-scale framing is wrong default for a 3-person bootstrap team |
| Dual-market (CN+international) template | Explicit sizing for each market prevents conflating very different opportunities |
| GTM "For this team" notes per archetype | Generic GTM advice is useless; notes are tailored to ≤3 people with no marketing budget |
| Anti-pattern list | Encodes the most common mistakes made when evaluating ideas for small teams |
