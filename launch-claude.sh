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

echo ""
echo "Launching Claude Code..."
devcontainer exec --workspace-folder "$WORKSPACE_DIR" claude
