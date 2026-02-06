#!/usr/bin/env bash
set -e
# Get version from git tag if available
if command -v git &>/dev/null && [ -d "$HOME/cowboy-update/.git" ]; then
    cd "$HOME/cowboy-update"
    VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "dev")
    cd - > /dev/null
else
    VERSION="unknown"
fi

echo "⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⣤⣤⣭⣍⣩⣭⣤⣬⠹⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡟⣸⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⢁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⣿⣿⣿⣿⣿⣿⣿
⣿⠟⢋⣉⣉⣉⣉⣉⠘⠛⠠⠀⠀⠤⠤⠠⠀⠉⠛⠃⢉⣉⣉⣉⢉⠛⠿
⡇⠀⠀⠀⠀⠉⠉⠙⠛⠛⠒⠒⠶⠒⠒⠖⠖⠘⠛⠉⠈⠉⠉⠀⠀⠀⠀
⣿⣄⠀⠀⠀⠀⠀⡦⠀⣾⣅⣀⡈⢷⡆⢀⢐⣹⡦⠀⢶⠀⠀⠀⠀⠀⣰
⣿⣿⣧⣄⠀⠀⢀⠃⠀⠛⢛⣋⣠⣴⣄⠘⠛⠿⠇⠀⠂⠀⠀⠀⣠⣾⣿
⣿⣿⣿⡿⢋⠤⠈⠀⠨⢭⣭⣭⣽⣿⡏⠀⣠⡶⠛⠁⢀⡠⣴⣿⣿⣿⣿
⣿⣿⡟⡰⠣⢊⢠⠀⡑⢶⣶⣶⣼⣿⠁⢰⣿⡶⠃⡀⢨⣿⣿⣿⣿⣿⣿
⣿⣿⣇⣡⣴⡿⠀⡆⠈⢲⣬⣙⣻⣿⡆⢸⡿⢁⠌⣴⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡇⠖⣠⡐⣄⢻⡙⣿⣿⣷⢸⣷⡟⣼⠇⣾⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣷⣿⣿⣷⡙⢾⣧⠘⣿⣿⢸⣿⡴⢃⣾⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠻⡆⢹⣿⡿⢋⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo -e "\e[1mCowboy-Update|$VERSION by sunny\e[0m"
echo "Installing Cowboy-Update..."

REPO_DIR="$HOME/cowboy-update"
BIN_DIR="$HOME/.local/bin"
BIN_NAME="cowboy"
SCRIPT="$REPO_DIR/cowboy"

# ---- Dependency checks ----
echo "Checking dependencies..."
MISSING_DEPS=()
for cmd in git paru pacman flatpak; do
    if ! command -v "$cmd" &>/dev/null; then
        MISSING_DEPS+=("$cmd")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "❌ Error: Missing required dependencies: ${MISSING_DEPS[*]}"
    echo "Please install them first."
    exit 1
fi
echo "✓ All dependencies found"

# ---- Ensure repo exists ----
if [[ ! -d "$REPO_DIR/.git" ]]; then
    echo "❌ Error: cowboy-update repo not found in $REPO_DIR"
    echo "Please clone it first:"
    echo "  git clone https://github.com/yourusername/cowboy-update.git $REPO_DIR"
    exit 1
fi
echo "✓ Repository found at $REPO_DIR"

# ---- Verify script exists ----
if [[ ! -f "$SCRIPT" ]]; then
    echo "❌ Error: Main script not found at $SCRIPT"
    exit 1
fi

# ---- Make script executable ----
chmod +x "$SCRIPT"
echo "✓ Made script executable"

# ---- Detect terminal ----
echo "Detecting terminal emulator..."
TERMINALS=()
command -v cosmic-term &>/dev/null && TERMINALS+=("cosmic-term -e")
command -v konsole &>/dev/null && TERMINALS+=("konsole -e")
command -v gnome-terminal &>/dev/null && TERMINALS+=("gnome-terminal --")
command -v alacritty &>/dev/null && TERMINALS+=("alacritty -e")
command -v kitty &>/dev/null && TERMINALS+=("kitty -e")
command -v xterm &>/dev/null && TERMINALS+=("xterm -e")

