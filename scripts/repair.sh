#!/bin/bash
# Hermes AI Agent Repair Script

echo "🔹 Checking OpenClaw..."
cd ~/OpenClaw && git pull && pip install -r requirements.txt

echo "🔹 Checking Paperclip AI..."
cd ~/PaperclipAI && git pull && pip install -r requirements.txt

echo "🔹 Checking Hermes..."
cd ~/Hermes-Agent && git pull && pip install -r requirements.txt

echo "🔹 Checking FreeLLMAPI..."
cd ~/FreeLLMAPI && git pull && pip install -r requirements.txt

echo "🔹 Restarting services..."
pkill -f "python.*(openclaw|hermes|freellmapi|paperclip)"
nohup python ~/OpenClaw/openclaw.py > ~/openclaw.log 2>&1 &
nohup python ~/Hermes-Agent/hermes.py > ~/hermes.log 2>&1 &
nohup python ~/FreeLLMAPI/freellmapi.py > ~/freellmapi.log 2>&1 &
nohup python ~/PaperclipAI/paperclip.py > ~/paperclip.log 2>&1 &


echo "🎉 Repair complete!"
