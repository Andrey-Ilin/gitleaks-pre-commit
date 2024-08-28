#!/bin/bash

set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure git is installed
if ! command_exists git; then
    echo "Error: git is not installed. Please install git and try again."
    exit 1
fi

# Ensure we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository. Please run this script from within a git repository."
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Download the pre-commit hook
echo "Downloading pre-commit hook..."
curl -sSL https://raw.githubusercontent.com/andrey-ilin/gitleaks-pre-commit/main/pre-commit-hook.sh > .git/hooks/pre-commit

# Make the hook executable
chmod +x .git/hooks/pre-commit

# Enable the pre-commit hook
git config hooks.precommit.enabled true

echo "Pre-commit hook installed successfully!"
echo "The hook is now enabled. To disable it, run: git config hooks.precommit.enabled false"