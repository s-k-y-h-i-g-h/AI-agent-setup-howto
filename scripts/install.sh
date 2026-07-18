#!/bin/bash
# Hermes AI Agent Installer - Stage 3 (Bash)

# Update and install dependencies
echo "🔹 Updating system and installing dependencies..."
sudo pacman -Syu --noconfirm
sudo pacman -S git python python-pip docker --noconfirm
sudo systemctl enable docker
sudo systemctl start docker

# Install OpenClaw
echo "🔹 Installing OpenClaw..."
git clone https://github.com/OpenClaw/OpenClaw.git ~/OpenClaw
cd ~/OpenClaw
pip install -r requirements.txt

# Install Hermes
echo "🔹 Installing Hermes..."
git clone https://github.com/NousResearch/Hermes-Agent.git ~/Hermes-Agent
cd ~/Hermes-Agent
pip install -r requirements.txt

# Install Paperclip AI
echo "🔹 Installing Paperclip AI..."
git clone https://github.com/PaperclipAI/PaperclipAI.git ~/PaperclipAI
cd ~/PaperclipAI
pip install -r requirements.txt

# Configure Paperclip AI
cd ~/PaperclipAI
cp config.example.yaml config.yaml
sed -i 's/endpoint: ""/endpoint: "http:\/\/localhost:3002"/g' config.yaml

# Start Paperclip AI in the background
echo "🔹 Starting Paperclip AI service..."
nohup python paperclip.py > paperclip.log 2>&1 &


# Configure services
echo "🔹 Configuring services..."
cd ~/OpenClaw
cp config.example.yaml config.yaml
sed -i 's/api_key: ""/api_key: "freellmapi-f21514c3a2fae08b170227d276e5285ad457624ab424fc50"/g' config.yaml

cd ~/Hermes-Agent
cp config.example.yaml config.yaml
sed -i 's/endpoint: ""/endpoint: "http:\/\/localhost:3001"/g' config.yaml

cd ~/FreeLLMAPI
cp config.example.yaml config.yaml
sed -i 's/host: "0.0.0.0"/host: "0.0.0.0"/g' config.yaml

# Start services in the background
echo "🔹 Starting services..."
cd ~/FreeLLMAPI
nohup python freellmapi.py > freellmapi.log 2>&1 &

cd ~/OpenClaw
nohup python openclaw.py > openclaw.log 2>&1 &

cd ~/Hermes-Agent
nohup python hermes.py > hermes.log 2>&1 &

cd ~/PaperclipAI
nohup python paperclip.py > paperclip.log 2>&1 &

echo "🎉 Hermes AI Agent is ready!"
echo "🔹 OpenClaw: http://localhost:18790"
echo "🔹 Hermes: http://localhost:3000"
echo "🔹 FreeLLMAPI: http://localhost:3001"
echo "🔹 Paperclip AI: http://localhost:3002"
