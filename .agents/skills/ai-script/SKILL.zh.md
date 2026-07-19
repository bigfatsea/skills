---
name: ai-script
description: "Call local AI-service CLI ai-script for real generation and retrieval tasks: LLM text (multi-provider second opinions, vision, consult mode), TTS speech synthesis, STT/ASR transcription, text-to-image / image-to-image, music generation, video generation, Tavily web search, OpenAlex scholar search, Firecrawl scraping, and local image resizing. Use when the user asks to 生成图片/配图、合成语音/朗读、转录音频、生成音乐/歌曲、生成视频、问另一个模型/多模型会诊、搜索网页/论文、抓取网页, or when a task needs actual media generation rather than code. Not for local code editing, git, or tasks with no external AI/service call (except resize, which is local)."
---

<!-- Ver 2026-07-19 05:00, by Claude Sonnet 5 -->

# ai-script — 统一 AI 服务 CLI

本机已安装的多能力 AI CLI,仓库位于 `~/code/ai-script`。所有 API Key 读系统环境变量,无需配置。

## 何时使用

| 需求 | 子命令 |
|------|--------|
| 调用外部 LLM:第二意见、视觉识图、多模型会诊(`--consult`)、需要特定模型(如 deepseek/glm/gemini) | `llm` |
| 文本转语音(播报、朗读、配音) | `tts` |
| 音频转文字(转录、字幕) | `stt` |
| 文生图 / 图生图(参考图) | `image` |
| 音乐/歌曲生成(有词或纯音乐) | `music` |
| 视频生成(文生视频 / 首帧图生视频) | `video` |
| 网页搜索(结构化摘要) | `search` |
| 学术论文搜索(OpenAlex) | `scholar` |
| 网页抓取为 Markdown(支持 JS 渲染) | `scrape` |
| 图片等比缩放(纯本地,无 API) | `resize` |

**不要用于**:本地代码任务、文件处理、git 操作,以及当前会话内自己就能完成的推理/写作(不必为普通文本任务调 `llm`)。搜索/抓取类若会话内已有更直接的工具(如 firecrawl skill),按当时上下文择优即可,ai-script 是稳定可脚本化的备选路径。

## 如何调用

```bash
cd ~/code/ai-script && ./ai-script <subcommand> ...
```

`./ai-script` 是仓库根目录的包装脚本,自动 source `~/.zshrc` 加载 API Key,再执行 `uv run ai-script`。**必须先 cd 到该仓库目录**(wrapper 内部是 `uv run`,依赖 cwd 定位项目,直接用绝对路径从别处调用会报 `Failed to spawn: ai-script`)。输出文件路径用绝对路径指定,避免产物落在 ai-script 仓库里。

**参数不确定时,先按需读指南,不要凭记忆猜 flag**:

```bash
./ai-script guide <subcommand>   # 单命令完整指南(选项/环境变量/示例)
./ai-script <subcommand> --list  # 列出该命令可用 provider:model 组合(及音色等)
./ai-script check --no-network   # 排错时:检查环境变量是否配齐
```

**`check` 报非 0 退出码就先停下**:它会检测目标 provider 的 API Key/环境变量是否配齐,失败通常意味着后续生成类调用大概率会在长 timeout 后才报错。`check` 失败时,先把缺失项告知用户,不要直接接着跑 `image`/`video` 等昂贵调用去"试试看"。

### `-e/--engine` 一个参数选 provider+model

生成类命令(llm/tts/stt/image/music/video)统一用 `-e <provider>:<model>`;只给 provider 用其默认模型;完全省略用命令默认值。model 部分不做强校验,openrouter/doubao 可传任意开放模型 ID。

默认值:`llm`=deepseek:deepseek-v4-flash · `tts`=minimax:speech-2.8-hd · `stt`=doubao(唯一) · `image`=grsai:gpt-image-2(唯一 provider) · `music`=minimax:music-2.6 · `video`=minimax:MiniMax-Hailuo-2.3(唯一)

**优先使用默认参数**——各命令默认值已按常见场景调优,只在跑不通或输出不符预期时才调参。

## 输出约定(如何判读结果)

- **stdout = 结果**(文件路径 / 转录文字 / LLM 回复 / Markdown),**stderr = 进度**。捕获 stdout 即拿到产物路径。
- **exit 0** 成功;**exit 1** 执行失败(API 报错/超时/参数校验)——命令语法没错,可换参数或直接重跑;**exit 2** 用法错误(非法 flag/取值)——先 `guide <cmd>` 修正命令再重试,原样重跑无意义。

## 实操要点(容易踩的坑)

**延迟与 Bash timeout**:生成类命令慢是常态,不是卡死。给 Bash 工具设足 timeout:

| 命令 | 实测耗时 | 建议 |
|------|---------|------|
| `image` (grsai) | 正常 20–60s;高峰限流下实测 **511s** | timeout ≥ 600s;高峰期加 `--retries 2`(唯一有内置重试的命令) |
| `video` 768P/6s | ~80–90s | timeout ≥ 300s |
| `video` 1080P/6s | ~170s | timeout ≥ 480s;或 `--no-wait` 拿 task_id 稍后 `--task <id>` 取回 |
| `music` minimax | ~35s(同步) | 必须 `--lyrics`(缺词直接 exit 1) |
| `music` sunoapi | ~125–185s(轮询) | **固定产出 2 首**,`-o song.mp3` → `song_1.mp3`/`song_2.mp3`,两路径逐行打印 |
| `tts`/`stt`/`llm` | 秒级到几十秒 | 默认 60s 超时通常够 |

video/music 无内置重试,失败直接 exit 1,重跑命令即可。

**长 prompt 用 `--stdin`**:prompt 含引号/换行/很长时,`echo "..." | ./ai-script image --stdin -o out.png` 比位置参数安全。

**图片输入自动缩到 512px**:`llm -a`、`image -r`、`video --frame` 的本地图片默认缩小长边至 512px 省 token;需要原图(如 1080P 视频首帧)加 `--no-resize`。

**stt 只吃 WAV**:mp3/mp4 先转:`ffmpeg -i in.mp4 -ar 16000 -ac 1 out.wav -y`。专有名词多时加 `--hotwords "词1 词2"`。

**批量任务用 `--batch`**(image/tts/music/video 支持):`tasks.jsonl` 每行一个 JSON 对象,字段名与命令选项一一对应,`prompt|text|style`+`output` 必填。严格串行、逐条写入 `<tasks>.result.jsonl`、中断重跑自动跳过已成功任务。**先 `--dry-run` 校验格式**再真跑;整批耗时 ≈ 单任务耗时 × N,长批次用 Bash `run_in_background`。

## 常用组合(管道)

```bash
# 搜索/抓取 → LLM 总结
./ai-script search "查询词" -n 8 | ./ai-script llm "基于以上结果写简报" --stdin
./ai-script scrape "https://..." | ./ai-script llm "总结这篇文章" --stdin

# 多模型会诊(难题求救)
./ai-script llm "这个 bug 怎么解" --consult

# 视觉识图
./ai-script llm "描述这张图" -a screenshot.png

# 异步视频(适合长流程)
TASK=$(./ai-script video "描述" --no-wait)
./ai-script video --task "$TASK" -o result.mp4
```
