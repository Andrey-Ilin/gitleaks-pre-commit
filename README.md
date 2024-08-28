# Gitleaks Pre-commit Hook

This repository contains a pre-commit hook that uses Gitleaks to scan for potential secrets in your code before each commit. It also includes an installation script for easy setup across multiple repositories.

## Contents

- `install.sh`: Script to install the pre-commit hook in a Git repository.
- `pre-commit-hook.sh`: The actual pre-commit hook that runs Gitleaks.

## Features

- Automatic installation of Gitleaks (if not present)
- Support for macOS, Linux, and Windows (via Docker)
- Fallback to building from source if necessary
- Easy installation across multiple repositories

## Prerequisites

- Git
- Bash
- One of the following:
  - Homebrew (for macOS)
  - Docker
  - Go and Make (for building from source)

## Installation

To install the pre-commit hook in your repository, run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/andrey-ilin/gitleaks-pre-commit/main/install.sh | bash
```

This command will:
1. Download the `pre-commit-hook.sh` file to your `.git/hooks` directory.
2. Make the hook executable.
3. Enable the hook in your Git configuration.

## Manual Installation

If you prefer to inspect the script before running it (recommended for security), follow these steps:

1. Download the installation script:
   ```bash
   curl -sSL https://raw.githubusercontent.com/andrey-ilin/gitleaks-pre-commit/main/install.sh > install.sh
   ```

2. Review the script:
   ```bash
   less install.sh
   ```

3. If you're satisfied with the content, run the script:
   ```bash
   bash install.sh
   ```

## Usage

Once installed, the pre-commit hook will run automatically before each commit. It will:

1. Check if Gitleaks is installed and install it if necessary.
2. Run Gitleaks to scan for potential secrets in your code.
3. Abort the commit if any potential secrets are found.

## Disabling the Hook

To temporarily disable the hook for a single commit, use:

```bash
git commit --no-verify
```

To disable the hook entirely, run:

```bash
git config hooks.precommit.enabled false
```

## Updating

To update the pre-commit hook, simply run the installation command again.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)

## Disclaimer

This tool is provided as-is, without any warranty. Always review the scripts and understand what they do before running them in your environment.
