---
name: audio-album-creator
description: "Distill a pack of source material (audio / text / photos) into a complete, production-ready original emotional music album plan (a Markdown document). Use when the user wants to make an album for a person or a life experience, turn raw material into an album plan, create a life/memorial album, an Amber Ark-style custom album, or write an album following the creation guide. The user names which source files to use this time. For narrative, custom albums made for close family, a partner, a child, or a team/company. Not for plain lyric polishing, pure music-theory Q&A, or generic lyric-writing with no narrative material."
---

<!-- Ver 2026-06-23, by Claude Opus 4.8 -->

# Audio Album Creator

Read and understand a user-supplied pack of source material (audio, text, photos, or any mix), distill its essence, then run a **simple but effective** pipeline to produce a **complete, ready-to-produce original emotional album plan** (a Markdown document).

The engine behind this method is `references/album-creation-guide.md` (the Album Creation Guide); the output structure follows `references/album-plan-template.md` (a pure skeleton template — section headings and placeholders only, with no story content or stylistic bias, so it can't contaminate the creation of different themes).

## Core principles (these drive every creative trade-off)

- **One lead + one second lead (two singles)**: a whole album (typically 6–8 tracks) carries **two singles** that bear the two different forces that "move the customer." The **lead single (主打)** — chosen by narrative, usually the throughline-resolving closer — is excellent in both lyrics and music, carries the emotional anchor, and is the breaking-point moment that "makes the customer cry" (QC ≥ 9/10, 85+). The **second lead (副主打)** — chosen by whichever track is most ear-catching in melody/style — aims first at "sounds great on the first listen," with lyrics that only need to clear the bar (80+, sound-first). The remaining "base tracks (底座)" hold the pass line (≥ 7/10, 60+). **Why two**: being catchy is what wins first impressions (the customer's gut reaction when choosing the album), and being moving is what drives retention (making the customer feel understood) — splitting these two peaks across two tracks is safer than betting everything on one. **(Where "signature track" appears below, it means the lead single.)**
- **Quality resources are deliberately uneven (stated clearly only here)**: "uneven" applies to **Suno roll-generation (抽卡) compute and style exploration** (audio generation is expensive) — **not to lyric-text polishing**. Lyrics are pure text, iteration is nearly free, and the three-pass polish is run on **every track** (base tracks included; see Step 4).
- **Two-layer quality model (each track's pass line and ceiling)**: the **threshold layer** (every track must pass) = melodically pleasant, smooth, singable, easy to sing along to, no 倒字 (tonal mismatch — a character whose tone contour fights the melody so it's misheard as another word), the story checks out, not maudlin. The **anchor layer** (required for the lead single — 1–2 spots; optional for the second lead) = the emotional moment that makes the customer feel "this is about me." **Metrical tidiness (工整) is a means in service of "catchy and pleasant," not an end — when over-tidiness hurts natural flow, pleasant wins.**
- **The 60-point commercial standard**: share-with-friends quality, not publication quality. Outside the two singles, don't chase artistic height — chase "the customer feels it was worth it."
- **Prosody (form matches meaning) is the first principle**: lyrics, music, voice, and production — all four layers serve one emotional intent. Paired with two underlying principles (guide §2): **signal over noise** (write only what the model can parse into sound, and put the strongest signal in the chorus) + **layered control** (put each intent on its most reliable layer: global sound → Style; section-level change → metatag; in-line breath points → punctuation and line breaks). The "hard writing discipline" below is mostly corollaries of these two.
- **Sense-bound sourcing**: an album's soul is the **personal anchors** caught from the source material (specific objects, smells, catchphrases, scenes, key events), not abstract sentiment. The more specific, the more the listener feels "this song is about me."
- **A real person means ethics**: if the subject is a real person, handle them with dignity; abstract away or cut sensitive content (politics / illness / the deceased / privacy) per guide §27; before delivering the finished work, remind the family to confirm it.
- **The cover art is Prosody at the visual layer**: the CD cover shares a source with the lyric/music/voice/production work — subject imagery, color, typography, and composition all obey the same emotional intent, reusing the blueprint's throughline imagery + strongest personal anchor + emotional tone + style family + Persona character, so "the cover looks like the album sounds." Produce **3 genuinely divergent styles** in one pass (echoing the three-sketch spirit of Step 2); details in guide §36.

## Workflow

This is a **human-run** skill, not an end-to-end fully automated one. It produces output in three escalating tiers: **Tier 1 pick the direction (Step 2) → Tier 2 lock the blueprint and contract (Step 3) → Tier 3 create track by track (Step 4 onward)**.

**Two run modes (confirm at Step 0)**:

- **Interactive mode (default)**: 1 mandatory gate (Step 2, creative direction) + 1 optional gate (Step 3, album name / lead + second lead / track order confirmation). **Track-by-track creation (Step 4) is not interrupted.**
- **Auto mode**: every gate auto-picks the "most recommended," runs straight through, and hands over a report at the end.

**Track-by-track creation uses subagent fan-out**: from Step 4 on, **dispatch one independent subagent per track** to focus on creation (this cures the attention dilution of "one long context carrying 8 songs"), relying on the "creative contract card" frozen in Step 3 to preserve album-level consistency. **Each track's "pick-best-from-multiple-lyric-versions" is done by the subagent's own self-evaluation; neither mode feeds it back to the user for a per-track choice** (avoiding choice explosion); if the user wants changes, they read the "candidates and polish" appendix and re-pick by hand.

The end produces standalone reports (a creation summary + a QA report). **Whether to rework is the user's call; the skill itself does no automatic rework.**

For non-trivial jobs (lots of material, unclear scope), first create `_album_plan.md` in the working directory to record task breakdown and progress, and clean it up when done.

### Step 0: Confirm input and working directory (before anything else)

1. **Confirm the material**: the user names which files to use this time. Confirm each path and type (audio / text / image / video) one by one.
2. **Determine the working directory (this is a fixed rule)**:
   - If all material is **inside one folder** → the working directory = that folder, and all intermediate results and final outputs are stored there.
   - If the material is **scattered across locations** → create a subfolder under the **current directory**, named by the **project name** (the project name is the subject's name or the album theme, e.g. `{subject}-album/`), and store all outputs there.
3. **Confirm the creative brief** (if missing, ask briefly — don't guess): who the subject is, what occasion, what core emotion is wanted, who's paying / who's listening, language (Mandarin by default), **whether it's a real person** (this sets the strength of ethics and sensitive handling).
4. **Confirm the run mode**:
   - **Interactive mode (default)**: Step 2 must stop, Step 3 may stop, track-by-track is uninterrupted.
   - **Auto mode**: every gate auto-picks the most recommended and runs through continuously.
   - At the same time confirm the **production tier** (affects Step 4 cost): **standard tier** (base tracks also get 3 lyric versions) / **economy tier** (base tracks get only 1 lyric version × 3 passes; only the two singles get the full treatment). Interactive mode defaults to standard tier, auto mode defaults to economy tier; the user can override.

### Step 1: Ingest & distill the material

This skill runs on a **multimodal model** by default: it reads and understands text / image / audio / video material directly, with no transcoding or transcription pipeline.

- **Text / images**: read in full. For images, extract era, scene, relationships, mood, and any **objects** usable as personal anchors.
- **Audio / video**: hand directly to the model to understand — catch the spoken content, tone and mood, environmental cues.
- **If the current model or harness cannot ingest a material type** (e.g. audio isn't supported): **don't get stuck and don't fabricate content** — skip that material and, in the Step 8 creation summary, **explicitly record "such-and-such material was ignored because the model doesn't support it"** so the user knows.

After distilling, **write an intermediate file** `material-distillation-{subject}.md` into the working directory, containing:

- Character bio / timeline (key life milestones)
- **Personal-anchor list** (the crux of guide §5: objects, smells, catchphrases, scenes, key events — list each one, the more specific the better)
- Emotional-arc candidates (bitter→sweet, loss→gain, parting→return, etc.)
- Family members and relationships, important dates (seeding later family-memory and repeat-purchase hooks; also serving the perspective choice)
- **Sensitive-content flags and handling plan** (which to abstract, which are too dark and must be cut)
- **Ingestion status** (what was read, what was ignored as unsupported, any obvious gaps) — to be cited in the creation summary
- **Raw stock for the creative contract** (groundwork for freezing the contract card in Step 3): draft three-layer vocal descriptors for Persona candidates, throughline image candidates, recurring-motif-word candidates, an initial gathering of usable anchors per track. This is just prep; formal locking happens in Step 3.

### Step 2: [Tier 1 · mandatory gate] Propose 3 draft directions, ask the user to choose

Based on the Step 1 distillation, **offer 3 fundamentally different draft directions** for the user to decide. The three should **genuinely diverge** (determined by the material's content, not reskins) along these dimensions:

- **Stylistic leaning** (e.g. Jiangnan folk vs. lyrical soul vs. neo-folk);
- **Emotional tone** (e.g. the warmth of bitterness-released vs. the restrained ache of holding back vs. the lightness of serene clarity);
- **Story core / throughline** (which throughline governs a whole life — e.g. "a pair of hands" vs. "a single lamp" vs. "the road home").

Give each draft (**only at "sketch" granularity — don't expand a full 8-track blueprint**, which is Step 3's job, to avoid 3× blueprint cost with 2 discarded):

- A one-line concept + the emotional-arc trajectory
- **Throughline image** + the recurring motif word
- **Rough tracklist outline** (6–8 tracks, one line of subject per track)
- The candidate lead single's angle + **one sample hook line** (so the user gets a taste first)
- An embryonic style family

**Mark the most recommended one and spell out why** (why it best fits this material and has the most "breaking-point" potential).

- **Interactive mode**: use `AskUserQuestion` to present the three sketches as options (the system auto-adds "Other" for custom directions). The user can: take the recommendation / pick another / customize / pick one and add notes.
- **Auto mode**: adopt the most recommended sketch directly, no interruption.

Record "three sketches + recommendation rationale + final choice and notes" into the intermediate file `creative-direction-{subject}.md`. **Once chosen, proceed to Step 3.**

### Step 3: [Tier 2 · optional gate] Album-level coordination (Album Blueprint) + freeze the creative contract card

Read §34 (album coordination), §24 (consistency), Part I §3 (emotion→lever) of `references/album-creation-guide.md`, and cross-reference template §0. **Expand along the direction the user chose** and write into the intermediate file `album-blueprint.md`:

1. **Concept and emotional arc**: state in one line what kind of album this is; the emotional arc is the track order.
2. **Persona lock**: describe the lead voice with the **three vocal layers** (timbre texture + delivery + production, guide §15.4, e.g. "warm aged mezzo, breathy to opened-up, close-mic"), and set a backup voice if needed (e.g. the next generation taking over the singing to complete "passing it on"). **Artist names are for internal reference only and never enter a prompt** (translate them into the three-layer descriptors). You may set 1–2 **keys** for the whole album to rein in drift.
3. **Thematic motif**: one throughline image running through the whole album + one one-line subplot image + one melodic motif that recurs in the instrumental / at closings.
4. **Style family**: a unified instrumentation and production baseline, with variation allowed within the family.
5. **Tracklist arrangement table** (6–8 tracks, may include 1 instrumental as a "breath"): list # / title / subject / genre / mode / BPM·meter / role (lead / second lead / base / interlude) / Persona.
6. **Designate the lead + nominate the second lead**: place the **lead single** at the album's climax (center-back, chosen by narrative, usually the throughline-resolving closer), leaving 1–2 tracks of descent and release after it. **Nominate one candidate for the second lead** among the rest by "most ear-catching style/melody" — **don't lock it**: after the Step 4 roll-generations, if another track's melody is more stunning, it can change (catchiness is decided by the rolls, so it's locked late).
7. **3 album-name candidates**: mark the recommendation, with a one-line reason.

**Optional gate**: in interactive mode, you may here use `AskUserQuestion` to have the user confirm the album name / lead + second lead / track order (the user may also skip and wave it through); auto mode adopts the recommendations directly, no interruption.

#### Freeze the "creative contract card" (the crux that keeps fan-out from falling apart)

After the blueprint is finalized, **freeze a roughly 1–2KB creative contract card** at the end of `album-blueprint.md`. It is the "constitution" handed to each per-track subagent, and **replaces having the subagent re-read the whole guide** — this is the key to album-level consistency not splitting under fan-out. Template:

```
## Creative contract card (inviolable album-wide)
- Persona "{name}" three vocal layers: {warm aged mezzo, breathy→opened-up with a catch, close-mic warm analog}
- Backup voice (if any): {young warm female}
- Unified key: main {A minor} / closing {C major}
- Style family: {Jiangnan folk / guofeng lyrical}; core instrumentation {erhu+guzheng+piano+soft strings}; production {warm analog, close-mic}
- Throughline image: {a pair of hands}; recurring motif words: {hand / scar / warm}
- Subplot image: {brass foot-warmer} (recur the motif in #5 instrumental, #8 finale)
- Perspective baseline: {first-person looking back}; breath points: {lead single Bridge / finale cuts to the next generation}
- Tidy vs. free: tidy by default; free-verse latitude {0–1 track, on the most repressed one}
- Writing-discipline card: see the full "hard writing discipline" in this SKILL (punctuation controls breath / no bare spaces / write every chorus out in full / dense parallel couplets in chorus / metatags all in English / zero 倒字 on motif words …)

## Per-track dossiers (one per track, handed to the matching subagent)
- # / title / role (lead · second lead · base · interlude) / position in the emotional arc
- Subject and material anchors (from the distillation, the more specific the better)
- Emotion→lever suggestions (mode / BPM / meter / instrumentation / dynamics / vocals)
- Throughline points that must be hit (e.g. the "hand" image must appear in the chorus)
```

> A subagent has free rein within its own track, but **may not invent its own Persona / style family / throughline**. When it needs to dig deep into the engine, give it the path to `references/album-creation-guide.md` to read the relevant § on demand.

### Step 4: [Tier 3] Parallel per-track subagent lyric+music creation

The main context **no longer writes each track's lyrics itself**; instead it **dispatches one independent subagent per track** — giving each track back the full attention of "a single focused song" (this is exactly the mechanism by which "handing it off to a clean context gives higher quality"), while the creative contract card preserves album consistency. 8 tracks can run in parallel; wall-clock ≈ the slowest single track, not the sum of all 8.

**The brief handed to each subagent**:

- **Input** = the creative contract card (album-wide constitution) + this track's dossier (role / anchors / levers / throughline touchpoints) + the path to `references/album-creation-guide.md` for reference.
- **Task** = produce ① 3 candidate song titles; ② several complete Chinese-lyric versions (each run through the "three-pass polish protocol" below); ③ the Suno Style; ④ self-evaluate and pick the recommended version, with a brief pick-rationale + a short 倒字/QC note.
- **Constraints** = obey the contract card; don't invent Persona / style family / throughline; follow this SKILL's "hard writing discipline."

**Tiered investment (three tiers; the meaning of "uneven" is in Core principles)**:

| Track role | Lyric versions | Three-pass polish | Style | Target | Production SOP |
|---|---|---|---|---|---|
| **Lead single** | **1 complete + dual-track killer line + 2 candidate choruses** | 3 passes on the complete version + killer-line forging | **3 (including vocal style)** | 85+ | N≥8, lock Persona, chorus Inpainting 2–5×, line-by-line 倒字 check (guide §31) |
| **Second lead** | 2 versions | 3 passes each + the three catchiness tests | **2–3 (favoring ear-catching melody/style)** | 80+ (sound-first) | **high-N rolls to land the melody**, Inpainting to tune the arrangement, lyrics clear the bar |
| **Base** | standard tier 3 versions / economy tier 1 | 3 passes each | **1 within the family** (may +1 backup) | 60+ | N=2–4, reuse Persona + style family, accept once it passes |
| **Instrumental interlude** | — | — | 1 (turn on Instrumental, leave Lyrics empty) + a structure note | — | roll several, take the warmest |

> **Base tracks don't do 3 styles**: a base track's style is already locked by the style family + Persona; forcing 3 styles either breaks album consistency or is a cosmetic tweak (wasteful). **Style is not the base track's variable — lyrics are.**

**For each lyric version, the subagent must write out all of the following (seven dimensions, fully landed)**:

1. **Dimension 1, lyrics and narrative**: material anchor → imagery (express emotion through the concrete, not bluntly venting grief) → chorus hook (short, repeatable, personal image + universal emotion) → perspective (§6) → structural placement (private details into verses, deep emotion held back into the chorus).
2. **Dimension 2, emotion→lever** (§3/§18): set mode, tempo/meter, instrumentation, dynamics, vocals, and state for each value "why" it serves the emotion. The emotional arc (e.g. minor-key verse → major-key chorus) lands as in-section change in mode + dynamics.
3. **Dimensions 3–7**: style / song form and dynamic arc / rhythm / vocals / instrumentation.
4. **Suno Style field** (§21): 4–7 descriptors; **the three vocal layers (timbre + delivery + production) go first**, may add the **key** to boost consistency, name core instruments (for Chinese folk instruments use specific names like erhu/guzheng). Leave timbre to Style + Persona, and push the section-level vocal arc down to metatags. Attach Sliders (emotional song = Weirdness Safe + Style Influence Strong + Prompt Helper Off).
5. **Complete Chinese lyrics** (see "hard writing discipline" below): put the strongest anchor in the chorus, use punctuation/line breaks for in-line breath points, don't fill every section just because the formula has one.
6. **Chinese singability / 倒字 self-check** (§13/§22): check the hook keywords and personal names one by one for zero 倒字, flag the long lines that need watching.

#### Three-pass polish protocol (turns guide §14 "rewriting = the gold standard" into executable steps, run on every track)

Every lyric version must run all three passes, and **keep a brief polish log** (what each pass changed):

```
Pass 1 — concept/imagery focus: catch the personal anchor, cut clichéd prefab phrases, set the throughline landing point, set perspective and section roles
Pass 2 — tidiness/rhyme: lock one rhyme category to the end, [dense parallel couplets in the chorus · bury couplets in verses as needed], even line length (≤10–12 chars),
          cut colloquial connectives ("you all know," "I carried it alone"), use stable/unstable tools per the emotion
Pass 3 — hook/singability: shorten the hook so it's repeatable, put the strongest anchor on the chorus's signal spot, 倒字 self-check (zero 倒字 on motif words/names),
          breath points to punctuation (no bare spaces), dual-anchor the metatags, write every chorus out in full
```

> This protocol costs only text tokens, is **run on every track (base included)**, and is the single highest-ROI fix for lyric quality. Keep the three-pass log alongside each lyric version, to be written into the "candidates and polish" appendix in Step 5.

#### Extra forging for the lead / second lead (hangs off this step, not a separate Step)

Beyond the three-pass polish, the lead and second-lead subagents each do one more thing (the cost is just a few extra lines of text):

- **Dual-track killer-line face-off (lead only)**: produce the core hook as **both a "minimalist, held-back version" and a "full, tidy version"**, pit them head-to-head, and pick the better — **forcing the tension to survive, preventing it from being diluted by one-way tidying** (this is exactly the switch that fixes "a good line dulled by rhyme"). The pick passes three tests: the **delete-the-adjectives test** (would deleting it hit harder), the **negative-space test** (did it say everything for the listener), the **sing-along test** (would an elder remember it after one listen).
- **Three catchiness tests (lead + second lead)**: the catchy test / the sing-along test / **the melodic-hook test (can the hook be hummed)**. The second lead is verified primarily by this yardstick.

> Boundary: **killer-line negative space is used only on the lead's 1–2 anchor lines, not pushed across the whole song** — full-song negative space thins out the lyrics and instead hurts catchiness.

### Step 5: Stitching and assembly (the consistency backstop after fan-out + assembly)

The subagents each write their own; cross-track consistency may crack. Return to the main context and do a **stitching check** (cheap but necessary), going through each item:

- **Motif/motif-word recurrence** actually landed (does the throughline image run through, does the subplot image recur in the designated tracks, does the melodic motif call back in the instrumental/finale);
- **Persona / key / style family** not drifting;
- **Perspective "breathes"** (not one person throughout, §6);
- Any **two choruses sharing a rhyme/hook**, any repeated imagery or self-plagiarism;
- **The lead / second lead are genuinely differentiated** (one goes for the emotional anchor, one for ear-catching melody — don't let them become two homogeneous songs);
- Real-person ethics and sensitive handling consistently in place.

When you find a crack, **feed it back to the matching subagent to revise, or fine-tune in the main context**, until stitching passes. Then assemble the outputs:

1. **The album-plan main document**: assembled from **each track's selected version**, clean and deliverable. Append a "how this album implements the Album Creation Guide" mapping table at the end (structure per the template's closing section).
2. **The candidates-and-polish document** (`candidates-and-polish-{album}-{model name}.md`): collect each track's **3 candidate titles / multiple lyric versions / three-pass polish logs / 3 album-name candidates**, mark the selected version and the reason, for the user to re-pick by hand.

### Step 6: CD cover design (produce 3 styles in one pass)

This goes after the stitched final draft — by now the album name, throughline, Persona, and style family are locked. The cover **doesn't start from scratch**: it draws directly from the blueprint — throughline image / strongest personal anchor / emotional tone / style family / Persona character — mapping each onto the four visual elements (subject imagery / color / typography / composition). Principles and specs in guide §36. **This step produces only the cover design and prompts (that's Design); actually generating the image is Production, on the same "to be executed" footing as Suno rolls — a pure-Design run goes only as far as the prompts and does not call an image API.**

- **Give 3 genuinely divergent styles in one pass** (not reskins, echoing the three sketches of Step 2): **photorealistic photography / hand-drawn illustration / abstract minimalism (or collage) are the default archetypes, swappable per the album's character**, or the same subject in different color and typography; only the three need to genuinely diverge. For each write: ① a one-line visual concept; ② the four-element values; ③ a prompt that can be fed straight to an image model. Fill in the template's "cover design (3 style candidates)" section.
- **Subject = the throughline image / strongest personal anchor** (prefer a concrete object, sense-bound), don't use a generic abstract image; **when the throughline can't be visualized, fall back to the anchor object**. Leave **negative space for overlaying the title** in the composition, and the thumbnail (the streaming first image is tiny) needs a strong focal point and little information.
- **Two prompt styles**: Midjourney uses "subject + style/medium + lighting + color mood + composition" with `--ar 1:1` (≤ ~60 words); Nano Banana / GPT Image use natural-language sentences (Subject + Action + Scene + mood). **Always add `no text` / "do not render any text"** to the prompt, to stop the model from smearing fake letters into the space.
- **AI text rendering is unreliable**: prefer **overlaying the title in post** for the album name / subject name, or use a model strong at text rendering (Nano Banana Pro / GPT Image); don't count on Midjourney to spell the title right.
- **Specs**: streaming master **3000×3000, 1:1, sRGB, JPG/PNG**; for a physical CD, also produce **126×126mm (incl. 3mm bleed), 300 DPI (≥1417px), CMYK**, with text in the safe area. AI first outputs the highest-resolution square, then upscale to 3000².
- **Real / living subjects**: **don't rely on a recognizable face by default** — use the throughline object, a hand/back-of-figure or other crop, or illustration (this both sidesteps likeness rights and works because AI can't actually render a specific real person); a genuine portrait of the person requires family authorization. Abstract sensitive imagery per guide §27.
- **Interactive mode** may use `AskUserQuestion` to have the user pick 1 main cover (the rest kept as alternates); **auto mode** picks the one best fitting the album's character and explains why.

Write the 3 style designs and prompts into the cover section of the album-plan document (the template already includes it). **If you want to actually generate the image** (Production, not pure Design), use the helper script `scripts/gen_cover.py` (UV + Python 3.12, multi-provider/multi-model, default `grsai:gpt-image-2`).

**Zero-config environment (prerequisite: uv is installed)**: the script carries an inline PEP 723 dependency block (`certifi`+`pillow`), so the first `uv run` will **auto-lock Python 3.12 and install the deps**, with no setup. **Run it inside the working directory** and images land in `{working dir}/covers/` (the script defaults to `--out-dir covers`):

```
cd {working dir} && uv run {skill}/scripts/gen_cover.py "<prompt>" -o covers/these-hands-A-still-life.png
```

> Note: the above **runs by path from the working directory**, with the env bootstrapped by the script's inline block — this is the recommended path. If you want a reproducible, lockable persistent env (e.g. for IDE/contributor use), `scripts/` also ships a `pyproject.toml` + `uv.lock` + `.python-version`; run `uv sync` once in that directory to set up `.venv`, then `uv run python gen_cover.py …`. The two paths have identical dependencies.

`--list` shows the available `provider:model`, keys are read from environment variables (GRSAI_API_KEY/GOOGLE_API_KEY/OPENAI_API_KEY). The script **defaults to `--upscale 3000`** (Lanczos upscaling to the streaming master; change the value or `0` to disable), with built-in PNG validation + retry. **Put all output images in the target project's (working) directory — don't scatter them elsewhere.**

### Step 7: QA Report (a fresh-eyes subagent's adversarial re-check)

**Dispatch an independent subagent for a fresh-eyes re-check** — give it only the final album plan + the engine's QC chapters (§31/§32/§33), **without the "I just wrote this" self-endorsement bias**. Like the editor standing behind the author, it owns product quality with a critical eye and would rather over-report problems. Check each item and give a verdict (pass / needs fix / risk):

- **Catchy / smooth (a first-class item, ahead of tidiness)**: is each track smooth, catchy, sing-along-able, with a melodic hook (can the hook be hummed); **the second lead is verified primarily by this**
- **Lead-single anchor**: are there 1–2 "this is about me" emotional moments; has the killer line been dulled by rhyme (self-check against the "minimalist held-back version")
- 倒字 / Chinese singability re-checked per track; does the hook hold up, short and repeatable
- **Parallel-couplet density**: is the chorus densely paved with parallel couplets, or has it degraded into "colloquial prose with line breaks"
- **Were the three passes actually done**: does each lyric version have a polish log, are there real iteration traces (not a one-shot draft with a label slapped on)
- **Bare-space violations**: are in-line breath points done with punctuation/line breaks, any bare spaces used as pauses (never allowed)
- Is every chorus written out in full, any "(repeat)" violation; are metatags all in English, any Chinese parenthetical notes in the lyric body
- Is each Style 4–7 descriptors, **are the three vocal layers up front, is the key marked**, any mutually conflicting descriptors; any misuse of an artist name / reproduction of a famous song
- Prosody form-meaning match (does structure match emotion); album consistency (Persona / style family / thematic motif running through)
- Does the emotional arc and track order hold up; is total runtime in the 26–30 minute range
- Is the genre-confidence expectation noted (opera/folk-instrument and other low-confidence cases only promise "approximate flavor")
- **The 3 cover styles**: genuinely divergent (not reskins), subject anchored to the throughline image/personal anchor, color and typography matching the emotional tone and Persona character, negative space left for the overlaid title, specs met (3000×3000 1:1); any platform logo/artist name wrongly stuffed into the prompt
- Sensitive / ethical handling adequate (real person; including whether the cover used an unauthorized likeness of a real person)
- Word-level polish: rare characters, mixed CJK-and-alphanumeric, **breath points (punctuation/line breaks, not bare spaces)**, colloquial feel; **is the strongest anchor in the chorus**, any section over-filled by formula/over-written, are the lyrics on the long side

**Honestly mark the boundary**: the plan stage is pure text — **the actual sound of 倒字, AI artifacts, pitch, dynamics, etc. can only be settled after Suno rolls and a listen** — list these separately as "to be verified at the listening stage," and don't pretend to have verified them on text.

End with an **overall QA verdict** + a **prioritized list of suggested rework items**. Write into a standalone file `qa-report-{album}-{model name}.md`. **Report only, no automatic rework** — whether to rework is the user's call.

### Step 8: Creation Summary (a project-level retrospective)

Write an **overall project summary** (a separate thing from the QA report, its own file): review the whole creation process, list the key points of each step (ingestion status, the chosen direction and why, the album blueprint highlights, an overview of the lead/second lead and base tracks, **why each track's selected lyric version was picked**, **the 3 cover styles and the chosen direction**), and **come clean about the problems along the way** — which material was ignored, whether the selection had gaps or bias, how sensitive content was handled, where compromises were made. Write into `creation-summary-{album}-{model name}.md`.

### Step 9: Save and deliver

All final outputs are stored in the working directory, each with a version-header comment at the top `<!-- Ver YYYY-MM-DD HH:MM, by {model name} -->`:

- **The album plan** (the main output, each track's selected version, **including the cover's 3-style design and prompts section**): `album-plan-{album}-{subject}-{model name}.md`
- **Candidates and polish** (3 candidate titles / multiple lyric versions / three-pass polish logs / 3 album-name candidates): `candidates-and-polish-{album}-{model name}.md`
- **QA report**: `qa-report-{album}-{model name}.md`
- **Creation summary**: `creation-summary-{album}-{model name}.md`
- **Cover images** (if actually generated): **stored in the working directory's `covers/` subfolder** (in the same project directory as the rest of the outputs, don't scatter them); the chosen main cover + alternates, named `{album}-{style}.png`, streaming master 3000×3000.
- Keep the intermediate files too (material distillation, creative direction, album blueprint [including the creative contract card]).

## Hard writing discipline (violations will directly ruin the Suno output)

> The foundation is just two principles — **signal over noise + layered control** (guide §2): write only what Suno can parse into sound, put the strongest signal in the most prominent spot, and place each intent on its most reliable control layer. Everything below is a corollary; when unsure, return to the principles.

- **Write every chorus out in full**: write out every chorus where it appears, **never "(repeat)" or "same as above"** — Suno generates literally.
- **Chorus = the strongest signal spot**: the chorus repeats most, so **put the most anchored (personal image), most impactful words in the chorus**; the verse handles "why/setup," the chorus is responsible for "being remembered."
- **Lock the rhyme + dense parallel couplets (the #1 lever for Chinese sounding "like a song")**: each chorus **locks one rhyme category to the end** (the thirteen rhyme categories of New Chinese Rhyme — 中华新韵十三辙), the verse rhymes on even lines; **the chorus defaults to densely paved parallel couplets (对仗)** (paired lines with matching structure and opposed imagery, e.g. "一碗甜粥／一缕晨光," "风吹不熄／雨打不凉"), and verses bury couplets as needed. Even line length (≤ ~10–12 chars), cut colloquial connectives. **Better tidy and densely paralleled than "colloquial prose with line breaks"** (guide §9.1). But **tidiness serves "catchy and pleasant"**: when the rhyme-lock/couplets force something stiff and tongue-twisting, or say everything for the listener, return to Prosody — being pleasant is itself an emotional carrier, so loosen a notch and favor negative space (especially on the lead's anchor lines).
- **Use punctuation and line breaks for in-line rhythm, not bare spaces**: Suno reads punctuation/line breaks as breath instructions (period = breath and reset, comma = short pause, … = lingering hold, hyphen = drawn-out, line break = a longer pause, blank line = instrument continues while vocals stop); **in-line bare spaces are unreliable and often swallowed in connected reading**. Lines should be ≤ ~10–12 chars, split long lines, don't cram.
- **All performance/arrangement cues go in English square-bracket metatags** (`[Verse: breathy, sparse]`, `[Chorus: full band, erhu accent]`), **the lyric body keeps only the words to be sung**; **strictly no Chinese parenthetical notes** (e.g. "(softly)") — Suno will sing them as lyrics.
- **Each Style is 4–7 descriptors, three vocal layers first**: timbre + delivery + production (§15.4) go at the start of Style; you may add the **key** (`in A minor`) to boost album consistency (§15.5); name core instruments (for Chinese folk instruments use specific names like erhu/guzheng/pipa/dizi).
- **Don't reproduce famous songs, don't write artist names** (filtered/banned, and an artist name is a placebo): treat the target singer as internal reference, **translate them into the three vocal-layer descriptors** before writing; do only "evocative likeness + original lyrics."
- **Add or cut sections by function, don't fill the whole formula, don't fill every section**: the classic template is a toolbox, not a fill-in-the-blank; if 3 sections say it clearly, don't write 5; **lyrics: simpler over fuller** (form follows emotion).
- **Don't write chord progressions into the lyric body** (they'd be sung as lyrics); to influence harmony use "mode + key + mood + genre," and put chord progressions only at the end of Style as a low-expectation supplement (§15.5).
- **Complete structure tags**: `[Intro]…[Verse 1]…[Chorus]…[Bridge]…[Outro][End]`, with `[End]` to prevent a trailing tail.

## References (read on demand, progressive disclosure)

- `references/album-creation-guide.md`: the complete methodology engine (Album Creation Guide v3.5). **Read the relevant chapters before creating in Steps 3–4** (the two underlying principles §2, emotion→lever §3/§18, lyrics Part II [tidiness §9.1], music Part III, Suno practice Part IV [three vocal layers §15.4, key/chords §15.5, Style §21, punctuation-as-rhythm §22], the prompt framework Part V, QC Part VI, genre confidence §26). **Per-track subagents by default read only the Step 3 creative contract card and aren't forced to read the whole thing**; read a given § by path when a deep dive is needed; **for Step 6 cover design read §36 (the cover = Prosody at the visual layer)**. Suno and image-model capabilities change by version — verify against the current version before hands-on work.
- `references/album-plan-template.md`: the structural skeleton and placeholders for the final plan. **Fill in by this structure from Step 3 on**, replacing each `{…}` placeholder, deleting inapplicable optional sections (e.g. delete the "real-person note" if not a real person). The template gives only the form; content and style all come from the material distillation.

When everything is done, brief the user: where the working directory is, which files were generated (the album plan [including the 3 cover styles] / candidates and polish / QA report / creation summary + intermediate files), which two tracks are the lead and second lead, **the chosen cover direction**, **the suggested rework items in the QA report** and **the ignored/incomplete material in the creation summary**, and make clear: **whether to rework is the user's decision, the skill does no automatic rework**. For real-person material, additionally remind them to "have the family confirm before delivering the finished work."
