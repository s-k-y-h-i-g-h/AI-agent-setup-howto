#!/usr/bin/env bash
#=====================================================================
# setup-dokploy.sh
#   One‑shot script to get Dokploy running inside a WSL 2 distro.
#   Prereqs: Docker Desktop for Windows with WSL 2 integration enabled.
#=====================================================================

set -euo pipefail

# ---- 1. Verify Docker daemon is reachable -------------------------
if ! docker info &>/dev/null; then
    echo "Docker daemon not reachable – trying to start Docker Desktop service..."
    # Docker Desktop usually starts automatically; if not, try to start the service.
    sudo service docker start || true
    # Wait a moment for the daemon to come up
    for i in {1..15}; do
        if docker info &>/dev/null; then
            echo "Docker daemon is up."
            break
        fi
        sleep 1
    done
    if ! docker info &>/dev/null; then
        echo "ERROR: Docker daemon still not reachable. Start Docker Desktop manually."
        exit 1
    fi
fi

# ---- 2. Ensure a Swarm manager exists -----------------------------
if ! docker info | grep -q 'Swarm: active'; then
    echo "Initialising Docker Swarm (advertise=127.0.0.1)..."
    docker swarm init --advertise-addr 127.0.0.1 --listen-addr 0.0.0.0:2377
else
    echo "Docker Swarm already active – skipping init."
fi

# ---- 3. Run Dokploy installer with correct advertise address -------
export ADVERTISE_ADDR=127.0.0.1
echo "Running Dokploy installer (this may take a few minutes)..."
curl -sSL https://dokploy.com/install.sh | sh

# ---- 4. Show useful info -------------------------------------------
echo
echo "=== Dokploy installation complete ==="
echo "If the installer printed an admin token, copy it now."
echo "Open a browser on your Windows host and go to:"
echo "    http://127.0.0.1:3000"
echo "Login with username 'admin' and the token you copied."
echo
echo "To check the swarm status:"
echo "    docker node ls"
echo
echo "To list Dokploy‑related services:"
echo "    docker service ls"
echo
echo "Happy deploying!"
#=====================================================================