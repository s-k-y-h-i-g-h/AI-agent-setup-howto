# Optional Components

This guide covers add-ons that extend your AI agent ecosystem beyond the core setup.
Each is **completely optional** — the base installer gives you a fully functional
Hermes-powered agent team without any of these.

We document them here first so you can explore what's possible. Automated
installer support is coming once we've figured out the best way to bundle
everything cleanly.

---

## Table of Contents

- [Voice Mode](#-voice-mode) — Talk to your agents, hear them speak back
- [More coming soon...](#-more-coming-soon)

---

## 🎤 Voice Mode

**Project:** [Hugging Face Speech-to-Speech](https://github.com/huggingface/speech-to-speech)

Add a real-time voice interface to your agent team. The pipeline runs
locally and connects to any OpenAI-compatible LLM — including your
FreeLLMAPI endpoint.

### What it lets you do

- Speak questions to your agents instead of typing
- Hear responses spoken back through your speakers
- Build voice-controlled automations and hands-free workflows
- (Future) Pipe agent output to a voice channel for alerts, briefings, etc.

### How it works

```
You speak → VAD (detects you're talking) → STT (speech to text)
  → LLM (your agent answers) → TTS (text to speech) → You hear it
```

It runs as a WebSocket server on your machine, speaking the
[OpenAI Realtime protocol](https://platform.openai.com/docs/guides/realtime),
so any compatible client can connect.

### Hardware requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **CPU** | Any x86-64 or Apple Silicon | — |
| **RAM** | 8 GB | 16 GB+ |
| **GPU** | None (CPU-only works, slower) | NVIDIA GPU with **compute capability ≥ 7.5** and **≥ 8 GB VRAM** (e.g., RTX 2070, 3060, 4070, Tesla T4, or better) |
| **Storage** | ~3 GB free for model files | — |
| **Microphone & speakers** | Any built-in or USB mic/speakers | — |

> **GPU note:** The default STT model (Parakeet TDT, 2.5 GB) requires
> CUDA compute capability ≥ 7.5. If your GPU is older (e.g., Quadro K1200
> with SM 5.0), use the `--device cpu` fallback. It still works, just slower.

### Installation

```bash
# 1. Install Python 3.10 (needed because some dependencies don't
#    support Python 3.14 which Arch ships by default)
#    From AUR:
yay -S python310

#    Or via pyenv:
#    pyenv install 3.10.14
#    pyenv virtualenv 3.10.14 speech-voice-env
#    pyenv activate speech-voice-env

# 2. Install the CLI using pipx with Python 3.10
pipx install --python /usr/bin/python3.10 speech-to-speech

# 3. Point it at your FreeLLMAPI endpoint
export OPENAI_API_BASE_URL="http://localhost:3001/v1"
export OPENAI_API_KEY="your-free-llm-api-key-here"

# 4. Start the server
speech-to-speech --device auto
```

The server will listen on `ws://localhost:8765/v1/realtime`.

> **Tip for GPU users:** If you have a modern NVIDIA GPU (RTX 30/40 series,
> or any GPU with SM ≥ 7.5), the pipeline will use CUDA automatically.
> If you're on CPU-only, pass `--device cpu` explicitly.

### Testing it

```bash
# Install a tiny audio helper
pip install sounddevice

# Run the demo microphone-to-speaker client
# (works best from a second terminal while the server is running)
python -m scripts.listen_and_play_realtime.py --host 127.0.0.1 --port 8765
```

Speak a sentence. You should hear the response spoken back through
your speakers. The server logs will show a line like:

```
[LLM] POST http://localhost:3001/v1/chat/completions ... → 200
```

### Using a different LLM

You can use **any OpenAI-compatible provider** by changing the two
environment variables:

```bash
# OpenAI
export OPENAI_API_BASE_URL="https://api.openai.com/v1"
export OPENAI_API_KEY="sk-..."

# OpenRouter
export OPENAI_API_BASE_URL="https://openrouter.ai/api/v1"
export OPENAI_API_KEY="..."

# Local model via llama.cpp
# First start the server:
#   llama-server -hf ggml-org/gemma-4-E4B-it-GGUF -np 2 -c 65536 -fa on
# Then:
export OPENAI_API_BASE_URL="http://127.0.0.1:8080/v1"
export OPENAI_API_KEY=""   # no key needed for localhost
```

### Swapping components

The pipeline supports multiple backends for each stage:

| Stage | Options |
|-------|---------|
| **STT** | `parakeet-tdt` (default), `whisper`, `faster-whisper`, `whisper-mlx` (macOS) |
| **LLM** | Any OpenAI-compatible API, local Transformers, mlx-lm (macOS) |
| **TTS** | `qwen3` (default), `kokoro`, `pocket-tts`, `chattts` |

Example with a lighter STT model on CPU:

```bash
speech-to-speech --stt faster-whisper --device cpu
```

### Run modes

| Mode | Flag | Description |
|------|------|-------------|
| **Realtime server** (default) | `--mode realtime` | OpenAI-compatible WebSocket at `/v1/realtime` |
| **Local mic/speaker** | `--mode local` | Full duplex on your machine, no client needed |
| **Raw WebSocket** | `--mode websocket` | Minimal raw PCM audio stream |
| **TCP socket** | `--mode socket` | For remote servers, simple client/server |

### Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `RuntimeError: cuDNN version ... not compatible` | GPU too old for the installed torch build | Use `--device cpu` |
| `No module named 'df'` | DeepFilterNet not installed (optional) | Ignore — it's an enhancement, not required |
| `Cannot install on Python version 3.14` | Running with system Python instead of 3.10 | Use `pipx install --python /usr/bin/python3.10` |
| Server starts but no audio response | Missing or invalid LLM key | Check `OPENAI_API_KEY` and `OPENAI_API_BASE_URL` |
| Audio stutters or lags | CPU-only mode on a slow machine | Try a lighter STT model: `--stt faster-whisper` |

### Uninstalling

```bash
pipx uninstall speech-to-speech
```

---

## 🧩 More Coming Soon...

This page will grow as we evaluate new optional components. Candidates
we're exploring include:

- **Security scanning** — Automated penetration testing with
  [Strix](https://github.com/usestrix/strix)
- **Local LLM inference** — Self-hosted models with
  [DwarfStar (ds4)](https://github.com/antirez/ds4) or
  [llama.cpp](https://github.com/ggml-org/llama.cpp)
- **Lightweight backend storage** — Structured data via
  [PocketBase](https://github.com/pocketbase/pocketbase)
|- **More agent skills** — Discover curated collections of useful skills from the community

Each will get its own section here with requirements, install steps, and
integration notes as we validate them.

> Have a suggestion? Open an [issue](https://github.com/s-k-y-h-i-g-h/AI-agent-setup-howto/issues)
> and tell us what you'd like to see bundled next.
