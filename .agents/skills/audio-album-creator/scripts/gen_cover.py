# /// script
# requires-python = ">=3.12"
# dependencies = ["certifi", "pillow"]
# ///
# Ver 2026-06-23, by Claude Opus 4.8
"""gen_cover.py — multi-provider/multi-model CD cover image generator (an audio-album-creator helper).

Depends on certifi + pillow (declared in the PEP 723 inline block below and in the
sibling pyproject.toml). Run with UV (auto-locks Python 3.12, auto-installs deps, no setup needed):

    uv run gen_cover.py "<English prompt>"                     # default grsai:gpt-image-2
    uv run gen_cover.py "<prompt>" -m grsai:nano-banana-2
    uv run gen_cover.py "<prompt>" -m google:gemini-2.5-flash-image -o coverA.png
    uv run gen_cover.py "<prompt>" -m openai:gpt-image-2 --size 1024x1024
    uv run gen_cover.py --prompts-file prompts.txt --out-dir ./covers --prefix these-hands
    uv run gen_cover.py --list                                 # list available provider:model

Pick the model with `provider:model`, default grsai:gpt-image-2. Keys are read from env vars:
    grsai  → GRSAI_API_KEY   (override the base with GRSAI_BASE_URL, default https://api.grsai.com)
    google → GOOGLE_API_KEY
    openai → OPENAI_API_KEY

Output: saves PNG/JPEG and verifies it really is a valid image (magic bytes + dimensions);
exits non-zero on failure.
Note: this tool only solves "prompt → cover image." A streaming master needs 3000×3000; most
models output 1024², so upscaling is handled separately (see --upscale).
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
# uv-managed standalone Python has no system CA; supply a CA bundle via certifi, else TLS fails
_SSL = ssl.create_default_context(cafile=certifi.where())

# Catalog of known combos (for --list and validation hints; not exhaustive — a new model on a
# known provider can be passed by name directly)
CATALOG: dict[str, list[str]] = {
    "grsai": ["gpt-image-2", "nano-banana-2", "nano-banana", "nano-banana-pro", "gpt-image-1.5"],
    "google": ["gemini-2.5-flash-image", "gemini-3.1-flash-image", "gemini-3-pro-image",
               "nano-banana-pro-preview", "imagen-4.0-generate-001"],
    "openai": ["gpt-image-2", "gpt-image-1", "gpt-image-1-mini", "gpt-image-1.5"],
}
RETRYABLE_STATUS = {429, 500, 502, 503, 504}


# ---------------- HTTP basics ----------------
def _env(name: str) -> str:
    v = os.environ.get(name)
    if not v:
        raise RuntimeError(f"environment variable {name} is not set")
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


# ---------------- each provider generates an image → returns image bytes ----------------
def gen_grsai(model: str, prompt: str, opt: dict, timeout: int) -> bytes:
    # Accept GRSAI_BASE_URL written as a bare host or with a /v1 suffix; normalize to .../v1/api/generate
    base = os.environ.get("GRSAI_BASE_URL", "https://api.grsai.com").rstrip("/")
    if base.endswith("/v1"):
        base = base[:-3]
    payload = {"model": model, "prompt": prompt, "images": [], "replyType": "json"}
    if "nano-banana" in model:
        payload["aspectRatio"] = opt["aspect"]
        payload["imageSize"] = opt["image_size"]
    else:  # gpt-image etc. use a pixel size
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
        raise RuntimeError(f"grsai response had no image url: {json.dumps(resp, ensure_ascii=False)[:300]}")
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
    raise RuntimeError(f"google response had no image: {json.dumps(resp, ensure_ascii=False)[:300]}")


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
    raise RuntimeError(f"openai response had no image: {json.dumps(resp, ensure_ascii=False)[:300]}")


PROVIDERS = {"grsai": gen_grsai, "google": gen_google, "openai": gen_openai}


# ---------------- image validation ----------------
def image_info(b: bytes) -> tuple[str, int, int]:
    """Return (format, width, height); raise if not an image."""
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
    raise RuntimeError(f"returned content is not a valid image (first 16 bytes: {b[:16]!r})")


def upscale_to(data: bytes, target: int) -> bytes:
    """Upscale the long edge to `target` pixels with Lanczos (keeping aspect ratio), return PNG bytes.
    Note: high-quality resampling, not AI super-resolution; used to bring an AI image up to the
    streaming 3000² master spec."""
    im = Image.open(io.BytesIO(data)).convert("RGB")
    w, h = im.size
    scale = target / max(w, h)
    im = im.resize((round(w * scale), round(h * scale)), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, format="PNG")
    return buf.getvalue()


# ---------------- single generation (with retry) ----------------
def generate_one(model_spec: str, prompt: str, opt: dict, timeout: int, retries: int) -> bytes:
    if ":" not in model_spec:
        raise SystemExit(f"model must be written as provider:model (e.g. {DEFAULT_MODEL}), got: {model_spec!r}")
    provider, model = model_spec.split(":", 1)
    if provider not in PROVIDERS:
        raise SystemExit(f"unknown provider: {provider!r}; available: {', '.join(PROVIDERS)}")
    fn = PROVIDERS[provider]
    last = None
    for attempt in range(retries + 1):
        try:
            data = fn(model, prompt, opt, timeout)
            image_info(data)  # validate
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
            print(f"  ⟳ attempt {attempt + 1} failed ({last}), retrying in {wait}s…", file=sys.stderr)
            time.sleep(wait)
    raise RuntimeError(f"{model_spec} still failing after {retries} retries: {last}")


def _slug(s: str) -> str:
    return re.sub(r"[^\w.-]", "_", s)


def main() -> int:
    ap = argparse.ArgumentParser(description="multi-provider/multi-model CD cover generator",
                                 formatter_class=argparse.RawDescriptionHelpFormatter, epilog=__doc__)
    ap.add_argument("prompt", nargs="?", help="English prompt (mutually exclusive with --prompts-file)")
    ap.add_argument("-m", "--model", default=DEFAULT_MODEL, help=f"provider:model (default {DEFAULT_MODEL})")
    ap.add_argument("-o", "--out", help="single-image output path (default covers/cover_<model>.png, under the current working dir)")
    ap.add_argument("--prompts-file", help="batch: one prompt per line (lines starting with # are ignored)")
    ap.add_argument("--out-dir", default="covers",
                    help="output directory (default ./covers/ — run inside the project dir and it lands under the project)")
    ap.add_argument("--prefix", default="cover", help="batch filename prefix")
    ap.add_argument("--aspect", default="1:1", help="grsai nano-banana / general aspect ratio (default 1:1)")
    ap.add_argument("--image-size", default="1K", help="grsai nano-banana resolution tier 1K/2K/4K (default 1K)")
    ap.add_argument("--size", default="1024x1024", help="openai / grsai gpt-image pixel size (default 1024x1024)")
    ap.add_argument("--upscale", type=int, default=3000,
                    help="upscale the long edge to this many pixels (Lanczos; default 3000 = streaming master; 0 = no upscale, keep native)")
    ap.add_argument("--timeout", type=int, default=300, help="per-request timeout in seconds (default 300; gpt-image-2 is slow)")
    ap.add_argument("--retries", type=int, default=1, help="retry count on failure (default 1)")
    ap.add_argument("--list", action="store_true", help="list known provider:model and exit")
    args = ap.parse_args()

    if args.list:
        print("known provider:model (a new model on the same provider can be passed by name directly):")
        for prov, models in CATALOG.items():
            for m in models:
                tag = "  ← default" if f"{prov}:{m}" == DEFAULT_MODEL else ""
                print(f"  {prov}:{m}{tag}")
        print("\nkeys: GRSAI_API_KEY / GOOGLE_API_KEY / OPENAI_API_KEY")
        return 0

    opt = {"aspect": args.aspect, "image_size": args.image_size, "size": args.size}

    # collect tasks
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
        ap.error("provide a prompt or --prompts-file")

    rc = 0
    for prompt, out in tasks:
        print(f"▶ [{args.model}] → {out}\n  prompt: {prompt[:80]}{'…' if len(prompt) > 80 else ''}")
        t0 = time.time()
        try:
            data = generate_one(args.model, prompt, opt, args.timeout, args.retries)
        except Exception as e:
            print(f"  ✗ failed: {e}\n", file=sys.stderr)
            rc = 1
            continue
        fmt, w, h = image_info(data)
        note = f"{fmt} {w}×{h}"
        if args.upscale and max(w, h) < args.upscale:
            data = upscale_to(data, args.upscale)
            _, w, h = image_info(data)
            note += f" → upscaled {w}×{h}"
        os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
        with open(out, "wb") as f:
            f.write(data)
        warn = "  ⚠ still below 3000²" if min(w, h) < 3000 else ""
        print(f"  ✓ {note}, {len(data)} bytes, {time.time() - t0:.0f}s{warn}\n")
    return rc


if __name__ == "__main__":
    sys.exit(main())
