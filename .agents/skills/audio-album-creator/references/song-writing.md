<!-- Ver 2026-07-21 11:36, by Claude Sonnet 5 -->

# Song writing kit: standalone entry contract + per-track creation kit

The methodology engine for **Module S (Song Writing)** — the skill's single most important capability, and its only capability that can run entirely on its own from a short brief. It operationalizes guide §14 (rewriting) and §15 (the seven-dimension model) into executable steps. All `§N` citations in this document refer to `references/album-creation-guide.md`.

Module S runs in **two contexts**, sharing the same craft kit below but differing in scope and default output count. **Which one applies is decided by whether this song already has a track dossier from a Module B blueprint — not by which entry point (Song Only vs. Full Album) the user typed.** A Song Only request can land in either context (see SKILL Step 0/4):

- **Standalone (no existing blueprint for this song)**: input is a short brief or story fragment, with no album framing — whether reached via a standalone Song Only request, or any other case where no Module B dossier exists for this song. Default output = **3 divergent lyric takes, each paired with its own matching Suno style, plus 3 candidate titles**. See "Standalone entry contract" below.
- **Album context (a track dossier exists — from a Full Album run's Module B fan-out, or from a Song Only request that's continuing one specific track from a prior Blueprint Only / Full Album run)**: input is the creative contract card (album-wide constitution) frozen in SKILL Step 3, plus this track's dossier. Output count follows the **tiered investment table** (unchanged from before — see "Album-context tiered investment" below), because the album already differentiates tracks by role (lead / second lead / base / interlude); a standalone single has no such role to differentiate against, so it defaults to full investment on all 3 takes instead.

