# Dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io/).

## New Machine Setup

### 1. Install chezmoi and apply

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply sandudorogan
```

This single command:
- Installs chezmoi
- Clones this repository to `~/.local/share/chezmoi`
- Runs all initialization scripts (Homebrew, packages, NVM, Rust, etc.)
- Applies dotfiles to your home directory

### 2. Transfer age key (for secrets decryption)

Copy `~/.config/chezmoi/key.txt` from an existing machine (USB, AirDrop, etc.) before running `chezmoi apply`. Without it, encrypted files (API keys, tokens) won't decrypt.

### 3. Restart your shell

```bash
exec zsh -l
```

## What Gets Installed

The initialization scripts install (macOS, Ubuntu, and Arch):

| Category | Packages |
|----------|----------|
| **Homebrew** | Auto-installed if missing |
| **CLI Tools** | git, neovim, tmux, fzf, ripgrep, eza, bat, tldr, ffmpeg, pass, age, atuin, direnv, yazi, difftastic, glow, hyperfine, tokei, zoxide, dust, chafa, poppler, p7zip, git-delta, lazygit, lazydocker, htop, neofetch, newsboat, calcurse, lynx, wget, fish, zsh, highlight, w3m, yt-dlp, peon-ping |
| **Clojure** | clojure, babashka, clojure-lsp |
| **Languages** | NVM + Node.js LTS, Rust (rustup) |
| **AI Tools** | Claude Code, Gemini CLI |
| **GUI Apps** | Alacritty |
| **Python** | pipx, fanficfare, bpytop |
| **Shell** | oh-my-zsh, fzf keybindings |
| **Themes** | Alacritty themes, JetBrains Mono Nerd Font |

See `.chezmoidata/packages.yaml` for the complete list.

## Secrets

API keys and tokens are stored in `~/.local/bin/env`, encrypted with [age](https://github.com/FiloSottile/age) via chezmoi. The shell sources this file automatically on login.

To edit secrets:

```bash
chezmoi edit ~/.local/bin/env
```

This decrypts the file into your editor, then re-encrypts on save.

## Making Changes

### Edit a managed file

```bash
chezmoi edit ~/.config/tmux/tmux.conf
```

This opens the source file in your editor. After saving:

```bash
chezmoi apply
```

### Add a new file to chezmoi

```bash
chezmoi add ~/.config/someapp/config.toml
```

### Preview changes before applying

```bash
chezmoi diff
```

### Commit and push changes

```bash
cd ~/.local/share/chezmoi
git add -A
git commit -m "description of changes"
git push
```

Or use chezmoi's built-in git commands:

```bash
chezmoi git add -A
chezmoi git commit -m "description of changes"
chezmoi git push
```

## Pulling Updates

On other machines, pull and apply the latest changes:

```bash
chezmoi update
```

This runs `git pull` and `chezmoi apply` in one command.

## Script Execution

Scripts run in this order during `chezmoi apply`:

| Order | Script | Type | Purpose |
|-------|--------|------|---------|
| 00 | install-homebrew | onchange | Install/update Homebrew |
| 10 | install-packages | onchange | Install OS packages |
| 20 | install-nvm | once | Install NVM + Node.js |
| 21 | install-rustup | once | Install Rust |
| 22 | install-claude-code | once | Install Claude Code |
| 23 | install-gemini-cli | once | Install Gemini CLI |
| 25 | install-cargo-packages | onchange | Install cargo packages (Ubuntu) |
| 30 | install-pipx-packages | onchange | Install pipx packages |
| *dotfiles applied* | | | |
| 90 | post-install | once | fzf, themes, oh-my-zsh, peon-ping |

- **onchange**: Re-runs when `.chezmoidata/packages.yaml` changes
- **once**: Runs only on first apply (tools have their own update mechanisms)

## Directory Structure

```
~/.local/share/chezmoi/
├── .chezmoidata/
│   └── packages.yaml          # Declarative package list
├── .chezmoi.toml.tmpl         # Chezmoi configuration
├── dot_config/                # ~/.config/* files
├── dot_local/                 # ~/.local/* files
├── run_onchange_before_*      # Re-run on package changes
├── run_once_*                 # One-time setup scripts
└── tests/                     # BATS test suite (ignored by chezmoi)
```

## Troubleshooting

### Check what would change

```bash
chezmoi apply --dry-run --verbose
```

### Re-run a "once" script

Remove the script from chezmoi's state:

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Force re-apply all files

```bash
chezmoi apply --force
```

## Testing

Install scripts are tested with [BATS](https://github.com/bats-core/bats-core) to verify template rendering and script correctness.

### Install test dependencies

```bash
brew install bats-core
brew tap kaos/shell
brew install bats-assert bats-support
```

### Run tests

```bash
cd ~/.local/share/chezmoi
./tests/run_tests.sh
```

Tests verify templates render correctly and contain expected content (URLs, flags, paths) without actually running installers.
