<!-- Ver 2026-07-18 20:00, by Claude Sonnet 5 -->

# skills

Reusable AI-agent skills covering business review, startup evaluation, prompt/spec design, content creation, and local dev tooling.

This repository is structured for installation with [`npx skills`](https://www.npmjs.com/package/skills). The public GitHub source is:

```text
https://github.com/bigfatsea/skills
```

## Skills

Each skill's `SKILL.md` is the source of truth for triggers, workflow, and output format. This table is intentionally a thin index — see `.agents/skills/<name>/SKILL.md` for full detail instead of looking for it here.

| Skill | Use it when |
| --- | --- |
| `master-bp-review` | You have a business plan, pitch deck, or memo (not a raw idea) and want investor-style/strategic review from multiple lenses. |
| `startup-idea-evaluator` | You want a startup idea, pivot, GTM direction, or monetization logic judged for viability. |
| `prompt-architect` | You have a rough feature/app/coding brief and want it turned into an implementation-ready Claude Code prompt. |
| `synthesize-documents` | You have multiple drafts/reports/memos and want one comprehensive synthesis that preserves disagreements and minority points. |
| `ai-script` | A task needs real AI generation/retrieval via the local `ai-script` CLI: LLM, TTS, STT, image, music, video, web/scholar search, scraping. |
| `dev-env-audit` | You want a read-only audit of a local macOS dev environment: SDK installs, version-manager conflicts, PATH drift, cache relocation. |
| `lobster-agent-creator` | You want to scaffold the IDENTITY/SOUL persona pair for a new OpenClaw/LobsterAI agent. Create-only. |
| `interview-methodology` | You're prepping an interview, organizing a transcript, or extracting a story core from oral-history material. |
| `audio-album-creator` | You have source material (audio/text/photos) for a person or life experience and want a production-ready original album plan. |
| `skill-creator` | You want to create, edit, or evaluate a Claude Code skill (including the ones in this repo). |

## Install

List available skills from GitHub:

```bash
npx -y skills add https://github.com/bigfatsea/skills --list
```

Install all skills from GitHub:

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill '*'
```

Install one specific skill (name must match a directory under `.agents/skills/`):

```bash
npx -y skills add https://github.com/bigfatsea/skills --skill startup-idea-evaluator
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

Skills are stored in the standard discovery path, one directory per skill, each with its own `SKILL.md`:

```text
.agents/skills/<skill-name>/SKILL.md
```

The skill list above is generated from that directory — run `ls .agents/skills` for the current, authoritative set instead of trusting a hardcoded list here.
