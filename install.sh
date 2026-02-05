#!/bin/bash

echo "Installing Cowboy Update Script..."

# Check if required tools are installed
if ! command -v paru &> /dev/null; then
    echo "Error: paru is not installed. Please install it first."
    exit 1
fi

if ! command -v arch-update &> /dev/null; then
    echo "Error: arch-update is not installed. Please install it first."
    exit 1
fi

if ! command -v flatpak &> /dev/null; then
    echo "Error: flatpak is not installed. Please install it first."
    exit 1
fi

# Detect available terminals
TERMINALS=()
command -v cosmic-term &> /dev/null && TERMINALS+=("cosmic-term -e")
command -v konsole &> /dev/null && TERMINALS+=("konsole -e")
command -v gnome-terminal &> /dev/null && TERMINALS+=("gnome-terminal --")
command -v alacritty &> /dev/null && TERMINALS+=("alacritty -e")
command -v kitty &> /dev/null && TERMINALS+=("kitty -e")
command -v xterm &> /dev/null && TERMINALS+=("xterm -e")

if [ ${#TERMINALS[@]} -eq 0 ]; then
    echo "Error: No supported terminal found."
    exit 1
elif [ ${#TERMINALS[@]} -eq 1 ]; then
    TERMINAL="${TERMINALS[0]}"
    echo "Using terminal: $TERMINAL"
else
    echo "Multiple terminals detected:"
    for i in "${!TERMINALS[@]}"; do
        echo "$((i+1)). ${TERMINALS[$i]}"
    done
    read -p "Which terminal do you want to use? (1-${#TERMINALS[@]}): " choice
    TERMINAL="${TERMINALS[$((choice-1))]}"
    echo "Using terminal: $TERMINAL"
fi


# Copy script to /usr/local/bin
sudo cp cowboy /usr/local/bin/cowboy
sudo chmod +x /usr/local/bin/cowboy

# Copy icon to system pixmaps
sudo cp cowboy-icon.png /usr/share/pixmaps/cowboy-icon.png

# Create desktop file with detected terminal
cat > cowboy.desktop << EOF
[Desktop Entry]
Name=Cowboy Update
Comment=Update Arch, AUR, and Flatpak
Exec=$TERMINAL /usr/local/bin/cowboy
Icon=cowboy-icon
Terminal=true
Type=Application
Categories=System;
EOF

# Copy desktop file to applications
mkdir -p ~/.local/share/applications
cp cowboy.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/cowboy.desktop

echo "Installation complete!"
echo "You can now run 'cowboy' from the terminal or find it in your application menu."
