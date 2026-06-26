---
name: interview-methodology
description: 'Three-mode pipeline for oral history and personal-experience interviews. Mode 1 Pre-Interview: research-dimensions report + semi-structured guide. Mode 2 Transcript Organization: transcription error correction + five-type structured notes + subtext capture. Mode 3 Story Core Extraction: theme identification + arc mapping + six-angle analysis + recommended narrative angle. Trigger: "interview prep", "prepare outline", "organize transcript", "extract story", "interview analysis", "访谈准备", "整理转写", "故事提炼". Not for job interviews, market research, or when audio-album-creator already has organized source material.'
---

<!-- Ver 2026-06-26 12:43, by Claude Sonnet 4.6 -->

# Interview Methodology

Three-mode skill for the full interview pipeline: **prepare → organize → extract**. AI is the production assistant; the human interviewer always conducts the actual session.

```
Mode 1 Pre-Interview  →  Mode 2 Transcript Org  →  Mode 3 Story Extraction
     ↓                          ↓                           ↓
research report            structured notes          narrative distillation
+ interview guide          + subtext log             → feeds audio-album-creator
```

---

## Core Philosophy

- **AI supports, human interviews.** Trust-building, real-time silence management, and empathy are tacit knowledge that cannot be parameterized (Polanyi). AI role: preparation, processing, pattern recognition — never live interviewing.
- **Narrator's subjective truth, not objective fact.** Record contradictions; never reconcile them. (Portelli: oral history tells us about the *meaning* of events, not the events themselves.)
- **Never trust AI transcription directly.** Mandarin ASR WER is typically 5–15%; dialect/elderly/specialized domains can reach 30%+. Every transcript requires human verification against the original audio.
- **Interview sessions: 60–90 minutes.** Beyond 90 minutes, narrator fatigue reduces information density. Agree on duration before starting.
- **Scene over summary.** One concrete detail outweighs a hundred adjectives.
- **Ethics first, always.** Informed consent precedes every recording. Narrator retains withdrawal, pseudonym, and access-restriction rights.

---

## Mode 1 — Pre-Interview Preparation

**Trigger:** Subject identified; interview has not yet occurred.

**Input:** Subject name/pseudonym · project goal · any known background (optional)

**Output:**
1. Research Dimensions Report — 8-dimension table (`references/ethics-and-prep.md §B.3`)
2. Semi-Structured Interview Guide — topic clusters + 3–5 open questions each + `[purpose:]` annotations + 5 contingency questions; max 2 A4 pages
3. Ethics pre-checklist — consent form reminders, sensitive-area flags

Output file: `pre-interview-{subject}.md`

**Agent prompt:**
```
Task: Generate pre-interview research report and semi-structured interview guide.

Input: subject name/pseudonym + project goal + any known background

Output:
1. Research Dimensions Report (fill 8-dimension table, references/ethics-and-prep.md §B.3)
2. Semi-structured guide: topic clusters + 3–5 open questions each + [purpose:] annotations + 5 contingency questions; max 2 A4 pages
3. Ethics pre-checklist: sensitive domains flagged, consent form reminders

Constraints: Start from topic clusters, not pre-formed questions. Avoid leading questions. Flag legally/ethically sensitive areas before the interview.
```

---

## Mode 2 — Transcript Organization

**Trigger:** Interview complete; raw AI transcript needs structuring.

**Input:** Raw transcript · original audio file (required for verification) · subject background · interview type (life / project / dream / event / relationship)

**Output:**
1. Corrected transcript — 3-round SOP applied; passages marked `[verified]` / `[uncertain]` / `[inaudible]`
2. Structured notes — filled using matching template (`references/transcript-templates.md §E.3.x`)
3. Subtext capture log — nonverbal signals, pauses, avoidances, emotional shifts, contradictions
4. Follow-up question list — gaps and unresolved points

Output files: `transcript-{subject}-{date}.md` · `structured-notes-{subject}.md`

