<!-- Ver 2026-07-21 11:04, by Claude Sonnet 5 -->

# Cover design kit: input sources, prompt-writing, specs, and generation

The methodology engine for **Module C (Cover Design)** — usable standalone (Cover Only entry) or attached to an album or a single song. Cover art is Prosody at the visual layer (SKILL Core principles): subject imagery, color, typography, and composition all obey the same emotional intent as the music. Detailed cover-design principles live in guide §36; this file holds the **three input-source mapping, prompt-writing rules, output specs, and how to actually generate the image**.

## Three input sources, one mapping target

Module C always maps its input onto the same four visual elements — **subject imagery / color / typography / composition** — regardless of where the input came from:

- **Album context** (Full Album entry, after the stitched final draft, or Cover Only entry fed an existing `album-blueprint-*.md` / finished album file): source the four elements from the album's **throughline image + strongest personal anchor + emotional tone + style family + Persona character** — by this point the album name, throughline, Persona, and style family are locked.
- **Song context** (Cover Only entry fed a `song-*.md` output, or a Full Album track that needs its own single-cover variant): source the four elements from **that song's own imagery + its Suno style + its lyrics' emotional register** — there is no album-wide throughline to defer to, so the song's own strongest anchor line/image carries the composition.
- **Freeform context** (Cover Only entry fed nothing but a story or style brief, no prior blueprint or song artifact): extract the four elements directly from the brief the same way Step 1 distillation would, just at a lighter weight — enough to identify one concrete subject anchor, an emotional tone, and a style family, without producing a full material-distillation file.

Whichever source, **produce 3 genuinely divergent styles in one pass** (not reskins, echoing the three-sketch spirit of Module B / Module S): **photorealistic photography / hand-drawn illustration / abstract minimalism (or collage) are the default archetypes, swappable per the subject's character**, or the same subject in different color and typography — only the three need to genuinely diverge. For each write: ① a one-line visual concept; ② the four-element values; ③ a prompt that can be fed straight to an image model.

- **Subject = the throughline image / strongest personal anchor** (album or song context) or **the brief's own concrete anchor** (freeform context) — prefer a concrete object, sense-bound, don't use a generic abstract image; when the throughline can't be visualized, fall back to the anchor object. Leave **negative space for overlaying the title** in the composition, and the thumbnail (the streaming first image is tiny) needs a strong focal point and little information.
- **Real / living subjects**: don't rely on a recognizable face by default — use the throughline object, a hand/back-of-figure or other crop, or illustration (this both sidesteps likeness rights and works because AI can't actually render a specific real person); a genuine portrait of the person requires family authorization. Abstract sensitive imagery per guide §27.

## Prompt-writing rules

- **Two prompt styles**: Midjourney uses "subject + style/medium + lighting + color mood + composition" with `--ar 1:1` (≤ ~60 words); Nano Banana / GPT Image use natural-language sentences (Subject + Action + Scene + mood). **Always add `no text`/"do not render any text"** to the prompt, to stop the model from smearing fake letters into the space.
- **AI text rendering is unreliable**: prefer **overlaying the title in post** for the album name / subject name, or use a model strong at text rendering (Nano Banana Pro / GPT Image); don't count on Midjourney to spell the title right.

## Specs

- Streaming master **3000×3000, 1:1, sRGB, JPG/PNG**; for a physical CD, also produce **126×126mm (incl. 3mm bleed), 300 DPI (≥1417px), CMYK**, with text in the safe area. AI first outputs the highest-resolution square, then upscale to 3000².

## Generating the image (Production, not pure Design) — via `ai-script`

A pure-Design run stops at the prompts. To actually generate, use the `ai-script` CLI's `image` subcommand (already installed and configured on this machine — see the `ai-script` skill for the full reference); this skill no longer ships its own image-generation script, since `ai-script image` already covers the same providers (default `grsai:gpt-image-2`, plus Google/OpenAI/Nano Banana per `--list`).

**`ai-script` must be invoked from its own repository directory** (its wrapper uses `uv run`, which resolves the project from the current working directory) — **not** from the album's working directory. Point the output flag at an **absolute path** inside the album's working directory so the image lands there instead of inside the `ai-script` repo:

```
cd ~/code/ai-script && ./ai-script image "<prompt>" -o {absolute path to working dir}/covers/{name}-{style}.png -e grsai:gpt-image-2
```

- **Use `--stdin` for the prompt** if it contains quotes, line breaks, or is otherwise long (cover prompts often are): `echo "<prompt>" | ./ai-script image --stdin -o {absolute path}/covers/{name}-{style}.png`.
- **Check the environment first**: `./ai-script check --no-network` verifies the selected provider's API keys are present; don't attempt an expensive `image` call to find out a key is missing.
- **Timeouts**: `grsai` image generation is usually 20–60s but has been observed up to ~511s during peak throttling — use a Bash timeout ≥ 600s, and add `--retries 2` during peak periods.
- **3 covers = 3 separate calls** (one per style); for batch convenience `ai-script image` also accepts `--batch` with a `tasks.jsonl` file if generating many at once (see `ai-script guide image`).
- **Put all output images in the target project's (working) directory's `covers/` subfolder** — don't scatter them elsewhere.

**Interactive mode** may use `AskUserQuestion` to have the user pick 1 main cover (the rest kept as alternates); **auto mode** picks the one best fitting the subject's character and explains why.
