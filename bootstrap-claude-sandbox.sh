#!/bin/bash
# ============================================================
# bootstrap-claude-sandbox.sh
#
# Drops a Claude Code devcontainer sandbox into the CURRENT
# directory: launch-claude.sh + .devcontainer/* + .claude/*.
# Minimal Python base — no project deps baked in (add them to
# the Dockerfile's PROJECT-SPECIFIC block, then --rebuild).
#
# Usage:
#   cd /path/to/new-repo
#   ./bootstrap-claude-sandbox.sh          # writes files; refuses to clobber
#   FORCE=1 ./bootstrap-claude-sandbox.sh  # overwrite existing files
#
# After it runs:
#   ./launch-claude.sh            # build + enter the container, start Claude
#   ./launch-claude.sh --rebuild  # rebuild image after editing the Dockerfile
# ============================================================
set -euo pipefail

FORCE="${FORCE:-0}"

# --- Safety: don't silently clobber an existing setup ---
targets=(
  "launch-claude.sh"
  ".devcontainer/devcontainer.json"
  ".devcontainer/Dockerfile"
  ".devcontainer/init-firewall.sh"
  ".claude/settings.json"
)
if [ "$FORCE" != "1" ]; then
  existing=()
  for t in "${targets[@]}"; do
    [ -e "$t" ] && existing+=("$t")
  done
  if [ "${#existing[@]}" -gt 0 ]; then
    echo "ERROR: these files already exist (re-run with FORCE=1 to overwrite):" >&2
    printf '  %s\n' "${existing[@]}" >&2
    exit 1
  fi
fi

mkdir -p .devcontainer .claude

# ============================================================
# launch-claude.sh
# ============================================================
cat > launch-claude.sh <<'LAUNCH_EOF'
#!/bin/bash
# Launch Claude Code in the devcontainer
# Usage: ./launch-claude.sh [optional: path to project]
#
# Options:
#   --rebuild    Force rebuild the container (removes existing container first)

set -e

# Parse arguments
REBUILD=false
PROJECT_DIR=""

for arg in "$@"; do
    case $arg in
        --rebuild)
            REBUILD=true
            ;;
        *)
            if [ -z "$PROJECT_DIR" ]; then
                PROJECT_DIR="$arg"
            fi
            ;;
    esac
done

# Default to script directory if no project specified
PROJECT_DIR="${PROJECT_DIR:-$(dirname "$0")}"
cd "$PROJECT_DIR"

# Ensure we have absolute path for workspace
WORKSPACE_DIR="$(pwd)"

echo "Starting devcontainer for: $WORKSPACE_DIR"

if [ "$REBUILD" = true ]; then
    echo "Rebuilding devcontainer (removing existing container)..."
    devcontainer up --workspace-folder "$WORKSPACE_DIR" --remove-existing-container
else
    echo "Starting devcontainer..."
    devcontainer up --workspace-folder "$WORKSPACE_DIR"
fi

# Propagate the host's git identity into the container. A fresh container has
# no ~/.gitconfig, so the first commit dies with "Author identity unknown".
# Reading it here (on the host, from inside the repo) picks up repo-local
# config as well as global, and avoids bind-mounting the whole host
# ~/.gitconfig — that would drag in credential helpers that don't exist in
# the container.
GIT_NAME="$(git config --get user.name 2>/dev/null || true)"
GIT_EMAIL="$(git config --get user.email 2>/dev/null || true)"

if [ -n "$GIT_NAME" ] && [ -n "$GIT_EMAIL" ]; then
    echo "Git identity: $GIT_NAME <$GIT_EMAIL>"
    devcontainer exec --workspace-folder "$WORKSPACE_DIR" \
        git config --global user.name "$GIT_NAME"
    devcontainer exec --workspace-folder "$WORKSPACE_DIR" \
        git config --global user.email "$GIT_EMAIL"
else
    echo "WARNING: no git user.name/user.email found on the host." >&2
    echo "         Commits inside the container will fail until one is set." >&2
fi

echo ""
echo "Launching Claude Code..."
devcontainer exec --workspace-folder "$WORKSPACE_DIR" claude
LAUNCH_EOF

