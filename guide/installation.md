# Installation Guide

## Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dots.git ~/dots
cd ~/dots
./install.sh
```

## Manual Installation

### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Fedora
sudo dnf install stow
```

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dots.git ~/dots
   ```

2. Backup any existing config files:
   ```bash
   # Check what would conflict
   ls -la ~/.zshrc
   ls -la ~/.config/ghostty/config
   ls -la ~/Library/Preferences/com.googlecode.iterm2.plist  # macOS only

   # Backup if they exist (and aren't already symlinks)
   mv ~/.zshrc ~/.zshrc.backup
   ```

3. Create symlinks with stow:
   ```bash
   cd ~/dots
   stow .
   ```

## What Gets Installed

| File | Description |
|------|-------------|
| `~/.zshrc` | Zsh configuration |
| `~/.config/ghostty/config` | Ghostty terminal config |
| `~/Library/Preferences/com.googlecode.iterm2.plist` | iTerm2 preferences (macOS) |

## Updating

After making changes on one machine, sync to others:

```bash
# On the machine where you made changes
cd ~/dots
git add -A
git commit -m "Update configs"
git push

# On other machines
cd ~/dots
git pull
# Symlinks automatically point to updated files
```

## Uninstalling

Remove all symlinks:

```bash
cd ~/dots
stow -D .
```

## Troubleshooting

### Stow reports conflicts

If stow says a file already exists, back it up first:
```bash
mv ~/.zshrc ~/.zshrc.backup
```

### iTerm2 not picking up settings

Restart iTerm2 after installation. If settings still don't appear, check that the symlink exists:
```bash
ls -la ~/Library/Preferences/com.googlecode.iterm2.plist
```
