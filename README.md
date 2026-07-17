<!-- Ver 2026-05-10 15:09, by GPT-5 -->

# skills

Reusable AI-agent skills for business review, startup evaluation, and prompt/spec design.

This repository is structured for installation with [`npx skills`](https://www.npmjs.com/package/skills). The public GitHub source is:

```text
https://github.com/bigfatsea/skills
```

## Skills

| Skill | Use it when | What it produces |
| --- | --- | --- |
| `master-bp-review` | You have a business plan, pitch deck, memo, or similar business document and want investor-style or strategic review. Do not use it for a raw startup idea without a document. | A structured BP review using 5 context-fit master reviewers, founder response, strategic decision, and rewritten BP direction. |
| `startup-idea-evaluator` | You want to evaluate a startup idea, early project, pivot, GTM direction, monetization logic, or whether something is worth building. | A pragmatic China/global startup assessment with kill switch, assumptions, validation plan, unit economics, GTM, and verdict. |
| `prompt-architect` | You have a rough feature request, app idea, workflow concept, or coding brief and want a stronger implementation prompt for Claude Code. | A clarified product spec, critical technical decisions, and a precise build prompt. |
| `synthesize-documents` | You have multiple drafts, reports, reviews, memos, or source documents and want one comprehensive synthesis. | A standalone synthesis that preserves consensus, minority-only points, disagreements, evidence checks, and final recommendations. |
| `ai-script` | A task needs real AI generation or retrieval via the local `ai-script` CLI: LLM (multi-provider), TTS, STT, image, music, video, web/scholar search, scraping. | Correct invocation of the right subcommand with sane defaults, timeout/retry expectations, and output-convention handling. |
| `dev-env-audit` | You want to audit a local macOS dev environment: what SDKs are installed, version-manager conflicts (pyenv+uv, nvm+fnm, rvm+rbenv), PATH drift across shell scenarios, external-SSD cache relocation status. Read-only — never installs or edits anything. | A six-section Markdown diagnosis: overall verdict, per-language status table, conflicts, cache relocation status, per-language 5-step migration plans, and execution-order advice. |

## master-bp-review

`master-bp-review` reviews an existing BP, pitch deck, memo, or business plan. It is not for raw startup idea brainstorming.

How it works:

- Reads the full business document.
- Selects exactly 5 context-fit masters from the pool below.
- Generates independent reviews, founder response, and BP rewrite direction.
- Saves a Markdown report named like `bp-review-{project-name}-{YYYYMMDD-HHMMSS}.md`.

Master pool:

| Master | Brief lens |
| --- | --- |
| Steve Jobs | Product taste, UX, brand story, and emotional connection. |
| Jason Fried | Bootstrap sustainability, calm small-team execution, and feature restraint. |
| Peter Thiel | Contrarian insight, monopoly potential, defensibility, and distribution. |
| Naval Ravikant | Leverage, specific knowledge, compounding assets, and long-term independence. |
| Y Combinator Angels | PMF, speed, early validation, founder quality, and growth evidence. |
| Rob Walling | Micro-SaaS, niche B2B, MRR, churn, ARPU, and bootstrap unit economics. |
| 张小龙（Allen Zhang） | China user behavior, restraint, trust, social mechanics, and user respect. |
| Seth Godin | Permission marketing, smallest viable audience, community, and word of mouth. |
| Kevin Kelly | 1,000 true fans, creator economy, loyal niches, and long-tail assets. |
| April Dunford | B2B positioning, category design, buyer clarity, and competitive alternatives. |
| Alex Hormozi | Offer strength, pricing, lead generation, conversion, and fulfillment economics. |
| Sahil Lavingia | Creator-first products, indie shipping, paid usage, and lightweight companies. |
| Paul Jarvis | Company-of-one thinking, intentional non-scaling, margin, and autonomy. |
| Brian Chesky | End-to-end experience, marketplace trust, community, and operational rituals. |
| Ben Horowitz | Operational reality, wartime leadership, enterprise pressure, and execution risk. |

Example prompt:

```text
Use master-bp-review to review docs/my-startup-bp.md
```

## startup-idea-evaluator

`startup-idea-evaluator` judges whether a startup idea, early project, pivot, market, or GTM path is worth pursuing. It is optimized for a <=3 person AI-augmented team with China familiarity, global optionality, no paid-ad dependency, and bootstrap-first bias.

Output modes:

- **Quick Scan**: one-sentence verdict, why it could work, why it could fail, and top 3 next actions.
- **Investment Memo**: thesis, kill switch, adaptive lenses, assumptions, validation plan, market analysis, unit economics, MV-GTM, pre-mortem, and Invest / Watch / Pass verdict.

Example prompt:

```text
Use startup-idea-evaluator: AI tool for helping Chinese exporters create product videos for overseas marketplaces.
```

## prompt-architect

`prompt-architect` turns a rough app, product, workflow, or coding brief into an implementation-ready Claude Code prompt. Use it when the goal is clear enough to build, but the request needs sharper product, technical, platform, and UX decisions.

Typical output:

- `Clarified spec`: success flow, requirements, states, constraints, non-goals, and acceptance criteria.
- `Critical tech decisions`: recommended choices, alternatives, tradeoffs, and risks.
- `Final build prompt`: a concise implementation prompt Claude Code can execute directly.
- `Assumptions / open questions`: only when needed.

Example prompt:

```text
Use prompt-architect: build a Mac menu bar tool that records short voice notes, transcribes them, and appends structured tasks to a local Markdown inbox.
```

## synthesize-documents

`synthesize-documents` merges multiple source documents into one comprehensive replacement document. It is for consolidation tasks where the output must preserve shared conclusions, minority-only points, disagreements, source structure, user-specific requirements, and evidence-based judgment instead of producing a shallow summary.

Typical workflow:

- Reads every provided document and builds a source inventory.
- Extracts shared consensus, partial consensus, minority-only content, and disagreements.
- Evaluates non-consensus points with context and external verification when needed.
- Writes a standalone synthesis that can replace the older input documents.

Example prompt:

```text
Use $synthesize-documents to merge docs/report-a.md, docs/report-b.md, and docs/report-c.md into one comprehensive Markdown synthesis.
```

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
npx -y skills add https://github.com/bigfatsea/skills --skill startup-idea-evaluator
```

Other valid skill names:

```text
master-bp-review
prompt-architect
startup-idea-evaluator
synthesize-documents
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
- `synthesize-documents`