# ============================================================
# .devcontainer/devcontainer.json
# ============================================================
cat > .devcontainer/devcontainer.json <<'DEVC_EOF'
{
  "name": "Claude Code Sandbox",
  "build": {
    "dockerfile": "Dockerfile",
    "args": {
      "TZ": "${localEnv:TZ:America/Los_Angeles}",
      "CLAUDE_CODE_VERSION": "latest",
      "GIT_DELTA_VERSION": "0.18.2",
      "ZSH_IN_DOCKER_VERSION": "1.2.0"
    }
  },
  "runArgs": [
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_RAW"
  ],
  "customizations": {
    "vscode": {
      "extensions": [
        "anthropic.claude-code",
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode",
        "eamodio.gitlens"
      ],
      "settings": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.codeActionsOnSave": {
          "source.fixAll.eslint": "explicit"
        },
        "terminal.integrated.defaultProfile.linux": "zsh",
        "terminal.integrated.profiles.linux": {
          "bash": {
            "path": "bash",
            "icon": "terminal-bash"
          },
          "zsh": {
            "path": "zsh"
          }
        }
      }
    }
  },
  "remoteUser": "node",
  "mounts": [
    "source=claude-code-bashhistory-${devcontainerId},target=/commandhistory,type=volume",
    "source=claude-code-config-${devcontainerId},target=/home/node/.claude,type=volume"
  ],
  "containerEnv": {
    "NODE_OPTIONS": "--max-old-space-size=4096",
    "CLAUDE_CONFIG_DIR": "/home/node/.claude",
    "POWERLEVEL9K_DISABLE_GITSTATUS": "true"
  },
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=delegated",
  "workspaceFolder": "/workspace",
  "postStartCommand": "sudo /usr/local/bin/init-firewall.sh",
  "waitFor": "postStartCommand"
}
DEVC_EOF

# ============================================================
# .devcontainer/Dockerfile  (minimal Python base)
# ============================================================
cat > .devcontainer/Dockerfile <<'DOCKER_EOF'
FROM node:20

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest

# Install basic development tools and iptables/ipset
RUN apt-get update && apt-get install -y --no-install-recommends \
  less \
  git \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  nano \
  vim \
  python3-pip \
  python3-venv \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && ln -sf /usr/bin/python3 /usr/bin/python \
  && ln -sf /usr/bin/pip3 /usr/bin/pip

# ============================================================
# PROJECT-SPECIFIC DEPENDENCIES
# Add your project's pip/apt packages here, then rebuild with
#   ./launch-claude.sh --rebuild
# Keep this list in sync with pyproject.toml / requirements.txt.
# Example:
#   RUN pip3 install --break-system-packages \
#     "fastapi>=0.110" \
#     "uvicorn>=0.29" \
#     "sqlalchemy>=2.0" \
#     "pytest>=8.0" \
#     "ruff>=0.4"
# ============================================================

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Set up non-root user
USER node

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=nano
ENV VISUAL=nano

# Default powerline10k theme
ARG ZSH_IN_DOCKER_VERSION=1.2.0
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Claude
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "node ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/node-firewall && \
  chmod 0440 /etc/sudoers.d/node-firewall
USER node
DOCKER_EOF

# ============================================================
# .devcontainer/init-firewall.sh
# ============================================================
cat > .devcontainer/init-firewall.sh <<'FW_EOF'
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

# ============================================================
# NETWORK FIREWALL FOR CLAUDE CODE SANDBOX
#
# This script restricts outbound network access to only:
#   - GitHub (for git operations)
#   - Anthropic (for Claude API)
#   - npm registry (for package installs)
#   - VS Code marketplace (for extensions)
#
# To add custom domains (e.g., your API server), add them to
# the EXTRA_ALLOWED_DOMAINS array below.
# ============================================================

# PROJECT-SPECIFIC: Add any additional domains your project needs
EXTRA_ALLOWED_DOMAINS=(
  # Python package index — needed for `pip install` from inside the container.
  # pypi.org serves the index; files.pythonhosted.org serves the wheels.
  "pypi.org"
  "files.pythonhosted.org"
)

# 1. Extract Docker DNS info BEFORE any flushing
DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)

# Flush existing rules and delete existing ipsets
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
ipset destroy allowed-domains 2>/dev/null || true

# 2. Selectively restore ONLY internal Docker DNS resolution
if [ -n "$DOCKER_DNS_RULES" ]; then
    echo "Restoring Docker DNS rules..."
    iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
    iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
    echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
else
    echo "No Docker DNS rules to restore"
fi

# First allow DNS and localhost before any restrictions
# Allow outbound DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
# Allow inbound DNS responses
iptables -A INPUT -p udp --sport 53 -j ACCEPT
# Allow outbound SSH
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
# Allow inbound SSH responses
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
# Allow localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Create ipset with CIDR support
ipset create allowed-domains hash:net

