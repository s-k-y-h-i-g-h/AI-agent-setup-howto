# Zero-to-Hermes: Installation Guide

## Prerequisites
- **Windows 10/11** (64-bit).
- **20GB+ free disk space**.
- **Internet connection**.

---

## Installation
### Option 1: One-Click Installer (Recommended)
1. **Download the installer**:
   - [Latest Release](https://github.com/s-k-y-h-i-g-h/AI-agent-setup-howto/releases)
2. **Run the `.exe`**:
   - Double-click `HermesAI_Installer.exe`.
   - Follow the prompts.
3. **Wait for completion**:
   - The installer will handle **restarts automatically**.
4. **Access the tools**:
   - OpenClaw: [http://localhost:18790](http://localhost:18790)
   - Hermes: [http://localhost:3000](http://localhost:3000)
   - FreeLLMAPI: [http://localhost:3001](http://localhost:3001)

### Option 2: Manual Installation
*(For advanced users who want to learn the process.)*

#### Step 1: Install Windows Terminal
1. Open **PowerShell as Administrator**.
2. Run:
   ```powershell
   winget install --id Microsoft.WindowsTerminal -e --silent
   ```

#### Step 2: Install WSL + Arch Linux
1. Run:
   ```powershell
   wsl --install -d Arch
   ```
2. **Restart your computer**.
3. After reboot, open **PowerShell** and run:
   ```powershell
   wsl --set-default Arch
   ```

#### Step 3: Install OpenClaw, Hermes, and FreeLLMAPI
1. Open **WSL** (type `wsl` in PowerShell).
2. Run:
   ```bash
   # Update and install dependencies
   sudo pacman -Syu --noconfirm
   sudo pacman -S git python python-pip docker --noconfirm

   # Install OpenClaw
   git clone https://github.com/OpenClaw/OpenClaw.git ~/OpenClaw
   cd ~/OpenClaw
   pip install -r requirements.txt

   # Install Hermes
   git clone https://github.com/NousResearch/Hermes-Agent.git ~/Hermes-Agent
   cd ~/Hermes-Agent
   pip install -r requirements.txt

   # Install FreeLLMAPI
   git clone https://github.com/FreeLLMAPI/FreeLLMAPI.git ~/FreeLLMAPI
   cd ~/FreeLLMAPI
   pip install -r requirements.txt
   ```

#### Step 4: Configure and Start Services
1. Configure OpenClaw:
   ```bash
   cd ~/OpenClaw
   cp config.example.yaml config.yaml
   nano config.yaml  # Add your API key
   ```
2. Configure Hermes:
   ```bash
   cd ~/Hermes-Agent
   cp config.example.yaml config.yaml
   nano config.yaml  # Add your endpoint
   ```
3. Configure FreeLLMAPI:
   ```bash
   cd ~/FreeLLMAPI
   cp config.example.yaml config.yaml
   nano config.yaml  # Set host to 0.0.0.0
   ```
4. Start the services:
   ```bash
   nohup python ~/OpenClaw/openclaw.py > ~/openclaw.log 2>&1 &
   nohup python ~/Hermes-Agent/hermes.py > ~/hermes.log 2>&1 &
   nohup python ~/FreeLLMAPI/freellmapi.py > ~/freellmapi.log 2>&1 &
   ```

---

## Responsible AI Usage & Security Considerations

As you install and use AI agents like Hermes, OpenClaw, and FreeLLMAPI, it's important to be aware of the broader landscape of AI technology:

### The Power of Open AI
AI tools are incredibly powerful for learning, creativity, and productivity. Your new setup gives you access to cutting-edge models that can help you explore complex topics, write code, and much more.

### Potential for Misuse
It's crucial to understand that AI technology, like any powerful tool, can be misused. Reports indicate that AI chatbots have been explored by malicious actors for:
- **Operational Guidance**: Planning attacks or troubleshooting weapon systems.
- **Propaganda and Recruitment**: Spreading disinformation and creating fake identities.
- **Cybersecurity Threats**: Writing malicious code or finding vulnerabilities.

### Your Role in Responsible AI Use
- **Be Skeptical**: Always critically evaluate AI-generated content. Verify information from multiple sources, especially if it concerns sensitive topics like safety, security, or health.
- **Use Locally**: Running models locally (like with FreeLLMAPI) gives you more control and privacy, reducing risks associated with external APIs.
- **Report Issues**: If you encounter a model providing harmful or unethical output, report it to the model provider and consider contributing to safer AI development through open-source communities.
- **Stay Informed**: Keep up-to-date on AI ethics and security best practices.

---

## Troubleshooting
### Common Issues
| Issue                          | Fix                                                                 |
|--------------------------------|---------------------------------------------------------------------|
| WSL fails to install           | Enable virtualization in BIOS. Run `wsl --update` in PowerShell.   |
| Docker permission denied       | Run `sudo usermod -aG docker $USER` in WSL and restart.             |
| Port already in use            | Run `sudo lsof -i :3000` (or `3001`, `18790`) and kill the process. |
| Model fails to load            | Check `~/hermes.log` for errors. Try 4-bit quantization.           |

### Repair Script (Advanced)
Run this in WSL to **fix common issues**:
```bash
curl -s https://raw.githubusercontent.com/s-k-y-h-i-g-h/AI-agent-setup-howto/main/scripts/repair.sh | bash
```

---

## Feedback
Found a bug? Have a suggestion? Open an [issue](https://github.com/s-k-y-h-i-g-h/AI-agent-setup-howto/issues)!
