<!-- Ver 2026-06-24 00:21, by Claude Opus 4.8 -->

# 封面生产：提示词写法、规格与 gen_cover.py 脚本

Step 6 的操作细则。封面*设计*（封面=视觉层 Prosody、从蓝图取料的 3 种分叉风格）在 SKILL Step 6 与框架 §36；本文件存**提示词写法、产出规格、以及怎么实际出图**。

## 提示词写法

- **提示词两套写法**：Midjourney 用"主体 + 风格/媒介 + 光线 + 色彩情绪 + 构图"并加 `--ar 1:1`（≤约 60 词）；Nano Banana / GPT Image 用自然语言句（Subject + Action + Scene + mood）。**提示词统一加 `no text`/"do not render any text"**，防模型自己糊假字母占掉留白。
- **AI 文字渲染不可靠**：专辑名 / 主角名优先**后期叠字**，或用文字渲染强的模型（Nano Banana Pro / GPT Image）；别指望 Midjourney 把标题拼对。

## 规格

- 流媒体母版 **3000×3000、1:1、sRGB、JPG/PNG**；若要实体 CD，另出 **126×126mm（含 3mm 出血）、300 DPI（≥1417px）、CMYK**、文字留安全区。AI 先出最高分辨率方形再放大到 3000²。

## 实际出图（Production，非纯 Design）

纯 Design 运行到提示词为止。要实际出图，用辅助脚本 `scripts/gen_cover.py`（UV + Python 3.12，多供应商/多模型，默认 `grsai:gpt-image-2`）。

**环境零配置（前提：已装 uv）**：脚本内含 PEP 723 内联依赖块（`certifi`+`pillow`），`uv run` 首次执行会**自动锁 Python 3.12 并装好依赖**，无需任何 setup。**在工作目录里运行**，图片即落到 `{工作目录}/covers/` 下（脚本默认 `--out-dir covers`）：

```
cd {工作目录} && uv run {skill}/scripts/gen_cover.py "<提示词>" -o covers/这双手-A写实静物.png
```

> 注：上面是**按路径从工作目录运行**，env 由脚本内联块自举——这是推荐路径。若想要一份可复现、可锁定的常驻 env（如 IDE/contributor 用），`scripts/` 下另备了 `pyproject.toml` + `uv.lock` + `.python-version`，在该目录执行一次 `uv sync` 即装好 `.venv`，之后可 `uv run python gen_cover.py …`。两条路径依赖一致。

`--list` 看可用 `provider:model`，密钥读环境变量（GRSAI_API_KEY/GOOGLE_API_KEY/OPENAI_API_KEY）。脚本**默认 `--upscale 3000`**（Lanczos 放大到流媒体母版，可改值或 `0` 关闭），自带 PNG 校验+重试。**所有产出图片放目标项目（工作）目录下，不要散落到别处。**
