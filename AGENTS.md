# System Configuration

## Overview

- **OS**: macOS (Darwin)
- **Shell**: zsh
- **Terminal**: Ghostty
- **Multiplexer**: tmux
- **Editor**: Neovim (nvim)
- **Dotfiles Manager**: chezmoi

## Workspace

All projects live in `~/workdir/`. Neovim config is at `~/workdir/nvim-config/` (symlinked).

## Dotfiles

Managed by chezmoi. Source: `~/.local/share/chezmoi/`

| Command               | Description                       |
| --------------------- | --------------------------------- |
| `chezmoi edit <file>` | Edit a dotfile's source           |
| `chezmoi apply`       | Apply changes from source to home |
| `chezmoi diff`        | Preview pending changes           |
| `chezmoi cd`          | Open shell in source directory    |

Always edit the chezmoi source files, never the target files directly.

## Coding Preferences

- **Package manager**: Prefer `bun` over npm/yarn/pnpm when possible
- **Comments**: Minimize code comments. Code should be self-documenting. Only add comments when logic is non-obvious or for required documentation (e.g., public API docs)
- **Fail fast**: Do not swallow exceptions with errors or warnings
- **No fallback logic**: Do not add fallback logic unless explicitly told to and agreed with the user
- **Minimize diffs**: Prefer the smallest change that satisfies the request. Avoid unrelated refactors or style rewrites unless necessary for correctness

## Commit Messages

Follow the git commit message template at `~/.gitmessage` — type prefixes (`feat`, `fix`, `refactor`, etc.), 50 char subject, imperative mood.

NEVER include co-authored-by or any AI attribution in commit messages or PR descriptions.

Write commit messages and PR descriptions as a humble but experienced engineer would. Keep it casual, briefly describe what we're doing and highlight non-obvious implementation choices but don't overthink it. No robot speak, marketing buzzwords, or vague fluff. Just leave a meaningful trace so someone can understand the choices later.

## Pull Requests

Use the PR template if available. Include summary, test plan, and issue number if applicable. Ensure new tests are added when needed, docs are updated, and the full test suite passes.
