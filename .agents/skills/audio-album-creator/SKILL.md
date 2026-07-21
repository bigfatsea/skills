---
name: audio-album-creator
description: "Turn a creative brief or source material (audio / text / photos) into original song and album assets: write a single song's lyrics, Suno-ready style, and title (3 divergent lyric takes, each paired with a matching style); design an album-level proposal — theme, narrative arc, track-by-track story/style outline, instrumental/transition placement — without drafting full lyrics; and design 1:1 cover art (3 divergent styles) for an album or a single track, with prompts ready for image generation. Use any of the three standalone, or run them end-to-end for a complete production-ready album plan. Use when the user wants to write a song, turn raw material into an album plan, design an album's overall proposal, or design cover/CD art for a song or album — including life/memorial albums, Amber Ark-style custom albums, or narrative albums for close family, a partner, a child, or a team/company. The user names which source files to use this time, if any. Not for polishing already-written lyrics, pure music-theory Q&A, or generic lyric-writing with no creative brief or narrative material."
---

<!-- Ver 2026-07-21 11:49, by Claude Sonnet 5 -->

# Audio Album Creator

Read and understand a user-supplied pack of source material (audio, text, photos, or any mix) — or just a short creative brief — distill its essence, then run a **simple but effective** pipeline to produce original, production-ready music assets: a single song, an album-level proposal, cover art, or a complete album that chains all three.

The engine behind this method is `references/album-creation-guide.md` (the Album Creation Guide — all `guide §N` citations in this document refer to it); the Full Album entry's output structure follows `references/album-plan-template.md` (a pure skeleton template — section headings and placeholders only, with no story content or stylistic bias, so it can't contaminate the creation of different themes).

## Core principles (these drive every creative trade-off)

