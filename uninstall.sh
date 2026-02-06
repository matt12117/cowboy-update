#!/usr/bin/env bash
# MIT License
# Copyright (c) 2026 sunny
# See LICENSE file for full details

# Check for --purge flag
PURGE=false
if [[ "$1" == "--purge" ]]; then
    PURGE=true
    echo -e "\e[33m⚠️  Running in PURGE mode - will remove EVERYTHING\e[0m"
    echo ""
fi

echo "Uninstalling Cowboy Update..."
echo ""

REPO_DIR="$HOME/cowboy-update"
BIN_DIR="$HOME/.local/bin"
BIN_NAME="cowboy"
DESKTOP_FILE="$HOME/.local/share/applications/cowboy.desktop"
DESKTOP_SHORTCUT="$HOME/Desktop/cowboy.desktop"

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Track what was removed
REMOVED=()
NOT_FOUND=()

# ---- Confirm uninstall ----
echo -e "${YELLOW}This will remove:${RESET}"
echo "  • Command symlink: $BIN_DIR/$BIN_NAME"
echo "  • Uninstall command: $BIN_DIR/cowboy-uninstall"
echo "  • Desktop entry: $DESKTOP_FILE"
[ -f "$DESKTOP_SHORTCUT" ] && echo "  • Desktop shortcut: $DESKTOP_SHORTCUT"
echo ""
echo -e "${YELLOW}This will NOT remove (unless using --purge):${RESET}"
echo "  • Repository directory: $REPO_DIR"
echo "  • PATH modifications in shell config files"
echo ""

if [ "$PURGE" = true ]; then
    echo -e "${RED}PURGE MODE: Repository and PATH modifications WILL be removed!${RESET}"
    echo ""
    read -p "Are you SURE you want to completely remove Cowboy Update? (y/N): " confirm
else
    read -p "Continue with uninstall? (y/N): " confirm
fi

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uninstall canceled."
    exit 0
fi

echo ""

# ---- Remove command symlink ----
if [ -L "$BIN_DIR/$BIN_NAME" ] || [ -f "$BIN_DIR/$BIN_NAME" ]; then
    rm -f "$BIN_DIR/$BIN_NAME"
    REMOVED+=("Command symlink")
    echo -e "${GREEN}✓${RESET} Removed command symlink"
else
    NOT_FOUND+=("Command symlink")
    echo "  Command symlink not found (already removed?)"
fi

# ---- Remove uninstall command symlink ----
if [ -L "$BIN_DIR/cowboy-uninstall" ] || [ -f "$BIN_DIR/cowboy-uninstall" ]; then
    rm -f "$BIN_DIR/cowboy-uninstall"
    REMOVED+=("Uninstall command")
    echo -e "${GREEN}✓${RESET} Removed uninstall command"
else
    echo "  Uninstall command not found (skipping)"
fi

# ---- Remove desktop entry ----
if [ -f "$DESKTOP_FILE" ]; then
    rm -f "$DESKTOP_FILE"
    REMOVED+=("Desktop entry")
    echo -e "${GREEN}✓${RESET} Removed desktop entry"
else
    NOT_FOUND+=("Desktop entry")
    echo "  Desktop entry not found (already removed?)"
fi

# ---- Remove desktop shortcut ----
if [ -f "$DESKTOP_SHORTCUT" ]; then
    rm -f "$DESKTOP_SHORTCUT"
    REMOVED+=("Desktop shortcut")
    echo -e "${GREEN}✓${RESET} Removed desktop shortcut"
else
    echo "  Desktop shortcut not found (skipping)"
fi

# ---- Update desktop database ----
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$HOME/.local/share/applications" &>/dev/null || true
    echo -e "${GREEN}✓${RESET} Updated desktop database"
fi

# ---- Check for repository ----
echo ""
if [ -d "$REPO_DIR" ]; then
    echo -e "${YELLOW}Repository directory found:${RESET} $REPO_DIR"
    
    if [ "$PURGE" = true ]; then
        remove_repo="y"
    else
        read -p "Remove repository directory? (y/N): " remove_repo
    fi
    
    if [[ "$remove_repo" =~ ^[Yy]$ ]]; then
        rm -rf "$REPO_DIR"
        REMOVED+=("Repository directory")
        echo -e "${GREEN}✓${RESET} Removed repository directory"
    else
        echo "  Kept repository directory (you can delete manually later)"
    fi
else
    echo "  Repository directory not found at $REPO_DIR"
fi

# ---- Check PATH modifications ----
echo ""
echo "Checking for PATH modifications in shell config files..."

# Check common shell config files
SHELL_CONFIGS=(
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.zshrc"
    "$HOME/.profile"
    "$HOME/.config/fish/config.fish"
)

FOUND_PATH_MODS=false
for config in "${SHELL_CONFIGS[@]}"; do
    if [ -f "$config" ]; then
        if grep -q "Added by Cowboy Update installer" "$config" 2>/dev/null || \
           grep -q "HOME/.local/bin.*PATH" "$config" 2>/dev/null; then
            echo -e "${YELLOW}  Found PATH entry in:${RESET} $config"
            FOUND_PATH_MODS=true
        fi
    fi
done

if [ "$FOUND_PATH_MODS" = true ]; then
    echo ""
    echo -e "${YELLOW}Note:${RESET} PATH modifications were left in place because other apps"
    echo "may depend on ~/.local/bin being in your PATH."
    echo ""
    
    if [ "$PURGE" = true ]; then
        remove_path="y"
    else
        read -p "Remove PATH modifications from shell configs? (y/N): " remove_path
    fi
    
    if [[ "$remove_path" =~ ^[Yy]$ ]]; then
        for config in "${SHELL_CONFIGS[@]}"; do
            if [ -f "$config" ]; then
                # Create backup
                cp "$config" "$config.backup-$(date +%Y%m%d-%H%M%S)"
                
                # Remove the line added by installer
                sed -i '/# Added by Cowboy Update installer/d' "$config"
                sed -i '/export PATH="\$HOME\/.local\/bin:\$PATH"/d' "$config"
                
                echo -e "${GREEN}✓${RESET} Cleaned $config (backup created)"
            fi
        done
        echo ""
        echo -e "${YELLOW}Reload your shell or run:${RESET}"
        echo "  source ~/.bashrc  # or ~/.zshrc or ~/.config/fish/config.fish"
    fi
else
    echo "  No PATH modifications found"
fi

# ---- Final summary ----
echo ""
echo "════════════════════════════════════════"
if [ ${#REMOVED[@]} -gt 0 ]; then
    echo -e "${GREEN}✅ Uninstall complete!${RESET}"
    echo "════════════════════════════════════════"
    echo ""
    echo "Removed:"
    for item in "${REMOVED[@]}"; do
        echo "  • $item"
    done
else
    echo -e "${YELLOW}⚠️  Nothing was removed${RESET}"
    echo "════════════════════════════════════════"
    echo ""
    echo "Cowboy Update doesn't appear to be installed"
fi

echo ""
echo "Thank you for using Cowboy Update! 🤠"
echo ""
if [ "$PURGE" = false ]; then
    echo "💡 Tip: Use 'cowboy-uninstall --purge' to remove everything including"
    echo "   the repository and PATH modifications."
    echo ""
fi
