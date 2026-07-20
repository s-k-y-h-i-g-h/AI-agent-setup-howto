=== Dokploy on WSL 2 – quick start guide ==============================

Prerequisites
-------------
- Windows 10/11 with WSL 2 enabled.
- Docker Desktop for Windows installed and configured to use the WSL 2
  backend (Settings → Resources → WSL Integration → enable your distro).
- Your WSL distro (e.g., Ubuntu) is launched and you are at a bash prompt.

Step 1 – make sure Docker is running
-------------------------------------
From your WSL terminal run:

    docker info

If you see an error like “Cannot connect to the Docker daemon”, start Docker
Desktop from the Windows start menu or, if you prefer a CLI start, run:

    sudo service docker start   # (only needed if Docker Desktop is not set to auto‑start)

Step 2 – initialise a Docker Swarm manager
------------------------------------------
Dokploy expects a Docker Swarm.  Under WSL 2 the safest advertise address is
the loop‑back address 127.0.0.1, which Docker Desktop maps to the VM’s internal
network.

Run once:

    docker swarm init --advertise-addr 127.0.0.1 --listen-addr 0.0.0.0:2377

You should see:

    Swarm initialized: current node ( <ID> ) is now a manager.

If you run the command again Docker will simply tell you the swarm is already
active – that is fine.

Step 3 – run the Dokploy installer with the correct advertise address
---------------------------------------------------------------------
The official installer tries to auto‑detect an advertise address and often
picks 10.255.255.254, which does not exist inside the WSL 2 VM, causing the
error:

    Error response from daemon: must specify a listening address ...

To avoid that, set the environment variable ADVERTISE_ADDR before invoking the
installer:

    export ADVERTISE_ADDR=127.0.0.1
    curl -sSL https://dokploy.com/install.sh | sh

The script will now:

- Detect that Docker is already installed.
- See that a swarm is active (thanks to step 2) and skip the swarm‑init step.
- Pull the Dokploy containers, create the needed services (Traefik, Postgres,
  the Dokploy API, etc.).
- Print a one‑time admin token at the end of the output.

Step 4 – access the Dokploy UI
------------------------------
Once the installer finishes, open a browser on your Windows host and go to:

    http://127.0.0.1:3000

Log in with the username **admin** and the password/token that was shown in
the installer output (copy it before the terminal scrolls away).

Step 5 – (optional) expose Dokploy to other machines on your LAN
----------------------------------------------------------------
If you want teammates or other devices to reach the UI, find the IP address
that your WSL 2 distro has on the virtual network:

    ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

Suppose it is `172.29.182.177`.  Then open port 3000 in the Windows firewall
(or let Docker Desktop handle it) and visit:

    http://172.29.182.177:3000

From the Dokploy UI you can now create projects, attach Git repositories,
deploy containers, etc., exactly as described in the official Dokploy docs.

Troubleshooting
---------------
* “Node left the swarm” message during install – this is harmless; the
  installer temporarily leaves the swarm to re‑join it with the correct
  advertise address.  After the script finishes run `docker node ls` to see
  your node back as a manager.

* Service stays in “pending” state – check Docker Desktop logs for port
  conflicts (ports 80, 443, 3000 must be free) or run:

    docker service ps <service-name>

  to see why a task failed.

* Forgetting the admin token – you can retrieve it by re‑running the installer
  with the same ADVERTISE_ADDR; it will show the token again, or you can reset
  it via the Dokploy UI under Settings → Administrators.

That’s it!  You now have a fully functional Dokploy control plane running
inside WSL 2, ready to orchestrate your AI‑agent containers, micro‑services,
or any other workload you wish to deploy.

======================================================================