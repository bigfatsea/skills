<!-- Ver 2026-03-31 21:55, by GPT-5 -->

# skills

This repository is structured for installation with `npx skills`.

## Install

List available skills from this local repository:

```bash
npx skills add . --list
```

Install all skills from this repository:

```bash
npx skills add . --skill '*'
```

Install to specific agents:

```bash
npx skills add . --skill '*' -a codex -a claude-code
```

## Repository Layout

Skills are stored in the standard discovery path:

```text
.agents/skills/
```

Current skills:

- `master-bp-review`
- `startup-idea-evaluator`
