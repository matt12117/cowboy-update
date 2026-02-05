# cowboy-update
Update wrapper for Arch (Sys/AUR/Flatpak)
--Cowboy Update v 0.2--


## Features
- Updates official repos (via arch-update)
- Updates AUR packages (via paru)  
- Updates Flatpaks
- Desktop notifications on success/failure

## Installation
```bash
git clone https://github.com/matt12117/cowboy-update.git
cd cowboy-update
chmod +x install.sh
./install.sh
```

## Usage
Run from terminal:
```bash
cowboy
```

Or find "Cowboy Update" in your application menu!

## Requirements
- arch-update
- paru
- flatpak
- libnotify (for notifications)
Uses Arch-update, paru -Sua, and flatpak update in a wrap.
Returns a terminal confirmation and notifcation for success or errors.


If you do not want to run install script and would like replicate/edit code yourself:
dl/copy code for Cowboy .sh and .desktop (txt format before .desktop declared) 
Edit .desktop in txt to point to shell script and add ICON location
Give Cowboy .sh and .desktop executable permissions.
Place Cowboy shell script in correct location
Place .desktop in correct location.
Copy executable for your placement.
Launch from executable or run cowboy in your terminal

NOTE: Cowboy is currently made for CachyOS and cosmic-terminal
