# cowboy-update
Updater for Arch (Sys/AUR/Flatpak)
--Cowboy Update v 0.2--
Uses Arch-update, paru -Sua, and flatpak update in a wrap.
Returns a terminal confirmation and notifcation for success or errors.

Give Cowboy.sh and .desktop executable permissions.
Place Cowboy .sh and .desktop in correct folders.
Copy executable for your placement.
Launch from executable or run cowboy in your terminal

NOTE: Cowboy is currently made for CachyOS and cosmic-terminal



check line 18 & 31 {}
enable hidden files

copy .sh to:
/usr/local/bin/
or (after permissions)
sudo mv cowboy /usr/local/bin/

exec perms:
sudo chmod +x file
or GUI

copy .desktop to:
/home/{name}/.local/share/applications/
or (after permissions)
sudo mv cowboy.desktop /home/{name}/.local/share/applications/

exec perms:
sudo chmod +x file
or GUI


desktop file edit Exec to your terminal:
[Desktop Entry]
Name=Cowboy
Comment=Update Arch, AUR, and Flatpak
Exec=cosmic-term{OR_YOUR_TERMINAL} -e /usr/local/bin/cowboy
Icon=
Terminal=true
Type=Application
Categories=System;
