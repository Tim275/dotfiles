# dotfiles

Personal dotfiles for macOS & Linux, managed with [chezmoi](https://chezmoi.io).

## Install

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply Tim275
```

Installs chezmoi, clones this repo, installs Homebrew and everything in the `Brewfile`, then applies every config.

## What's inside

- **shell** — zsh, starship, atuin, fastfetch
- **editor** — Neovim (LazyVim, Go & Python, LSP / DAP / tests)
- **terminal** — Ghostty, tmux
- **desktop** — aerospace, sketchybar, karabiner
- **tools** — mise, git and ~120 more (`Brewfile`)

## Usage

```sh
chezmoi edit ~/.zshrc   # edit a config
chezmoi re-add          # pull in changes edited directly
chezmoi git push        # sync to GitHub
```
