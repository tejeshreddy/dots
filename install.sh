
#!/bin/bash
set -e

DOTS_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $DOTS_DIR"

# Check for stow
if ! command -v stow &> /dev/null; then
    echo "GNU Stow not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install stow
        else
            echo "Error: Homebrew not found. Install it first: https://brew.sh"
            exit 1
        fi
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y stow
    else
        echo "Error: Could not install stow. Please install it manually."
        exit 1
    fi
fi

# Backup existing files that would conflict
backup_if_exists() {
    if [[ -e "$1" && ! -L "$1" ]]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

echo "Checking for existing files..."
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.config/ghostty/config"

# Create parent directories if needed
mkdir -p "$HOME/.config"

# Run stow
echo "Creating symlinks..."
cd "$DOTS_DIR"
stow . --verbose

# iTerm2 Dynamic Profiles (macOS only)
# Symlinked manually because the path contains spaces
if [[ "$OSTYPE" == "darwin"* ]]; then
    ITERM_DYNAMIC_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$ITERM_DYNAMIC_DIR"
    ln -sf "$DOTS_DIR/.config/iterm2/DynamicProfiles/profiles.json" \
           "$ITERM_DYNAMIC_DIR/profiles.json"
    echo "iTerm2 Dynamic Profiles symlinked"
fi

echo ""
echo "Done! Dotfiles installed successfully."
echo ""
echo "Installed:"
echo "  - .zshrc"
echo "  - .config/ghostty/config"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  - iTerm2 Dynamic Profiles"
fi
