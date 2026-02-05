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


## NOTE
Cowboy is currently made for CachyOS and cosmic-terminal in raw files. Using install script will detect your systems installed terminals and confirm your preferred terminal.


## Alternative methods
If you do not want to run install script and would like replicate/edit code yourself:<br>
dl/copy code for Cowboy .sh and .desktop (txt format before .desktop declared) <br>
Edit .desktop in txt to point to shell script and add ICON location<br>
Give Cowboy .sh and .desktop executable permissions.<br>
Place Cowboy shell script in correct location<br>
Place .desktop in correct location.<br>
Copy executable for your placement.<br>
Launch from executable or run cowboy in your terminal<br>
