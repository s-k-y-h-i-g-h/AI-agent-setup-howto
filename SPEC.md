# Zero-to-Hermes: Project Specification

## Vision
Democratize access to frontier AI agents by creating a **zero-friction, self-documenting installer** that:
- Assumes **zero prior knowledge** (no terminal, no Linux, no Docker).
- Respects the **user’s time** (one-click `.exe` → working system).
- Lives on the **edge** (Arch Linux + rolling releases for latest AI tools).
- **Teaches while it installs** (explanations + shortcuts).

---

## Technical Architecture
### Three-Stage Bootstrap
| Stage               | Tool               | Purpose                                                                 |
|---------------------|--------------------|-------------------------------------------------------------------------|
| **1. Windows `.exe`** | Inno Setup         | Installs Terminal, WSL, and kicks off PowerShell. Handles restarts.   |
| **2. PowerShell**    | PowerShell         | Installs WSL + Arch Linux, downloads Stage 3 (Bash).                    |
| **3. Bash (WSL)**    | Bash               | Installs OpenClaw, Hermes, FreeLLMAPI, and configures/launches them.   |

### Key Features
- **GUI for the `.exe`**:
  - Progress bar (e.g., *"Installing WSL... 50%"*).
  - Options (e.g., *"Install for all users"*).
  - Error handling (e.g., *"WSL failed to install. Try this fix: [link]"*).
- **Idempotent scripts**: Safe to run multiple times.
- **Logging**: All output saved to `~/install.log`.
- **Self-documenting**: Every step explains *what* is happening and *why*.

---

## Why Arch Linux?
- **Rolling release**: Always up-to-date with **latest AI tools** (no waiting for Ubuntu LTS).
- **Minimalist**: No bloat—just what’s needed for **OpenClaw, Hermes, and FreeLLMAPI**.
- **User control**: Forces **understanding of the system** (aligns with the ethos of **self-sufficiency**).

---

## GUI Design (Inno Setup)
### Screen 1: Welcome
*(Mockup: Welcome screen with options for "Install for all users" and "Custom install location")*

### Screen 2: Progress
*(Mockup: Progress bar with restart prompt for WSL installation)*

### Screen 3: Completion
*(Mockup: Completion screen with links to OpenClaw, Hermes, and FreeLLMAPI)*

---

## Repair Option: Advanced Mode
### Arguments For
- **User trust**: If something breaks, they can **fix it without reinstalling**.
- **Debugging**: Logs + repair scripts help **diagnose issues**.
- **Professionalism**: Matches the **polish of commercial installers**.

### Arguments Against
- **Complexity**: Adds **maintenance burden**.
- **Overkill**: Most users **won’t need it**.
- **Philosophy**: Encourages **dependency** vs. **self-sufficiency**.

### Compromise
- Hide the repair option **behind an "Advanced" toggle** in the GUI.
- Include a **`repair.sh` script** in the repo (for power users).

---

## Documentation Plan
### What’s Included
1. **`README.md`**: High-level overview + screenshots.
2. **`INSTALL.md`**: Step-by-step guide + troubleshooting.
3. **`/scripts`**: All installer scripts (`install.iss`, `install.ps1`, `install.sh`, `repair.sh`).
4. **`/docs`**: Detailed explanations (e.g., *"What is WSL?"*, *"Why Arch Linux?"*).

---

## Next Steps
1. **Build the `.exe` prototype** (Inno Setup).
2. **Test on a fresh Windows VM** (to ensure no dependencies are missing).
3. **Gather feedback** from early adopters.
4. **Iterate** based on user input.

---

## Philosophy
*"Matters of little concern should be treated seriously."*
- **Respect the user’s time**: A GUI isn’t bloat—it’s **respect**.
- **Live on the edge**: Arch Linux isn’t reckless—it’s **strategic**.
- **Teach self-sufficiency**: The installer should **empower**, not **handhold**.
