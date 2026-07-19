---
name: ai-script
description: "Call the local AI-service CLI ai-script for real generation and retrieval tasks: LLM text (multi-provider second opinions, vision, consult mode), TTS speech synthesis, STT/ASR transcription, text-to-image and image-to-image generation, music generation, video generation, Tavily web search, OpenAlex scholarly search, Firecrawl scraping, and local image resizing. Use when the user asks to generate an image or illustration, synthesize or narrate speech, transcribe audio, generate music or a song, generate video, consult another model or multiple models, search the web or scholarly literature, scrape a webpage, or when a task requires actual media generation rather than code. Do not use for local code editing, Git, or tasks that require no external AI/service call, except local resizing."
---

<!-- Ver 2026-07-19 05:00, by Claude Sonnet 5 -->

# ai-script — Unified AI Service CLI

This machine has the multi-capability AI CLI installed at `~/code/ai-script`. All API keys are read from system environment variables; no configuration is required.

## When to use it

| Need | Subcommand |
|------|------------|
| Call an external LLM for a second opinion, image understanding, a multi-model consultation (`--consult`), or a specific model such as DeepSeek, GLM, or Gemini | `llm` |
| Convert text to speech for announcements, narration, or voice-over | `tts` |
| Convert audio to text for transcripts or subtitles | `stt` |
| Generate an image from text or from a reference image | `image` |
| Generate music or a song, with or without lyrics | `music` |
| Generate video from text or from a first-frame image | `video` |
| Search the web and return structured summaries | `search` |
| Search scholarly papers through OpenAlex | `scholar` |
| Scrape a webpage into Markdown, including JavaScript-rendered pages | `scrape` |
| Resize an image proportionally, entirely locally and without an API | `resize` |

**Do not use it for** local coding tasks, file manipulation, Git operations, or reasoning/writing that can be completed directly in the current session; ordinary text tasks do not justify an `llm` call. If the session has a more direct search or scraping tool, such as a Firecrawl skill, choose based on the current context. `ai-script` remains the stable, scriptable fallback.

## How to call it

```bash
cd ~/code/ai-script && ./ai-script <subcommand> ...
```

`./ai-script` is a wrapper at the repository root. It automatically sources `~/.zshrc` to load API keys, then runs `uv run ai-script`. **You must first change into the repository directory**: the wrapper uses `uv run`, which relies on the current working directory to locate the project. Calling the wrapper by absolute path from elsewhere fails with `Failed to spawn: ai-script`. Specify absolute output paths so generated files do not land in the `ai-script` repository.

**When uncertain about an option, read the relevant guide instead of guessing flags**:

```bash
./ai-script guide <subcommand>   # Full guide for one command: options, environment variables, and examples
./ai-script <subcommand> --list  # Available provider:model combinations, voices, and related choices
./ai-script check --no-network   # Troubleshooting: verify required environment variables
```

**Stop if `check` exits nonzero.** It verifies that the selected provider's API keys and environment variables are present. A failed check usually means a generation call will time out before reporting the same problem. Report the missing item to the user instead of attempting an expensive `image`, `video`, or similar call merely to see whether it works.

### One `-e/--engine` argument selects both provider and model

Generation commands (`llm`, `tts`, `stt`, `image`, `music`, and `video`) consistently use `-e <provider>:<model>`. Supplying only a provider uses that provider's default model; omitting the option uses the command default. The model component is not strictly validated, so OpenRouter and Doubao may receive any model ID they expose.

Defaults: `llm` = `deepseek:deepseek-v4-flash`; `tts` = `minimax:speech-2.8-hd`; `stt` = `doubao` (the only provider); `image` = `grsai:gpt-image-2` (the only provider); `music` = `minimax:music-2.6`; `video` = `minimax:MiniMax-Hailuo-2.3` (the only provider).

**Prefer the defaults.** Each command's defaults are tuned for common cases. Change them only if the default fails or does not fit the requested output.

## Output contract

- **stdout contains the result**: a file path, transcript, LLM response, or Markdown. **stderr contains progress.** Capture stdout to obtain the artifact path or response.
- Exit code **0** means success. Exit code **1** means an execution failure, such as an API error or timeout; change parameters or retry. Exit code **2** means a usage error caused by an invalid flag or value; read `guide <cmd>` and fix the command instead of repeating it unchanged.

## Operational notes and common pitfalls

**Latency and Bash timeouts:** generation is often slow and is not necessarily stuck. Set a sufficient Bash timeout:

| Command | Observed duration | Recommendation |
|---------|-------------------|----------------|
| `image` (grsai) | Usually 20–60 seconds; measured at **511 seconds** during peak throttling | Timeout ≥ 600 seconds; during peak periods add `--retries 2`, the only generation command with built-in retries |
| `video` at 768p/6s | About 80–90 seconds | Timeout ≥ 300 seconds |
| `video` at 1080p/6s | About 170 seconds | Timeout ≥ 480 seconds, or use `--no-wait` to get a `task_id` and retrieve it later with `--task <id>` |
| `music` with MiniMax | About 35 seconds, synchronous | `--lyrics` is required; omitting lyrics exits with code 1 |
| `music` with SunoAPI | About 125–185 seconds while polling | **Always produces two songs**. `-o song.mp3` creates `song_1.mp3` and `song_2.mp3`, with one path printed per line |
| `tts`, `stt`, or `llm` | Seconds to tens of seconds | The default 60-second timeout is usually sufficient |

`video` and `music` have no built-in retry. If either fails with exit code 1, rerun the command.

**Use `--stdin` for long prompts.** When a prompt contains quotation marks, line breaks, or substantial text, `echo "..." | ./ai-script image --stdin -o out.png` is safer than a positional argument.

**Image inputs are automatically resized to 512 px.** Local images passed to `llm -a`, `image -r`, or `video --frame` have their longest edge reduced to 512 px by default to save tokens. Add `--no-resize` when the original resolution is necessary, such as for a 1080p video's first frame.

**`stt` accepts WAV only.** Convert MP3 or MP4 first: `ffmpeg -i in.mp4 -ar 16000 -ac 1 out.wav -y`. If the source contains many proper nouns, add `--hotwords "term1 term2"`.

**Use `--batch` for bulk work.** The `image`, `tts`, `music`, and `video` commands accept a `tasks.jsonl` file with one JSON object per line. Field names match command options; `prompt|text|style` and `output` are required. Processing is strictly sequential, results are written incrementally to `<tasks>.result.jsonl`, and a restarted run skips completed entries. **Validate with `--dry-run` before starting the real batch.** Total duration is approximately per-item duration multiplied by item count; run long batches in the background through Bash.

## Common pipelines

```bash
# Search or scrape, then summarize with an LLM
./ai-script search "query" -n 8 | ./ai-script llm "Write a briefing based on the results above" --stdin
./ai-script scrape "https://..." | ./ai-script llm "Summarize this article" --stdin

# Ask all configured models for help on a difficult problem
./ai-script llm "How should I fix this bug?" --consult

# Image understanding
./ai-script llm "Describe this image" -a screenshot.png

# Asynchronous video generation for a long workflow
TASK=$(./ai-script video "description" --no-wait)
./ai-script video --task "$TASK" -o result.mp4
```