**Agent prompt:**
```
Task: Correct and structure an interview transcript.

Input: raw transcript + audio file + subject background + interview type

Output:
1. Corrected transcript (3-round SOP, references/transcript-templates.md §E.1; mark [verified]/[uncertain]/[inaudible])
2. Structured notes (template E.3.x matching interview type)
3. Subtext log (pauses, avoidances, repetitions, intensity shifts, contradictions, body language)
4. Follow-up question list

Constraints: Faithful to narrator's phrasing — do not improve their language. Mark contradictions; do not reconcile. Subtext log is a separate section, not embedded in the notes body. Never accept AI transcription without verifying uncertain passages against the original audio.
```

---

## Mode 3 — Story Core Extraction

**Trigger:** Organized notes exist; need narrative core and angle recommendation for creative use.

**Input:** Structured notes · subject background · project goal

**Output:**
1. Theme identification — five-method table (frequency / intensity / contrast / binary opposition / omission)
2. Story arc — setup / confrontation / resolution + turning points, low point, epiphany
3. Six-angle assessment — growth / relationship / conflict / era / reversal / commitment (applicability + one-sentence pitch per angle)
4. Recommended angle — reasoning: narrator's emotional peak + strongest scene material + project goal fit
5. Key scene list — concrete, sensory, specific moments for reconstruction
6. One-sentence story test: `[person] in [context] who experienced [turning point] and ultimately [change/choice]`
7. Five-question test — unique / relatable / worth-telling / credible / complete

Output file: `story-core-{subject}.md`

**Agent prompt:**
```
Task: Extract story core and recommend narrative angle from organized interview notes.

Input: structured notes + subject background + project goal

Output:
1. Theme identification (five-method table: frequency / intensity / contrast / binary opposition / omission)
2. Story arc (setup / confrontation / resolution; turning points, low point, epiphany)
3. Six-angle table (growth / relationship / conflict / era / reversal / commitment — applicability + one-sentence pitch)
4. Recommended angle + reasoning (narrator emotional peak + strongest scene material + project goal fit)
5. Key scene list (concrete, sensory, timestamped where possible)
6. One-sentence story test for recommended angle
7. Five-question test verdict (unique / relatable / worth-telling / credible / complete)

Constraints: Let material surface the angle — do not impose a framework. Emotional intensity > narrative tidiness. Mark each angle: applicable / marginal / not applicable (with evidence).
```

---

## Ethics — Always Applies

| Step | Action | Timing |
|---|---|---|
| 1 | Prepare project description + recording consent form + release form | Before first contact |
| 2 | Walk through documents at pre-interview; verbal consent | Pre-interview meeting |
| 3 | Verbal on-record consent, captured in recording | Opening of every session |
| 4 | Sign release form (rights assignment, publication scope) | After interview is complete |

Run the full ethics self-check (`references/ethics-and-prep.md §A.6`) before every recording session.

---

## Downstream → audio-album-creator

- **Feeds Step 1** (Ingest & Distill): `structured-notes-{subject}.md` + `story-core-{subject}.md` replace raw audio/text — album creator receives pre-digested material, reducing Step 1 effort and improving anchor precision
- **Feeds Step 2** (3 creative directions): six-angle assessment maps to three sketch directions; recommended angle seeds the "recommended" sketch
- **Feeds Step 3** (Album Blueprint): one-sentence story test becomes the blueprint concept; key scene list populates the sense-bound anchor pool

Reference `story-core-{subject}.md` in Step 0 source material. Album creator does not need to re-read the raw transcript.

---

## References — Progressive Disclosure

| File | When to read |
|---|---|
| `references/ethics-and-prep.md` | Mode 1: full consent process, research dimensions table, outline method, sample outline |
| `references/interview-execution.md` | Advising on interview conduct: recording protocol, active listening, S.O.C.I.A.L., special scenarios, follow-up triggers, tools, interviewer growth |
| `references/transcript-templates.md` | Mode 2: 3-round correction SOP, all 5 templates, subtext capture table |
| `references/story-extraction.md` | Mode 3: 5-method theme extraction, arc identification, 6-angle table, one-sentence test, 5-question test |
