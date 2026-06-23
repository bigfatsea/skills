<!-- Ver 2026-06-24 00:21, by Claude Opus 4.8 -->

# Cover production: prompt-writing, specs, and the gen_cover.py script

The operational detail for Step 6. The cover *design* (cover = Prosody at the visual layer, 3 divergent styles drawn from the blueprint) lives in the SKILL Step 6 and guide §36; this file holds the **prompt-writing rules, output specs, and how to actually generate the image**.

## Prompt-writing rules

- **Two prompt styles**: Midjourney uses "subject + style/medium + lighting + color mood + composition" with `--ar 1:1` (≤ ~60 words); Nano Banana / GPT Image use natural-language sentences (Subject + Action + Scene + mood). **Always add `no text` / "do not render any text"** to the prompt, to stop the model from smearing fake letters into the space.
- **AI text rendering is unreliable**: prefer **overlaying the title in post** for the album name / subject name, or use a model strong at text rendering (Nano Banana Pro / GPT Image); don't count on Midjourney to spell the title right.

## Specs

- Streaming master **3000×3000, 1:1, sRGB, JPG/PNG**; for a physical CD, also produce **126×126mm (incl. 3mm bleed), 300 DPI (≥1417px), CMYK**, with text in the safe area. AI first outputs the highest-resolution square, then upscale to 3000².

## Generating the image (Production, not pure Design)

A pure-Design run stops at the prompts. To actually generate, use the helper script `scripts/gen_cover.py` (UV + Python 3.12, multi-provider/multi-model, default `grsai:gpt-image-2`).

**Zero-config environment (prerequisite: uv is installed)**: the script carries an inline PEP 723 dependency block (`certifi`+`pillow`), so the first `uv run` will **auto-lock Python 3.12 and install the deps**, with no setup. **Run it inside the working directory** and images land in `{working dir}/covers/` (the script defaults to `--out-dir covers`):

```
cd {working dir} && uv run {skill}/scripts/gen_cover.py "<prompt>" -o covers/these-hands-A-still-life.png
```

> Note: the above **runs by path from the working directory**, with the env bootstrapped by the script's inline block — this is the recommended path. If you want a reproducible, lockable persistent env (e.g. for IDE/contributor use), `scripts/` also ships a `pyproject.toml` + `uv.lock` + `.python-version`; run `uv sync` once in that directory to set up `.venv`, then `uv run python gen_cover.py …`. The two paths have identical dependencies.

`--list` shows the available `provider:model`, keys are read from environment variables (GRSAI_API_KEY/GOOGLE_API_KEY/OPENAI_API_KEY). The script **defaults to `--upscale 3000`** (Lanczos upscaling to the streaming master; change the value or `0` to disable), with built-in PNG validation + retry. **Put all output images in the target project's (working) directory — don't scatter them elsewhere.**
