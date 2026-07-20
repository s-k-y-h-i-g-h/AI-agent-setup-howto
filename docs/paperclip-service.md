# Paperclip Service – Run Paperclip as a Systemd Service

This guide shows how to run **Paperclip** (`npx paperclipai run`) automatically as a systemd user service, so it starts when you log in (or at boot if you enable lingering) and is restarted automatically on failure.

---

## Prerequisites

- Paperclip is installed globally (e.g. `npm install -g paperclipai`) or locally in a project.
- You know the full path to the `npx` (or `paperclipai`) binary you want to run.
  - `which npx` → e.g. `/home/skyhigh/.npm-global/bin/npx`
  - If you prefer to call the binary directly: `$(npm bin)/paperclipai` (gives something like `/home/skyhigh/.npm-global/lib/node_modules/paperclipai/bin/paperclipai`).

- (Optional) Any environment variables Paperclip needs (API keys, config paths, etc.).

---

## 1. Create the service file

Create the directory for user services if it doesn’t exist:

```bash
mkdir -p ~/.config/systemd/user
```

Create and edit the service file:

```bash
nano ~/.config/systemd/user/paperclip.service
```

Paste the following (adjust the paths/variables as needed):

```ini
[Unit]
Description=Paperclip AI agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
# ---- Use the absolute path to npx (or to the paperclipai binary) ----
ExecStart=/home/skyhigh/.npm-global/bin/npx paperclipai run
# If you prefer to call the binary directly, use the line below instead:
# ExecStart=/home/skyhigh/.npm-global/lib/node_modules/paperclipai/bin/paperclipai run

# Working directory where Paperclip looks for its config (~/.paperclip by default)
WorkingDirectory=/home/skyhigh

# Restart on failure (adjust as you like)
Restart=on-failure
RestartSec=10

# ---- Environment variables (uncomment and edit if needed) ----
# Example:
# Environment=SOME_API_KEY=your_secret_here
# Environment=PAPERCLIP_CONFIG=/home/skyhigh/.paperclip/

[Install]
WantedBy=default.target
```

Save (`Ctrl+O`, `Enter`) and exit (`Ctrl+X`).

### Explanation of key fields

| Field | Purpose |
|-------|---------|
| `ExecStart` | Full path to the executable (`npx` or the paperclipai binary) plus the argument `run`. |
| `WorkingDirectory` | Directory from which Paperclip runs; by default it reads `~/.paperclip`. Adjust if you keep your config elsewhere. |
| `Restart` / `RestartSec` | Automatically restarts the service if it crashes, waiting the specified seconds between attempts. |
| `Environment` | Define any required environment variables (API keys, etc.). |
| `WantedBy=default.target` | Makes the service start when you log in (or at boot if you enable lingering, see step 3). |

---

## 2. Reload systemd and enable the service

```bash
# Reload the user manager to pick up the new unit file
systemctl --user daemon-reload

# Enable the service to start at login (or boot with lingering)
systemctl --user enable paperclip.service

# Start it immediately for testing
systemctl --user start paperclip.service
```

---

## 3. (Optional) Enable lingering so the service survives logout / starts at boot

If you want the service to start **even when you’re not logged in** (e.g., on a headless WSL box or server), enable lingering for your user:

```bash
loginctl enable-linger $USER
```

After enabling linger, the service will be started by the systemd user manager at boot and will keep running after you log out.

---

## 4. Check status and logs

```bash
# See if it’s active
systemctl --user status paperclip.service

# Follow the log output (like `tail -f`)
journalctl --user -u paperclip.service -f
```

You should see output from Paperclip, e.g.:

```
[14:03:41] INFO: Server listening on 127.0.0.1:3100
```

If the service fails, inspect the logs:

```bash
journalctl --user -u paperclip.service -b   # logs from the last boot
```

Common issues:
- **Executable not found** – double‑check the absolute path in `ExecStart`.
- **Missing environment variables** – add them via `Environment=` lines.
- **Wrong working directory** – ensure `WorkingDirectory` points to where Paperclip expects its config (usually your home directory, where `~/.paperclip` lives).

---

## 5. Stopping / disabling the service

```bash
# Stop it now
systemctl --user stop paperclip.service

# Disable it from starting at login/boot
systemctl --user disable paperclip.service

# Remove the file (optional)
rm ~/.config/systemd/user/paperclip.service
systemctl --user daemon-reload
```

---

## 6. TL;DR – One‑liner to copy/paste

```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/paperclip.service <<'EOF'
[Unit]
Description=Paperclip AI agent
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/home/skyhigh/.npm-global/bin/npx paperclipai run
WorkingDirectory=/home/skyhigh
Restart=on-failure
RestartSec=10
# Environment=SOME_API_KEY=your_key_here

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now paperclip.service   # start and enable
# (Optional) enable lingering for boot‑time start without login:
loginctl enable-linger $USER
```

That’s it! Your Paperclip agent will now run in the background, restart on failure, and start automatically whenever you log in (or at boot if you enabled lingering).  

--- 

*Need help? Open an issue in the [AI‑agent‑setup‑howto](https://github.com/s-k-y-h-i-g-h/AI-agent-setup-howto) repository or ask in the community chat.*