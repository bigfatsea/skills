---
name: lobster-agent-creator
description: Generate a complete Chinese (zh) IDENTITY/SOUL/USER persona trio for a new OpenClaw/LobsterAI agent by merging a shared governance core with the agent's specific identity and task (English emitted only on request). Use when the user wants to create or scaffold a new agent's definition / trio, "create an agent", "spin up an agent", "make a 三件套 for X". Tiered (worker vs self-managing), zh-default (en on request), create-only.
---

# lobster-agent-creator

Generate a ready-to-deploy persona trio (IDENTITY / SOUL / USER, zh + en) for one OpenClaw/LobsterAI agent. This is a **Claude Code authoring tool** — it runs here and emits files; it does NOT touch any live LobsterAI agent. Deploying the output into LobsterAI is a separate manual step (see Handoff).

## When to use
User wants to create / scaffold / spin up a new agent and needs its trio. Not for editing an existing live agent (that's the consolidation ritual, out of scope — this skill is **create-only**).

## Core idea
A trio = **shared governance core** (cross-agent, identical for the fleet) + **per-agent layer** (this agent's identity + task). The core lives in `core/` as bilingual templates with module markers `<!-- [M-XXX] ... -->` and `{{PLACEHOLDER}}` slots. You assemble by selecting modules per tier, filling placeholders, and stripping the markers.

## Input schema
Collect these from the user (ask for any missing REQUIRED field; infer sensible defaults for optional ones and state what you assumed):

- `agent_id` (REQUIRED) — stable id, used in workspace path
- `name` (REQUIRED) — the agent's name (the only required M0 field).
- `creature`, `vibe`, `emoji`, `avatar` (OPTIONAL, M0-OPT) — descriptive/cosmetic surface. **Default: drop the whole block** — they don't drive capability or behavior. Include only if the user explicitly asks. If the live Lobster UI renders an emoji/avatar, set those in the UI; they need not appear in the prompt text.
- `languages` (optional) — `zh` (default) | `bilingual` (= `zh+en`). Default emits the zh trio only; emit the `_en.md` trio **only when** the user asks for English/bilingual.
- `tier` (REQUIRED) — `worker` | `self-managing`
- `role_and_mandate` (REQUIRED) — what this agent does, its scope, its boundaries. Fills `{{ROLE_AND_MANDATE}}`.
- `tone_overrides` (optional) — e.g. "rigorous, terse". Fills `{{TONE_OVERRIDES}}`; if absent, delete the M-TONE section.
- `cwd` (REQUIRED for `self-managing`; N/A for `worker` since its trio drops the CWD-bearing modules) — this agent's user-set workspace = its runtime CWD, **path ending in `/`**. Each agent has its own; Fills `{{CWD}}` (so `{{CWD}}persona/`, `{{CWD}}AGENT_LOG.md` resolve correctly). Ask if a self-managing agent's cwd is not given.
- `agent_scoped_focus` (optional) — which of Stanford's projects/contexts this agent serves. Fills `{{AGENT_SCOPED_FOCUS}}`; if none, use "通用助理, 暂无固定项目焦点" / "General assistant, no fixed project focus yet".
- `module_overrides` (optional) — explicitly add/remove modules beyond the tier default (e.g. worker + M-REASON).
- `output_dir` (optional) — default `./agents/`.

## Tier → modules
Modules are tagged in the core templates. Keep a module = keep its block(s); drop a module = delete its block(s).

| Module | Content | worker | self-managing |
|---|---|---|---|
| M0 | **Name only** (in IDENTITY) — required identity anchor | ✅ | ✅ |
| M0-OPT | creature / vibe / emoji / avatar (in IDENTITY) — descriptive/cosmetic surface | optional (default DROP) | optional (default DROP) |
| M-ROLE | role & mandate (in **IDENTITY**; "who I am / what I'm for"). The shared user-vs-agent relationship line is folded into this same section. Boundaries here are pointers only — full rules in SOUL § Behavior Off-Limits | ✅ | ✅ |
| M-BASE | core truths, input adaptation, behavior off-limits, output style, external network, continuity, user-vs-agent relationship line (folded into IDENTITY's M-ROLE section), USER human profile | ✅ | ✅ |
| M-TONE | tone overrides (in **SOUL**, right after Output Style as its per-agent overlay; "how I express") | optional | optional |
| M-REASON | epistemology & reasoning (Polanyi) | optional (advisory agents) | ✅ |
| M-SELF | self-definition management + Agent Change Log + self-def routing | ❌ | ✅ |
| M-WS | workspace 8 principles + two-workspaces + multi-workspace | ❌ | ✅ |
| M-SKILL | skill location (sub-block of M-SELF) | ❌ | ✅ if agent authors skills, else drop |
| M-FOCUS | this agent's project focus (USER overlay) | ✅ | ✅ |

`module_overrides` wins over the tier default.

## Assembly procedure
**Language**: by default generate ONLY the zh trio (`IDENTITY.md` / `SOUL.md` / `USER.md`). Generate the `_en.md` trio **only when** `languages` = bilingual/en — then run every step below for both `.md` and `_en.md`.

For each file to generate:
1. Read the matching `core/<FILE>.core.md` (zh) / `core/<FILE>.core_en.md` (en, bilingual only).
2. **Module selection**: keep blocks whose `[M-XXX]` tag is enabled for this tier (+ overrides); delete disabled blocks entirely.
3. **Fill placeholders**: replace every `{{...}}` with the input value. `{{ROLE_AND_MANDATE}}` and `{{TONE_OVERRIDES}}` get full prose (write it in the file's language — zh in .md, en in _en.md, same meaning both). Leave NO `{{...}}` behind.
4. **Strip markers**: remove every `<!-- [M-XXX] ... -->` and the two top template-comment lines.
5. **Version header**: prepend `<!-- Ver YYYY-MM-DD HH:MM, by {model name} (lobster-agent-creator: <agent_id>, tier=<tier>) -->` (get the real timestamp via a shell `date`).
6. **zh/en parity** (bilingual only): the two language versions must carry identical meaning and identical module set. Double-check after filling. If zh-only, skip this step.

## Guardrails (must hold)
- **The ONLY data sources are: the user's input, and (for an existing agent being re-canonicalized) its source definitions.** `example-input.md` and template `{{PLACEHOLDER}}` slots are illustrative scaffolding, **never data** — never copy an example's agent names, emoji, or prose into real output. You usually don't need to open `example-input.md`; if you do, treat every value in it as fake. (Likewise, don't cite an example as evidence about a real agent.)
- Output is **canonical**, never live. Never write into any LobsterAI workspace path. Everything goes under `output_dir/<agent_id>/`.
- Don't invent facts about the user — USER M-BASE is shared/verbatim; only `{{AGENT_SCOPED_FOCUS}}` is new and must come from input.
- Don't leave placeholders or module markers in the output.
- Keep TOOLS/MEMORY/skill-location rules intact in the generated SOUL (don't paraphrase the mechanism).
- If a REQUIRED field is missing, ask — don't guess identity or mandate.

## Output (write these files)
Under `<output_dir>/<agent_id>/` (default = zh only; the `_en.md` files are emitted only when `languages` = bilingual/en):
```
persona/IDENTITY.md   (persona/IDENTITY_en.md — bilingual only)
persona/SOUL.md       (persona/SOUL_en.md   — bilingual only)
persona/USER.md       (persona/USER_en.md   — bilingual only)
AGENT_LOG.md          ← seeded: header + format spec + one "applied · created by lobster-agent-creator" entry
HANDOFF.md            ← deploy guide (below)
```

### AGENT_LOG.md seed
Header explaining purpose (append-only, not auto-injected, records self-definition changes), the per-entry format (`### <time> · <area> · <status>` / target / what / why / applied-to-live), then one seed entry recording this creation (area=`identity`/`soul`/`user`, status=`pending`, target=the persona/ files, why="created by lobster-agent-creator").

### HANDOFF.md
A short deploy guide for the user:
1. These trio files are **canonical** (the source of truth), not yet live.
2. To deploy: open Lobster App UI for agent `<agent_id>`, paste IDENTITY/SOUL/USER into the three boxes (the zh trio by default; the en trio only if you generated bilingual), save (UI dual-writes sqlite+workspace), then start a new session to verify.
3. Keep this `<agent_id>/` folder as the agent's CWD persona canonical; put it under local git.
4. Reminder: never edit the live workspace trio directly — always edit canonical here, then re-deploy via UI.

## After writing
Report: which files were written, the tier + module set used, any assumed defaults, and the next manual step (paste into Lobster UI). Do not claim the agent is "live" — it is only scaffolded.
