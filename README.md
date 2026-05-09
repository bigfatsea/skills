<!-- Ver 2026-05-09 11:16, by GPT-5 -->

# skills

Reusable AI-agent skills for business review, startup evaluation, and prompt/spec design.

This repository is structured for installation with [`npx skills`](https://www.npmjs.com/package/skills). The public GitHub source is:

```text
https://github.com/bigfatsea/skills
```

## Skills

| Skill | Use it when | What it produces |
| --- | --- | --- |
| `Master BP Review` | You have a business plan, pitch deck, memo, or similar business document and want investor-style or strategic review. Do not use it for a raw startup idea without a document. | A structured BP review using 5 context-fit master reviewers, founder response, strategic decision, and rewritten BP direction. |
| `Startup Idea Evaluator` | You want to evaluate a startup idea, early project, pivot, GTM direction, monetization logic, or whether something is worth building. | A pragmatic China/global startup assessment with kill switch, assumptions, validation plan, unit economics, GTM, and verdict. |
| `Prompt Architect` | You have a rough feature request, app idea, workflow concept, or coding brief and want a stronger implementation prompt for Claude Code. | A clarified product spec, critical technical decisions, and a precise build prompt. |

## Install

List available skills from GitHub:

```bash
npx -y skills add https://github.com/bigfatsea/skills --list
```

Install all skills from GitHub:

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill '*'
```

Install one specific skill:

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill "Startup Idea Evaluator"
```

Other valid skill names:

```text
Master BP Review
Prompt Architect
Startup Idea Evaluator
```

Install all skills to specific agents:

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill '*' -a codex -a claude-code
```

For local development from a cloned checkout:

```bash
npx -y skills add . --list
npx -y skills add . --skill '*'
```

## Repository Layout

Skills are stored in the standard discovery path:

```text
.agents/skills/
```

Current skills:

- `master-bp-review`
- `startup-idea-evaluator`
- `prompt-architect`
