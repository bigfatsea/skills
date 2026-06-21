<!-- CORE TEMPLATE · USER · en · same human Stanford, shared across agents; {{AGENT_SCOPED_FOCUS}} is per-agent overlay. Assembly rules in ../SKILL.md -->
# USER.md — About the User

<!-- [M-BASE] all agents (shared human profile, usually kept verbatim) -->
- **Name:** Stanford
- **Timezone:** Asia/Shanghai

## Professional Background
- Engineering background; has managed R&D teams of dozens, done mid-level management
- Core tech stack: big data / search engines / text analysis / BI / web
- AI capabilities (since 2023): LLM / Agent / Context Engineering / Harness / Langchain / Codex / Claude / OpenClaw / Hermes — full stack
- Has actually shipped: data analysis, investment evaluation, TTS, audio dramas, fiction, interactive drama, real-time conversation systems
- Gaps: native app development / WeChat mini-program frontend / complex frontends / marketing

## Philosophy (Core)
- **First Principles** — don't optimize best practices, rebuild from underlying constraints
- **MVP-first** — ship first, iterate after
- **Bootstrap / Ramen-profitable** — avoid fundraising unless truly necessary
- **Niche > VC-scale** — consider VC only when the business genuinely requires scale
- **PLG, organic, community-driven, zero paid ads** — no paid-growth budget
- **Solve by eliminating, not by branching** — redesign to make edge cases disappear
- **Pragmatism** — simple and maintainable wins
- **Conduct impact assessments** — evaluate before any change

## Operating Style
- Decision-maker: give options + analysis, then wait for his choice
- Asks more questions than gives instructions
- Sensitive about things being overwritten or synced without consent — dislikes "being sync'd over"
- Particularly annoyed when an agent fakes that it remembered something
- Frequently tests agent behavior (asks "who are you?" etc.)
- Reads agent reports closely; wants raw data, timestamps, and sources
- Oral / voice-input habit (Feishu DMs are often voice-typed — expect redundancy and transcription errors; agent behavior in SOUL § Input Adaptation)

## Hard Output Formatting
- No emoji (unless explicitly requested)
- Think in English, default output in Chinese
- English for code / comments / logs / git commits / business terms (CAC, LTV, GTM)
- Every generated file gets a version header: `// Ver YYYY-MM-DD HH:MM, by {model name}`
- When saving markdown files, include model name in the filename (unless user specifies otherwise)
- Don't convert quote styles — preserve straight `'` or smart `'"` exactly as-is
- Use `git mv` for renames/moves to preserve commit history

## Applying Michael Polanyi's Tacit Knowledge
Stanford prefers **judgment and experience** over raw data alone. When a conversation or proposal is **primarily experience-based or pattern-recognition-driven**, say so directly — don't pad it with pseudo-data or fake metrics. Use Michael Polanyi's "we know more than we can tell" as the underlying epistemological frame.

(For agent behavior rules, see SOUL.md § Epistemology & Reasoning)

<!-- [M-FOCUS] per-agent: which of Stanford's projects/contexts this agent serves. If none, use "General assistant, no fixed project focus yet" -->
## This Agent's Focus
{{AGENT_SCOPED_FOCUS}}
