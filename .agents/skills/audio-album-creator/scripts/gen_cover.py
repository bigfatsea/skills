# /// script
# requires-python = ">=3.12"
# dependencies = ["certifi", "pillow"]
# ///
# Ver 2026-06-22, by Claude Opus 4.8
"""gen_cover.py — 多供应商/多模型 CD 封面图像生成器（audio-album-creator 辅助工具）。

依赖 certifi + pillow（已写入下方 PEP 723 内联块与同目录 pyproject.toml）。
用 UV 运行（自动锁 Python 3.12、自动装依赖，无需先 setup）：

    uv run gen_cover.py "<英文提示词>"                         # 默认 grsai:gpt-image-2
    uv run gen_cover.py "<prompt>" -m grsai:nano-banana-2
    uv run gen_cover.py "<prompt>" -m google:gemini-2.5-flash-image -o coverA.png
    uv run gen_cover.py "<prompt>" -m openai:gpt-image-2 --size 1024x1024
    uv run gen_cover.py --prompts-file prompts.txt --out-dir ./covers --prefix 这双手
    uv run gen_cover.py --list                                 # 列出可用 provider:model

模型用 `provider:model` 指定，默认 grsai:gpt-image-2。密钥从环境变量读取：
    grsai  → GRSAI_API_KEY   (base 可用 GRSAI_BASE_URL 覆盖，默认 https://api.grsai.com)
    google → GOOGLE_API_KEY
    openai → OPENAI_API_KEY

输出：保存 PNG/JPEG，并校验确为有效图像（magic bytes + 尺寸）；失败非零退出。
注意：本工具只解决"提示词→封面图"。流媒体母版需 3000×3000，多数模型出 1024²，放大另做（见 --note）。
"""
from __future__ import annotations
import argparse
import base64
import io
import json
import os
import re
import ssl
import struct
import sys
import time
import urllib.error
import urllib.request

import certifi
from PIL import Image

DEFAULT_MODEL = "grsai:gpt-image-2"
# uv 托管的独立 Python 无系统 CA，用 certifi 提供 CA bundle，否则 TLS 校验失败
_SSL = ssl.create_default_context(cafile=certifi.where())

# 可用组合目录（用于 --list 与校验提示；非穷举，新模型同 provider 可直接传名字）
CATALOG: dict[str, list[str]] = {
    "grsai": ["gpt-image-2", "nano-banana-2", "nano-banana", "nano-banana-pro", "gpt-image-1.5"],
    "google": ["gemini-2.5-flash-image", "gemini-3.1-flash-image", "gemini-3-pro-image",
               "nano-banana-pro-preview", "imagen-4.0-generate-001"],
    "openai": ["gpt-image-2", "gpt-image-1", "gpt-image-1-mini", "gpt-image-1.5"],
}
RETRYABLE_STATUS = {429, 500, 502, 503, 504}


# ---------------- HTTP 基础 ----------------
def _env(name: str) -> str:
    v = os.environ.get(name)
    if not v:
        raise RuntimeError(f"环境变量 {name} 未设置")
    return v


def _post_json(url: str, headers: dict, payload: dict, timeout: int) -> dict:
    body = json.dumps(payload).encode("utf-8")
    h = {"Content-Type": "application/json", **headers}
    req = urllib.request.Request(url, data=body, headers=h, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=_SSL) as r:
            return json.loads(r.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        detail = e.read().decode("utf-8", "replace")[:500]
        raise RuntimeError(f"HTTP {e.code}: {detail}") from e


def _get_bytes(url: str, timeout: int) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "gen_cover/1.0"})
    with urllib.request.urlopen(req, timeout=timeout, context=_SSL) as r:
        return r.read()


# ---------------- 各 provider 出图 → 返回图像 bytes ----------------
def gen_grsai(model: str, prompt: str, opt: dict, timeout: int) -> bytes:
    # 兼容 GRSAI_BASE_URL 写成裸 host 或带 /v1 后缀两种形式，统一拼出 .../v1/api/generate
    base = os.environ.get("GRSAI_BASE_URL", "https://api.grsai.com").rstrip("/")
    if base.endswith("/v1"):
        base = base[:-3]
    payload = {"model": model, "prompt": prompt, "images": [], "replyType": "json"}
    if "nano-banana" in model:
        payload["aspectRatio"] = opt["aspect"]
        payload["imageSize"] = opt["image_size"]
    else:  # gpt-image 等用像素比
        payload["aspectRatio"] = opt["size"]
    resp = _post_json(f"{base}/v1/api/generate",
                      {"Authorization": f"Bearer {_env('GRSAI_API_KEY')}"}, payload, timeout)
    status = resp.get("status")
    if status and status != "succeeded":
        raise RuntimeError(f"grsai status={status}: {json.dumps(resp, ensure_ascii=False)[:300]}")
    urls = [r["url"] for r in resp.get("results", []) if r.get("url")]
    if not urls and resp.get("url"):
        urls = [resp["url"]]
    if not urls:
        raise RuntimeError(f"grsai 响应无图片 url: {json.dumps(resp, ensure_ascii=False)[:300]}")
    return _get_bytes(urls[0], timeout)


