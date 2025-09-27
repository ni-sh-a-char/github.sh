# github.sh  
**Script to automate git from working directory.**  

`github.sh` is a lightweight Bash helper that wraps the most common Git operations into short, memorable commands. It is designed to be run from any project directory, eliminating the need to remember long `git` invocations or to type repetitive flags.  

---  

## Table of Contents  

| Section | Description |
|---------|-------------|
| [Features](#features) | What the script can do |
| [Prerequisites](#prerequisites) | Required tools & environment |
| [Installation](#installation) | How to get the script on your system |
| [Usage](#usage) | Quick‑start command reference |
| [API Documentation](#api-documentation) | Functions, environment variables, and exit codes |
| [Examples](#examples) | Real‑world workflows |
| [Configuration](#configuration) | Customising behaviour |
| [Contributing](#contributing) | How to help improve the project |
| [License](#license) | Open‑source terms |

---  

## Features  

- **One‑liner shortcuts** for `git status`, `add`, `commit`, `push`, `pull`, `branch`, `checkout`, `merge`, `rebase`, `log`, and more.  
- **Automatic branch detection** – the script knows the current branch and can act on it without extra flags.  
- **Smart commit messages** – optional template that pre‑populates the message with ticket IDs, timestamps, or emojis.  
- **Safety checks** – prevents accidental force‑pushes, pushes to protected branches, or committing with untracked files unless explicitly allowed.  
- **Pluggable extensions** – you can source additional Bash functions to extend the command set.  

---  

## Prerequisites  

| Tool | Minimum version | Why |
|------|----------------|-----|
| `bash` | 4.0+ | Script is written in Bash. |
| `git` | 2.20+ | Core VCS. |
| `coreutils` (optional) | – | For `realpath`, `basename`, etc. |
| `sed`, `awk`, `grep` | – | Used internally for parsing. |

> **Tip:** The script works on Linux, macOS, and WSL (Windows Subsystem for Linux).  

---  

## Installation  

### 1️⃣ Clone the repository  

```bash
git clone https://github.com/your‑username/github.sh.git
cd github.sh
```

### 2️⃣ Make the script executable  

```bash
chmod +x github.sh
```

### 3️⃣ Add to your `$PATH` (recommended)  

You can either move the script to a directory that is already on `$PATH` (e.g. `/usr/local/bin`) or add the repository’s `bin/` folder to your path.

```bash
# Option A – system‑wide (requires sudo)
sudo mv github.sh /usr/local/bin/github

# Option B – user‑local
mkdir -p "$HOME/.local/bin"
mv github.sh "$HOME/.local/bin/github"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

> **Note:** The command name is `github` (no extension) for convenience.

### 4️⃣ Verify the installation  

```bash
github --version
# Expected output: github.sh v1.2.0
```

---  

## Usage  

`github` follows the pattern:

```bash
github <subcommand> [options] [arguments]
```

### Quick reference  

| Subcommand | Description | Example |
|------------|-------------|---------|
| `status`   | Show `git status` in a compact format. | `github status` |
| `add`      | Stage files (defaults to `.`). | `github add src/` |
| `commit`   | Commit staged changes. Supports `-m`, `-a`, `-e`. | `github commit -m "Fix bug #42"` |
| `push`     | Push current branch to its upstream. | `github push` |
| `pull`     | Pull & rebase (or merge) the upstream. | `github pull --rebase` |
| `branch`   | List, create, delete, or rename branches. | `github branch -c feature/login` |
| `checkout`| Switch branches or restore files. | `github checkout develop` |
| `merge`    | Merge another branch into the current one. | `github merge feature/ui` |
| `rebase`   | Rebase current branch onto another. | `github rebase main` |
| `log`      | Pretty‑printed log (default 10 entries). | `github log -n 20` |
| `reset`    | Reset HEAD or working tree (safe defaults). | `github reset --hard` |
| `clean`    | Remove untracked files/directories. | `github clean -fd` |
| `help`     | Show help for a subcommand. | `github help commit` |
| `--version`| Print version information. | `github --version` |

### Global options  

| Flag | Meaning |
|------|---------|
| `-q, --quiet` | Suppress informational output (only errors). |
| `-v, --verbose` | Show detailed debug information. |
| `-h, --help` | Show the top‑level help. |

### Subcommand‑specific options  

Below is a condensed list; see the **API Documentation** section for the full spec.

| Subcommand | Option | Description |
|------------|--------|-------------|
| `commit` | `-m <msg>` | Use `<msg>` as the commit message (no editor). |
| | `-a` | Stage *all* modified files before committing. |
| | `-e` | Open the default `$EDITOR` for the commit message. |
| `push` | `-f, --force` | Force‑push (disabled by default on protected branches). |
| | `--set-upstream` | Set upstream to the remote branch if missing. |
| `pull` | `--rebase` | Pull with `--rebase` instead of merge. |
| `branch` | `-c <name>` | Create a new branch `<name>` and switch to it. |
| | `-d <name>` | Delete branch `<name>` (local only). |
| | `-r <old:new>` | Rename branch `<old>` to `<new>`. |
| `log` | `-n <num>` | Show the last `<num>` commits (default 10). |
| | `--oneline` | One‑line per commit (default). |
| | `--graph` | Include a graph view. |
| `reset` | `--soft` | Keep working tree, reset only HEAD. |
| | `--mixed` | Reset index but keep working tree (default). |
| | `--hard` | Reset index **and** working tree. |
| `clean` | `-f` | Force removal (required by Git). |
| | `-d` | Remove untracked directories as well. |

---  

## API Documentation  

`github.sh` is a single‑file Bash library that can also be **sourced** from other scripts. All public functions are prefixed with `gh_` to avoid name clashes.

| Function | Synopsis | Description | Exit codes |
|----------|----------|-------------|------------|
| `gh_version` | `gh_version` | Prints the script version (`vX.Y.Z`). | `0` |
| `gh_status` | `gh_status [-q]` | Wrapper around `git status --short`. `-q` suppresses the “On branch …” line. | `0` on success, `1` on Git error |
| `gh_add` | `gh_add [<path>…]` | Stages the given paths (or `.` if omitted). | `0` / `1` |
| `gh_commit` | `gh_commit [-a] [-m <msg>] [-e]` | Commits staged changes. `-a` stages all modified files first. `-e` opens `$EDITOR`. | `0` / `1` |
| `gh_push` | `gh_push [--force] [<remote> <branch>]` | Pushes the current branch. If `<remote>`/`<branch>` omitted, uses upstream. | `0` / `1` |
| `gh_pull` | `gh_pull [--rebase] [<remote> <branch>]` | Pulls from upstream (or supplied remote/branch). | `0`