if [ ${#TERMINALS[@]} -eq 0 ]; then
    echo "❌ Error: No supported terminal found."
    echo "Supported terminals: cosmic-term, konsole, gnome-terminal, alacritty, kitty, xterm"
    exit 1
elif [ ${#TERMINALS[@]} -eq 1 ]; then
    TERMINAL="${TERMINALS[0]}"
    echo "✓ Using terminal: $TERMINAL"
else
    echo "Multiple terminals detected:"
    for i in "${!TERMINALS[@]}"; do
        echo "  $((i+1)). ${TERMINALS[$i]}"
    done
    read -p "Choose terminal (1-${#TERMINALS[@]}): " choice
    
    # Validate input
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#TERMINALS[@]} ]; then
        echo "❌ Invalid choice. Exiting."
        exit 1
    fi
    
    TERMINAL="${TERMINALS[$((choice-1))]}"
    echo "✓ Selected terminal: $TERMINAL"
fi

# ---- Create symlink ----
echo "Creating command symlink..."
mkdir -p "$BIN_DIR"

# Remove old symlink if it exists
[ -L "$BIN_DIR/$BIN_NAME" ] && rm "$BIN_DIR/$BIN_NAME"

ln -sf "$SCRIPT" "$BIN_DIR/$BIN_NAME"
echo "✓ Created symlink: $BIN_DIR/$BIN_NAME -> $SCRIPT"

# ---- Create uninstall symlink ----
UNINSTALL_SCRIPT="$REPO_DIR/uninstall.sh"
if [ -f "$UNINSTALL_SCRIPT" ]; then
    chmod +x "$UNINSTALL_SCRIPT"
    [ -L "$BIN_DIR/cowboy-uninstall" ] && rm "$BIN_DIR/cowboy-uninstall"
    ln -sf "$UNINSTALL_SCRIPT" "$BIN_DIR/cowboy-uninstall"
    echo "✓ Created uninstall command: cowboy-uninstall"
fi

# ---- Check PATH ----
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo ""
    echo "⚠️  WARNING: $BIN_DIR is not in your PATH"
    echo ""
    echo "To use the 'cowboy' command, add this line to your shell config:"
    
    # Detect shell
    if [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_RC="~/.zshrc"
    else
        SHELL_RC="~/.bashrc"
    fi
    
    echo ""
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Add it to $SHELL_RC, then run:"
    echo "    source $SHELL_RC"
    echo ""
    
    read -p "Add to $SHELL_RC automatically? This will allow you to run 'cowboy' in terminal. (y/n): " add_path
    if [[ "$add_path" =~ ^[Yy]$ ]]; then
        SHELL_RC_EXPANDED="${SHELL_RC/#\~/$HOME}"
        
        # Check if line already exists
        if grep -q "HOME/.local/bin" "$SHELL_RC_EXPANDED" 2>/dev/null; then
            echo "✓ PATH already configured in $SHELL_RC"
        else
            echo "" >> "$SHELL_RC_EXPANDED"
            echo "# Added by Cowboy Update installer" >> "$SHELL_RC_EXPANDED"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC_EXPANDED"
            echo "✓ Added to $SHELL_RC"
            echo "Run: source $SHELL_RC"
        fi
    fi
else
    echo "✓ $BIN_DIR is already in PATH"
fi

# ---- Desktop entry ----
echo "Creating desktop entry..."
DESKTOP_FILE="$HOME/.local/share/applications/cowboy.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

# Use full path to cowboy for reliability
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Cowboy Update
Comment=Update Arch, AUR, and Flatpak packages
Exec=$TERMINAL $BIN_DIR/$BIN_NAME
Icon=cowboy-icon
Terminal=true
Type=Application
Categories=System;Settings;PackageManager;
Keywords=update;upgrade;pacman;aur;flatpak;
EOF

echo "✓ Created desktop entry: $DESKTOP_FILE"

# Update desktop database
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" &>/dev/null || true
    echo "✓ Updated desktop database"
fi

# ---- Desktop shortcut (optional) ----
if [ -d "$HOME/Desktop" ]; then
    read -p "Create desktop shortcut? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        DESKTOP_SHORTCUT="$HOME/Desktop/cowboy.desktop"
        cp "$DESKTOP_FILE" "$DESKTOP_SHORTCUT"
        chmod +x "$DESKTOP_SHORTCUT"
        
        # Make it trusted (for GNOME/etc)
        if command -v gio &>/dev/null; then
            gio set "$DESKTOP_SHORTCUT" metadata::trusted yes 2>/dev/null || true
        fi
        
        echo "✓ Created desktop shortcut"
    fi
fi

# ---- Final summary ----
echo ""
echo "════════════════════════════════════════"
echo "  Installation complete!"
echo "════════════════════════════════════════"
echo ""
echo "Usage:"
echo "  • Run updates: cowboy"
echo "  • Uninstall: cowboy-uninstall"
echo "  • Application menu: Search for 'Cowboy Update'"
if [ -f "$HOME/Desktop/cowboy.desktop" ]; then
    echo "  • Desktop: Double-click the desktop icon"
fi
echo ""

# Check if PATH issue exists
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "⚠️  Remember to reload your shell or run:"
    echo "    source $SHELL_RC"
    echo ""
fi
