# github.sh  
**Script to automate git from working directory.**  

A lightweight Bash helper that wraps the most common `git` commands, adds sensible defaults, and makes it easy to work with a repository from any sub‑directory. It can be sourced as a library or executed directly as a CLI tool.

---  

## Table of Contents
1. [Installation](#installation)  
2. [Usage](#usage)  
3. [API Documentation](#api-documentation)  
4. [Examples](#examples)  
5. [Contributing & Support](#contributing--support)  

---  

## Installation  

### Prerequisites
| Tool | Minimum version | Why |
|------|----------------|-----|
| `bash` | 4.0+ | Required for associative arrays and `[[ … ]]` tests |
| `git` | 2.20+ | Core functionality |
| `coreutils` (optional) | any | For `realpath`, `dirname`, etc. |

> **Note:** The script is POSIX‑compatible except for a few Bash‑only features (associative arrays, `declare -g`). If you need strict POSIX compliance, see the `POSIX` branch.

### Quick install (single user)

```bash
# 1️⃣ Download the script
curl -fsSL https://raw.githubusercontent.com/your-org/github.sh/main/github.sh \
    -o ~/.local/bin/github.sh

# 2️⃣ Make it executable
chmod +x ~/.local/bin/github.sh

# 3️⃣ Add to your PATH (if not already)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### System‑wide install (root)

```bash
sudo curl -fsSL https://raw.githubusercontent.com/your-org/github.sh/main/github.sh \
    -o /usr/local/bin/github.sh
sudo chmod +x /usr/local/bin/github.sh
```

### As a library (source it)

If you want to call the functions from your own scripts:

```bash
source /path/to/github.sh   # e.g. /usr/local/bin/github.sh
```

### Updating

```bash
# Using curl (single user)
curl -fsSL https://raw.githubusercontent.com/your-org/github.sh/main/github.sh \
    -o ~/.local/bin/github.sh && chmod +x ~/.local/bin/github.sh

# Or, if you cloned the repo:
git -C ~/github.sh pull && sudo cp github.sh /usr/local/bin/
```

---  

## Usage  

`github.sh` can be invoked **directly** (CLI mode) or **sourced** (library mode).  

### CLI Synopsis  

```bash
github.sh <command> [options] [-- <git‑args>]
```

| Command | Description |
|---------|-------------|
| `status` | Show `git status` for the repository root (even if you’re deep inside). |
| `add`    | Shortcut for `git add`. Accepts the same arguments as `git add`. |
| `commit` | Commit with a pre‑filled template. `-m "msg"` works as usual. |
| `push`   | Push current branch to its upstream (or specify remote/branch). |
| `pull`   | Pull with rebase (`git pull --rebase`) by default. |
| `branch` | List, create, delete, or switch branches (`branch -c new`). |
| `checkout` | Checkout a branch or commit (wraps `git checkout`). |
| `log`    | Pretty‑printed log (`git log --oneline --graph`). |
| `reset`  | Reset the working tree (`--hard`, `--soft`, etc.). |
| `help`   | Show this help screen. |

#### Global Options  

| Option | Alias | Description |
|--------|-------|-------------|
| `-h`   | `--help` | Show help and exit. |
| `-v`   | `--version` | Print script version. |
| `-q`   | `--quiet` | Suppress informational messages. |
| `-d`   | `--debug` | Enable Bash `set -x` debugging output. |
| `-r`   | `--repo <path>` | Force a repository root (overrides auto‑discovery). |

#### Example CLI calls  

```bash
# Show status from any sub‑directory
github.sh status

# Add all changes and commit with a message
github.sh add . && github.sh commit -m "Refactor utils"

# Push current branch to origin
github.sh push

# Create a new branch and switch to it
github.sh branch -c feature/login

# Show a compact log
github.sh log -- --decorate
```

> **Tip:** Anything after `--` is passed verbatim to the underlying `git` command, allowing you to use any git flag not explicitly wrapped.

---  

## API Documentation  

When sourced, the script exposes a small, well‑documented function library. All functions are prefixed with `gh_` to avoid name clashes.

| Function | Signature | Description |
|----------|-----------|-------------|
| `gh_find_repo_root` | `gh_find_repo_root [start_dir]` → `string` | Walks up the directory tree from `start_dir` (default `$PWD`) until a `.git` folder is found. Returns the absolute path or exits with error. |
| `gh_git` | `gh_git <git‑subcommand> [args…]` | Thin wrapper that runs `git` from the repository root, preserving the current working directory. Handles error propagation. |
| `gh_status` | `gh_status` | Calls `gh_git status -sb`. |
| `gh_add` | `gh_add <pathspec…>` | Wrapper for `git add`. |
| `gh_commit` | `gh_commit [-m msg] [--amend]` | Commits with optional message. If no `-m` is supplied, opens `$EDITOR` with a template. |
| `gh_push` | `gh_push [remote] [branch]` | Pushes the current branch to the given remote (default `origin`). |
| `gh_pull` | `gh_pull [remote] [branch]` | Pulls with `--rebase` by default. |
| `gh_branch` | `gh_branch [-l] [-c name] [-d name] [name]` | List (`-l`), create (`-c`), delete (`-d`), or checkout (`name`) a branch. |
| `gh_checkout` | `gh_checkout <ref>` | Wrapper for `git checkout`. |
| `gh_log` | `gh_log [git‑log‑options…]` | Pretty‑printed log (`--oneline --graph --decorate`). |
| `gh_reset` | `gh_reset [--hard|--soft|--mixed] [commit]` | Reset the working tree. |
| `gh_help` | `gh_help` | Prints the same help as the CLI. |
| `gh_version` | `gh_version` | Echoes the script version. |

### Internal Constants  

| Name | Value | Purpose |
|------|-------|---------|
| `GH_VERSION` | `1.4.2` | Current script version. |
| `GH_DEFAULT_REMOTE` | `origin` | Default remote used by `push`/`pull`. |
| `GH_LOG_FORMAT` | `"%C(auto)%h %C(bold blue)%d %C(reset)%s %C(green)(%cr)%C(reset)"` | Default `git log` pretty format. |

### Error handling  

All public functions exit with a non‑zero status on failure and print a concise error message to `stderr`. When used in a script, you can capture the error code:

```bash
if ! gh_push; then
    echo "❌ Push failed – aborting" >&2
    exit 1
fi
```

### Extending the library  

You can add your own helpers by sourcing the script **after** your definitions, or by defining functions that call the internal `gh_git` wrapper:

```bash
my_rebase_onto_master() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD)
    gh_git checkout master && gh_git pull && gh_git checkout "$branch" && gh_git rebase master
}
```

---  

## Examples  

### 1️⃣ Quick status from any sub‑folder  

```bash
$ cd ~/projects/my-app/src/components
$ github.sh status
## On branch feature/ui
## Your branch is ahead of 'origin/feature/ui' by 2 commits.
##   (use "git push" to publish your local commits)
##
## Changes not staged for commit:
##   modified:   src/components/Button.vue
##
## Untracked files:
##   src/components/NewWidget.vue
```

### 2️⃣ Automated commit workflow  

```bash
# Add everything, open an editor with a commit template, then push
github.sh add .
github.sh commit          # opens $EDITOR with a template
github.sh