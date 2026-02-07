# cowboy-update
Update wrapper, cleaner, snapshot support for Arch (Sys/AUR/Flatpak)
--Cowboy Update v0.4--


## Features
- Updates official repos (via pacman)
- Updates AUR packages (via paru)
- Updates Flatpaks system & user
- Creates snapshot (Timeshift/BTRFS) -> ./snaphot
- Creates pacman database backup on large updates
- Smart Save -> Snapshot created every 14 days, only holds 2 snapshots
- Detect-Bloat deletes old snapshots, pacman backups, and older .log lines
- Checks if kernel/GPU updated and reboot reminder
- Removes Orphans
- Cleans package cache (keep last 2 versions)
- Cleans flatpak cache
- pacnew/pacsave
- Desktop notifications on success/failure
- Provides summary
- Provides .log

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

sunny
