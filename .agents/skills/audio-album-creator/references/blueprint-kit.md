<!-- Ver 2026-07-21 11:36, by Claude Sonnet 5 -->

# Album blueprint kit: material distillation and the three draft directions

The methodology engine for **Module B (Album Blueprint)**, used by the **Full Album** and **Blueprint Only** entry points (SKILL Step 1–2; Step 3 — the blueprint itself and the creative contract card — stays inline in the SKILL, since the contract card is the connective tissue Module S reads directly). All `§N` citations in this document refer to `references/album-creation-guide.md`.

## Step 1 detail: what `material-distillation-{subject}.md` must contain

> **Extraction principle: exhaust, don't pre-filter.** Record every emotion, personality trait, scene, and story beat that exists in the material — this file is the complete "material archive," not a curated shortlist for this album. If there are 10 anchors, list all 10; Step 2/3 will select. **Step 1 is the only stage in the whole pipeline that reads the full input** — information lost here is lost permanently.

The file contains:

- Character bio / timeline (key life milestones)
- **The core story** (synthesized narrative, not a verbatim quote): 300–600 words, written from the perspective of a songwriter. Faithfully reflect the material — don't embellish or invent uncertain details. Focus on: what kind of person the subject is, what key turning points they experienced, what moments carry the most emotional weight. Capture personality traits (speech patterns, ways of handling things, recurrent behavioral patterns). Flag implied subtext (things the material doesn't state but can reasonably infer, e.g. "repeatedly mentions X but never says Y — this may mean…"). For multi-subject or relationship albums, describe the core tension of the relationship.
- **Personal-anchor & golden-line list** (the crux of guide §5: objects, smells, catchphrases, scenes, key events — list each, the more specific the better; **tag verbatim catchphrases as hook-candidate vs. texture**, so downstream creation can land the 1–2 that hit hardest per beat rather than stacking quotes to use them up)
- **The spine + emotional curve** (guide §5): the subject's *arc* — how they changed (wanted vs. needed, the turning point) as the album throughline — plus a **valence-over-time curve** of the key beats (this curve drives track order and tempo in Step 3, guide §34). List bitter→sweet / loss→gain / parting→return etc. as candidate shapes.
- Family members and relationships, important dates (seeding later family-memory and repeat-purchase hooks; also serving the perspective choice)
- **Sensitive-content flags and handling plan** (which to abstract, which are too dark and must be cut)
- **Ingestion status** (what was read, what was ignored as unsupported, any obvious gaps) — to be cited in the creation summary
- **Raw stock for the creative contract** (groundwork for freezing the contract card in Step 3): draft three-layer vocal descriptors for Persona candidates, throughline image candidates, recurring-motif-word candidates, an initial gathering of usable anchors per track. This is just prep; formal locking happens in Step 3.

**If the current model or harness cannot ingest a material type** (e.g. audio isn't supported): don't get stuck and don't fabricate content — skip that material and, in the creation summary, explicitly record "such-and-such material was ignored because the model doesn't support it" so the user knows.

## Step 2 detail: how to draft 3 genuinely divergent directions

Based on the Step 1 distillation, offer 3 fundamentally different draft directions for the user to decide. The three should **genuinely diverge** (determined by the material's content, not reskins) along these dimensions:

- **Stylistic leaning** (e.g. neo-folk vs. lyrical soul vs. synth-pop — whatever genuinely diverges for this material);
- **Emotional tone** (e.g. the warmth of bitterness-released vs. the restrained ache of holding back vs. the lightness of serene clarity);
- **Story core / throughline** (which single image threads the whole album — e.g. "a kept ticket" vs. "a single lamp" vs. "the road home").

Give each draft (**only at "sketch" granularity — don't expand a full blueprint**, which is Step 3's job, to avoid 3× blueprint cost with 2 discarded):

- A one-line concept + the emotional-arc trajectory + **the arc's shape** (classic rising-action / spiral-introspective / gradual no-climax / fragmented — guide §5; whichever the material actually has)
- **Throughline image** + the recurring motif word
- **Rough tracklist outline** (6–8 tracks as the default — lean 6 for a short/single-facet story, 8 for a long/eventful one; fewer or more only if the material's real beat count calls for it; one line of subject per track)
- The candidate lead single's angle + **one sample hook line** (so the user gets a taste first)
- An embryonic style family

**Mark the most recommended one and spell out why** (why it best fits this material and has the most "breaking-point" potential).

Record "three sketches + recommendation rationale + final choice and notes" into the intermediate file `creative-direction-{subject}.md`.

## The same divergence method, applied at song grain (Module S standalone entry)

When Module S runs standalone (no album context), it borrows this exact divergence method but narrows the grain from "album" to "one song": instead of 3 album-wide sketches, it produces 3 song-wide lyric+style takes, diverging along the same kind of axes (stylistic leaning / emotional tone / story core) scaled down to a single song's material. See `references/song-writing.md` for the standalone spec.