- **One lead + one second lead (two singles)**: a whole album (typically 6–8 tracks) carries **two singles** that bear the two different forces that "move the customer." The **lead single (主打)** — chosen by narrative, usually the throughline-resolving closer — is excellent in both lyrics and music, carries the emotional anchor, and is the breaking-point moment that "makes the customer cry" (QC ≥ 9/10, 85+). The **second lead (副主打)** — chosen by whichever track is most ear-catching in melody/style — aims first at "sounds great on the first listen," with lyrics that only need to clear the bar (80+, sound-first). The remaining "base tracks (底座)" hold the pass line (≥ 7/10, 60+). **Why two**: being catchy is what wins first impressions (the customer's gut reaction when choosing the album), and being moving is what drives retention (making the customer feel understood) — splitting these two peaks across two tracks is safer than betting everything on one.
- **Two-layer quality model (each track's pass line and ceiling)**: the **threshold layer** (every track must pass) = melodically pleasant, smooth, singable, easy to sing along to, no 倒字 (tonal mismatch — a character whose tone contour fights the melody so it's misheard as another word), **it reads through** (the plain-reading gate — every line and every adjacent pair reads in plain Chinese; see Prosody below), the story checks out, not maudlin. The **anchor layer** (required for the lead single — 1–2 spots; optional for the second lead) = the emotional moment that makes the customer feel "this is about me." **Metrical tidiness (工整) is a means in service of "catchy and pleasant," not an end — when over-tidiness hurts natural flow, pleasant wins.** **The three-pass lyric polish runs on every track**: lyrics are pure text, iteration is nearly free — the three-pass protocol applies to every track including base tracks (see Step 4); singles get additional forging beyond the three passes, base tracks accept once they pass the bar.
- **The 60-point commercial standard**: share-with-friends quality, not publication quality. Outside the two singles, don't chase artistic height — chase "the customer feels it was worth it." **This tiering is an album-internal discount** — a standalone single made via Module S's independent entry has no "outside the two singles" to discount against, so it holds every take to the lead-single bar (see Step 4).
- **Prosody (form matches meaning) is the first principle**: lyrics, music, voice, and production — all four layers serve one emotional intent. Paired with two underlying principles (guide §2): **signal over noise** (write only what the model can parse into sound, and put the strongest signal in the chorus) + **layered control** (put each intent on its most reliable layer: global sound → Style; section-level change → metatag; in-line breath points → punctuation and line breaks). The "hard writing discipline" below is mostly corollaries of these two. **There are no rules, only tools — when a discipline fights the emotion, return to Prosody rather than bolt on a new rule** (guide §2); abstract the underlying signifier instead of stacking "if X then Y" rules. **And meaning must hold before form can serve it** — Prosody makes form serve meaning, but only on a line that actually reads. So the first gate on every line is the **plain-reading (裸读)**: read it cold, as a native listener who doesn't know what you meant. Every word opens a semantic expectation — a question expects an answer on the *same axis*, a construction's first half expects its matching close, a word in a parallel slot locks to one sense — and the next line must honor it. One failure wears many faces: an answer off the question's axis (问"疼不疼"答"非常满意"), a construction opened but never closed ("先是凉的" with no "后"), one word forced into two clashing senses ("走" as *leave* beside "走" as *elapse*), a dangling fragment ("做到了的"). **Reads-through is a threshold, ahead of all form-work** — no tidiness, rhyme, real-quote authenticity, or negative space redeems a line that doesn't read. Corollary: **any form-fix is a re-write** — changing a rhyme or swapping a character can silently flip the sense ("过"→"走" locks the rhyme but changes the meaning), so re-run the plain-reading on whatever you touched, never assuming "I only moved the form."
- **Sense-bound sourcing**: a song or album's soul is the **personal anchors** caught from the source material (specific objects, smells, catchphrases, scenes, key events), not abstract sentiment. The more specific, the more the listener feels "this song is about me." This holds at any scale — one song's brief or an album's full material pack.
- **Track count is a beats budget, diagnosed from the story, not a slot count to fill**: 6–8 tracks is the recommended default (lean 6 for a short/single-facet story, 8 for a long/eventful one) — 5 or 9–10 stay acceptable when the material's own beat count clearly calls for it; don't drift further without a reason. What matters more than the number is the **arc's shape**, diagnosed from the material before anything is drafted (guide §5): a classic rising-action arc (clear external conflict/turning point) is only one shape among several — a spiral/introspective arc (every track circles the same core wound from a different facet), a gradual "no-climax" arc (an unremarkable, quietly-accumulating life — guide §5's example), and a fragmented/poetic collage are equally valid, each with its own track-count feel and its own curve (guide §34). **Never manufacture a climax the story doesn't have** — pick the shape the material actually has, then let the count and curve follow it. (This principle applies to Module B / album-scale work; a standalone song has no track count to diagnose.)
- **A real person means ethics**: if the subject is a real person, handle them with dignity; abstract away or cut sensitive content (politics / illness / the deceased / privacy) per guide §27; before delivering the finished work, remind the family to confirm — regardless of whether the deliverable is a full album, a single song, or just cover art.
- **Cover art is Prosody at the visual layer**: whether for an album or a single track, the cover shares a source with the lyric/music/voice/production work — subject imagery, color, typography, and composition all obey the same emotional intent, reusing the throughline imagery (album context) or the song's own imagery (song context) + strongest personal anchor + emotional tone + style family + Persona character, so "the cover looks like the music sounds." Produce **3 genuinely divergent styles** in one pass (echoing the three-sketch spirit of Step 2); details in `references/cover-design.md` and guide §36.
- **Delivery must be executable (Production Handoff)**: what Module B/S produce is a narrative "blueprint" or "take," but the **executable recipe** actually needed to roll songs / generate covers (each track's Style/Exclude/Sliders/full lyrics/roll SOP, the cover-gen command, the post-roll acceptance items) — if it stays scattered across a long document's track sections, the user still has to go back and re-extract it track by track. That "assembly grunt-work" is the skill's job to prepare once, at handoff (Full Album entry — see Step 9; scaled down to a single copy-paste block for the Song Only / Cover Only entries, see their exit notes in Step 4/6). **Suno rolling stays manual** (a physical limit — no stable official API), and no tool can press "generate" for the user; but "prep it down to copy-paste / one-line image gen" is squarely the skill's job.

## Workflow

This is a **human-run** skill, not an end-to-end fully automated one. It has **three modules**, each usable on its own or chained into a full production:

- **Module B — Album Blueprint** (Step 1–3): from a material pack or a long story, design the album-level proposal — concept, arc, throughline, Persona, track-by-track story/style/role outline, instrumental/transition placement. Stops short of full lyrics or a final Style string for any track.
- **Module S — Song Writing** (Step 4): from a short brief, a story fragment, or a track dossier handed down from Module B, write one song's title, lyrics, and Suno style. **This is the skill's core capability** — see Step 4 for how its output scales with context.
- **Module C — Cover Design** (Step 6): from an album, a song, or a plain brief, design 3 divergent 1:1 cover concepts with generation-ready prompts, and optionally render them via `ai-script image`.

**Four entry points (decided at Step 0)** determine which modules run and in what order:

- **Full Album**: Module B → Module S (fan-out per track) → stitch → Module C → QA → summary → handoff — Step 1 through Step 10, the original end-to-end pipeline. Within this entry, output escalates in three tiers: **Tier 1 pick the direction (Step 2) → Tier 2 lock the blueprint and contract (Step 3) → Tier 3 create track by track (Step 4 onward)**.
- **Blueprint Only**: Module B alone, stopping at Step 3 with the album proposal as the deliverable.
- **Song Only**: Module S alone (Step 4) — standalone and skipping all album machinery if there's no existing blueprint for this song, or scoped to just this one track's role if it's continuing a prior Blueprint Only / Full Album run (see Step 4).
- **Cover Only**: Module C alone (Step 6), fed by an existing blueprint, an existing song, or a fresh brief.

**Two run modes (confirm at Step 0), orthogonal to the entry point above**:

- **Interactive mode (default)**: within Module B, 1 mandatory gate (Step 2, creative direction) + 1 optional gate (Step 3, album name / lead + second lead / track order confirmation). **Track-by-track creation (Step 4) is not interrupted.** Module S's standalone entry has no narrowing gate of its own — all 3 takes are always delivered, interactive or auto, since there's no per-candidate choice for the skill to make on the user's behalf.
- **Auto mode**: every gate auto-picks the "most recommended," runs straight through, and hands over a report at the end.

**Fan-out to subagents happens at two grains**: in album context, Step 4 **dispatches one independent subagent per track** (cures the attention dilution of "one long context carrying 8 songs"), relying on the creative contract card frozen in Step 3 to preserve album-level consistency. In Module S's standalone entry, Step 4 **dispatches one subagent per lyric take** (3 in parallel) instead, for the analogous reason — writing 3 genuinely divergent takes in one context risks them drifting toward each other. Either way, **each subagent's "pick-best-from-multiple-lyric-versions" is its own self-evaluation; neither run mode feeds it back to the user for a per-candidate choice** (avoiding choice explosion): in album context the user re-picks by hand from the "candidates and polish" appendix if they want changes; in Module S's standalone entry all 3 takes are delivered anyway, so there's no separate appendix to re-pick from — the deliverable *is* the candidate set.

**Full Album entry** produces standalone reports (a creation summary + a QA report) plus one **ready-to-execute "Production Handoff sheet"** (Suno roll recipes + cover-gen commands + post-roll acceptance, see Step 9). **Blueprint Only / Song Only / Cover Only entries** each produce a single self-contained deliverable file plus a short brief on what to do next — no separate QA report, creation summary, or handoff sheet (see each module's exit note in Step 3/4/6). **Whether to rework is the user's call; the skill itself does no automatic rework, in any entry.**

For non-trivial jobs (lots of material, unclear scope — typically the Full Album or Blueprint Only entries), first create `_album_plan.md` in the working directory to record task breakdown and progress, and clean it up when done.

### Step 0: Determine the entry point and input (before anything else)

1. **Determine the entry point** — read what the user is actually asking for; only ask if genuinely ambiguous (don't add a confirmation step the request doesn't need):
   - **Full Album**: the user wants a complete album from a material pack or a long story ("make an album for…", "turn this into an album"). Runs Module B → Module S (fan-out per track) → stitch/QA/summary/handoff.
   - **Blueprint Only**: the user wants the album-level proposal without any song's actual lyrics yet ("design the album", "plan out the tracklist first", "don't write lyrics yet, just the overall shape"). Runs Module B alone.
   - **Song Only**: the user wants a single song, in one of two shapes — (a) **standalone**: a short brief or story fragment, no album framing ("write me a song about…"), skipping all album machinery entirely — no material-distillation file, no 3-direction gate, no blueprint, no contract card; or (b) **from an existing blueprint**: continuing one specific track from a prior Blueprint Only / Full Album run ("now write track 3"), using that track's role and dossier already frozen in the contract card. These two produce genuinely different output — see Step 4.
   - **Cover Only**: the user wants cover art for an existing album, an existing song, or a fresh brief ("design covers for this album/song", "just show me some cover directions"). Runs Module C alone.

   A **Song Only** or **Cover Only** run can pick up where a prior **Blueprint Only** or **Full Album** run left off: if an `album-blueprint-*.md` or a finished album/song file exists in the working directory, or was produced earlier in this conversation, treat it as available input and read it directly — don't re-run Module B just because the entry point changed. This holds across sessions too: a file path handed over cold, with no prior conversation, is a valid way to start Module S or Module C.

2. **Confirm the material**, scaled to the entry point:
   - **Full Album / Blueprint Only**: as before — the user names which files to use this time; confirm each path and type (audio / text / image / video) one by one.
   - **Song Only / Cover Only**: if the input is already a short brief or story fragment, confirm just what's given — don't demand a full material pack. If the user does hand over a fuller pack for a single song or a single cover, read it in full (same spirit as Step 1) rather than skipping ingestion.
3. **Determine the working directory** (a fixed rule, unaffected by entry point):
   - If all material is **inside one folder** → the working directory = that folder, and all intermediate results and final outputs are stored there.
   - If the material is **scattered across locations**, or the entry is **Song Only / Cover Only with no file material at all** (a plain-text brief) → create a subfolder under the **current directory**, named by the **project name** (the subject's name, the album theme, or the song title once known, e.g. `{subject}-album/` or `{song-title}/`), and store all outputs there.
4. **Confirm the creative brief** (if missing, ask briefly — don't guess): who the subject is, what occasion, what core emotion is wanted, who's paying / who's listening, language (**Mandarin by default**; if the material's story has a strong modern/Western/English-language cultural background, 1–2 English-lyric or mixed-language tracks may be added, driven by the material not by the creator's preference — unless the user explicitly specifies an English-track count at input), **whether it's a real person** (this sets the strength of ethics and sensitive handling, in any entry).
5. **Confirm the run mode**:
   - **Interactive mode (default)**: Step 2 must stop, Step 3 may stop, track-by-track is uninterrupted. Applies to **Full Album / Blueprint Only**.
   - **Auto mode**: every gate auto-picks the most recommended and runs through continuously.
   - **For Full Album / Blueprint Only, and for Song Only when it's continuing a specific track from an existing blueprint**, also confirm the **production tier** (affects Step 4 cost): **standard tier** (base tracks also get 3 lyric versions) / **economy tier** (base tracks get only 1 lyric version × 3 passes; only the two singles get the full treatment). Interactive mode defaults to standard tier, auto mode defaults to economy tier; the user can override. **A standalone Song Only run (no existing blueprint) has no production tier** — it always produces the full 3 divergent takes (see Step 4), since there's no album role to grade the discount against.

### Step 1 [Module B] Ingest & distill the material — Full Album / Blueprint Only

This skill runs on a **multimodal model** by default: it reads and understands text / image / audio / video material directly, with no transcoding or transcription pipeline.

- **Text / images**: read in full. For images, extract era, scene, relationships, mood, and any **objects** usable as personal anchors.
- **Audio / video**: hand directly to the model to understand — catch the spoken content, tone and mood, environmental cues.
- **If the current model or harness cannot ingest a material type** (e.g. audio isn't supported): don't get stuck and don't fabricate content — skip that material and record the gap (see `references/blueprint-kit.md` §1 for exactly what to record and where).

After distilling, **write an intermediate file** `material-distillation-{subject}.md` into the working directory. **The full field list this file must contain, and the "exhaust, don't pre-filter" extraction principle, are in `references/blueprint-kit.md` §1** — read it before drafting. **Step 1 is the only stage in the whole pipeline that reads the full input** — information lost here is lost permanently.

### Step 2 [Module B · Tier 1 · mandatory gate] Propose 3 draft directions, ask the user to choose

Based on the Step 1 distillation, offer **3 fundamentally different draft directions** for the user to decide — genuinely diverging (determined by the material's content, not reskins) in stylistic leaning / emotional tone / story core. **The full method for constructing the three sketches — what each must contain, the divergence dimensions, the "sketch, don't blueprint" granularity rule — is in `references/blueprint-kit.md` §2.**

**Mark the most recommended one and spell out why** (why it best fits this material and has the most "breaking-point" potential).

- **Interactive mode**: use `AskUserQuestion` to present the three sketches as options (the system auto-adds "Other" for custom directions). The user can: take the recommendation / pick another / customize / pick one and add notes.
- **Auto mode**: adopt the most recommended sketch directly, no interruption.

Record "three sketches + recommendation rationale + final choice and notes" into the intermediate file `creative-direction-{subject}.md`. **Once chosen, proceed to Step 3.**

### Step 3 [Module B · Tier 2 · optional gate] Album-level coordination (Album Blueprint) + freeze the creative contract card

Read §34 (album coordination), §24 (consistency), Part I §3 (emotion→lever) of `references/album-creation-guide.md`, and cross-reference template §0. **Expand along the direction the user chose** and write into the intermediate file `album-blueprint.md`:

1. **Concept and emotional arc**: state in one line what kind of album this is, **and confirm the arc's shape** (guide §5 — classic rising-action, spiral-introspective, gradual no-climax, fragmented, or another shape the material genuinely fits); the emotional arc — in that shape, not forced into another — is the track order.
2. **Persona lock**: describe the lead voice with the **three vocal layers** (timbre texture + delivery + production, guide §15.4), and set a backup voice if needed (e.g. a contrasting voice that enters on one track for a duet or a hand-off). **Artist names are for internal reference only and never enter a prompt** (translate them into the three-layer descriptors). You may set 1–2 **keys** for the whole album to rein in drift.
3. **Thematic motif**: one throughline image running through the whole album + one one-line subplot image + one melodic motif that recurs in the instrumental / at closings.
4. **Style family**: the sonic starting point and default baseline for the album — individual tracks may actively deviate per their narrative beat; this is design, not damage (§24/§34). The blueprint should assign each track its **actual genre slot** (the genre/era-color that track will actually use), not merely say "follows the family."
5. **Tracklist arrangement table** (6–8 tracks by default per the diagnosed arc shape — fewer/more if the material's real beat count calls for it; may include 1 instrumental as a "breath" — actively consider whether one earns its place here, not just as a filler when the count falls short): list # / title / subject / genre / mode / BPM·meter / role (lead / second lead / base / interlude) / Persona.
6. **Designate the lead + nominate the second lead**: place the **lead single** at the album's strongest emotional moment (center-back) — for a classic rising-action arc that's the climax with 1–2 tracks of descent/release after it; for a gradual/spiral/fragmented arc it's wherever the material's real peak of feeling falls, climax or not (guide §34) — chosen by narrative either way, usually the throughline-resolving track. **Nominate one candidate for the second lead** among the rest by "most ear-catching style/melody" — **don't lock it**: after the Step 4 roll-generations, if another track's melody is more stunning, it can change (catchiness is decided by the rolls, so it's locked late).
7. **3 album-name candidates**: mark the recommendation, with a one-line reason.

**Optional gate**: in interactive mode, you may here use `AskUserQuestion` to have the user confirm the album name / lead + second lead / track order (the user may also skip and wave it through); auto mode adopts the recommendations directly, no interruption.

#### Freeze the "creative contract card" (the crux that keeps fan-out from falling apart)

After the blueprint is finalized, **freeze a roughly 1–2KB creative contract card** at the end of `album-blueprint.md`. It is the "constitution" handed to each per-track subagent, and **replaces having the subagent re-read the whole guide** — this is the key to album-level consistency not splitting under fan-out. Template:

```
## Creative contract card (inviolable album-wide)
# An album reads as ONE album because the INVARIANT BINDER (Persona voice + throughline/motif + unified key) never moves — NOT because every track shares one genre. Genre / era-color / instrumentation are per-track variables, shifting by narrative beat (guide §24/§34).
- Persona "{name}" three vocal layers: {timbre texture + delivery + production — see §15.4}
- Backup voice (if any): {a second voice + where it is used}
- Unified key: main {key} / closing {key, if it resolves elsewhere}
- Style-family STARTING POINT (not a cage): {style family} + {core instrumentation} + {production} — **each track's genre/era-color is driven by its narrative beat, not forced into the family**; the album reads as one album because of the invariant binder (Persona voice + throughline + unified key), not genre uniformity. One genre end-to-end = monotonous; deliberate style variety = narrative energy (§24/§34). Heavy diversity → lean on Persona as the coherence anchor, not a Custom Model (§24)
- Throughline image: {throughline image}; recurring motif words: {2–3 motif words}
- Subplot image (if any): {subplot image} (recur the motif in {which tracks})
- Perspective baseline: {perspective}; breath points: {where the album shifts perspective to "breathe"}
- Tidy vs. free: tidy by default; free-verse latitude {0–N tracks, and which}
- Writing-discipline card: see the full "hard writing discipline" in this SKILL (punctuation controls breath / no bare spaces / write every chorus out in full / dense parallel couplets in chorus / metatags all in English / zero 倒字 on motif words …)

## Per-track dossiers (one per track, handed to the matching subagent)
- # / title / role (lead · second lead · base · interlude) / position in the emotional arc
- Narrative context for this track (1–3 sentences): which part of the source story this track corresponds to, what emotional moment it captures, what state the subject is in — not a list of anchors, but an explanation of why this track belongs here and what it's saying
- Subject and material anchors (from the distillation, the more specific the better)
- Most relevant golden lines / voice fragments for this track (selected from material-distillation, with source note)
- Emotion→lever suggestions (mode / BPM / meter / instrumentation / dynamics / vocals)
- This track's GENRE / era-color slot — driven by its narrative beat (the sound that fits this beat: its emotion, plus any era/place/event/cultural association the story carries; guide §15.1/§34)
- Throughline points that must be hit (e.g. the throughline image must appear in the chorus)
```

> A subagent has free rein within its own track, but **may not invent its own Persona / style family / throughline**. When it needs to dig deep into the engine, give it the path to `references/album-creation-guide.md` to read the relevant § on demand.

**Exit point — Blueprint Only entry**: if the entry point is Blueprint Only, stop here. Save the finalized `album-blueprint.md` as the deliverable `album-blueprint-{album}-{model name}.md` (apply the version-header convention from Step 10). Brief the user on the concept, arc, tracklist, and lead/second-lead picks, and ask whether they want to continue into Module S (song writing, one track at a time or the whole album) or Module C (cover design) next — **don't auto-continue**. **Full Album entry** continues straight to Step 4 with the frozen contract card.

### Step 4 [Module S] Song writing — standalone, from a blueprint, or per-track, subagent fan-out either way

Module S is the skill's core capability. **`references/song-writing.md` has the full craft kit** (seven dimensions, three-pass polish protocol, extra forging) and the complete standalone-vs-album-context contract; this step covers the dispatch mechanics. **The Song Only entry has two shapes**, and they are not interchangeable — which one applies depends on whether this song already has a track dossier from a Module B blueprint (see Step 0):

**Song Only — standalone** (no existing blueprint for this song): there is no contract card and no dossier from Module B — the input is just the brief confirmed in Step 0. **Dispatch 3 subagents in parallel, one per lyric-take orientation** (see `references/song-writing.md`, "Standalone entry contract," for the divergence method and exactly what each subagent produces); the main context then runs the plain-reading QC pass (Core principles, above) across all 3 before presenting them. **Every take gets full investment**: three-pass polish + extra forging (dual-track killer-line face-off + three catchiness tests) on all 3, with no tiering discount — a standalone single has no album role to grade against.

**Song Only — from an existing blueprint** (continuing one specific track from a prior Blueprint Only / Full Album run): this is **not** the 3-take standalone contract — it is the album-context path below, just invoked for one track instead of all of them in parallel. Pull that track's role (lead / second lead / base / interlude) and dossier from the blueprint's frozen contract card, dispatch one subagent per the album-context brief, and apply the tiered investment table — a base track picked up this way still gets base-track investment, not 3 full standalone takes, because the blueprint has already decided its role.

**Exit point — Song Only entry**: once the take(s) for this song pass their QC, stop here.
- **Standalone shape**: write `song-{title}-{model name}.md` with all 3 takes + recommendation (contents specified in `references/song-writing.md`). Brief the user and ask whether they want Module C (cover design) next.
- **From-blueprint shape**: write the same `song-{title}-{model name}.md` naming, containing the selected version plus its candidates and polish log — or, if the user is working track by track toward a full album, offer to fold it into a running `album-plan-*.md` instead. Brief the user and ask whether they want another track, or Module C, next.

**Don't auto-continue in either shape.**

**Album context (Full Album entry, or Song Only continuing one track from a blueprint)**: the main context **no longer writes each track's lyrics itself**; instead it **dispatches one independent subagent per track** — giving each track back the full attention of "a single focused song" (this is exactly the mechanism by which "handing it off to a clean context gives higher quality"), while the creative contract card frozen in Step 3 preserves album consistency. In the Full Album entry, 8 tracks can run in parallel; wall-clock ≈ the slowest single track, not the sum of all 8.

**The brief handed to each subagent** = the creative contract card (album-wide constitution) + this track's dossier (narrative context / anchors / golden lines / levers / throughline touchpoints) + **`references/song-writing.md`** (the per-track creation kit, including the tiered investment table for lead / second lead / base / instrumental interlude) + the path to `references/album-creation-guide.md` for reference. **The subagent doesn't read the full source material, but it must know the story behind this track** — the dossier's "narrative context" and "relevant golden lines" fields are its emotional anchor; the main context must fill them carefully, not just supply anchor symbols. **Constraints** = obey the contract card; don't invent Persona / style family / throughline; follow this SKILL's "hard writing discipline."

Two cross-cutting reminders the main context keeps in view, in album context:

- The three-pass polish log travels with each lyric version — in the Full Album entry, into the Step 5 "candidates and polish" appendix; in a Song Only pickup of one blueprint track, into that song's deliverable per the exit note above (real iteration traces either way, not a one-shot draft with a label slapped on).
- **Restraint on the strongest material**: keep killer-line negative space to the lead's 1–2 anchor lines (full-song negative space thins the lyrics and hurts catchiness); and you needn't land every quotable source line — the 1–2 that hit hardest are usually enough (the rest stay as texture), so don't stack quotes just to use them up, though more may stay if they genuinely earn their place (guide §5).

**Full Album entry** continues to Step 5 once all tracks are drafted.

### Step 5 [Orchestration · Full Album entry only] Stitching and assembly (the consistency backstop after fan-out + assembly)

This step only runs in the Full Album entry — **Blueprint Only, Song Only, and Cover Only entries have no cross-track consistency to check** (each has its own lighter self-check folded into its exit note above/below).

The subagents each write their own; cross-track consistency may crack. Return to the main context and do a **stitching check** (cheap but necessary), going through each item:

- **Motif/motif-word recurrence** actually landed (does the throughline image run through, does the subplot image recur in the designated tracks, does the melodic motif call back in the instrumental/finale);
- **Persona / key / style family** not drifting;
- **Perspective "breathes"** (not one person throughout, §6);
- Any **two choruses sharing a rhyme/hook**, any repeated imagery or self-plagiarism;
- **The lead / second lead are genuinely differentiated** (one goes for the emotional anchor, one for ear-catching melody — don't let them become two homogeneous songs);
- Real-person ethics and sensitive handling consistently in place.
- **Every selected lyric reads through** (the plain-reading gate, Core principles): re-read each final lyric **cold in the main context** — don't inherit the subagent's self-endorsement — line by line and against adjacent lines; **any rhyme/character fix you make here is itself a re-write** — re-check its meaning, never assume "form-only" (a 混辙 fix that swaps a character can flip its sense, e.g. "过"→"走").

When you find a crack, **feed it back to the matching subagent to revise, or fine-tune in the main context**, until stitching passes. Then assemble the outputs:

1. **The album-plan main document**: assembled from **each track's selected version**, clean and deliverable. Append a "how this album implements the Album Creation Guide" mapping table at the end (structure per the template's closing section).
2. **The candidates-and-polish document** (`candidates-and-polish-{album}-{model name}.md`): collect each track's **3 candidate titles / multiple lyric versions / three-pass polish logs / 3 album-name candidates**, mark the selected version and the reason, for the user to re-pick by hand.

### Step 6 [Module C] Cover design (produce 3 styles in one pass, then optionally generate)

Module C runs in **three input contexts** — album, song, or freeform brief — each mapping onto the same four visual elements (subject imagery / color / typography / composition). **The full mapping method, prompt-writing rules, output specs, and the `ai-script image` generation command live in `references/cover-design.md`.**

- **Full Album entry**: runs here, after Step 5's stitched final draft — by now the album name, throughline, Persona, and style family are locked. Source the four elements from the blueprint (the album context in `references/cover-design.md`).
- **Cover Only entry**: fed one of — an existing album blueprint or finished album file (album context), an existing `song-*.md` (song context), or a fresh story/style brief with no prior artifact (freeform context). Pick the matching context from `references/cover-design.md` and proceed the same way.

**This step produces only the cover design and prompts (that's Design); actually generating the image is Production**, on the same "to be executed" footing as Suno rolls — a pure-Design run goes only as far as the prompts and does not call an image API.

- **Give 3 genuinely divergent styles in one pass** (not reskins, echoing the three-sketch spirit of Step 2/Module S): the default archetypes, subject/negative-space rules, and real-person handling are in `references/cover-design.md`.
- **Interactive mode** may use `AskUserQuestion` to have the user pick 1 main cover (the rest kept as alternates); **auto mode** picks the one best fitting the subject's character and explains why.

Write the 3 style designs and prompts into the cover section of the album-plan document (Full Album entry — the template already includes it) or into the standalone cover deliverable (Cover Only entry — see exit note below). **Actually generating the image is Production, not pure Design** — `references/cover-design.md` documents the exact `ai-script image` command (this skill no longer ships its own image-generation script — `ai-script image` already covers the same providers); the Step 9 handoff (Full Album entry) splices the chosen prompt into a ready-to-run command.

**Exit point — Cover Only entry**: once the 3 styles are designed (and rendered, if the user wants them generated now), stop here. Write `cover-options-{subject}-{model name}.md` with the 3 style write-ups and prompts, plus the actual images in `covers/` if generated. Brief the user on the recommendation and, for any style not yet rendered, the exact `ai-script image` command to run it. **Full Album entry** continues to Step 7.

### Step 7 [Orchestration · Full Album entry only] QA Report (a fresh-eyes subagent's adversarial re-check)

This step only runs in the Full Album entry. **Blueprint Only** has its own lighter self-check (tracklist self-consistency — role assignment, instrumental placement, arc shape — folded into Step 3); **Song Only** has the plain-reading QC pass folded into Step 4's exit note; **Cover Only** has the "3 genuinely divergent + spec check" folded into Step 6.

**Dispatch an independent subagent for a fresh-eyes re-check** — give it only the final album plan + the engine's QC chapters (§31/§32/§33), **without the "I just wrote this" self-endorsement bias**. Like the editor standing behind the author, it owns product quality with a critical eye and would rather over-report problems. Check each item and give a verdict (pass / needs fix / risk):

- **Plain-reading / reads through (a first-class item, ahead of catchiness)**: read each lyric **cold, as a native listener who doesn't know the intent** — does every line and every adjacent pair read in plain Chinese, with no answer-off-axis, no construction opened-but-never-closed, no one-word-two-senses, no dangling fragment; **the lead's killer line above all** (a question and its answer must sit on the same axis — 问"疼不疼"答"非常满意" fails this). Anything that doesn't read is a **must-fix regardless of how tidy or catchy it is**
- **Catchy / smooth (a first-class item, ahead of tidiness)**: is each track smooth, catchy, sing-along-able, with a melodic hook (can the hook be hummed); **the second lead is verified primarily by this**
- **Lead-single anchor**: are there 1–2 "this is about me" emotional moments; has the killer line been dulled by rhyme (self-check against the "minimalist held-back version")
- 倒字 / Chinese singability re-checked per track; does the hook hold up, short and repeatable
- **Parallel-couplet density**: is the chorus densely paved with parallel couplets, or has it degraded into "colloquial prose with line breaks"
- **Golden-line restraint**: does any track stack source quotes that dilute the memory point (quotes that don't earn their place) — restraint means you needn't use every quote, not a hard cap on how many (guide §5)
- **Rhyme-label cross-check**: per track, check the tracklist's chorus rhyme label against the lyrics' **actual end-rhyme**; if the lead / signature line takes the "legal exception" and drops the rhyme-lock for parallelism, the label must honestly say "parallelism / rhyme-break," not vaguely name a rhyme category (catches mislabels — see "legal rhyme-lock exception" in the hard writing discipline)
- **Were the three passes actually done**: does each lyric version have a polish log, are there real iteration traces (not a one-shot draft with a label slapped on)
- **Bare-space violations**: are in-line breath points done with punctuation/line breaks, any bare spaces used as pauses (never allowed)
- Is every chorus written out in full, any "(repeat)" violation; are metatags all in English, any Chinese parenthetical notes in the lyric body
- Is each Style 4–7 descriptors, **are the three vocal layers up front, is the key marked**, any mutually conflicting descriptors; any misuse of an artist name / reproduction of a famous song
- Prosody form-meaning match (does structure match emotion); **album consistency via the invariant binder** — does the Persona voice / unified key / thematic motif run through (the real source of coherence); where genre/era-color varies by beat, is it a deliberate narrative signifier rather than drift, and conversely not a monotone single-genre album (guide §24/§34)
- Does the emotional arc and track order hold up **for its diagnosed shape** (don't fault a gradual/spiral album for lacking a classic climax); is total runtime in proportion to track count (~2:30–3:30/track, so an 8-track album lands ≈ 26–30 min)
- Is the genre-confidence expectation noted (opera/folk-instrument and other low-confidence cases only promise "approximate flavor")
- **The 3 cover styles**: genuinely divergent (not reskins), subject anchored to the throughline image/personal anchor, color and typography matching the emotional tone and Persona character, negative space left for the overlaid title, specs met (3000×3000 1:1); any platform logo/artist name wrongly stuffed into the prompt
- Sensitive / ethical handling adequate (real person; including whether the cover used an unauthorized likeness of a real person)
- Word-level polish: rare characters, mixed CJK-and-alphanumeric, **breath points (punctuation/line breaks, not bare spaces)**, colloquial feel; **is the strongest anchor in the chorus**, any section over-filled by formula/over-written, are the lyrics on the long side

**Honestly mark the boundary**: the plan stage is pure text — **the actual sound of 倒字, AI artifacts, pitch, dynamics, etc. can only be settled after Suno rolls and a listen** — list these separately as "to be verified at the listening stage," and don't pretend to have verified them on text.

End with an **overall QA verdict** + a **prioritized list of suggested rework items**. Write into a standalone file `qa-report-{album}-{model name}.md`. **Report only, no automatic rework** — whether to rework is the user's call.

### Step 8 [Orchestration · Full Album entry only] Creation Summary (a project-level retrospective)

This step only runs in the Full Album entry.

Write an **overall project summary** (a separate thing from the QA report, its own file): review the whole creation process, list the key points of each step (ingestion status, the chosen direction and why, the album blueprint highlights, an overview of the lead/second lead and base tracks, **why each track's selected lyric version was picked**, **the 3 cover styles and the chosen direction**), and **come clean about the problems along the way** — which material was ignored, whether the selection had gaps or bias, how sensitive content was handled, where compromises were made. Write into `creation-summary-{album}-{model name}.md`.

### Step 9 [Orchestration · Full Album entry only] Assemble the Production Handoff sheet (pure extraction and reordering, no new creation)

This step only runs in the Full Album entry (the other entries produce a lighter self-contained deliverable instead — see their exit notes). This goes after QA — by now the album plan, the cover's 3-style design, and the to-verify-at-listening items are all locked. **Converge in one pass** the executable recipes scattered across the long document into one ready-to-execute sheet `production-handoff-{album}-{model name}.md`, so the user can roll songs / generate covers straight from it without going back to re-extract. **All content comes from the already-produced album plan and QA report — no new creation.** Three sections:

1. **Suno roll section (one block per track, copy-paste ready)**: each track a delimited block — title + role (lead / second lead / base / interlude) + target score; `Style` (4–7 descriptors, three vocal layers first, key included) + `Exclude` (only if the album plan specified one — it's an optional negative field, guide §23) + `Sliders`, each on a copyable line; full lyrics (English metatags, every chorus written out) as one paste-into-Suno-Lyrics block; this track's roll SOP (N value, Inpainting count, what to listen for — lead: 倒字 on anchor lines / second lead: the melodic hook / base: accept once it passes). The instrumental interlude listed separately (turn on Instrumental, leave Lyrics empty, give Style + a structure note). **Sliders notation must be unified album-wide into one form** (pick qualitative Safe/Strong OR percentages, not mixed per track), killing the scatter.
2. **Cover-gen section (commands ready to run)**: splice the chosen main-cover prompt straight into the full command `cd ~/code/ai-script && ./ai-script image "<chosen prompt>" -o {absolute path to working dir}/covers/{album}-{style}.png -e grsai:gpt-image-2`, plus one line each for alternates B/C (full command details, `--stdin` for long prompts, and the `check`/timeout notes in `references/cover-design.md`); note the output dir `covers/` inside the working directory.
3. **Post-roll acceptance checklist (checkbox list)**: distill QA's "to be verified at the listening stage" items into a checkable list (倒字 on a real listen, AI artifacts, pitch/dynamics, overall catchiness, whether a legal-exception parallelism/rhyme-break holds up); append the **post-roll delivery specs** (from template §0.6: WAV master + 320k MP3, unified **-14 LUFS**, verify volume and track order separately for the physical version) to give Production specs a landing spot.

### Step 10: Save and deliver

All final outputs are stored in the working directory, each with a version-header comment at the top `<!-- Ver YYYY-MM-DD HH:MM, by {model name} -->` (**time down to the minute** — use `date "+%Y-%m-%d %H:%M"` to fetch the current time; don't write date only). What gets saved depends on the entry point:

**Full Album entry**:

- **The album plan** (the main output, each track's selected version, **including the cover's 3-style design and prompts section**): `album-plan-{album}-{subject}-{model name}.md`
- **Candidates and polish** (3 candidate titles / multiple lyric versions / three-pass polish logs / 3 album-name candidates): `candidates-and-polish-{album}-{model name}.md`
- **Production handoff** (Suno roll recipes + cover-gen commands + post-roll acceptance, ready to execute): `production-handoff-{album}-{model name}.md`
- **QA report**: `qa-report-{album}-{model name}.md`
- **Creation summary**: `creation-summary-{album}-{model name}.md`
- **Cover images** (if actually generated): **stored in the working directory's `covers/` subfolder** (in the same project directory as the rest of the outputs, don't scatter them); the chosen main cover + alternates, named `{album}-{style}.png`, streaming master 3000×3000.
- Keep the intermediate files too (material distillation, creative direction, album blueprint [including the creative contract card]).

**Blueprint Only entry**: `album-blueprint-{album}-{model name}.md` (the finalized blueprint + contract card, promoted from the Step 3 intermediate file to a versioned deliverable) — no candidates/handoff/QA/summary files.

**Song Only entry**: `song-{title}-{model name}.md` — for a standalone song, the 3 lyric+style+title takes, their polish logs, and the recommendation (see `references/song-writing.md` for contents), with no separate candidates-and-polish file since the takes themselves are the deliverable; for a track picked up from an existing blueprint, the selected version plus its candidates and polish log (or folded into the running `album-plan-*.md` instead, per Step 4's exit note).

**Cover Only entry**: `cover-options-{subject}-{model name}.md` (the 3 style write-ups + prompts) + any generated images in `covers/`.

## Hard writing discipline (violations will directly ruin the Suno output)

> The foundation is just two principles — **signal over noise + layered control** (guide §2): write only what Suno can parse into sound, put the strongest signal in the most prominent spot, and place each intent on its most reliable control layer. Everything below is a corollary; when unsure, return to the principles. Applies to Module S in any context, standalone or album.

> **Two categories in this section:**
> - **★ Suno engineering rules** (marked ★): violating these causes Suno to generate incorrectly — non-negotiable, Prosody can't help here.
> - **Lyric-quality defaults** (unmarked): recommended practice based on Prosody; legal exceptions exist, but must be intentional and disciplined; when one fights the emotion, return to Prosody.

- **★ Write every chorus out in full**: write out every chorus where it appears, **never "(repeat)" or "same as above"** — Suno generates literally.
- **Chorus = the strongest signal spot**: the chorus repeats most, so **put the most anchored (personal image), most impactful words in the chorus**; the verse handles "why/setup," the chorus is responsible for "being remembered."
- **Lock the rhyme + dense parallel couplets (the #1 lever for Chinese sounding "like a song")**: each chorus **locks one rhyme category to the end** (the thirteen rhyme categories of New Chinese Rhyme — 中华新韵十三辙), the verse rhymes on even lines; **the chorus defaults to densely paved parallel couplets (对仗)** (paired lines with matching structure and opposed imagery, e.g. "一碗甜粥／一缕晨光," "风吹不熄／雨打不凉"), and verses bury couplets as needed. Even line length (≤ ~10–12 chars), cut colloquial prose phrases. **Better tidy and densely paralleled than "colloquial prose with line breaks"** (guide §9.1). But **tidiness serves "catchy and pleasant"**: when the rhyme-lock/couplets force something stiff and tongue-twisting, or say everything for the listener, return to Prosody — being pleasant is itself an emotional carrier, so loosen a notch and favor negative space (especially on the lead's anchor lines).
- **Legal rhyme-lock exception (lock by default; break with discipline)**: the lead's anchor lines / the signature hook's opening line may drop the end-rhyme and use **strong parallelism** or another binding device instead (e.g. "these hands cut grass / sewed clothes / carried the load" — parallelism is itself catchy, a legitimate strong binder in Chinese song). But a break must: ① **stay within 1–2 lines**, never spreading across the whole song (a fully rhyme-less song falls apart); ② be **labeled honestly as "parallelism / rhyme-break" in the tracklist rhyme label**, never vaguely tagged as some rhyme category (else it misleads, and QA checks it — see Step 7); ③ be **listed under "to be verified at the listening stage,"** confirmed by rolling and a listen. Every other line still locks one rhyme to the end.
- **★ Use punctuation and line breaks for in-line rhythm, not bare spaces**: Suno reads punctuation/line breaks as breath instructions (period = breath and reset, comma = short pause, … = lingering hold, hyphen = drawn-out, line break = a longer pause, blank line = instrument continues while vocals stop); **in-line bare spaces are unreliable and often swallowed in connected reading**. Lines should be ≤ ~10–12 chars, split long lines, don't cram.
- **★ All performance/arrangement cues go in English square-bracket metatags** (`[Verse: breathy, sparse]`, `[Chorus: full band, erhu accent]`), **the lyric body keeps only the words to be sung**; **strictly no Chinese parenthetical notes** (e.g. "(softly)") — Suno will sing them as lyrics.
- **★ Each Style is 4–7 descriptors, three vocal layers first**: timbre + delivery + production (guide §15.4) go at the start of Style; you may add the **key** (`in A minor`) to boost album consistency (guide §15.5); name core instruments (for Chinese folk instruments use specific names like erhu/guzheng/pipa/dizi). Fewer than 4 descriptors is too vague; more than 7 produces conflicting signals and a muddy output.
- **★ Don't write artist names** (filtered/banned by the platform, and a placebo anyway): treat the target singer as internal reference, **translate them into the three vocal-layer descriptors** before writing; don't reproduce famous songs — do "evocative likeness + original lyrics" only.
- **Add or cut sections by function, don't fill the whole formula, don't fill every section**: the classic template is a toolbox, not a fill-in-the-blank; if 3 sections say it clearly, don't write 5; **lyrics: simpler over fuller** (form follows emotion).
- **★ Don't write chord progressions into the lyric body** (they'd be sung as lyrics); to influence harmony use "mode + key + mood + genre," and put chord progressions only at the end of Style as a low-expectation supplement (guide §15.5).
- **★ Tag every section; `[End]` is mandatory**: add a bracket tag to every section (`[Verse 1]`, `[Chorus]`, `[Bridge]`, etc.); **`[End]` is an engineering rule — prevents Suno from trailing off endlessly**. Which sections to include is decided by narrative logic and genre, not by a fixed formula — a simple ballad may have no Bridge, a rap track may have no traditional chorus form (see guide §7). The tag names listed here are a toolbox, not a checklist.

## References (read on demand, progressive disclosure)

- `references/album-creation-guide.md`: the complete methodology engine (Album Creation Guide). **Read the relevant chapters before creating in Module B / Module S** (the two underlying principles §2, emotion→lever §3/§18, lyrics Part II [tidiness §9.1], music Part III, Suno practice Part IV [three vocal layers §15.4, key/chords §15.5, Style §21, punctuation-as-rhythm §22], the prompt framework Part V, QC Part VI, genre confidence §26). **Per-track/per-take subagents by default read only the Step 3 creative contract card (album context — including a Song Only pickup of one blueprint track) or the standalone brief (a Song Only request with no existing blueprint) and aren't forced to read the whole thing**; read a given § by path when a deep dive is needed; **for Module C read §36 (the cover = Prosody at the visual layer)**. Suno and image-model capabilities change by version — verify against the current version before hands-on work.
- `references/album-plan-template.md`: the structural skeleton and placeholders for the Full Album entry's final plan. **Fill in by this structure from Step 3 on**, replacing each `{…}` placeholder, deleting inapplicable optional sections (e.g. delete the "real-person note" if not a real person). The template gives only the form; content and style all come from the material distillation. Not used by the Blueprint Only / Song Only / Cover Only entries, which each write a single self-contained deliverable instead.
- `references/blueprint-kit.md`: **Module B's methodology detail** — the full field list for the Step 1 material-distillation file (and its "exhaust, don't pre-filter" principle), and the full method for Step 2's three divergent draft directions, including how the same divergence method scales down to Module S's standalone song grain. Read at Step 1–2.
- `references/song-writing.md`: **Module S's full contract and craft kit** — the standalone entry contract (3-take default, divergence method, output naming — for a Song Only request with no existing blueprint), the album-context tiered investment table (for the Full Album entry, and for a Song Only request continuing one track from an existing blueprint), and the shared seven-dimension / three-pass-polish / extra-forging craft kit. **Handed to each Step 4 subagent** — one per track (album context) or one per take (standalone context) — alongside whatever contract card, dossier, or brief applies.
- `references/cover-design.md`: **Module C's full contract** — the three input-source mapping (album / song / freeform), prompt-writing rules per image model, output specs, and the `ai-script image` generation command. **Read at Step 6** when writing prompts / generating the image, in any entry.

**Terminology cross-reference (this SKILL vs. the underlying engine)**: `album-creation-guide.md` is a general-purpose methodology engine written before this SKILL introduced the two-single model. In the engine, "代表作 (signature track)" means the single most important song — corresponding to this SKILL's "lead single (主打)." The engine's "底座 (base)" maps to this SKILL's "base track (底座曲)." The engine doesn't have a "second lead (副主打)" concept; that's an extension in this SKILL. Where engine and SKILL terminology diverge, this SKILL's definitions take precedence.

When everything is done, brief the user, scaled to the entry point:

- **Full Album**: where the working directory is, which files were generated (the album plan [including the 3 cover styles] / candidates and polish / **production handoff** / QA report / creation summary + intermediate files), which two tracks are the lead and second lead, **the chosen cover direction**, **the suggested rework items in the QA report** and **the ignored/incomplete material in the creation summary**, and **point them to the production handoff**: roll the Suno tracks and generate the cover by following it item by item.
- **Blueprint Only**: where the working directory is, the concept/arc/tracklist and the lead/second-lead picks, and that Module S (song writing) and Module C (cover design) are available next, on this same blueprint, whenever they want them.
- **Song Only**: for a standalone song, the 3 takes and the recommendation; for a track picked up from an existing blueprint, the selected version and how it fits that track's role — either way, note that Module C (cover design) is available next if they want cover art for this song.
- **Cover Only**: the 3 style directions, which is recommended and why, whether images were actually generated or only designed, and — if only designed — the exact `ai-script image` commands to run each one.

In every entry: **whether to rework is the user's decision, the skill does no automatic rework**. For real-person material, additionally remind them to "have the family confirm before delivering the finished work."