# Fetch GitHub meta information and aggregate + add their IP ranges
echo "Fetching GitHub IP ranges..."
gh_ranges=$(curl -s https://api.github.com/meta)
if [ -z "$gh_ranges" ]; then
    echo "ERROR: Failed to fetch GitHub IP ranges"
    exit 1
fi

if ! echo "$gh_ranges" | jq -e '.web and .api and .git' >/dev/null; then
    echo "ERROR: GitHub API response missing required fields"
    exit 1
fi

echo "Processing GitHub IPs..."
while read -r cidr; do
    if [[ ! "$cidr" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]; then
        echo "ERROR: Invalid CIDR range from GitHub meta: $cidr"
        exit 1
    fi
    echo "Adding GitHub range $cidr"
    ipset add allowed-domains "$cidr"
done < <(echo "$gh_ranges" | jq -r '(.web + .api + .git)[]' | aggregate -q)

# Core allowed domains (required for Claude Code to function)
CORE_DOMAINS=(
    "registry.npmjs.org"
    "api.anthropic.com"
    "console.anthropic.com"
    "claude.ai"
    "www.claude.ai"
    "auth.anthropic.com"
    "accounts.anthropic.com"
    "sentry.io"
    "statsig.anthropic.com"
    "statsig.com"
    "marketplace.visualstudio.com"
    "vscode.blob.core.windows.net"
    "update.code.visualstudio.com"
)

# Combine core and extra domains
ALL_DOMAINS=("${CORE_DOMAINS[@]}" "${EXTRA_ALLOWED_DOMAINS[@]}")

# Resolve and add all allowed domains
for domain in "${ALL_DOMAINS[@]}"; do
    echo "Resolving $domain..."
    ips=$(dig +noall +answer A "$domain" | awk '$4 == "A" {print $5}')
    if [ -z "$ips" ]; then
        echo "WARNING: Failed to resolve $domain (skipping)"
        continue
    fi

    while read -r ip; do
        if [[ ! "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo "ERROR: Invalid IP from DNS for $domain: $ip"
            exit 1
        fi
        echo "Adding $ip for $domain"
        ipset add allowed-domains "$ip" -exist
    done < <(echo "$ips")
done

# Get host IP from default route
HOST_IP=$(ip route | grep default | cut -d" " -f3)
if [ -z "$HOST_IP" ]; then
    echo "ERROR: Failed to detect host IP"
    exit 1
fi

HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")
echo "Host network detected as: $HOST_NETWORK"

# Set up remaining iptables rules
iptables -A INPUT -s "$HOST_NETWORK" -j ACCEPT
iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

# Set default policies to DROP first
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# First allow established connections for already approved traffic
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Then allow only specific outbound traffic to allowed domains
iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT

# Explicitly REJECT all other outbound traffic for immediate feedback
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "Firewall configuration complete"
echo "Verifying firewall rules..."
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - was able to reach https://example.com"
    exit 1
else
    echo "Firewall verification passed - unable to reach https://example.com as expected"
fi

# Verify GitHub API access
if ! curl --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://api.github.com"
    exit 1
else
    echo "Firewall verification passed - able to reach https://api.github.com as expected"
fi
FW_EOF

# ============================================================
# .claude/settings.json  (permission allowlist)
# ============================================================
cat > .claude/settings.json <<'SETTINGS_EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git commit:*)",
      "Bash(git fetch:*)",
      "Bash(git pull:*)",
      "Bash(git push:*)",
      "Bash(git check-ignore:*)",
      "Bash(git log:*)",
      "Bash(git diff:*)",
      "Bash(git status:*)",
      "Bash(git branch:*)",
      "Bash(git checkout:*)",
      "Bash(git stash:*)",
      "Bash(python3:*)",
      "Bash(python:*)",
      "Bash(pip install:*)",
      "Bash(pip list:*)",
      "Bash(grep:*)",
      "Bash(find:*)",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(echo:*)",
      "Bash(diff:*)",
      "Bash(test:*)",
      "Bash(curl:*)",
      "Bash(wc:*)",
      "Bash(gh pr list:*)",
      "Bash(gh pr view:*)",
      "Bash(gh pr create:*)",
      "Bash(gh issue list:*)",
      "Bash(gh issue view:*)"
    ]
  }
}
SETTINGS_EOF

chmod +x launch-claude.sh .devcontainer/init-firewall.sh

echo "Claude Code sandbox scaffold written to: $(pwd)"
echo "  launch-claude.sh"
echo "  .devcontainer/{devcontainer.json,Dockerfile,init-firewall.sh}"
echo "  .claude/settings.json"
echo ""
echo "Next:"
echo "  ./launch-claude.sh            # build the image + start Claude Code"
echo "  ./launch-claude.sh --rebuild  # after you edit the Dockerfile's deps block"
