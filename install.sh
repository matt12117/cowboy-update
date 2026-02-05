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

# Copy script to /usr/local/bin
sudo cp cowboy.sh /usr/local/bin/cowboy
sudo chmod +x /usr/local/bin/cowboy

# Copy desktop file to applications
mkdir -p ~/.local/share/applications
cp cowboy.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/cowboy.desktop

echo "Installation complete!"
echo "You can now run 'cowboy' from the terminal or find it in your application menu."