These two contracts are not in tension — they're the same craft kit applied at two different scopes. **Don't apply the album's tiering discount to a genuinely standalone single, and don't apply the standalone default of "3 full takes" to a track that already has a role assigned in a blueprint** (a base track picked up one-at-a-time via Song Only is still a base track — giving it 3 full takes would blow the album's cost budget for no narrative reason).

## Standalone entry contract (no existing blueprint)

**Input**: a short brief or story fragment (a paragraph, a memory, a scene — doesn't need to be a full material pack; if the user does hand over a fuller pack, read it in full first, same spirit as guide §5's "sense-bound sourcing"), plus the minimal brief from SKILL Step 0 (language, real-person status, rough emotional direction). No material-distillation file, no 3-direction album gate, no blueprint, no contract card — those are Module B's job and are not prerequisites here. **If a blueprint and a track dossier for this song already exist, this section does not apply — use "Album-context tiered investment" below instead, even if the user's request came in through the Song Only entry point.**

**Task**: produce, in one pass —

1. **3 candidate song titles** (not tied 1:1 to the 3 lyric takes — offer titles that could fit any of them, then let the recommended pairing settle once the takes are written).
2. **3 lyric takes that genuinely diverge**, using the same divergence method as Module B's three sketches (`references/blueprint-kit.md`, "the same divergence method, applied at song grain") but scaled to one song: pick at least one axis — story core / emotional tone / stylistic leaning — and make it actually fork, not a reskin of the same take (e.g., for the same source material: "plain narrative + folk" vs. "restrained negative-space + lyrical soul" vs. "imagery-driven + synth-pop"). Each take runs the **full three-pass polish protocol** below — no discount for any of the 3, since there's no album role to grade against.
3. **3 matching Suno styles, one per take** — the style is derived from that take's own emotional register and imagery, not a shared style description reused across all 3. A take written as restrained negative-space soul should not be paired with a style card that reads like a synth-pop take's style card.
4. **Extra forging on all 3 takes** (not just a designated "lead"): the dual-track killer-line face-off and the three catchiness tests below apply to every take, because in a standalone single every take is a candidate for "the" song, not a base track that only needs to clear the pass bar.
5. **Self-evaluate and recommend one take**, with a brief pick-rationale + a short 倒字/QC note — same as the album-context brief below, but here the recommendation is a suggestion for the user to weigh against the other 2, not an irreversible narrowing (all 3 stay in the deliverable).

**Execution**: a single song does not suffer from the "one context carrying 8 songs" attention dilution that motivated per-track subagent fan-out in the album context — but writing 3 genuinely divergent takes back-to-back in one context risks the opposite failure, takes drifting toward each other instead of staying forked. **Dispatch one subagent per take** (3 in parallel), each briefed on its own divergence axis assignment (e.g. "you own the restrained/negative-space take") plus this document plus the user's brief; this mirrors the album context's per-track fan-out, just at orientation grain instead of track grain. Then the main context does the plain-reading QC pass (see SKILL Core principles) across all 3 before presenting them.

**Output naming**: `song-{title}-{model name}.md`, containing the 3 takes (lyrics + style + title + three-pass polish log + killer-line face-off + catchiness-test notes for each), the recommendation and why, and a short QC note per take (倒字 self-check, reads-through check). No `candidates-and-polish` split-file — for a single song, candidates *are* the deliverable.

## Album-context tiered investment (unchanged)

**The brief handed to each per-track subagent** (dispatched from SKILL Step 4 — whether as part of a Full Album run's fan-out to all tracks, or a Song Only request continuing just this one track from an existing blueprint):

- **Input** = the creative contract card (album-wide constitution) + this track's dossier (narrative context / anchors / golden lines / levers / throughline touchpoints) + this document + the path to `references/album-creation-guide.md` for reference. **The subagent doesn't read the full source material, but it must know the story behind this track** — the dossier's "narrative context" and "relevant golden lines" fields are its emotional anchor; the main context must fill them carefully, not just supply anchor symbols.
- **Task** = produce ① 3 candidate song titles; ② several complete lyric versions per the tiered table below (each run through the "three-pass polish protocol"; lyrics default to Mandarin — if this track's narrative beat has a strong English-language cultural flavor, the subagent may propose mixed-language or full-English lyrics with a reason, for the main context / user to confirm); ③ the Suno Style; ④ self-evaluate and pick the recommended version, with a brief pick-rationale + a short 倒字/QC note.
- **Constraints** = obey the contract card; don't invent Persona / style family / throughline; follow the SKILL's "hard writing discipline."

| Track role | Lyric versions | Three-pass polish | Style | Target | Production SOP |
|---|---|---|---|---|---|
| **Lead single** | **1 complete + dual-track killer line + 2 candidate choruses** | 3 passes on the complete version + killer-line forging | **3 (including vocal style)** | 85+ | N≥8, lock Persona, chorus Inpainting 2–5×, line-by-line 倒字 check (guide §31) |
| **Second lead** | 2 versions | 3 passes each + the three catchiness tests | **2–3 (favoring ear-catching melody/style)** | 80+ (sound-first) | **high-N rolls to land the melody**, Inpainting to tune the arrangement, lyrics clear the bar |
| **Base** | standard tier 3 versions / economy tier 1 | 3 passes each | **1 within the family** (may +1 backup) | 60+ | N=2–4, reuse Persona + style family, accept once it passes |
| **Instrumental interlude** | — | — | 1 (turn on Instrumental, leave Lyrics empty) + a structure note | — | roll several, take the warmest |

> **Base tracks don't do 3 styles**: a base track's style is already locked by the style family + Persona; forcing 3 styles either breaks album consistency or is a cosmetic tweak (wasteful). **Style is not the base track's variable — lyrics are.**

## For each lyric version/take, write out all of the following (seven dimensions, fully landed)

1. **Dimension 1, lyrics and narrative**: material anchor → imagery (express emotion through the concrete, not bluntly venting grief) → chorus hook (short, repeatable, personal image + universal emotion) → perspective (§6) → structural placement (private details into verses, deep emotion held back into the chorus).
2. **Dimension 2, emotion→lever** (§3/§18): set mode, tempo/meter, instrumentation, dynamics, vocals, and state for each value "why" it serves the emotion. The emotional arc (e.g. minor-key verse → major-key chorus) lands as in-section change in mode + dynamics.
3. **Dimensions 3–7**: style / song form and dynamic arc / rhythm / vocals / instrumentation.
4. **Suno Style field** (§21): 4–7 descriptors; **the three vocal layers (timbre + delivery + production) go first**, may add the **key** to boost consistency, name core instruments (for Chinese folk instruments use specific names like erhu/guzheng). Leave timbre to Style + Persona, and push delivery arc and instrumentation changes down to metatags — **two control levels** (see §22C for the full tag list): ① **section colon syntax** `[Chorus: full band, erhu accent, powerful vocals]` — sets the whole section's production + delivery, augments (not replaces) global Style; ② **per-line delivery tags** `[Whispered]`/`[Belted]` on their own line immediately before one lyric line — vocal delivery only, that line only. Attach Sliders (emotional song = Weirdness Safe + Style Influence Strong + Prompt Helper Off).
5. **Complete Chinese lyrics** (see the SKILL's "hard writing discipline"): put the strongest anchor in the chorus, use punctuation/line breaks for in-line breath points, don't fill every section just because the formula has one.
6. **Chinese singability / 倒字 self-check** (§13/§22): check the hook keywords and personal names one by one for zero 倒字, flag the long lines that need watching.

## Three-pass polish protocol (run on every take — standalone or album, base tracks included)

The three stages of guide §14, made executable. Do the passes **in order — never all at once** (doing them together is what makes lines stiff and tongue-twisting). Every lyric version runs all three and **keeps a brief polish log** (what each pass changed):

```
Pass 1 — narrative first (rules OFF): tell this song's emotional truth and its scenes plainly, prose-like; get the story and the personal anchor right.
          Note which verbatim golden lines this beat could land — you needn't use them all; the 1–2 that hit hardest are usually enough (pick most sense-bound + shortest/singable + most universal), keep more only if they genuinely earn their place. Ignore rhyme/meter/tidiness here.
Pass 2 — make it a lyric (prosodic shaping): section function (verse = show/setup, chorus = the point/hook), lock one rhyme category to the end,
          [dense parallel couplets in the chorus · bury couplets in verses as needed], even line length (≤10–12 chars), cut colloquial prose phrases (e.g. "你们都知道" / "我自己扛"),
          compress the hook, use stable/unstable tools per the emotion, write every chorus out in full
Pass 3 — polish + gate (word level): plain-reading FIRST (read cold, as a native listener who doesn't know your intent — every line and every adjacent pair must read through:
          a question and its answer on the same axis, no construction opened-but-never-closed, no word forced into two senses, no dangling fragment; this gate precedes all form-work, and any rhyme/character fix is a re-write to be re-read),
          then: strongest anchor on the chorus's signal spot, 倒字 self-check (zero on motif words/names), open vowels on held/high notes,
          breath points to punctuation (no bare spaces), dual-anchor the metatags; run the delete-the-adjective / negative-space / sing-along tests
```

> This protocol costs only text tokens and is the single highest-ROI fix for lyric quality. Keep the three-pass log alongside each lyric version — in album context, written into the "candidates and polish" appendix in Step 5; in standalone context, kept inline in the `song-*.md` deliverable.

## Extra forging (album lead/second lead — mandatory; standalone takes — mandatory on all 3)

Beyond the three-pass polish:

- **Dual-track killer-line face-off**: produce the core hook as **both a "minimalist, held-back version" and a "full, tidy version"**, pit them head-to-head, and pick the better — **forcing the tension to survive, preventing it from being diluted by one-way tidying** (this is exactly the switch that fixes "a good line dulled by rhyme"). **Before the three tests, the killer line must pass the plain-reading** — its punch comes from the line actually reading, so if it's a Q&A the answer must sit on the question's axis (问"疼不疼" answered by a satisfaction verdict like "我非常满意" fails — answer the *pain* axis: "不疼了" / "值了" / "无怨无悔"). Then the pick passes three tests: the **delete-the-adjectives test** (would deleting it hit harder), the **negative-space test** (did it say everything for the listener), the **sing-along test** (could someone sing it back after one listen).
- **Three catchiness tests**: the catchy test / the sing-along test / **the melodic-hook test (can the hook be hummed)**. In album context, the second lead is verified primarily by this yardstick; in standalone context, all 3 takes are.

> Boundary: **killer-line negative space is used only on the anchor's 1–2 lines, not pushed across the whole song** — full-song negative space thins out the lyrics and instead hurts catchiness.
