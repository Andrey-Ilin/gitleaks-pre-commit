#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get OS type
get_os() {
    case "$(uname -s)" in
        Darwin*)    echo 'macOS';;
        Linux*)     echo 'Linux';;
        CYGWIN*)    echo 'Windows';;
        MINGW*)     echo 'Windows';;
        *)          echo 'Unknown';;
    esac
}

# Function to install Gitleaks
install_gitleaks() {
    os=$(get_os)
    if [ "$os" = "macOS" ]; then
        echo "Installing Gitleaks via Homebrew..."
        brew install gitleaks
    elif command_exists docker; then
        echo "Docker detected. Using Gitleaks Docker image..."
        docker pull zricethezav/gitleaks:latest
    elif command_exists go && command_exists make; then
        echo "Installing Gitleaks from source..."
        git clone https://github.com/gitleaks/gitleaks.git
        cd gitleaks
        make build
        sudo mv gitleaks /usr/local/bin/
        cd ..
        rm -rf gitleaks
    else
        echo "Error: Unable to install Gitleaks. Please install Docker or Go and Make, then try again."
        exit 1
    fi
}

# Function to run Gitleaks
run_gitleaks() {
    if command_exists gitleaks; then
        gitleaks detect --verbose
    elif command_exists docker; then
        docker run -v "$(pwd):/path" zricethezav/gitleaks:latest detect --source="/path" --verbose
    else
        echo "Error: Gitleaks not found and unable to run via Docker."
        exit 1
    fi
}

# Check if the pre-commit hook is enabled in git config
is_enabled=$(git config --get hooks.precommit.enabled)

if [ "$is_enabled" = "true" ]; then
    echo "Pre-commit hook is enabled"

    # Check if gitleaks is installed or available via Docker
    if ! command_exists gitleaks && ! command_exists docker; then
        echo "Gitleaks is not installed. Attempting to install..."
        install_gitleaks
    fi

    echo "Running Gitleaks..."
    if ! run_gitleaks; then
        echo "Gitleaks found potential secrets. Please review and fix before committing."
        exit 1
    fi

else
    echo "Pre-commit hook is disabled"
    exit 0
fi

# To enable the hook:
# git config hooks.precommit.enabled true

# To disable the hook:
# git config hooks.precommit.enabled false