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

# Detect terminal emulator
if command -v cosmic-term &> /dev/null; then
    TERMINAL="cosmic-term -e"
elif command -v konsole &> /dev/null; then
    TERMINAL="konsole -e"
elif command -v gnome-terminal &> /dev/null; then
    TERMINAL="gnome-terminal --"
elif command -v alacritty &> /dev/null; then
    TERMINAL="alacritty -e"
elif command -v kitty &> /dev/null; then
    TERMINAL="kitty -e"
elif command -v xterm &> /dev/null; then
    TERMINAL="xterm -e"
else
    echo "Warning: No supported terminal found. Using xterm as fallback."
    TERMINAL="xterm -e"
fi

echo "Detected terminal: $TERMINAL"


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
Terminal=false
Type=Application
Categories=System;
EOF

# Copy desktop file to applications
mkdir -p ~/.local/share/applications
cp cowboy.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/cowboy.desktop

echo "Installation complete!"
echo "You can now run 'cowboy' from the terminal or find it in your application menu."
