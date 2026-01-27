# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository managed with GNU Stow for symlink management. The repository root is treated as a stow package directory.

## Usage

To deploy these dotfiles to a home directory:

```bash
cd ~/dots
stow .
```

This creates symlinks from `~/.config/*` pointing to the files in this repo.

To remove symlinks:

```bash
stow -D .
```

## Structure

- `.config/` - XDG config directory containing application configs
  - `ghostty/config` - Ghostty terminal emulator configuration
  - `iterm2/DynamicProfiles/profiles.json` - iTerm2 Dynamic Profiles (symlinked by install.sh)
- `.zshrc` - Zsh configuration
- `.stow-local-ignore` - Patterns for stow to ignore (VCS files, READMEs, etc.)
- `install.sh` - Installation script for new machines
- `guide/` - Documentation and setup guides (not symlinked)

## Guides

Refer to the `guide/` folder for detailed instructions:
- `guide/installation.md` - How to install dotfiles on a new machine
- `guide/stow-setup.md` - How to add new configs and common stow commands

When performing a new process or workflow, check if a guide exists in `guide/`. If not, create one with the basic commands used.

## Adding New Configs

Place config files in their standard XDG paths relative to the repo root. For example:
- Neovim: `.config/nvim/init.lua`
- Zsh: `.zshrc` (at repo root)
