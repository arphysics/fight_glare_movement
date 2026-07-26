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
