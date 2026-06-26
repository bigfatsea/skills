<!-- Ver 2026-06-26 17:36, by Claude Opus 4.8 -->

# Per-track lyric craft kit

The creation kit handed to each per-track subagent in Step 4, **alongside the creative contract card and this track's dossier**. It operationalizes guide §14 (rewriting) and §15 (the seven-dimension model) into executable steps. A subagent obeys the contract card and this SKILL's "hard writing discipline"; it reads the engine guide (`references/album-creation-guide.md`) by path only when a deep dive is needed.

## For each lyric version, write out all of the following (seven dimensions, fully landed)

1. **Dimension 1, lyrics and narrative**: material anchor → imagery (express emotion through the concrete, not bluntly venting grief) → chorus hook (short, repeatable, personal image + universal emotion) → perspective (§6) → structural placement (private details into verses, deep emotion held back into the chorus).
2. **Dimension 2, emotion→lever** (§3/§18): set mode, tempo/meter, instrumentation, dynamics, vocals, and state for each value "why" it serves the emotion. The emotional arc (e.g. minor-key verse → major-key chorus) lands as in-section change in mode + dynamics.
3. **Dimensions 3–7**: style / song form and dynamic arc / rhythm / vocals / instrumentation.
4. **Suno Style field** (§21): 4–7 descriptors; **the three vocal layers (timbre + delivery + production) go first**, may add the **key** to boost consistency, name core instruments (for Chinese folk instruments use specific names like erhu/guzheng). Leave timbre to Style + Persona, and push the section-level vocal arc down to metatags. Attach Sliders (emotional song = Weirdness Safe + Style Influence Strong + Prompt Helper Off).
5. **Complete Chinese lyrics** (see the SKILL's "hard writing discipline"): put the strongest anchor in the chorus, use punctuation/line breaks for in-line breath points, don't fill every section just because the formula has one.
6. **Chinese singability / 倒字 self-check** (§13/§22): check the hook keywords and personal names one by one for zero 倒字, flag the long lines that need watching.

## Three-pass polish protocol (run on every track, base included)

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

> This protocol costs only text tokens and is the single highest-ROI fix for lyric quality. Keep the three-pass log alongside each lyric version, to be written into the "candidates and polish" appendix in Step 5.

## Extra forging for the lead / second lead (the cost is just a few extra lines of text)

Beyond the three-pass polish, the lead and second-lead subagents each do one more thing:

- **Dual-track killer-line face-off (lead only)**: produce the core hook as **both a "minimalist, held-back version" and a "full, tidy version"**, pit them head-to-head, and pick the better — **forcing the tension to survive, preventing it from being diluted by one-way tidying** (this is exactly the switch that fixes "a good line dulled by rhyme"). **Before the three tests, the killer line must pass the plain-reading** — its punch comes from the line actually reading, so if it's a Q&A the answer must sit on the question's axis (问"疼不疼" answered by a satisfaction verdict like "我非常满意" fails — answer the *pain* axis: "不疼了" / "值了" / "无怨无悔"). Then the pick passes three tests: the **delete-the-adjectives test** (would deleting it hit harder), the **negative-space test** (did it say everything for the listener), the **sing-along test** (could someone sing it back after one listen).
- **Three catchiness tests (lead + second lead)**: the catchy test / the sing-along test / **the melodic-hook test (can the hook be hummed)**. The second lead is verified primarily by this yardstick.

> Boundary: **killer-line negative space is used only on the lead's 1–2 anchor lines, not pushed across the whole song** — full-song negative space thins out the lyrics and instead hurts catchiness.
