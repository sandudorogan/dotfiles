# System Configuration

## Overview

- **OS**: macOS (Darwin)
- **Shell**: zsh
- **Terminal**: Alacritty
- **Multiplexer**: tmux
- **Editor**: Neovim (nvim)
- **Dotfiles Manager**: chezmoi

Follow the instructions of the specific tool & env you're running in.

## Dotfiles Location

Dotfiles are managed by chezmoi. Source directory:

```
~/.local/share/chezmoi/
```

## Coding Preferences

- **Package manager**: Prefer `bun` over npm/yarn/pnpm when possible
- **Comments**: Minimize code comments. Code should be self-documenting. Only add comments when logic is non-obvious or for required documentation (e.g., public API docs)

## Notes

- Neovim config is maintained separately in `~/workdir/nvim-config/` and symlinked
- When modifying dotfiles, edit the chezmoi source files, then run `chezmoi apply`

## Commit Messages

NEVER include co-authored by Claude or any claude information in any commit messages or pr descriptions.

Write commit messages and PR descriptions as a humble but experienced engineer would. Keep it casual, avoid listicles, briefly describe what we're doing and highlight non-obvious implementation choices but don't overthink it.

Don't embarrass me with robot speak, marketing buzzwords, or vague fluff. You're not writing a fucking pamphlet. Just leave a meaningful trace so someone can understand the choices later. Assume the reader is able to follow the code perfectly fine.

## Pull request expectations

PRs should use the template if available.
Provide a summary, test plan and issue number if applicable, then check that:

New tests are added when needed.
Documentation is updated.
The full test suite passes.

## Code Change Guidelines

- Full file read before edits: Before editing any file, read it in full first to ensure complete context; partial reads lead to corrupted edits
- Minimize diffs: Prefer the smallest change that satisfies the request. Avoid unrelated refactors or style rewrites unless necessary for correctness
- Fail fast: Write code with fail-fast logic by default. Do not swallow exceptions with errors or warnings
- No fallback logic: Do not add fallback logic unless explicitly told to and agreed with the user
- No guessing: Do not say "The issue is..." before you actually know what the issue is. Investigate first.
