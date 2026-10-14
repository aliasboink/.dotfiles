# Dotfiles

## Arch Linux
```
sudo pacman -S --needed xorg-server xorg-xrandr lightdm lightdm-gtk-greeter i3-wm i3lock xss-lock dex rofi dunst alacritty feh polybar flameshot brightnessctl polkit-gnome network-manager-applet libnotify libpulse psmisc stow neovim papirus-icon-theme npm base-devel
sudo systemctl enable lightdm.service
```

## Sway
Same setup as i3, on Wayland. Both configs include `.config/wm/common.conf`, so a change to keys, workspaces or colours there applies to both. Waybar takes the place of polybar.

On top of the Arch packages above:
```
sudo pacman -S --needed sway swaybg swaylock swayidle waybar xdg-desktop-portal-wlr
```

The proprietary NVIDIA driver needs `sway --unsupported-gpu`, which the stock session doesn't pass. Install the extra login entry and pick "Sway (NVIDIA)" in lightdm:
```
sudo install -m644 ~/.config/sway/sway-nvidia.desktop /usr/share/wayland-sessions/
```

Link the configs into `~` with stow:
```
cd ~/.dotfiles && stow .
```

## Linux Mint
For general use and change to i3 with lightdm-gtk-greeter:
```
sudo apt install xorg lightdm lightdm-gtk-greeter i3-wm i3lock i3status i3blocks rofi terminator dunst alacritty feh polybar stow neovim papirus-icon-theme npm build-essential flameshot brightnessctl dex xss-lock policykit-1-gnome network-manager-gnome libnotify-bin pulseaudio-utils
sudo systemctl enable lightdm.service
apt purge --autoremove slick-greeter lightdm-settings
```

For Starship follow [the instructions from the official repository](https://github.com/starship/starship).
