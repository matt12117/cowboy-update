#!/usr/bin/env bash
set -e

echo "Installing Cowboy Update..."

REPO_DIR="$HOME/cowboy-update"
BIN_DIR="$HOME/.local/bin"
BIN_NAME="cowboy"
SCRIPT="$REPO_DIR/cowboy"

# ---- Dependency checks ----
for cmd in git paru pacman flatpak; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# ---- Detect terminal ----
TERMINALS=()
command -v cosmic-term &>/dev/null && TERMINALS+=("cosmic-term -e")
command -v konsole &>/dev/null && TERMINALS+=("konsole -e")
command -v gnome-terminal &>/dev/null && TERMINALS+=("gnome-terminal --")
command -v alacritty &>/dev/null && TERMINALS+=("alacritty -e")
command -v kitty &>/dev/null && TERMINALS+=("kitty -e")
command -v xterm &>/dev/null && TERMINALS+=("xterm -e")

if [ ${#TERMINALS[@]} -eq 0 ]; then
    echo "Error: No supported terminal found."
    exit 1
elif [ ${#TERMINALS[@]} -eq 1 ]; then
    TERMINAL="${TERMINALS[0]}"
else
    echo "Multiple terminals detected:"
    for i in "${!TERMINALS[@]}"; do
        echo "$((i+1)). ${TERMINALS[$i]}"
    done
    read -p "Choose terminal (1-${#TERMINALS[@]}): " choice
    TERMINAL="${TERMINALS[$((choice-1))]}"
fi

# ---- Ensure repo exists ----
if [[ ! -d "$REPO_DIR/.git" ]]; then
    echo "Error: cowboy-update repo not found in $REPO_DIR"
    echo "Please clone it first:"
    echo "  git clone <repo-url> $REPO_DIR"
    exit 1
fi

chmod +x "$SCRIPT"

# ---- Create symlink (THIS IS THE FIX) ----
mkdir -p "$BIN_DIR"
ln -sf "$SCRIPT" "$BIN_DIR/$BIN_NAME"

# ---- Desktop entry ----
DESKTOP_FILE="$HOME/.local/share/applications/cowboy.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cowboy Update
Comment=Update Arch, AUR, and Flatpak
Exec=$TERMINAL $BIN_NAME
Icon=cowboy-icon
Terminal=true
Type=Application
Categories=System;
EOF

update-desktop-database "$HOME/.local/share/applications" &>/dev/null || true

# ---- Desktop shortcut (optional) ----
read -p "Create desktop shortcut? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    cp "$DESKTOP_FILE" "$HOME/Desktop/cowboy.desktop"
    chmod +x "$HOME/Desktop/cowboy.desktop"
    command -v gio &>/dev/null && gio set "$HOME/Desktop/cowboy.desktop" metadata::trusted yes
fi

echo "✅ Installation complete"
echo "Run with: cowboy"
