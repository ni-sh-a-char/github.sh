# github.sh – Automate Git from Your Working Directory  

**Description**: `github.sh` is a lightweight Bash script that wraps the most common Git commands into a single, easy‑to‑use interface. It lets you perform routine Git operations (clone, pull, push, branch management, PR creation, etc.) without leaving the directory you’re working in.  

---  

## Table of Contents  

1. [Installation](#installation)  
2. [Quick Start](#quick-start)  
3. [Usage](#usage)  
4. [API Documentation](#api-documentation)  
5. [Examples](#examples)  
6. [Configuration & Environment Variables](#configuration--environment-variables)  
7. [Troubleshooting & FAQ](#troubleshooting--faq)  
8. [Contributing](#contributing)  
9. [License](#license)  

---  

## Installation  

### Prerequisites  

| Tool | Minimum Version | Why? |
|------|-----------------|------|
| **Bash** | 4.0+ | Required runtime for the script |
| **Git** | 2.20+ | Core VCS operations |
| **cURL** | any | Used for GitHub API calls (PR creation, status checks) |
| **jq** | 1.6+ | JSON parsing for API responses (optional but recommended) |

> **Tip** – On macOS you can install missing tools with Homebrew: `brew install git curl jq`.  
> On Debian/Ubuntu: `sudo apt-get install git curl jq`.  

### Option 1 – System‑wide installation (recommended)

```bash
# 1️⃣ Clone the repository somewhere permanent (e.g. /opt)
sudo git clone https://github.com/your‑org/github.sh.git /opt/github.sh

# 2️⃣ Make the script executable
sudo chmod +x /opt/github.sh/github.sh

# 3️⃣ Add a symlink to a directory in your $PATH (e.g. /usr/local/bin)
sudo ln -s /opt/github.sh/github.sh /usr/local/bin/github
```

Now you can run the script from any location simply with:

```bash
github <subcommand> [options]
```

### Option 2 – Per‑user installation  

```bash
# Clone into your home directory
git clone https://github.com/your‑org/github.sh.git ~/.github.sh

# Make it executable
chmod +x ~/.github.sh/github.sh

# Add an alias to your shell rc (e.g. ~/.bashrc or ~/.zshrc)
echo 'alias github="~/.github.sh/github.sh"' >> ~/.bashrc
source ~/.bashrc
```

### Option 3 – One‑liner (for quick testing)

```bash
curl -sSL https://raw.githubusercontent.com/your‑org/github.sh/main/github.sh \
  -o /tmp/github.sh && chmod +x /tmp/github.sh && /tmp/github.sh --help
```

> **Note** – The one‑liner does **not** install the script permanently; it’s only for a quick look‑around.

---  

## Quick Start  

```bash
# Clone a repository (creates a local folder and sets up the remote)
github clone https://github.com/owner/repo.git

# Change into the repo and start working
cd repo

# Stage all changes and commit with a message
github commit -am "Add new feature"

# Push the current branch to origin
github push

# Create a new branch and switch to it
github branch -c feature/awesome

# Open a pull request (requires a GitHub token, see config below)
github pr create -t "Add awesome feature" -b main
```

---  

## Usage  

```
github <command> [options] [arguments]
```

| Command | Description | Primary Options |
|---------|-------------|-----------------|
| `clone <url>` | Clone a remote repo into the current directory (or a sub‑folder). | `-d <dir>` – target directory (default: repo name) |
| `status` | Show `git status` with colourised output. | |
| `add <path>` | Stage files (wrapper for `git add`). | `-A` – stage all |
| `commit` | Commit staged changes. | `-m <msg>` – commit message <br> `-a` – auto‑stage modified files |
| `push` | Push current branch to its upstream. | `-f` – force push |
| `pull` | Pull latest changes from upstream. | `--rebase` – rebase instead of merge |
| `branch` | Manage branches. | `-c <name>` – create & checkout <br> `-d <name>` – delete <br> `-l` – list |
| `checkout <branch>` | Switch to another branch. | |
| `log` | Pretty‑printed `git log`. | `-n <N>` – limit entries |
| `pr` | GitHub Pull‑Request helper (requires `GITHUB_TOKEN`). | `create`, `list`, `checkout` |
| `config` | Show or edit script configuration. | `--set <key>=<value>` |
| `help` | Show help for a specific command. | `github help <command>` |
| `version` | Print script version. | |

### Global Options  

| Option | Effect |
|--------|--------|
| `-h, --help` | Show the global help screen. |
| `-v, --verbose` | Enable verbose output (debug mode). |
| `-q, --quiet` | Suppress non‑essential output. |
| `--no-color` | Disable coloured output (useful for CI). |

### Command‑specific Help  

```bash
github help <command>
```

Example:

```bash
github help commit
```

---  

## API Documentation  

`github.sh` is a single‑file Bash script that exposes a small set of **public functions**. They can be sourced by other scripts if you want to embed its capabilities.

| Function | Signature | Description | Exit Codes |
|----------|-----------|-------------|------------|
| `gh_clone` | `gh_clone <repo_url> [target_dir]` | Clone a repository. Handles shallow clones (`--depth 1`) when `GITHUB_SHALLOW=1`. | `0` – success, `1` – git error, `2` – invalid URL |
| `gh_status` | `gh_status` | Wrapper around `git status` with colourised diff. | `0` – success, `1` – not a git repo |
| `gh_add` | `gh_add [-A] <path>` | Stage files. `-A` stages all changes. | `0` – success, `1` – git error |
| `gh_commit` | `gh_commit [-a] -m "<msg>"` | Commit staged changes. `-a` auto‑adds modified files before committing. | `0` – success, `1` – nothing to commit, `2` – git error |
| `gh_push` | `gh_push [remote] [branch]` | Push current branch to the given remote (default `origin`). | `0` – success, `1` – upstream not set, `2` – push rejected |
| `gh_pull` | `gh_pull [remote] [branch]` | Pull from remote. Supports `--rebase`. | `0` – success, `1` – merge conflict, `2` – git error |
| `gh_branch` | `gh_branch -c <name>`<br>`gh_branch -d <name>`<br>`gh_branch -l` | Create, delete, or list branches. | `0` – success, `1` – branch already exists / not found |
| `gh_checkout` | `gh_checkout <branch>` | Switch to a branch (creates it if `-c` flag is used). | `0` – success, `1` – branch not found |
| `gh_log` | `gh_log [-n N]` | Show a pretty log (graph, colours). | `0` – success, `1` – git error |
| `gh_pr_create` | `gh_pr_create -t "<title>" -b <base> [-d "<desc>"]` | Create a PR via GitHub API. Requires `GITHUB_TOKEN`. | `0` – PR created (URL printed), `1` – missing token, `2` – API error |
| `gh_pr_list` | `gh_pr_list [-s open|closed|all]` | List PRs for the current repo. | `0` – success, `1` – API error |
| `gh_pr_checkout` | `gh_pr_checkout <pr_number>` | Fetch and checkout a PR locally (`git fetch origin pull/<num>/head:<branch>`). | `0` – success, `1` – PR not found |
| `gh_config` | `gh_config [--set key=value]` | Get