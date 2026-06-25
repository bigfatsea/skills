<!-- Ver YYYY-MM-DD HH:MM, by {model name} -->

# Album Plan "{album name}" — {subject/theme}

> **Nature of this file**: a complete original emotional album plan, created per the `Album Creation Guide` methodology and using `{material-distillation file}` as source material. {N} tracks ({tracks-with-lyrics} with lyrics{ + 1 instrumental}), every track's lyrics written out in full, every chorus repeated in full each time, all performance cues in English square-bracket metatags (no Chinese parenthetical notes in the lyric body — Suno would sing Chinese parentheticals as lyrics).
>
> **Real-person note (keep only when the subject is a real person, otherwise delete this paragraph)**: {subject} is a real person ({basic background}). This is a life album made for a real loved one, to be handled with dignity. **Sensitive-handling principles**: {list the sensitive content this album touches and how it's handled — political content rewritten as personal sensory imagery, overly dark plot points cut, the deceased requiring heir authorization, etc., per v3.5 §27}.

---

## 0. Album-level coordination

### 0.1 Concept, spine and emotional arc
State in one line what kind of album this is (perspective choice + core emotion) **and the spine — how the subject changed (the throughline)**. The **emotional curve** (valence over time) is the track order and shapes the tempo (tempo inverted-U, valence opposite; §34):

```
{node 1} → {node 2} → [{signature-track node} · signature track] → {descent node} → {closing node}
 {mood}     {mood}      {peak · tear-jerker}                          {descent}     {release · close}
```

> Put the signature track at the album's climax (center-back), leaving 1–2 tracks of descent and release after it.

### 0.2 Persona lock (v3.5 §24)
- **Main Persona "{lead-voice name}"**: {gender + register + timbre texture + delivery + production, per §15.4}. All first-person tracks across the album use this one voice.
- **Backup Persona "{backup-voice name}" (optional)**: {use — e.g. a second voice entering on one track for a duet or a hand-off}.
- Procedure: audition and lock the main voice on the signature track first, reuse it for the rest (Persona keeps the timbre, not the melody).

### 0.3 Thematic motif (v3.5 §34)
- **Lyric motif: "{throughline image}"** — the album throughline, recurring in tracks {x, x, x}, closing the loop in track {final track}.
- **Subplot image: "{subplot image}"**, echoed in tracks {x, x}.
- **Melodic motif**: the signature track's chorus melodic line, recurring in track {x}'s instrumental interlude / track {x}'s humming, forming an aural echo.

### 0.4 Style-family default + per-track genre variable (v3.5 §24/§34)
**Invariant binder (what makes it one album — not a uniform genre): Persona voice + thematic motif + unified key.** The style-family here is only the **default**: **"{style-family description}"**, {core instrumentation} as the base, {color instruments} for color, production **{production}**. **A track may swap genre / era-color to match its narrative beat** (the Genre column in 0.5 may differ per track — e.g. a faster, harder genre at a turning point, or a sound the listener associates with a moment via its era/place/event/cultural touchstone); heavy diversity → rely on Persona, not a Custom Model (§24).

### 0.5 Tracklist arrangement table

| # | Title | Subject | Genre | Mode | BPM/meter | Role | Persona |
|---|---|---|---|---|---|---|---|
| 1 | {title} | {subject} | {genre} | {major/minor} | {BPM} / {meter} | base | {main voice} |
| … | … | … | … | … | … | … | … |
| {signature #} | **{signature title}** | **{subject}** | … | **{minor→major}** | … | **lead (85+)** | {main voice} |
| {second-lead #} | **{second-lead title}** | {subject} | … | … | … | **second lead (80+ · sound-first)** | {main voice} |
| … | … | … | … | … | … | interlude (instrumental) | — |
| {final #} | {title} | {subject} | … | … | … | base · closing | {main voice (+ backup voice)} |

Target total runtime ≈ 26–30 minutes.

### 0.6 Delivery (v3.5 §35)
WAV master + 320k MP3; unified **-14 LUFS**; verify loudness and track order separately for the physical version; include the cover (see 0.7), tracklist, handwritten card. Commercial use requires Pro+ and checking the current terms. **Real material — have the family confirm before delivering the finished work.**

### 0.7 Cover design (3 style candidates · v3.5 §36)

> **Cover = Prosody at the visual layer**: subject/color/typography/composition share a source with the lyrics and music, reusing the above **throughline image "{throughline}" + strongest personal anchor "{anchor}" + emotional tone + style family + Persona character**. The three tiers below (photorealistic/illustration/abstract) are the **default archetypes, swappable per the album's character** (e.g. for a high-energy album swap in "dynamic collage / film-grain sense of speed"), only requiring the three to **genuinely diverge** (not reskins). For selecting 1 main cover, the rest kept as alternates.
> **How to set the subject**: if the throughline can go straight into the image, paint it; **if the throughline is abstract and can't be visualized** (e.g. "a sentence never said"), fall back to the **strongest personal-anchor object** (prefer a concrete object, sense-bound), don't force a literal abstract concept.
> **Real / living subjects**: **don't rely on a recognizable face by default** — use the throughline object, a hand/back-of-figure or other crop, or illustration (this both sidesteps likeness rights and works because AI can't actually render a specific real person); a genuine portrait of the person requires family authorization.
> **Specs**: streaming master **3000×3000 · 1:1 · sRGB · JPG/PNG**; for a physical CD also produce **126×126mm (incl. 3mm bleed) · 300 DPI (≥1417px) · CMYK**, with text in the safe area. **Avoid** platform logos / prices / URLs; leave negative space for the overlaid title in the composition; keep the thumbnail legible (strong focal point, little information).
> **AI text rendering is unreliable**: prefer **overlaying the title in post** for the album name "{album name}"{ + subject name}, or use a model strong at text (Nano Banana Pro / GPT Image); the prompts **already uniformly add `no text`** to stop the model from smearing fake letters into the space. Replace the `{…}` in the prompts for this album.

#### Style A · Photorealistic photography · still-life object (most sense-bound, object-anchored)
- **Visual concept**: {one line — e.g. "a close-up of the {throughline/anchor object} in {lighting}, {color tone}, negative space for the title"}
- **Four elements**: subject {throughline object / anchor object} | color {matching the emotional tone} | typography {serif/handwriting/sans — match the Persona character} | composition {close-up + rule of thirds + top-right negative space}
- **Midjourney**: `{subject object — the throughline / anchor object}, close-up still life, {photographic style, e.g. analog film / clean studio}, 35mm, {lighting}, {color palette}, shallow depth of field, centered focal point, negative space top-right for title, {mood}, no text, no lettering --ar 1:1 --style raw`
- **Nano Banana / GPT Image**: `A close-up still-life photograph of {subject object}, {lighting}, {color} palette, shallow depth of field, {mood}; leave clean negative space in the upper area for an album title; do not render any text; square 1:1, photorealistic.`

#### Style B · Illustration · hand-drawn (sidesteps real-likeness rights)
- **Visual concept**: {one line — e.g. "a watercolor hand-drawn {throughline image}, {lighting}"}
- **Four elements**: subject {an illustrated version of the throughline image} | color {watercolor wash, matching the tone} | typography {handwriting / rounded sans-serif, approachable} | composition {central image + large negative space}
- **Midjourney**: `{throughline image} illustration, soft watercolor and gouache, hand-painted storybook style, {color palette}, {lighting}, simple composition with generous negative space, {mood}, no text, no lettering --ar 1:1`
- **Nano Banana / GPT Image**: `A hand-painted watercolor illustration of {throughline image}, {color} tones, {lighting}, {mood}, minimal composition with empty space for a title; do not render any text; square 1:1.`

#### Style C · Abstract · minimalism/collage (mood carried by color and composition, typography-led)
- **Visual concept**: {one line — e.g. "convey emotion through color blocks and texture, the subject name in large typography"}
- **Four elements**: subject {an abstract symbol / texture / old-photo collage of the throughline} | color {two or three high-contrast colors or a monochrome scheme, matching the emotional arc} | typography {large type / geometric, dominating the frame} | composition {asymmetric / geometric division + a strong focal point}
- **Midjourney**: `abstract minimal album cover, {abstract image / geometric symbol of the throughline}, {two-or-three color palette, high contrast}, {textured paper / risograph / collage} aesthetic, bold asymmetric composition, lots of negative space, {mood}, no text, no lettering --ar 1:1`
- **Nano Banana / GPT Image**: `A minimalist abstract album cover evoking {emotion} through {color} color and {texture/geometric} forms, bold asymmetric layout with strong negative space for large title typography; do not render any text; square 1:1.`

- **Selected**: main cover = Style {A/B/C} (reason: {why it best fits the album's character}); the rest kept as alternates.

---

# Part One: The signature track (full-process demonstration, target 85+)

## {signature #}. "{signature title}" ★ signature track

> Do the signature track first and lock the Persona, then do the base tracks. This is the track of concentrated quality investment, and the source of the thematic motif. Target QC ≥ 9/10, must hold up to "the whole family listening through in silence."

### {x}.1 Dimension 1: lyrics and narrative (Part II)

| Sub-item | Content |
|---|---|
| Material anchor | {a specific object/event/catchphrase distilled from the material} |
| Imagery | {what concrete image carries what abstract emotion, not bluntly venting grief} |
| Chorus hook | **"{short, repeatable, personal image + universal emotion}"** |
| Narrative perspective | {first/second/third person, §6} |
| Structural placement | private details into the verse; universal deep emotion into the chorus |

### {x}.2 Dimension 2: emotion→lever mapping (§3, §18)
- Dominant emotion: {emotion}; intensity {n}/10.
- Emotional arc: **{repressed looking-back (verse, minor, meter) → released transcendence (chorus, turn to major, meter)}**.

| Lever | Value | Why |
|---|---|---|
| Mode | {minor verse → major chorus} | {the strongest emotional switch} |
| Tempo/meter | {BPM; 6/8→4/4} | {why} |
| Instrumentation | {from intimate to grand} | {why} |
| Dynamics | {weak start → burst → close} | {why} |
| Voice | {breathy verse → opened-up chorus → whispered tail line} | {why} |

### {x}.3 Dimensions 3–7

| Dimension | Value |
|---|---|
| 3 Style | {main style + color, production baseline} |
| 4 Form & dynamic arc | {Intro→V1→PreC→Chorus→…→Outro→End; one line of the dynamic curve} |
| 5 Rhythm | {BPM; meter; groove} |
| 6 Voice | {Persona · register, timbre, section emotional arc} |
| 7 Instruments | {core 3–4 pieces + section change} |

### {x}.4 Suno Style field (4–7 descriptors, §21)

```
{three vocal layers: timbre+delivery+production}, {genre subgenre}, {tempo/energy}, {core instruments}, {mood}, {optional in X major/minor}
```
({n} descriptors; **the three vocal layers go first** (§15.4), may add the **key** to gather consistency (§15.5); **name** folk instruments (erhu/guzheng…); artist name = a placebo → translate into descriptors. Push the section-level vocal arc down to each section's metatag.)
**Sliders**: Weirdness=Safe; Style Influence=Strong; Prompt Helper=Off (§23).

### {x}.5 Chinese lyrics (complete · every chorus written out in full)

> The section sequence below is **a template, not a checklist** — add/cut by emotional need (§7): if there's no need for tension, delete the Pre-Chorus; if 3 sections say it clearly, don't write 5; **put the strongest anchor in the chorus** (§11); **use punctuation/line breaks for in-line breath points, not bare spaces** (§22).

```
[Intro: {instrumental, atmosphere}]

[Verse 1: {breathy intimate, sparse, etc. English metatag}]
(private details, each line ≤ ~10–12 chars, last line = anchor line; **in-line breath points with commas/line breaks, not bare spaces**)
…

[Pre-Chorus: {strings enter, rising, etc.}]
(turn/question/energy lifting)
…

[Chorus: {full band, opened-up vocals, etc.}]
(short hook, repeatable, zero 倒字 — written out in full, don't write "repeat")
…

[Verse 2: {…}]
…

[Pre-Chorus: {…}]
…

[Chorus: {…}]
(identical text to the chorus above, written out word for word)
…

[Bridge: {piano only, vulnerable, etc.}]
(one new image, then back to the hook)
…

[Outro: {fade out / near-whisper, etc.}]
…

[End]
```

### {x}.6 Chinese singability / 倒字 self-check (§13, §22 · mandatory for the signature track)
- **hook keyword "{character}"** ({tone}) — placed at the {ascending/sustained} spot in the chorus, ensuring it's bright and stable. ✔
- 上声/去声 (rising/falling-tone) key characters checked one by one: {character} ({tone}) placed at {position} to avoid awkwardness/倒字. ✔
- **long hook line** "{line}" — on the long side, already broken at breath points with **punctuation/line breaks** (not bare spaces); if rolls come out muddy, split back into two lines. ⚠ watch closely
- the tail line must avoid being buried by instruments; `[End]` hard stop to prevent a trailing tail. ✔
- no rare characters, no mixed CJK-and-alphanumeric across the track; leave a breath point every two lines in the verse. ✔

### {x}.7 Production SOP and QC (signature-track route, §31)
- **Rolls**: N≥8; try {n} takes of a {register} Persona, pick the one closest to "{character's quality}" → lock the main voice (reused album-wide).
- **Fine-fix**: chorus Replace Section / Inpainting 2–3×; line-by-line check of key characters; confirm the tail line is clear separately.
- **QC (§32, target ≥9/10)**: focus on ⑤ the hook holds up, ⑥ the mode's emotional turn, ⑧ dynamic rise and fall, ② key characters not muddy, ③ a closing with no trailing tail.

---

# Part Two: The base, {N} tracks (streamlined process, target 60+, reusing the main voice)

> Follow the Persona and style family locked by the signature track, N=2–4 rolls, accept once it passes (§31, uneven quality investment). **Every chorus written out in full.**
>
> **The second lead** (the one marked in the tracklist) has the same structure as the base block below, but upgraded per the tiered investment: target 80+, sound-first, write 2 lyric versions, roll 2–3 styles for "ear-catching melody/style," and pass the "three catchiness tests" (catchy / sing-along / melodic hook). The lyrics only need to clear the bar, no need to force an emotional anchor.

## {#}. "{title}" — {subject} ({genre})

**Role**: base · {role in the emotional arc}. **Emotion→lever**: {dominant emotion}, {mode}, {BPM} {meter}, {core instrumentation}, {vocal delivery}; {what the verse writes, what the chorus writes}. **Thematic motif**: {how "{throughline}" appears in this track}.

**Suno Style**
```
{4–7 descriptors}
```

**Chinese lyrics**
```
[Intro: {…}]

[Verse 1: {English metatag}]
…
[Pre-Chorus: {…}]
…
[Chorus: {…}]
(written out in full)
…
[Verse 2: {…}]
…
[Chorus: {…}]
…
[Bridge: {…}]
…
[Final Chorus: {…}]
…
[Outro: {fade out}]

[End]
```
**倒字/QC**: {check the placement of key characters}; target 7/10, reusing the main voice.

---

## {#}. "{instrumental-interlude title}" — a negative-space interlude (instrumental, optional)

**Role**: interlude · a breath (pure instrumental, no vocals, letting the signature track's melodic motif recur once via {instrument}). **Emotion→lever**: {emotion}, {mode/pentatonic}, {BPM} {meter}.

**Suno Style**
```
{…} instrumental, {BPM}, {core instruments}, {mode}, {production}, {mood}
```
**Lyrics field**: leave empty (turn on the Instrumental switch).
**Note**: about 1:30–2:00. Structure: {ensemble start → mid-section solo recurs the signature track's chorus melody → ensemble close}.

---

(The remaining base tracks repeat the "base" block structure above, each written out in full.)

---

## Appendix: how this album implements the Album Creation Guide

| v3.5 point | How it shows up in this album |
|---|---|
| Signal over noise (§2) | {what noise was cut: artist names/bare spaces/over-filled sections; strongest anchor put in the chorus} |
| Layered control (§2) | {global sound → Style, section change → metatag, breath points → punctuation/line breaks} |
| Perspective and perspective change (§6) | {how it's used} |
| Sense-bound sourcing (§5) | {which real anchors were used} |
| Prosody, form matches meaning (§2) | {what tools for bitter/sorrow, what tools for release} |
| Emotion→lever (§3/§18) | mode/tempo/meter/instrumentation/voice marked per track |
| Three vocal layers + key (§15.4/§15.5/§21) | {voice timbre + delivery + production put first in Style; album-wide key} |
| Chorus = the strongest signal spot (§11) | {each chorus's anchor; chorus short, written out in full} |
| Punctuation is rhythm (§22) | {breath points with punctuation/line breaks, not bare spaces; lines ≤ ~10–12 chars} |
| Add/cut sections as needed (§7) | {which tracks dropped sections, didn't fill the whole formula} |
| Chinese 倒字 (§13) | 倒字 self-check per track; key characters watched closely on the signature track |
| One lead + one second lead (§31) | lead track {x} 85+ (narrative core + emotional anchor); second lead track {y} 80+ (ear-catching melody/style, sound-first); the rest base 60+ |
| Album consistency (§24/§34) | lock the main-voice Persona{; final track adds the backup voice} |
| Thematic motif (§34) | "{motif}" runs through track {x}; the melodic motif echoes in {x} |
| Arrangement and breath (§34) | signature track at the climax; instrumental interlude; final track a release close |
| Style 4–7 descriptors (§21) | each track's Style kept to ≤7 descriptors |
| Performance cues in English metatags (§22) | all in `[Verse: …]`; the lyric body keeps only the words to be sung |
| Genre confidence (§26) | lead with high-confidence genres; for low-confidence genres roll more, lower expectations |
| Sensitivity and ethics (§27) | {politics personalized, overly-dark cut, real-person confirmation} |
| Cover = Prosody at the visual layer (§36) | {main cover Style A/B/C; subject = throughline "{throughline}"; color matching the emotional tone; master 3000×3000 1:1} |

---

*Album "{album name}" — {subject/theme} · {N} tracks · two singles: lead "{signature title}" + second lead "{second-lead title}"*
*Material: {material-distillation file} · Methodology: Album Creation Guide*
*YYYY-MM-DD · by {model name}*
*Reminder: Suno capabilities change by version — verify Style/Persona/Section Replace etc. against the current version before hands-on work. Every chorus is already written out in full; do not revert to "(repeat)"-style notes.*
