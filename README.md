# dotfiles

Personal dotfiles for macOS & Linux, managed with [chezmoi](https://chezmoi.io).

## Install

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply Tim275
```

Installs chezmoi, clones this repo, installs Homebrew and everything in the `Brewfile`, then applies every config.

## Usage

```sh
chezmoi edit ~/.zshrc   # edit a config
chezmoi re-add          # pull in changes edited directly
chezmoi git push        # sync to GitHub
```