def gen_google(model: str, prompt: str, opt: dict, timeout: int) -> bytes:
    url = (f"https://generativelanguage.googleapis.com/v1beta/models/"
           f"{model}:generateContent?key={_env('GOOGLE_API_KEY')}")
    payload = {"contents": [{"parts": [{"text": prompt}]}],
               "generationConfig": {"responseModalities": ["IMAGE"]}}
    resp = _post_json(url, {}, payload, timeout)
    if "error" in resp:
        raise RuntimeError(f"google: {resp['error'].get('message')}")
    for part in resp.get("candidates", [{}])[0].get("content", {}).get("parts", []):
        if "inlineData" in part:
            return base64.b64decode(part["inlineData"]["data"])
    raise RuntimeError(f"google 响应无图: {json.dumps(resp, ensure_ascii=False)[:300]}")


def gen_openai(model: str, prompt: str, opt: dict, timeout: int) -> bytes:
    payload = {"model": model, "prompt": prompt, "size": opt["size"], "n": 1}
    resp = _post_json("https://api.openai.com/v1/images/generations",
                      {"Authorization": f"Bearer {_env('OPENAI_API_KEY')}"}, payload, timeout)
    if "error" in resp:
        raise RuntimeError(f"openai: {resp['error'].get('message')}")
    d = resp["data"][0]
    if d.get("b64_json"):
        return base64.b64decode(d["b64_json"])
    if d.get("url"):
        return _get_bytes(d["url"], timeout)
    raise RuntimeError(f"openai 响应无图: {json.dumps(resp, ensure_ascii=False)[:300]}")


PROVIDERS = {"grsai": gen_grsai, "google": gen_google, "openai": gen_openai}


# ---------------- 图像校验 ----------------
def image_info(b: bytes) -> tuple[str, int, int]:
    """返回 (格式, 宽, 高)；非图像抛错。"""
    if b[:8] == b"\x89PNG\r\n\x1a\n":
        w, h = struct.unpack(">II", b[16:24])
        return "PNG", w, h
    if b[:2] == b"\xff\xd8":
        i = 2
        while i < len(b) - 9:
            if b[i] != 0xFF:
                i += 1
                continue
            marker = b[i + 1]
            if marker in (0xC0, 0xC1, 0xC2, 0xC3):
                h, w = struct.unpack(">HH", b[i + 5:i + 9])
                return "JPEG", w, h
            i += 2 + struct.unpack(">H", b[i + 2:i + 4])[0]
    raise RuntimeError(f"返回内容不是有效图像（前 16 字节: {b[:16]!r}）")


def upscale_to(data: bytes, target: int) -> bytes:
    """用 Lanczos 把长边放大到 target 像素（保持宽高比），返回 PNG bytes。
    注：高质量重采样、非 AI 超分；用于把 AI 出图补到流媒体 3000² 母版规格。"""
    im = Image.open(io.BytesIO(data)).convert("RGB")
    w, h = im.size
    scale = target / max(w, h)
    im = im.resize((round(w * scale), round(h * scale)), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, format="PNG")
    return buf.getvalue()


# ---------------- 单次生成（含重试）----------------
def generate_one(model_spec: str, prompt: str, opt: dict, timeout: int, retries: int) -> bytes:
    if ":" not in model_spec:
        raise SystemExit(f"模型须写成 provider:model（如 {DEFAULT_MODEL}），收到: {model_spec!r}")
    provider, model = model_spec.split(":", 1)
    if provider not in PROVIDERS:
        raise SystemExit(f"未知 provider: {provider!r}；可用: {', '.join(PROVIDERS)}")
    fn = PROVIDERS[provider]
    last = None
    for attempt in range(retries + 1):
        try:
            data = fn(model, prompt, opt, timeout)
            image_info(data)  # 校验
            return data
        except (urllib.error.URLError, TimeoutError) as e:
            last = e
        except RuntimeError as e:
            msg = str(e)
            if any(f"HTTP {s}" in msg for s in RETRYABLE_STATUS):
                last = e
            else:
                raise
        if attempt < retries:
            wait = 3 * (attempt + 1)
            print(f"  ⟳ 第 {attempt + 1} 次失败（{last}），{wait}s 后重试…", file=sys.stderr)
            time.sleep(wait)
    raise RuntimeError(f"{model_spec} 重试 {retries} 次仍失败: {last}")


