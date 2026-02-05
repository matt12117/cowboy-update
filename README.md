# cowboy-update
Update wrapper for Arch (Sys/AUR/Flatpak)
--Cowboy Update v0.3--


## Features
- Updates official repos (via pacman)
- Updates AUR packages (via paru)
- Updates Flatpaks
- Checks if kernel updated and reboot reminder
- Removes Orphans
- Cleans package cache (keep last 2 versions)
- Cleans flatpak cache
- pacnew/pacsave
- Desktop notifications on success/failure
- Provides summary

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
- pacman
- paru
- flatpak
- libnotify (for notifications)
- pacman-contrib (paccache)


## NOTE
Cowboy-Update is currently made for CachyOS and cosmic-terminal in raw files. Using install script will detect your systems installed terminals and confirm your preferred terminal.


## Alternative methods
If you do not want to run install script and would like replicate/edit code yourself:<br>
dl/copy files (excluding install.sh) for Cowboy and .desktop (rename and delete .desktop extension so it is txt format) <br>
Edit .desktop in txt to point to shell script and add ICON location.(LOCATIONS IN README) Add the .desktop extension back to the file<br>
Give Cowboy .sh and .desktop executable permissions.<br>
Place Cowboy shell script in correct location<br>
Place .desktop in correct location.<br>
Copy executable for your placement.<br>
Launch from executable or run cowboy in your terminal<br>
