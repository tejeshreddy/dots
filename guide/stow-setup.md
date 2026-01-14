# GNU Stow Setup Guide

## Adding a new config file

1. Copy/move the file to the dots repo (maintaining the path structure from home):
   ```bash
   # For files in home root (like .zshrc)
   cp ~/.zshrc ~/dots/.zshrc

   # For XDG configs
   cp ~/.config/ghostty/config ~/dots/.config/ghostty/config
   ```

2. Remove the original file (stow won't overwrite existing files):
   ```bash
   rm ~/.zshrc
   ```

3. Run stow from the dots directory:
   ```bash
   cd ~/dots
   stow .
   ```

## Common Commands

```bash
# Deploy all dotfiles (creates symlinks)
cd ~/dots && stow .

# Remove all symlinks
cd ~/dots && stow -D .

# Dry run (see what would happen without making changes)
cd ~/dots && stow -n -v .

# Re-stow (useful after adding new files)
cd ~/dots && stow -R .
```

## Troubleshooting

If stow complains about existing files:
```bash
# Back up and remove the conflicting file first
mv ~/.zshrc ~/.zshrc.backup
cd ~/dots && stow .
```
