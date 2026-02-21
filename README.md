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

### 2. Restart your shell

```bash
exec zsh -l
```

## What Gets Installed

The initialization scripts install (macOS only):

| Category | Packages |
|----------|----------|
| **Homebrew** | Auto-installed if missing |
| **CLI Tools** | git, neovim, tmux, fzf, ripgrep, eza, bat, ranger, lazygit, lazydocker, htop, etc. |
| **Clojure** | clojure, babashka, clojure-lsp |
| **Languages** | NVM + Node.js LTS, Rust (rustup) |
| **GUI Apps** | Alacritty, Docker Desktop, Zathura |
| **Python** | pipx, fanficfare, bpytop |
| **Shell** | oh-my-zsh, fzf keybindings |
| **Themes** | Alacritty themes, JetBrains Mono Nerd Font |

See `.chezmoidata/packages.yaml` for the complete list.

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
| 10 | install-packages-darwin | onchange | Install brew packages |
| 20 | install-nvm | once | Install NVM + Node.js |
| 21 | install-rustup | once | Install Rust |
| 30 | install-pipx-packages | onchange | Install pipx packages |
| *dotfiles applied* | | | |
| 90 | post-install | once | fzf, themes, oh-my-zsh |

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