def _slug(s: str) -> str:
    return re.sub(r"[^\w.-]", "_", s)


def main() -> int:
    ap = argparse.ArgumentParser(description="多供应商/多模型 CD 封面生成器",
                                 formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
    ap.add_argument("prompt", nargs="?", help="英文提示词（与 --prompts-file 二选一）")
    ap.add_argument("-m", "--model", default=DEFAULT_MODEL, help=f"provider:model（默认 {DEFAULT_MODEL}）")
    ap.add_argument("-o", "--out", help="单图输出路径（默认 封面/cover_<model>.png，落在当前工作目录下）")
    ap.add_argument("--prompts-file", help="批量：每行一条提示词（# 开头忽略）")
    ap.add_argument("--out-dir", default="封面",
                    help="输出目录（默认 ./封面/——在项目目录里运行即落到项目下）")
    ap.add_argument("--prefix", default="cover", help="批量文件名前缀")
    ap.add_argument("--aspect", default="1:1", help="grsai nano-banana / 通用宽高比（默认 1:1）")
    ap.add_argument("--image-size", default="1K", help="grsai nano-banana 分辨率档 1K/2K/4K（默认 1K）")
    ap.add_argument("--size", default="1024x1024", help="openai / grsai gpt-image 像素尺寸（默认 1024x1024）")
    ap.add_argument("--upscale", type=int, default=3000,
                    help="放大长边到此像素（Lanczos 重采样；默认 3000=流媒体母版；0=不放大保持原生）")
    ap.add_argument("--timeout", type=int, default=300, help="单次请求超时秒（默认 300；gpt-image-2 较慢）")
    ap.add_argument("--retries", type=int, default=1, help="失败重试次数（默认 1）")
    ap.add_argument("--list", action="store_true", help="列出已知 provider:model 后退出")
    args = ap.parse_args()

    if args.list:
        print("已知 provider:model（同 provider 的新模型可直接传名字）：")
        for prov, models in CATALOG.items():
            for m in models:
                tag = "  ← 默认" if f"{prov}:{m}" == DEFAULT_MODEL else ""
                print(f"  {prov}:{m}{tag}")
        print("\n密钥：GRSAI_API_KEY / GOOGLE_API_KEY / OPENAI_API_KEY")
        return 0

    opt = {"aspect": args.aspect, "image_size": args.image_size, "size": args.size}

    # 收集任务
    tasks: list[tuple[str, str]] = []  # (prompt, out_path)
    if args.prompts_file:
        with open(args.prompts_file, encoding="utf-8") as f:
            lines = [ln.strip() for ln in f if ln.strip() and not ln.lstrip().startswith("#")]
        for i, p in enumerate(lines, 1):
            out = os.path.join(args.out_dir, f"{_slug(args.prefix)}_{i:02d}_{_slug(args.model)}.png")
            tasks.append((p, out))
    elif args.prompt:
        out = args.out or os.path.join(args.out_dir, f"cover_{_slug(args.model)}.png")
        tasks.append((args.prompt, out))
    else:
        ap.error("需提供 prompt 或 --prompts-file")

    rc = 0
    for prompt, out in tasks:
        print(f"▶ [{args.model}] → {out}\n  prompt: {prompt[:80]}{'…' if len(prompt) > 80 else ''}")
        t0 = time.time()
        try:
            data = generate_one(args.model, prompt, opt, args.timeout, args.retries)
        except Exception as e:
            print(f"  ✗ 失败: {e}\n", file=sys.stderr)
            rc = 1
            continue
        fmt, w, h = image_info(data)
        note = f"{fmt} {w}×{h}"
        if args.upscale and max(w, h) < args.upscale:
            data = upscale_to(data, args.upscale)
            _, w, h = image_info(data)
            note += f" → 放大 {w}×{h}"
        os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
        with open(out, "wb") as f:
            f.write(data)
        warn = "  ⚠ 仍低于 3000²" if min(w, h) < 3000 else ""
        print(f"  ✓ {note}, {len(data)} bytes, {time.time() - t0:.0f}s{warn}\n")
    return rc


if __name__ == "__main__":
    sys.exit(main())
